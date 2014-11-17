#!/bin/bash
ffmpeg -i green-f095-orbit1.mov -c:v libx264 -preset slow -crf 18 -c:a copy -pix_fmt yuv420p green-f095-orbit1.mkv
ffmpeg -i orbit-%04d.png -pix_fmt yuv420p -vcodec h264 green-f000-orbit2.mp4
