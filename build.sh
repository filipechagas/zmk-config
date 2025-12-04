#!/bin/bash

# Initialize west only if not already initialized
if [ ! -d ".west" ]; then
  west init -l config
fi

# Update and export (force update to get latest manifest changes)
west update --fetch always
west zephyr-export

# Export CMAKE_PREFIX_PATH
export "CMAKE_PREFIX_PATH=/zmk-config/zephyr:$CMAKE_PREFIX_PATH"

# Build left side
west build -d /build/left -p -b "nice_nano_v2" \
  -s zmk/app \
  -- -DSHIELD="hillside48_left" \
  -DZMK_CONFIG="/zmk-config/config"

# Build right side
west build -d /build/right -p -b "nice_nano_v2" \
  -s zmk/app \
  -- -DSHIELD="hillside48_right" \
  -DZMK_CONFIG="/zmk-config/config"

# Build settings reset
west build -d /build/settings_reset -p -b "nice_nano_v2" \
  -s zmk/app \
  -- -DSHIELD="settings_reset" \
  -DZMK_CONFIG="/zmk-config/config"

# Copy firmware files to output directory
mkdir -p /output
cp /build/left/zephyr/zmk.uf2 /output/hillside48_left-nice_nano_v2-zmk.uf2
cp /build/right/zephyr/zmk.uf2 /output/hillside48_right-nice_nano_v2-zmk.uf2
cp /build/settings_reset/zephyr/zmk.uf2 /output/settings_reset.uf2
