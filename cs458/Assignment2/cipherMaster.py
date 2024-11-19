from Crypto.Cipher import AES, DES, DES3
from Crypto.Random import get_random_bytes
from Crypto.Util.Padding import pad, unpad
import string

# Shift Cipher
def shift_cipher_encrypt(plaintext, key):
    result = ''
    for i in range(len(plaintext)):
        char = plaintext[i]
        if char.isupper():
            result += chr((ord(char) + key - 65) % 26 + 65)
        elif char.islower():
            result += chr((ord(char) + key - 97) % 26 + 97)
        else:
            result += char
    return result

def shift_cipher_decrypt(ciphertext, key):
    return shift_cipher_encrypt(ciphertext, -key)

# Permutation Cipher
def permutation_cipher_encrypt(plaintext, key):
    key_order = sorted(list(key))
    key_map = {k: i for i, k in enumerate(key_order)}
    return ''.join(plaintext[key_map[c]] for c in key)

def permutation_cipher_decrypt(ciphertext, key):
    key_order = sorted(list(key))
    key_map = {i: k for i, k in enumerate(key_order)}
    return ''.join(ciphertext[key_map[c]] for c in key)

# Simple Transposition Cipher
def simple_transposition_encrypt(plaintext):
    return ''.join(plaintext[::2] + plaintext[1::2])

def simple_transposition_decrypt(ciphertext):
    midpoint = len(ciphertext) // 2
    return ''.join(ciphertext[i] + ciphertext[midpoint+i] for i in range(midpoint))

# Double Transposition Cipher
def double_transposition_encrypt(plaintext):
    return simple_transposition_encrypt(simple_transposition_encrypt(plaintext))

def double_transposition_decrypt(ciphertext):
    return simple_transposition_decrypt(simple_transposition_decrypt(ciphertext))

# Vigenere Cipher
def vigenere_encrypt(plaintext, key):
    key_length = len(key)
    key_as_int = [ord(i) for i in key]
    plaintext_int = [ord(i) for i in plaintext]
    ciphertext = ''
    for i in range(len(plaintext_int)):
        value = (plaintext_int[i] + key_as_int[i % key_length]) % 26
        ciphertext += chr(value + 65)
    return ciphertext

def vigenere_decrypt(ciphertext, key):
    key_length = len(key)
    key_as_int = [ord(i) for i in key]
    ciphertext_int = [ord(i) for i in ciphertext]
    plaintext = ''
    for i in range(len(ciphertext_int)):
        value = (ciphertext_int[i] - key_as_int[i % key_length]) % 26
        plaintext += chr(value + 65)
    return plaintext

# AES Encryption/Decryption
def aes_encrypt(plaintext, key, mode):
    cipher = AES.new(key, mode)
    ct_bytes = cipher.encrypt(pad(plaintext.encode(), AES.block_size))
    return cipher.iv + ct_bytes

def aes_decrypt(ciphertext, key, mode):
    iv = ciphertext[:AES.block_size]
    cipher = AES.new(key, mode, iv)
    pt = unpad(cipher.decrypt(ciphertext[AES.block_size:]), AES.block_size)
    return pt.decode()

# DES Encryption/Decryption
def des_encrypt(plaintext, key, mode):
    cipher = DES.new(key, mode)
    ct_bytes = cipher.encrypt(pad(plaintext.encode(), DES.block_size))
    return cipher.iv + ct_bytes

def des_decrypt(ciphertext, key, mode):
    iv = ciphertext[:DES.block_size]
    cipher = DES.new(key, mode, iv)
    pt = unpad(cipher.decrypt(ciphertext[DES.block_size:]), DES.block_size)
    return pt.decode()

# Triple DES Encryption/Decryption
def triple_des_encrypt(plaintext, key, mode):
    cipher = DES3.new(key, mode)
    ct_bytes = cipher.encrypt(pad(plaintext.encode(), DES3.block_size))
    return cipher.iv + ct_bytes

def triple_des_decrypt(ciphertext, key, mode):
    iv = ciphertext[:DES3.block_size]
    cipher = DES3.new(key, mode, iv)
    pt = unpad(cipher.decrypt(ciphertext[DES3.block_size:]), DES3.block_size)
    return pt.decode()


