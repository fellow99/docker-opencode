#!/bin/bash
set -e

# Start virtual display
Xvfb :99 -screen 0 1280x720x24 &
sleep 1

# Start window manager
fluxbox &
sleep 1

# Start VNC server
x11vnc -display :99 -forever -shared -rfbport 5900 -nopw &
sleep 1

# Start noVNC web server
websockify --web /usr/share/novnc 6080 localhost:5900 &
