# This is exactly https://github.com/bazelbuild/rules_python/blob/main/examples/pip_parse/main.py @018e355

import requests


def version():
    return requests.__version__
