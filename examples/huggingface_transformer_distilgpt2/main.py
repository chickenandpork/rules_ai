# This is based on https://www.youtube.com/watch?v=tiZFewofSLM&t=160

from transformers import pipeline

def main():
    generator = pipeline("text-generation", model="distilgpt2")
    generator(
        "In this course, we will teach you how to",
        max_length=30,
        num_return_sequences=2,
    )

if __name__ == "__main__":
    main()

