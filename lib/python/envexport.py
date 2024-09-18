import yaml
import re
import os

def env_export(filename, keys):
    """Load a yaml file <filename> and set environment variables from the list <keys> from k/v in
    the file.

    Intended use is like importing specific k/v from a yaml file to the env, such as specific
    secrets by key from a decrypted SOPS file.

    parameters:
     - filename: a filename such as "my/secrets.yaml"
     - keys: list of keys such as [ "OPENAI_API_KEY", "PROMPTLAYER_KEY" ]
    """

    with open(filename, 'r') as file:
        p = yaml.load(file, Loader=yaml.FullLoader)
        for k in keys:
            if k in p.keys():
                os.environ[k] = p[k]


