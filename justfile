default:
    @just --list

# Render every design and every example to STL, failing on any warning
test:
    #!/usr/bin/env bash
    set -euo pipefail
    out=$(mktemp -d)
    # The shared helpers define modules only; the gyro shade refuses a full render
    # until two settings are changed, which examples/other-designers/gyro_shade.scad does.
    for f in $(git ls-files '*.scad' | grep -vE '^(geometry_functions|mounting_functions)\.scad$|^gyro-shade/'); do
        echo "$f"
        openscad --hardwarnings --export-format binstl -o "$out/part.stl" "$f"
    done
