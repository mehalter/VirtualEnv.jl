""" VirtualEnv

Module to provide the ability to create self-contained julia virtual environments.

"""
module VirtualEnv

export venv

include("Utilities.jl")

""" Julia instance context definition
"""
struct Context
  install::String
  bin::String
  lib::String
  libexec::String
  share::String
  depot::String
  registries::String
end

"""
    context(install_dir::String, depot_dir::String)

Helper function to instantiate a julia context
"""
function context(install_dir::String, depot_dir::String)
  return Context(install_dir,
                 joinpath(install_dir, "bin"),
                 joinpath(install_dir, "lib"),
                 joinpath(install_dir, "libexec"),
                 joinpath(install_dir, "share"),
                 depot_dir,
                 joinpath(depot_dir, "registries")
                )
end

"""
    usage()

Print usage of the venv function
"""
function usage()
  print("""
usage: venv(ENV_DIR, [ENV_DIR, ...]; [clear=(true|false)], [upgrade=(true|false)],
            [prompt=PROMPT], [help=(true|false)])

Creates virtual Julia environments in one or more target directories.

positional arguments:
  ENV_DIR               A directory to create the environment in.

optional arguments:
  help=(true|false)     show this help message and exit
  clear=(true|false)    Delete the contents of the environment directory if it
                        already exists, before environment creation. (Default: false)
  upgrade=(true|false)  Upgrade the environment directory to use this version
                        of Julia, assuming Julia has been upgraded in-place. (Default: false)
  prompt=PROMPT         Provides an alternative prompt prefix for this environment. (Default: ENV_DIR)

Once an environment has been created, you may wish to activate it,
e.g. by sourcing an activate script in its bin directory.
""")
end

"""
    create(env_dir::String, clear::Bool, upgrade::Bool, prompt::String)

Helper function to create a single virtual environment
"""
function create(env_dir::String, clear::Bool, upgrade::Bool, prompt::String)
  # Set system specific variables
  if Sys.iswindows()
    exec_name = "julia.exe"
    sym = false
  else
    exec_name = "julia"
    sym = true
  end

  # set original context
  julia_install   = abspath(joinpath(Sys.BINDIR, ".."))
  julia_depot     = get(ENV, "JULIA_DEPOT_PATH", joinpath(Sys.homedir(), ".julia"))
  orig_context = context(julia_install, julia_depot)

  # set virtual environment variables
  venv_dir        = abspath(env_dir)
  venv_depot      = joinpath(venv_dir, ".julia")
  venv_context = context(venv_dir, venv_depot)

  # set venv prompt
  if isempty(prompt)
    venv_prompt   = basename(venv_context.install)
  else
    venv_prompt   = prompt
  end
  venv_prompt     = string("(", venv_prompt, ") ")

  # Check that dependent files exist on the system
  check_exists(orig_context.lib)
  if VERSION > v"1.0"
    check_exists(orig_context.libexec)
  end
  check_exists(orig_context.share)

  # Create environment directory
  if ispath(venv_context.install) && clear
    rm(venv_context.install; force=true, recursive=true)
  end
  mkpath(venv_context.bin)
  mkpath(venv_context.share)
  mkpath(venv_context.depot)

  # Create julia installation
  for file in readdir(orig_context.bin)
    sym_or_cp(joinpath(orig_context.bin, file), joinpath(venv_context.bin, file), sym, upgrade)
  end
  sym_or_cp(orig_context.lib, venv_context.lib, sym, upgrade)
  if VERSION > v"1.0"
    sym_or_cp(orig_context.libexec, venv_context.libexec, sym, upgrade)
  end
  sym_or_cp(joinpath(orig_context.share, "julia"), joinpath(venv_context.share, "julia"), sym, upgrade)

  # Create activate executable
  for file in readdir(assets_dir())
    file_orig = joinpath(assets_dir(), file)
    file_dest = joinpath(venv_context.bin, file)
    if !isfile(file_dest)
      open(file_dest, "w") do io
        for line in eachline(file_orig)
          line = replace(line, "__VENV_DIR__" => venv_context.install)
          line = replace(line, "__VENV_PROMPT__" => venv_prompt)
          line = replace(line, "__DEPOT_DIR__" => venv_context.depot)
          write(io, string(line, "\n"))
        end
      end
    end
  end

  # Create symlink to central registries
  sym_or_cp(orig_context.registries, venv_context.registries, sym, false)
end

"""
    venv(env_dirs::String...; clear::Bool=false, upgrade::Bool=false, prompt::String=nothing)

Create the listed environment directories.
"""
function venv(env_dirs::String...; clear::Bool=false, upgrade::Bool=false, help::Bool=false, prompt::String="")
  # Print usage if no environment directories given
  if help || isempty(env_dirs)
    usage()
  # Create each environment directory provided if directories provided
  else
    for env_dir in env_dirs
      create(env_dir, clear, upgrade, prompt)
    end
  end
end

end
