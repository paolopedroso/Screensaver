#!/usr/bin/env python3
# Copyright (c) 2024 Ethan Sifferman.
# All rights reserved. Distribution Prohibited.

from PIL import Image
import sys

def rgb_to_hex(r, g, b):
    r_4bit = (r >> 4) & 0xF
    g_4bit = (g >> 4) & 0xF
    b_4bit = (b >> 4) & 0xF
    return f"{r_4bit:X}{g_4bit:X}{b_4bit:X}"

def convert_image_to_memh(input_filename, output_filename):
    image = Image.open(input_filename).convert("RGB")

    width, height = image.size

    with open(output_filename, 'w') as outfile:
        outfile.write(f"// Image ROM generated from \"{input_filename}\"\n")
        outfile.write(f"// 12-bit color depth\n")
        outfile.write(f"// Dimensions: {width}x{height}\n")
        outfile.write(f"\n")
        for y in range(height):
            for x in range(width):
                r, g, b = image.getpixel((x, y))
                hex_value = rgb_to_hex(r, g, b)
                outfile.write(hex_value + "\n")

if __name__ == "__main__":
    if len(sys.argv) != 3:
        print(f"Usage: {sys.argv[0]} <input_png> <output_file>")
        sys.exit(1)

    input_filename = sys.argv[1]
    output_filename = sys.argv[2]

    convert_image_to_memh(input_filename, output_filename)
