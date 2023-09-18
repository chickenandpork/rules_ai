import unittest

import main
import sys
from transformers import pipelines


class ExampleTest(unittest.TestCase):
    def test_main(self):
        qa = main.qa()

        self.assertIsInstance(
            qa,
            pipelines.question_answering.QuestionAnsweringPipeline,
        )

        # Exercise/acivate the pipeline
        answer = qa(
            question="What did I eat?",
            context="We went down to the dock and met a few friends.  I gobbled a cookie and drank some very sweet tea as we walked the length of the docks",
        )

        # The result of qa.__call__() is a single dict such as:
        # {'score': 0.18500451743602753, 'start': 61, 'end': 67, 'answer': 'cookie'}

        self.assertIs(type(answer), dict)
        print(f"QA answer is {answer}", file=sys.stderr)

        # We asked for 1 answer
        self.assertEqual(answer["answer"], "cookie")


if __name__ == "__main__":
    unittest.main()
