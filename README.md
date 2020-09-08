# VirtualEnv.jl

VirtualEnv.jl provides support for creating lightweight “virtual environments”
with their own site directories, isolated from system site directories. Each
virtual environment has its own Julia binary (which matches the version of the
binary that was used to create this environment) and can have its own
independent set of installed Julia packages in its site directories.

## Supported Shells

- Bash
- ZSH
- Windows Command Prompt

### Upcoming

- Fish
- CSH
- Powershell

# Installation

```
~$ julia -e 'using Pkg; Pkg.add("VirtualEnv")'
```

add `~/.julia/bin` to your `PATH`, or you can install paths automatically with

```julia
using VirtualEnv; VirtualEnv.comonicon_install_path()
```

# Usage

```
  venv

Creates virtual Julia environments in one or more target directories.

Usage

  venv [options] [flags] <env_dirs>

Args

  <env_dirs>               One or more directories to create environments in.

Options

  -p, --prompt <prompt>    Provides an alternative prompt prefix for this
                           environment.(Default: ENV_DIR)

Flags

  -c, --clear              Delete the contents of the environment directory if it
                           alreadyexists. (Default: false)

  -u, --upgrade            Upgrade the environment directory to use this version
                           ofJulia. (Default: false)

  -h, --help               print this help message

  -V, --version            print version information
```

Print help dialogue:

`~$ venv -h`

Creating a virtual environment:

`~$ venv env`

Activating the virtual environment:

`~$ source env/bin/activate`

Deactivating an environment:

`~$ deactivate`