# Select Encryption
def select_encryption():
    print("Select an encryption technique:")
    print("1. Shift Cipher")
    print("2. Permutation Cipher")
    print("3. Simple Transposition")
    print("4. Double Transposition")
    print("5. Vigenere Cipher")
    print("6. AES-128")
    print("7. DES")
    print("8. 3DES")

    choice = int(input("Enter your choice (1-8): "))
    
    if choice == 1:
        key = int(input("Enter shift key: "))
        plaintext = input("Enter plaintext: ")
        ciphertext = shift_cipher_encrypt(plaintext, key)
        print(f"Encrypted message: {ciphertext}")
        
        decrypt = input("Do you want to decrypt the message? (yes/no): ")
        if decrypt.lower() == "yes":
            decrypted_message = shift_cipher_decrypt(ciphertext, key)
            print(f"Decrypted message: {decrypted_message}")

    elif choice == 2:
        key = input("Enter permutation key: ")
        plaintext = input("Enter plaintext: ")
        ciphertext = permutation_cipher_encrypt(plaintext, key)
        print(f"Encrypted message: {ciphertext}")
        
        decrypt = input("Do you want to decrypt the message? (yes/no): ")
        if decrypt.lower() == "yes":
            decrypted_message = permutation_cipher_decrypt(ciphertext, key)
            print(f"Decrypted message: {decrypted_message}")

    elif choice == 3:
        plaintext = input("Enter plaintext: ")
        ciphertext = simple_transposition_encrypt(plaintext)
        print(f"Encrypted message: {ciphertext}")
        
        decrypt = input("Do you want to decrypt the message? (yes/no): ")
        if decrypt.lower() == "yes":
            decrypted_message = simple_transposition_decrypt(ciphertext)
            print(f"Decrypted message: {decrypted_message}")

    elif choice == 4:
        plaintext = input("Enter plaintext: ")
        ciphertext = double_transposition_encrypt(plaintext)
        print(f"Encrypted message: {ciphertext}")
        
        decrypt = input("Do you want to decrypt the message? (yes/no): ")
        if decrypt.lower() == "yes":
            decrypted_message = double_transposition_decrypt(ciphertext)
            print(f"Decrypted message: {decrypted_message}")

    elif choice == 5:
        key = input("Enter Vigenere key: ")
        plaintext = input("Enter plaintext: ")
        ciphertext = vigenere_encrypt(plaintext.upper(), key.upper())
        print(f"Encrypted message: {ciphertext}")
        
        decrypt = input("Do you want to decrypt the message? (yes/no): ")
        if decrypt.lower() == "yes":
            decrypted_message = vigenere_decrypt(ciphertext.upper(), key.upper())
            print(f"Decrypted message: {decrypted_message}")

    elif choice == 6:
        modes = select_mode()
        if modes:
            mode = modes[0]
            key = get_random_bytes(16)
            plaintext = input("Enter plaintext: ")
            ciphertext = aes_encrypt(plaintext, key, mode)
            print(f"Encrypted message: {ciphertext.hex()}")
            
            decrypt = input("Do you want to decrypt the message? (yes/no): ")
            if decrypt.lower() == "yes":
                decrypted_message = aes_decrypt(ciphertext, key, mode)
                print(f"Decrypted message: {decrypted_message}")

    elif choice == 7:
        modes = select_mode()
        if modes:
            mode = modes[1]
            key = get_random_bytes(8)
            plaintext = input("Enter plaintext: ")
            ciphertext = des_encrypt(plaintext, key, mode)
            print(f"Encrypted message: {ciphertext.hex()}")
            
            decrypt = input("Do you want to decrypt the message? (yes/no): ")
            if decrypt.lower() == "yes":
                decrypted_message = des_decrypt(ciphertext, key, mode)
                print(f"Decrypted message: {decrypted_message}")

    elif choice == 8:
        modes = select_mode()
        if modes:
            mode = modes[2]
            key = get_random_bytes(16)
            plaintext = input("Enter plaintext: ")
            ciphertext = triple_des_encrypt(plaintext, key, mode)
            print(f"Encrypted message: {ciphertext.hex()}")
            
            decrypt = input("Do you want to decrypt the message? (yes/no): ")
            if decrypt.lower() == "yes":
                decrypted_message = triple_des_decrypt(ciphertext, key, mode)
                print(f"Decrypted message: {decrypted_message}")
    
    else:
        print("Invalid choice!")

def select_mode():
    print("Select an encryption mode:")
    print("1. OFB (Output Feedback)")
    print("2. CBC (Cipher Block Chaining)")
    print("3. CFB (Cipher Feedback)")

    choice = int(input("Enter your choice (1-3): "))
    if choice == 1:
        print("Using OFB mode.")
        return (AES.MODE_OFB, DES.MODE_OFB, DES3.MODE_OFB)

    elif choice == 2:
        print("Using CBC mode.")
        return (AES.MODE_CBC, DES.MODE_CBC, DES3.MODE_CBC)

    elif choice == 3:
        print("Using CFB mode.")
        return (AES.MODE_CFB, DES.MODE_CFB, DES3.MODE_CFB)

    else:
        print("Invalid choice!")
        return None, None, None

if __name__ == "__main__":
    select_encryption()