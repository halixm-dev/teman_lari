#!/bin/bash
set -e

FLUTTER_VERSION="3.41.9"
CACHE_DIR="/vercel/.cache"
FLUTTER_DIR="$CACHE_DIR/flutter"
PUB_CACHE_DIR="$CACHE_DIR/pub-cache"

export PUB_CACHE="$PUB_CACHE_DIR"

if [ ! -f "$FLUTTER_DIR/bin/flutter" ]; then
  echo "Downloading Flutter SDK $FLUTTER_VERSION..."
  mkdir -p "$CACHE_DIR"
  curl -fsSL \
    "https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_$FLUTTER_VERSION-stable.tar.xz" \
    -o /tmp/flutter.tar.xz
  tar xf /tmp/flutter.tar.xz -C "$CACHE_DIR"
  rm /tmp/flutter.tar.xz
fi

export PATH="$FLUTTER_DIR/bin:$PATH"

flutter config --enable-web --no-analytics

DART_DEFINES=""
[ -n "$STRAVA_CLIENT_ID" ] && DART_DEFINES="$DART_DEFINES --dart-define=STRAVA_CLIENT_ID=$STRAVA_CLIENT_ID"
[ -n "$STRAVA_CLIENT_SECRET" ] && DART_DEFINES="$DART_DEFINES --dart-define=STRAVA_CLIENT_SECRET=$STRAVA_CLIENT_SECRET"
[ -n "$STRAVA_REDIRECT_URI" ] && DART_DEFINES="$DART_DEFINES --dart-define=STRAVA_REDIRECT_URI=$STRAVA_REDIRECT_URI"
[ -n "$STRAVA_ACCESS_TOKEN" ] && DART_DEFINES="$DART_DEFINES --dart-define=STRAVA_ACCESS_TOKEN=$STRAVA_ACCESS_TOKEN"
[ -n "$STRAVA_REFRESH_TOKEN" ] && DART_DEFINES="$DART_DEFINES --dart-define=STRAVA_REFRESH_TOKEN=$STRAVA_REFRESH_TOKEN"

flutter build web --release $DART_DEFINES
