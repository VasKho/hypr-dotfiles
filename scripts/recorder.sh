#!/bin/bash 
set -x

pid=`pgrep wf-recorder`
status=$?

gif=false

countdown() {
  notify "Recording in 3 seconds" -t 1000
  sleep 1
  notify "Recording in 2 seconds" -t 1000
  sleep 1
  notify "Recording in 1 seconds" -t 1000
  sleep 1
}

notify() {
    line=$1
    shift
    notify-send "Recording" "${line}" -i ~/.icons/gruvbox-icon-theme-plus/devices/32/camera-video.svg $*
}

if [ $status != 0 ]; then
    target_path="/home/${USER}/Documents/Recordings"
    timestamp=$(date +'recording_%Y%m%d-%H%M%S')

    notify "Select a region to record" -t 1000
    area=$(slurp)

    countdown
    (sleep 0.5 && pkill -RTMIN+8 waybar) &

    file="$target_path/$timestamp.webm"
    wf-recorder -g "$area" -c libvpx --codec-param="qmin=0" --codec-param="qmax=25" --codec-param="crf=4" --codec-param="b:v=1M" --file="$file"

    pkill -RTMIN+8 waybar && notify "Finished recording ${file}"
fi
