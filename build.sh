#!/bin/bash
set -e

FLUTTER_VERSION="stable"
FLUTTER_DIR="$HOME/flutter"

if [ ! -d "$FLUTTER_DIR" ]; then
  echo "Installing Flutter SDK..."
  git clone https://github.com/flutter/flutter.git --depth 1 -b "$FLUTTER_VERSION" "$FLUTTER_DIR"
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
