import unittest

import main
from transformers import pipeline, pipelines


class ExampleTest(unittest.TestCase):
    def test_main(self):
        # generate = main.generate()

        generator = pipeline("text-generation", model="distilgpt2")
        self.assertIsInstance(
            generator, pipelines.text_generation.TextGenerationPipeline
        )

        # Exercise/acivate the pipeline
        generate = generator(
            "In this course, we will teach you how to",
            max_length=30,
            num_return_sequences=2,
        )

        # The result of generator.__call__() is a list of dict such as:
        # [
        #     {'generated_text': 'In this course, we will teach you how to use your power to protect you and to protect you. This course will focus on the power of power'},
        #     {'generated_text': 'In this course, we will teach you how to use the methods you need to do before you can make your own changes to the app and how you'},
        # ]
        self.assertIs(type(generate), list)
        self.assertIs(type(generate[0]), dict)

        # We asked for 2 return sequences
        self.assertEqual(len(generate), 2)


if __name__ == "__main__":
    unittest.main()
