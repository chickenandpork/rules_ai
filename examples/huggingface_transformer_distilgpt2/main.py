# This is based on https://www.youtube.com/watch?v=tiZFewofSLM&t=160

from transformers import pipeline, pipelines


def generate() -> pipelines.text_generation.TextGenerationPipeline:
    return pipeline("text-generation", model="distilgpt2")


def main():
    gen = generate(
        "In this course, we will teach you how to",
        max_length=30,
        num_return_sequences=2,
    )

    # gen is low a list of dist: [ {'generated_text': 'In this course, ...'}, {'generated_text': 'In this course, ...'} ]
    print(f"Result: {gen}")


if __name__ == "__main__":
    main()
