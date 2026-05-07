#!/usr/bin/env bash
# Test round-trip encrypt -> decrypt.
# Encrypt plaintext, rồi decrypt ciphertext, kiểm tra decrypt(encrypt(plaintext)) = plaintext.
set -euo pipefail

PLAINTEXT="0001001000110100010101100111100010011010101111001101111011110001"
KEY="0001001100110100010101110111100110011011101111001101111111110001"

g++ -std=c++17 -Wall -Wextra -pedantic ../des.cpp -o des_test

# Encrypt
CIPHERTEXT=$(./des_test encrypt "$PLAINTEXT" "$KEY")

# Decrypt
DECRYPTED=$(./des_test decrypt "$CIPHERTEXT" "$KEY")

if [[ "$DECRYPTED" != "$PLAINTEXT" ]]; then
  echo "[FAIL] Round-trip failed"
  echo "Original:  $PLAINTEXT"
  echo "Decrypted: $DECRYPTED"
  exit 1
fi

echo "[PASS] Round-trip encrypt/decrypt successful."
rm -f des_test
