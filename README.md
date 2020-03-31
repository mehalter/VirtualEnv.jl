# VirtualEnv.jl

Self contained virtual environments for Julia.

**Currently only officially supports Linux, but it should work on Mac OS X**

# Installation

Current installation until ready to put on General.jl repository

`~$ julia -e 'using Pkg; Pkg.add("https://git.mehalter.com/mehalter/VirtualEnv.jl.git")'`

# Usage

```
usage: venv(ENV_DIR, [ENV_DIR, ...]; [clear=(true|false)], [upgrade=(true|false)], [help=(true|false)])

Creates virtual Julia environments in one or more target directories.

positional arguments:
  ENV_DIR               A directory to create the environment in.

optional arguments:
  help=(true|false)     show this help message and exit
  clear=(true|false)    Delete the contents of the environment directory if it
                        already exists, before environment creation. (Default: false)
  upgrade=(true|false)  Upgrade the environment directory to use this version
                        of Julia, assuming Julia has been upgraded in-place. (Default: false)

Once an environment has been created, you may wish to activate it,
e.g. by sourcing an activate script in its bin directory.
```

Print help dialogue:

`~$ julia -e 'using VirtualEnv; venv(help=true)'`

Creating a virtual environment:

`~$ julia -e 'using VirtualEnv; venv("env")'`

Activating the virtual environment:

`~$ source env/bin/activate`

Deactivating an environment:

`~$ deactivate`
