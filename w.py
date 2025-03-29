import itertools
import nltk
from nltk.corpus import words, wordnet
from tqdm import tqdm

nltk.download('words')
nltk.download('wordnet')

adjectives = [word for word in words.words() if wordnet.synsets(word, pos=wordnet.ADJ) and 4 <= len(word) <= 6]
nouns = [word for word in words.words() if wordnet.synsets(word, pos=wordnet.NOUN) and 3 <= len(word) <= 6]
numbers = list(range(10, 100))

adjectives = [adj.capitalize() for adj in adjectives]
nouns = [noun.capitalize() for noun in nouns]

total_combinations = len(adjectives) * len(nouns) * len(numbers)

with open("passwords.txt", "w") as file:
    for i, (adj, noun, num) in enumerate(itertools.product(adjectives, nouns, numbers)):
        password = f"{adj}{noun}{num}"
        if 8 <= len(password) <= 12:
            file.write(f"{password}\n")
        
        if (i + 1) % 1000 == 0:
            tqdm.write(f"Progress: {100 * (i + 1) / total_combinations:.2f}%")

print("Password generation complete!")
