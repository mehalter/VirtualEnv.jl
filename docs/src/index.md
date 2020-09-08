# VirtualEnv.jl

```@meta
CurrentModule = VirtualEnv
```

VirtualEnv.jl provides support for creating lightweight “virtual environments”
with their own site directories, isolated from system site directories. Each
virtual environment has its own Julia binary (which matches the version of the
binary that was used to create this environment) and can have its own
independent set of installed Julia packages in its site directories.

## Installation

 VirtualEnv is a Julia Language package. To install VirtualEnv, please open Julia's interactive session (known as REPL) and press `]` key in the REPL to use the package mode, then type the following command

For stable release

```
pkg> add VirtualEnv
```

For current master

```
pkg> add VirtualEnv#master
```

## Usage

Creation of virtual environments is done by executing the command `venv`:

```
julia -e 'using VirtualEnv; venv("/path/to/new/virtual/environment")'
```

An executable is also created in your `.julia` folder in `.julia/bin` (The
default location of this folder is `~/.julia`) which can be used for easier
execution:

```
venv /path/to/new/virtual/environment
```

The help text can easily be displayed in the Julia REPL with `?venv` or by
executing the command `venv -h`. This shows the available options when
creating new environments or upgrading existing environments.

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

## Global Installation

It is recommended to add this `.julia/bin` folder to your `PATH` so that the
executable is available everywhere. To easily add the appropriate locations to
your path, you can run the following:

```
julia> using VirtualEnv
julia> VirtualEnv.comonicon_install_path()
```
