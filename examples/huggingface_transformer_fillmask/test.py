import unittest

import main
from transformers import pipelines


class ExampleTest(unittest.TestCase):
    def test_main(self):
        maskfiller = main.fillmask()

        self.assertIsInstance(
            maskfiller,
            pipelines.fill_mask.FillMaskPipeline,
        )

        # Exercise/acivate the pipeline
        filler = maskfiller(
            "I am hungry for <mask> icecream",
            top_k=3,
        )

        # The result of maskfiller.__call__() is a list of dict such as:
        # [
        #     {'score': 0.27218255400657654, 'token': 30559, 'token_str': ' strawberry', 'sequence': 'I am hungry for strawberry icecream'},
        #     {'score': 0.13239310681819916, 'token': 7548, 'token_str': ' chocolate', 'sequence': 'I am hungry for chocolate icecream'}
        # ]
        self.assertIs(type(filler), list)
        self.assertIs(type(filler[0]), dict)

        # We asked for 3 return sequences ("top_k = 3")
        self.assertEqual(len(filler), 3)


if __name__ == "__main__":
    unittest.main()
