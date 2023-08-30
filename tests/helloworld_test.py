import unittest
from tests.helloworld import HelloWorld


class HelloWorldTestCase(unittest.TestCase):
    def test_message_ok(self):
        hello = HelloWorld()

        self.assertIsNotNone(hello.message)
        self.assertEqual(hello.message, "Hello world!")
        self.assertNotEqual(hello.message, "Hello WORLD!")


if __name__ == "__main__":
    unittest.main()
