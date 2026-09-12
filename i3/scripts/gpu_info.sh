#!/bin/bash

# Fetch GPU utilization and temperature
gpu_util=$(nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits 2>/dev/null)
gpu_temp=$(nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader,nounits 2>/dev/null)

# Output the formatted string if the GPU is active
if [ -n "$gpu_util" ] && [ -n "$gpu_temp" ]; then
    echo "GPU ${gpu_util}% ${gpu_temp}°C"
else
    echo "GPU OFF"
fi
