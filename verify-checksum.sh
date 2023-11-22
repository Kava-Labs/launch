#!/bin/bash

set -e

# This script verifies the checksums of binaries in a JSON file.
# Usage: ./verify-checksum.sh <path-to-json-file>
# Example: ./verify-checksum.sh ./kava-10/v0.25.0-binaries.json

# Check if a file path was provided
if [ $# -eq 0 ]; then
    echo "Error: Please provide path to a JSON file containing a 'binaries' object."
    exit 1
fi

# Read the JSON from the file
json=$(cat $1)

binaries=$(echo $json | jq -r '.binaries | keys[]')

# Echo how many binaries there were found, and their keys
echo "Found $(echo $binaries | wc -w |  tr -d ' ') binaries:"
echo $binaries
echo ""

# Create a temporary directory
temp_dir=$(mktemp -d)

for binary in $binaries
do
  url=$(echo $json | jq -r ".binaries.\"$binary\"")
  checksum=$(echo $url | awk -F'sha256:' '{print $2}')
  url=$(echo $url | awk -F'\\?checksum' '{print $1}')

  echo "Downloading $binary from $url"
  binary_file=$(echo $binary | tr '/' '-')
  temp_file="$temp_dir/$binary_file"
  curl -s -L $url -o $temp_file

  echo "Verifying checksum..."
  echo "$checksum  $temp_file" | shasum -a 256 --check

  if [ $? -eq 0 ]; then
    echo "PASS: $binary - $checksum"
  else
    echo "FAIL: $binary"
    echo "  Expected: $checksum"
    echo "  Actual:   $(shasum -a 256 $temp_file | awk '{print $1}')"
  fi

  rm $temp_file

  echo ""
done

# Remove the temporary directory
rmdir $temp_dir
