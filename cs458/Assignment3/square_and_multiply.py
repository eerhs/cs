def square_and_multiply(x, y, n):
    """
    Compute x^y mod n using the square-and-multiply algorithm.

    Parameters:
    x (int): Base
    y (int): Exponent
    n (int): Modulus

    Returns:
    The result of x^y mod n
    """
    binary_y = bin(y)[2:]   # Convert y to binary
    result = 1              # Start with result = 1

    # Iterate through each bit in the binary representation of y
    for bit in binary_y:
        result = (result * result) % n  # Square the current result
        if bit == '1':                  # If the bit is 1, multiply by x and take modulo n
            result = (result * x) % n

    return result

# Test cases
print(square_and_multiply(5, 13, 23))   # Expected output: 21
print(square_and_multiply(12, 17, 29))  # Expected output: 12
print(square_and_multiply(10, 25, 37))  # Expected output: 10