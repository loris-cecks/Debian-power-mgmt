#!/bin/bash

# Improved CPU Governor Management Script

# Function to get available CPU governors
get_cpu_governors() {
  if [ ! -f /sys/devices/system/cpu/cpu0/cpufreq/scaling_available_governors ]; then
    echo "CPU governors are not accessible on this system."
    exit 1
  fi
  cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_available_governors
}

# Function to set CPU governor
set_cpu_governor() {
  local governor="$1"
  if ! grep -q "$governor" <<< "$available_governors"; then
    echo "Invalid governor: $governor"
    exit 1
  fi

  for cpu in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor; do
    echo "$governor" | sudo tee "$cpu" > /dev/null
  done
}

# Main script
available_governors=$(get_cpu_governors)
echo "Available CPU Governors:"
echo "$available_governors"
echo

read -p "Enter the CPU Governor you want to set: " selected_governor

if [ -z "$selected_governor" ]; then
  echo "No governor selected. Exiting..."
  exit 1
fi

set_cpu_governor "$selected_governor"
echo "CPU Governor set to: $selected_governor"
