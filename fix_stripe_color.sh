#!/bin/bash

# Script to fix the Color API issue in stripe_platform_interface
# Run this after 'flutter pub get' if you encounter Color API errors

STRIPE_COLOR_FILE="$HOME/.pub-cache/hosted/pub.dev/stripe_platform_interface-11.5.0/lib/src/models/color.dart"

if [ -f "$STRIPE_COLOR_FILE" ]; then
    echo "Fixing Color API in stripe_platform_interface..."
    # Replace the old Color API (r, g, b, a) with the new API (red, green, blue, alpha)
    perl -i -pe 's/\(r \* 255\)\.toInt\(\)/this.red/g; s/\(g \* 255\)\.toInt\(\)/this.green/g; s/\(b \* 255\)\.toInt\(\)/this.blue/g; s/\(a \* 255\)\.toInt\(\)/this.alpha/g' "$STRIPE_COLOR_FILE"
    # Alternative fix using sed for better compatibility
    sed -i '' 's/(r \* 255)\.toInt()/this.red/g; s/(g \* 255)\.toInt()/this.green/g; s/(b \* 255)\.toInt()/this.blue/g; s/(a \* 255)\.toInt()/this.alpha/g' "$STRIPE_COLOR_FILE" 2>/dev/null || true
    echo "Color API fix applied successfully!"
else
    echo "Warning: stripe_platform_interface color.dart file not found at: $STRIPE_COLOR_FILE"
    echo "Make sure to run 'flutter pub get' first."
    exit 1
fi

