# This is based on https://www.youtube.com/watch?v=tiZFewofSLM&t=160

from transformers import pipeline, pipelines


def recognize() -> pipelines.token_classification.TokenClassificationPipeline:
    return pipeline(
        "ner",  # ner == Named Entity Recognition
        grouped_entities=True,  # this causes words like "Allan Clark" to remain grouped
    )


def main():
    rec = recognize(
        "Hi I'm Allan Clark from Seattle, and I used the Bazel tool at Apple, Snap, and BCAI"
    )
    print(f"Result: {rec}")


if __name__ == "__main__":
    main()
