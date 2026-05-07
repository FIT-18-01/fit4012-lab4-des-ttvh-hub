#!/usr/bin/env bash
# Test negative cho wrong key / incorrect key / sai key.
# Giải mã với khóa sai và chứng minh không khôi phục đúng plaintext.
set -euo pipefail

PLAINTEXT="0001001000110100010101100111100010011010101111001101111011110001"
KEY1="0001001100110100010101110111100110011011101111001101111111110001"
KEY2="0001001100110100010101110111100110011011101111001101111111110010"  # Different key

g++ -std=c++17 -Wall -Wextra -pedantic ../des.cpp -o des_test

# Encrypt with KEY1
CIPHERTEXT=$(./des_test encrypt "$PLAINTEXT" "$KEY1")

# Decrypt with KEY2
DECRYPTED=$(./des_test decrypt "$CIPHERTEXT" "$KEY2")

if [[ "$DECRYPTED" == "$PLAINTEXT" ]]; then
  echo "[FAIL] Wrong key decryption succeeded unexpectedly"
  exit 1
fi

echo "[PASS] Decryption with wrong key fails as expected."
rm -f des_test
