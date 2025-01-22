import hashlib
import random
import matplotlib.pyplot as plt

def random_inputs(num_inputs: int, length: int = 10):
    inputs = []
    for _ in range(num_inputs):
        random_string = ''.join(random.choices('abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789', k=length))
        inputs.append(random_string)
    return inputs

def count_1_bits_in_hash(input_string: str) -> int:
    sha256_hash = hashlib.sha256(input_string.encode('utf-8')).hexdigest()
    binary_hash = bin(int(sha256_hash, 16))[2:]  # hash to binary
    return binary_hash.count('1')

def compute_histogram(num_inputs: int):
    inputs = random_inputs(num_inputs)
    bit_counts = [count_1_bits_in_hash(inp) for inp in inputs]
    
    # Create a histogram of the bit counts
    max_bits = max(bit_counts)
    histogram = [0] * (max_bits + 1)
    for count in bit_counts:
        histogram[count] += 1
    
    return histogram

def plot_histogram(histogram):
    plt.bar(range(len(histogram)), histogram, color='blue', alpha=0.7)
    plt.xlabel("Number of 1-bits in SHA-256 hash")
    plt.ylabel("Frequency")
    plt.title("Histogram of 1-bits in SHA-256 hash values")
    plt.show()


num_inputs = 1000
histogram = compute_histogram(num_inputs)

# Print histogram data
for count, freq in enumerate(histogram):
    if freq > 0:
        print(f"1-bit count: {count}, Frequency: {freq}")

# Plot histogram
plot_histogram(histogram)