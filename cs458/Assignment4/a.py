import hashlib

def sha256_hash(name: str) -> str:
    # Encode the name to bytes
    encoded_name = name.encode('utf-8')
    # Compute the SHA-256 hash
    sha256_hash = hashlib.sha256(encoded_name).hexdigest()
    return sha256_hash

name = "Shree Ramachandran Muthukumaran"
hash_value = sha256_hash(name)

print(f"SHA-256 hash value of the name '{name}' in hexadecimal: {hash_value}")