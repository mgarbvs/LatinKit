#!/usr/bin/env bash
# max_restart.sh — kill standalone Max (never Live's Max) and drop its crash-recovery workspace so
# the next maxtest call relaunches a clean harness without reopening old test patches.
P=$(pgrep -f "^/Applications/Max.app/Contents/MacOS/Max")
[ -n "$P" ] && { kill $P; sleep 2; kill -9 $P 2>/dev/null; rm -f ~/Library/Application\ Support/Cycling\ \'74/Max\ 9/Crash\ Recovery/maxworkspace-$P.txt; }
echo "standalone Max stopped"
