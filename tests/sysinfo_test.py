import sys
import unittest


class VersionTestCase(unittest.TestCase):
    # This test is intended to match the version-locked toolchain, and still pass regardless the
    # host OS's python, if any.  This ensures that the environment used is actually the intended
    # toolchain, in case of human-error triggering taint from host environment.

    def test_version_ok(self):
        ver = sys.version_info

        self.assertIsNotNone(ver)

        self.assertEqual(ver[0], 3)
        self.assertEqual(ver[1], 11)


if __name__ == "__main__":
    unittest.main()
