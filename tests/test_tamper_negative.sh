#!/usr/bin/env bash
# Test negative cho tamper / flip 1 byte / bit flip.
# Sửa 1 byte hoặc một số bit của ciphertext rồi quan sát kết quả giải mã / kiểm thử.
set -euo pipefail

PLAINTEXT="0001001000110100010101100111100010011010101111001101111011110001"
KEY="0001001100110100010101110111100110011011101111001101111111110001"

g++ -std=c++17 -Wall -Wextra -pedantic ../des.cpp -o des_test

# Encrypt
CIPHERTEXT=$(./des_test encrypt "$PLAINTEXT" "$KEY")

# Flip the first bit
TAMPERED=$(echo "$CIPHERTEXT" | sed 's/^0/1/' | sed 's/^1/0/')

# Decrypt tampered
DECRYPTED=$(./des_test decrypt "$TAMPERED" "$KEY")

if [[ "$DECRYPTED" == "$PLAINTEXT" ]]; then
  echo "[FAIL] Tampering did not affect decryption"
  exit 1
fi

echo "[PASS] Tampering with ciphertext prevents correct decryption."
rm -f des_test
