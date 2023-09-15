import unittest

import main
from transformers import pipelines


class ExampleTest(unittest.TestCase):
    def test_main(self):
        recognizer = main.recognize()

        # recognizer = pipeline(
        #    "ner",  # ner == Named Entity Recognition
        #    grouped_entities=True,  # this causes words like "Allan Clark" to remain grouped
        # )

        self.assertIsInstance(
            recognizer, pipelines.token_classification.TokenClassificationPipeline
        )

        # Exercise/acivate the pipeline
        recognize = recognizer(
            "Hi I'm Allan Clark from Seattle, and I used the Bazel tool at Apple, Snap, and BCAI"
        )

        # The result of recognizer.__call__() -- ie TokenClassificationPipeline.__call__() -- is a
        # list of dict such as:
        # [
        #     {'entity_group': 'PER', 'score': 0.9996722, 'word': 'Allan Clark', 'start': 7, 'end': 18}, <-- found a person
        #     {'entity_group': 'LOC', 'score': 0.99831665, 'word': 'Seattle', 'start': 24, 'end': 31}, <-- found a location
        #     {'entity_group': 'MISC', 'score': 0.90329456, 'word': 'Bazel', 'start': 48, 'end': 53}, <-- found !org !person !location
        #     {'entity_group': 'ORG', 'score': 0.9920346, 'word': 'Apple', 'start': 62, 'end': 67}, <-- found an organization
        #     {'entity_group': 'ORG', 'score': 0.87771577, 'word': 'Snap', 'start': 69, 'end': 73},
        #     {'entity_group': 'ORG', 'score': 0.980426, 'word': 'BCAI', 'start': 79, 'end': 83},
        # ]

        self.assertIs(type(recognize), list)
        self.assertIs(type(recognize[0]), dict)

        # this is not reliable in general; empirically, the model gave me 6 tokens
        self.assertEqual(len(recognize), 6)


if __name__ == "__main__":
    unittest.main()
