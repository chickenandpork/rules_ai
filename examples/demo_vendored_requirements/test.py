# This is exactly https://github.com/bazelbuild/rules_python/blob/main/examples/pip_parse/test.py @018e355

import unittest

import main


class ExampleTest(unittest.TestCase):
    def test_main(self):
        self.assertEqual("2.31.0", main.version())


if __name__ == "__main__":
    unittest.main()
