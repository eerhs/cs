import hashlib
import random
import time

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

def measure_hashing_speed(num_inputs: int):
    inputs = random_inputs(num_inputs)
    start = time.time()
    for i in inputs:
        count_1_bits_in_hash(i)
    end = time.time()
    
    elapsed_time = end - start
    hashes_per_second = num_inputs / elapsed_time
    return elapsed_time, hashes_per_second

def estimate_time_for_hashes(hashes_per_second: float, total_hashes: int):
    seconds = total_hashes / hashes_per_second
    return seconds


num_inputs = 1000
elapsed_time, hashes_per_second = measure_hashing_speed(num_inputs)

# Report timings
print(f"Elapsed time for {num_inputs} hashes: {elapsed_time:.6f} seconds")
print(f"Hashes per second: {hashes_per_second:.2f}")

# Estimations
hashes_2_128 = 2**128
hashes_2_256 = 2**256

time_2_128 = estimate_time_for_hashes(hashes_per_second, hashes_2_128)
time_2_256 = estimate_time_for_hashes(hashes_per_second, hashes_2_256)


def seconds_to_years(seconds):
    years = seconds / (60 * 60 * 24 * 365)
    return years

print(f"Time to compute 2^128 hashes: {seconds_to_years(time_2_128):.2e} years")
print(f"Time to compute 2^256 hashes: {seconds_to_years(time_2_256):.2e} years")