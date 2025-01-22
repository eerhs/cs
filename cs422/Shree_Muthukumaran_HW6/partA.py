import csv

# Create a dictionary to map product IDs to product names
product_map = {}
with open('products.csv', 'r') as file:
    reader = csv.reader(file)
    for row in reader:
        product_id = int(row[0])
        product_name = row[1]
        product_map[product_id] = product_name

# Read the tr-20k.csv file and transform product IDs to names
with open('tr-20k.csv', 'r') as infile, open('tr-20k-canonical.csv', 'w') as outfile:
    reader = csv.reader(infile)
    for row in reader:
        transaction_id = row[0]
        product_ids = map(int, row[1:])
        product_names = [product_map[pid] for pid in product_ids]
        outfile.write(", ".join(product_names) + "\n")