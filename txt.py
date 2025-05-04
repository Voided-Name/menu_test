import json
from collections import defaultdict

# Input and output file names
input_file = "words.txt"
output_file = "words_by_length.json"

# Dictionary to hold grouped words
word_map = defaultdict(list)

# Read and process the file
with open(input_file, 'r') as f:
    for line in f:
        word = line.strip().lower()
        if word.isalpha():  # skip numbers/symbols if any
            word_map[len(word)].append(word)

# Convert defaultdict to normal dict for JSON
word_map = dict(word_map)

# Save to JSON
with open(output_file, 'w') as f:
    json.dump(word_map, f, indent=4)

print(f"Saved grouped words to {output_file}")

