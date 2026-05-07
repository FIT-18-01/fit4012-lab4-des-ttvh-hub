#!/usr/bin/env bash
# Test cho trường hợp multi-block và padding.
# Kiểm tra plaintext dài hơn 64 bit, chia block đúng và zero padding đúng.
set -euo pipefail

# Plaintext 128 bits (2 blocks)
PLAINTEXT="00010010001101000101011001111000100110101011110011011110111100010001001000110100010101100111100010011010101111001101111011110001"
KEY="0001001100110100010101110111100110011011101111001101111111110001"

g++ -std=c++17 -Wall -Wextra -pedantic ../des.cpp -o des_test

# Encrypt
CIPHERTEXT=$(./des_test encrypt "$PLAINTEXT" "$KEY")

# Check length: 128 bits
if [[ ${#CIPHERTEXT} -ne 128 ]]; then
  echo "[FAIL] Ciphertext length incorrect: expected 128, got ${#CIPHERTEXT}"
  exit 1
fi

# Decrypt
DECRYPTED=$(./des_test decrypt "$CIPHERTEXT" "$KEY")

if [[ "$DECRYPTED" != "$PLAINTEXT" ]]; then
  echo "[FAIL] Multi-block round-trip failed"
  echo "Original:  $PLAINTEXT"
  echo "Decrypted: $DECRYPTED"
  exit 1
fi

echo "[PASS] Multi-block encryption/decryption with padding successful."

# Test padding: plaintext 70 bits, should pad to 128
SHORT_PLAINTEXT="00010010001101000101011001111000100110101011110011011110111100010001"
PADDED=$(printf '%-128s' "$SHORT_PLAINTEXT" | tr ' ' '0')

CIPHERTEXT_SHORT=$(./des_test encrypt "$SHORT_PLAINTEXT" "$KEY")
DECRYPTED_SHORT=$(./des_test decrypt "$CIPHERTEXT_SHORT" "$KEY")

if [[ "$DECRYPTED_SHORT" != "$PADDED" ]]; then
  echo "[FAIL] Padding test failed"
  echo "Expected padded: $PADDED"
  echo "Decrypted:      $DECRYPTED_SHORT"
  exit 1
fi

echo "[PASS] Zero padding for short plaintext successful."
rm -f des_test
