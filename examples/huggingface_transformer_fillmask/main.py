# This is based on https://www.youtube.com/watch?v=tiZFewofSLM&t=160

from transformers import pipeline, pipelines


def fillmask() -> pipelines.fill_mask.FillMaskPipeline:
    # a stub-function in this case, but can be used for more complex initialization
    return pipeline("fill-mask")

    # The result of maskfiller.__call__() is a list of dict such as:
    # [
    #     {'score': 0.27218255400657654, 'token': 30559, 'token_str': ' strawberry', 'sequence': 'I am hungry for strawberry icecream'},
    #     {'score': 0.13239310681819916, 'token': 7548, 'token_str': ' chocolate', 'sequence': 'I am hungry for chocolate icecream'}
    #     { ... one more ... (top_k=3) ...}
    # ]


def main():
    # Instantiate the pipeline
    maskfiller = fillmask()

    # Exercise it
    fill = maskfiller("I am hungry for <mask> icecream", top_k=3)
    print(f"Result: {fill}")


if __name__ == "__main__":
    main()
