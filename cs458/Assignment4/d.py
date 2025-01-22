from scipy.special import comb

def binomial_probability(n, k, p=0.5):
    return comb(n, k) * (p**k) * ((1-p)**(n-k))

n = 256
p = 0.5
prob_128 = binomial_probability(n, 128, p)
prob_100 = binomial_probability(n, 100, p)

print(f"Probability of exactly 128 bits set to one: {prob_128:.3e}")
print(f"Probability of exactly 100 bits set to one: {prob_100:.3e}")