# generate template for exporting SOPS files -- decrypted -- to Environment
#
# LangChain and others take the simple route: if they need a credential or a secret, they expect it
# to be on the environmrnt of the running App.  So aweseome, except in cases suh as SOPS-protected
# secrets in code: you're encrypting and descripting the secret, which can be exported in a
# `deployment` file (envFromSecrets) but is a bit more difficult when you're opening the plaintext
# decrypted SOPS file in the app that's already running and has its env set up.
#
# The idea here is a boring boilerplate of opening a decrypted file, finding certain secrets,
# exporting them to env.  If you're re-using the same secret across a number of tests or services,
# but not exporting all the secrets to all the tests (ie CHOOSING what to export), then you've got
# a bunch of encrypted 1- or 2-credential files, all shared, but not all shared by all.
#
# This boilerplate will be a bunch of copy-pasta to write, maintain when better patterns arise,
# etc.  Blech.  Let's just template that part in.
#
# I'd like to maintain a service such as:
#
# ```
# sops_env_export(
#     name = "chatbot_openai_env",
#     mapping = { ":decrypt_openai_sops": [ "OPENAI_API_KEY" ] }
# }
#
# sops_env_export(
#     name = "chatbot_prompt_env",
#     mapping = { ":decrypt_promptlayer_sops": [ "PROMPTLAYER_API_KEY" ] }
# )
#
# py_binary(
#     name = "chatbot",
#     srcs = [
#         "main.py",  # some mainfunc flask/fast API for slack API
#         # These ENV templates can be off in different directories of course
#         ":chatbot_openai_env"  # generated python file for openai envexport
#         ":chatbot_promptlayer_env"  # generated python file for promptlayer envexport
#     ],
# )
#
# The key here is that the `main.py` should be fairly trivial, and the "code" to maintain isn't
# some cut-n-paste boilerplate, but a reusable "mapping = { ... }" block allowing very consistent
# definition of an environment variable from a SOPS-protected file.  


