import unittest

import main


class ExampleTest(unittest.TestCase):
    def test_main(self):
        generate = main.generate()
        self.assertEqual(2, len(generate))


if __name__ == "__main__":
    unittest.main()
