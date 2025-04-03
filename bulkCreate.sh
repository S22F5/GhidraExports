#!/bin/bash

if [ $# -ne 1 ]; then
    echo "Usage: $0 dll_dir"
    exit 1
fi

DLL_DIR="$1"
GHIDRA_PROJNAME="DLL_Analysis_$(date +%s)"
GHIDRA_HEADLESS="/opt/ghidra/support/analyzeHeadless"
GHIDRA_POSTSCRIPT="-postScript CreateExportFileForDLL.java"

find "$DLL_DIR" -type f -iname "*.dll" | while read -r dll_file; do
    abspath=$(readlink -f "$dll_file")
    
    printf "%s\n" "$abspath"
    
    temp_project="${GHIDRA_PROJNAME}_$(basename "$dll_file" | tr ' ' '_')"

    "$GHIDRA_HEADLESS" ~/.ghidra_proj/ "$temp_project" \
        -import "$abspath" \
        "$GHIDRA_POSTSCRIPT" \
        -deleteProject \
        -noanalysis \
        -readOnly

done
