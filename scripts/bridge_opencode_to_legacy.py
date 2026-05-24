"""
Bridge: OpenCode v1.15 SQLite → legacy file format for AI-Engineering-Coach.

Converts the SQLite database back into the file-per-entity layout
that Coach's parser-opencode.ts expects:

  storage/session/global/<session-id>.json
  storage/message/<session-id>/<msg-id>.json
  storage/part/<msg-id>/<part-id>.json

Usage:
  python bridge_opencode_to_legacy.py
  python bridge_opencode_to_legacy.py --db <path/to/opencode.db> --out <output-dir>
"""

import argparse
import json
import os
import sqlite3
from datetime import datetime, timezone
from pathlib import Path


DEFAULT_DB = os.path.join(
    os.environ.get("HOME") or os.environ.get("USERPROFILE") or "",
    ".local", "share", "opencode", "opencode.db",
)


def map_session(row):
    return {
        "id": row["id"],
        "slug": row.get("slug", ""),
        "version": row.get("version", "local"),
        "projectID": row.get("project_id", ""),
        "directory": row.get("directory", ""),
        "title": row.get("title", ""),
        "time": {
            "created": row.get("time_created"),
            "updated": row.get("time_updated"),
        },
    }


def map_message(msg_id, session_id, data):
    return {
        "id": msg_id,
        "sessionID": session_id,
        "role": data.get("role", "user"),
        "time": data.get("time", {}),
        "parentID": data.get("parentID"),
        "modelID": data.get("modelID") or data.get("model", {}).get("modelID"),
        "providerID": data.get("providerID") or data.get("model", {}).get("providerID"),
        "mode": data.get("mode"),
        "agent": data.get("agent"),
        "cost": data.get("cost"),
        "tokens": data.get("tokens"),
        "finish": data.get("finish"),
        "summary": data.get("summary"),
        "variant": data.get("variant"),
        "model": data.get("model"),
    }


def map_part(part_id, session_id, message_id, data):
    return {
        "id": part_id,
        "sessionID": session_id,
        "messageID": message_id,
        "type": data.get("type", ""),
        "text": data.get("text"),
        "tool": data.get("tool"),
        "callID": data.get("callID"),
        "state": data.get("state"),
        "tokens": data.get("tokens"),
        "cost": data.get("cost"),
        "reason": data.get("reason"),
    }


def build(db_path, out_dir):
    os.makedirs(out_dir, exist_ok=True)

    conn = sqlite3.connect(db_path)
    conn.row_factory = sqlite3.Row
    cursor = conn.cursor()

    session_dir = os.path.join(out_dir, "session", "global")
    message_dir_base = os.path.join(out_dir, "message")
    part_dir_base = os.path.join(out_dir, "part")

    cursor.execute("""
        SELECT id, project_id, parent_id, slug, directory, title, version,
               time_created, time_updated
        FROM session
        ORDER BY time_created
    """)
    sessions = [dict(r) for r in cursor.fetchall()]
    print(f"Sessions: {len(sessions)}")

    for session in sessions:
        sid = session["id"]
        sess_path = os.path.join(session_dir, f"{sid}.json")
        os.makedirs(session_dir, exist_ok=True)
        with open(sess_path, "w", encoding="utf-8") as f:
            json.dump(map_session(session), f, ensure_ascii=False)

    cursor.execute("SELECT id, session_id, time_created, time_updated, data FROM message ORDER BY session_id, time_created")
    msg_count = 0
    part_count = 0
    for row in cursor.fetchall():
        msg_id = row["id"]
        session_id = row["session_id"]
        try:
            data = json.loads(row["data"])
        except (json.JSONDecodeError, TypeError):
            continue

        msg_path = os.path.join(message_dir_base, session_id, f"{msg_id}.json")
        os.makedirs(os.path.dirname(msg_path), exist_ok=True)
        with open(msg_path, "w", encoding="utf-8") as f:
            json.dump(map_message(msg_id, session_id, data), f, ensure_ascii=False)
        msg_count += 1

    cursor.execute("SELECT id, message_id, session_id, time_created, time_updated, data FROM part ORDER BY message_id, time_created")
    for row in cursor.fetchall():
        part_id = row["id"]
        session_id = row["session_id"]
        message_id = row["message_id"]
        try:
            data = json.loads(row["data"])
        except (json.JSONDecodeError, TypeError):
            continue

        part_path = os.path.join(part_dir_base, message_id, f"{part_id}.json")
        os.makedirs(os.path.dirname(part_path), exist_ok=True)
        with open(part_path, "w", encoding="utf-8") as f:
            json.dump(map_part(part_id, session_id, message_id, data), f, ensure_ascii=False)
        part_count += 1

    conn.close()

    msg_dir_count = len(os.listdir(message_dir_base)) if os.path.isdir(message_dir_base) else 0
    part_dir_count = len(os.listdir(part_dir_base)) if os.path.isdir(part_dir_base) else 0
    print(f"Messages: {msg_count}")
    print(f"Parts: {part_count}")
    print(f"Message dirs: {msg_dir_count}")
    print(f"Part dirs: {part_dir_count}")
    print(f"Output: {os.path.abspath(out_dir)}")


def main():
    parser = argparse.ArgumentParser(description="Bridge OpenCode SQLite → legacy file format for Coach")
    parser.add_argument("--db", default=DEFAULT_DB, help="Path to opencode.db (default: %(default)s)")
    parser.add_argument("--out", default=None, help="Output directory (default: <db-dir>/legacy-for-coach)")
    args = parser.parse_args()

    db_path = os.path.abspath(args.db)
    if not os.path.isfile(db_path):
        print(f"DB not found: {db_path}")
        return 1

    out_dir = args.out or os.path.join(os.path.dirname(db_path), "legacy-for-coach")
    build(db_path, out_dir)
    return 0


if __name__ == "__main__":
    exit(main())
