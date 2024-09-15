# Caesar Cipher Program: Encryption, Decryption, and Brute Force Attack

# Function to encrypt plaintext using the Caesar cipher
def encrypt(plaintext, key):
    ciphertext = ""
    for char in plaintext:
        if char.isalpha():
            shift = 65 if char.isupper() else 97
            ciphertext += chr((ord(char) - shift + key) % 26 + shift)
        else:
            ciphertext += char
    return ciphertext

# Function to decrypt ciphertext using the Caesar cipher
def decrypt(ciphertext, key):
    plaintext = ""
    for char in ciphertext:
        if char.isalpha():
            shift = 65 if char.isupper() else 97
            plaintext += chr((ord(char) - shift - key) % 26 + shift)
        else:
            plaintext += char
    return plaintext

# Function to perform brute force attack on the ciphertext
def brute_force_attack(ciphertext):
    print("Brute Force Attack Results:")
    for key in range(26):
        possible_plaintext = decrypt(ciphertext, key)
        print(f"Key {key}: {possible_plaintext}")

# Main menu and user interaction
def main():
    while True:
        print("\nChoose an option:")
        print("1. Encryption")
        print("2. Decryption")
        print("3. Brute Force Attack")
        print("4. Exit")
        choice = input("Enter your choice (1/2/3/4): ")

        if choice == '1':  # Encryption
            plaintext = input("Enter plaintext: ")
            try:
                key = int(input("Enter key (numeric): "))
                ciphertext = encrypt(plaintext, key)
                print(f"Ciphertext: {ciphertext}")
            except ValueError:
                print("Invalid key! Please enter a numeric value.")

        elif choice == '2':  # Decryption
            ciphertext = input("Enter ciphertext: ")
            try:
                key = int(input("Enter key (numeric): "))
                plaintext = decrypt(ciphertext, key)
                print(f"Decrypted Plaintext: {plaintext}")
            except ValueError:
                print("Invalid key! Please enter a numeric value.")

        elif choice == '3':  # Brute Force Attack
            ciphertext = input("Enter ciphertext: ")
            brute_force_attack(ciphertext)

        elif choice == '4':  # Exit
            print("Exiting the program.")
            break

        else:
            print("Invalid choice! Please enter 1, 2, 3, or 4.")

# Run the program
if __name__ == "__main__":
    main()