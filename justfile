default:
    @just --list

# Render every design and every example to STL, failing on any warning
test:
    #!/usr/bin/env bash
    set -euo pipefail
    out=$(mktemp -d)
    # The shared helpers define modules only; the gyro shade refuses a full render
    # until two settings are changed, which examples/other-designers/gyro_shade.scad does.
    # A failed assert leaves the exit status at 0, so a WARNING or ERROR line fails it too.
    for f in $(git ls-files '*.scad' | grep -vE '^(geometry_functions|mounting_functions)\.scad$|^gyro-shade/'); do
        echo "$f"
        log=$(openscad --hardwarnings --export-format binstl -o "$out/part.stl" "$f" 2>&1)
        if grep -E '^(WARNING|ERROR)' <<<"$log"; then exit 1; fi
    done

# Everything CI runs, bar the tests
check: fmt-check

# Format the .scad sources with topiary (.topiary/languages.ncl)
fmt:
    git ls-files -z '*.scad' | xargs -0 -r topiary format

# Check the .scad sources are formatted, without changing them
fmt-check:
    git ls-files -z '*.scad' | xargs -0 -r -n1 topiary format --check
