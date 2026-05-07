#!/usr/bin/env bash
# Test cho trường hợp DES mẫu từ code gốc.
# Compile chương trình, chạy encrypt với sample, rồi đối chiếu ciphertext mẫu mong đợi.
set -euo pipefail

EXPECTED="0111111010111111010001001001001100100011111110101111101011111000"

g++ -std=c++17 -Wall -Wextra -pedantic ../des.cpp -o des_test
OUTPUT=$(./des_test encrypt "0001001000110100010101100111100010011010101111001101111011110001" "0001001100110100010101110111100110011011101111001101111111110001")

if [[ "$OUTPUT" != "$EXPECTED" ]]; then
  echo "[FAIL] Unexpected ciphertext output"
  echo "Expected: $EXPECTED"
  echo "Actual:   $OUTPUT"
  exit 1
fi

echo "[PASS] DES sample encryption produced the expected ciphertext."
rm -f des_test
