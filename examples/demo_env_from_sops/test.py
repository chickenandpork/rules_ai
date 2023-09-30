import unittest

import os
from rules_ai.lib.python.envexport import env_export


class ExampleTest(unittest.TestCase):
    def test_env_is_present(self):
        self.assertIn("OPENAI_API_KEY", os.environ)
        self.assertNotIn("BOB", os.environ)  # "BOB" key defined in yaml file but not in `keys`


if __name__ == "__main__":
    if "SOPS" in os.environ:
        env_export(filename=os.environ["SOPS"], keys = [ "OPENAI_API_KEY" ] )
    unittest.main()
