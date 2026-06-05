#!/usr/bin/env bash

artist=$(playerctl -p spotify metadata artist)
title=$(playerctl -p spotify metadata title)

if [[ -n "$artist" && -n "$title" ]]; then
    printf '{"text": "%s - %s"}\n' "$artist" "$title"
fi
