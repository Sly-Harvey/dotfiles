#!/bin/env bash
if pgrep -x Hyprland >/dev/null; then
    killall -9 Hyprland
fi
