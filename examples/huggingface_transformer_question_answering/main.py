# This is based on https://www.youtube.com/watch?v=tiZFewofSLM&t=160

from transformers import pipeline, pipelines


def qa() -> pipelines.question_answering.QuestionAnsweringPipeline:
    # a stub-function in this case, but can be used for more complex initialization
    return pipeline("question-answering")

    # The result of qa.__call__() is a single dict such as:
    # {'score': 0.27218255400657654, 'start': 14, 'end': 20, 'answer': 'cookie'}


def main():
    # Instantiate the pipeline
    answering = qa()

    # Exercise the pipeline
    answer = answering(
        question="What did I eat?",
        context="We went down to the dock and met a few friends.  I gobbled a cookie and drank some very sweet tea as we walked the length of the docks",
    )
    print(f"Result: {answer}")


if __name__ == "__main__":
    main()
