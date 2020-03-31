""" VirtualEnv

Module to provide the ability to create self-contained julia virtual environments.

"""
module VirtualEnv

export venv

include("Utilities.jl")

"""
    usage()

Print usage of the venv function
"""
function usage()
  print("""
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
""")
end

"""
    create(env_dir::String, clear::Bool, upgrade::Bool)

Helper function to create a single virtual environment
"""
function create(env_dir::String, clear::Bool, upgrade::Bool)
  # Check compatibility
  if Sys.iswindows()
    throw(ErrorException("Windows is not currently supported"))
  end

  # Create variables for use throughout
  venv_dir = abspath(env_dir)
  bin_name = "bin"
  bin_dir = joinpath(venv_dir, bin_name)

  julia_depot = ENV["JULIA_DEPOT_PATH"]
  julia_exec = ENV["_"]
  activate_exec = joinpath(assets_dir(), "activate")
  registries_orig = joinpath(julia_depot, "registries")

  julia_dest = joinpath(bin_dir, "julia")
  activate_dest = joinpath(bin_dir, "activate")
  registries_dest = joinpath(venv_dir, "registries")

  # Check that dependent files exist on the system
  check_exists(julia_exec)
  check_exists(activate_exec)
  check_exists(registries_orig)

  # Create environment directory
  if ispath(venv_dir) && clear
    rm(venv_dir; force=true, recursive=true)
  end
  mkpath(bin_dir)

  # Create julia executable symlink
  if upgrade
    rm(julia_dest; force=true)
  end
  if !isfile(julia_dest)
    symlink(julia_exec, julia_dest)
  end

  # Create activate executable
  if !isfile(activate_dest)
    open(activate_dest, "w") do io
      for line in eachline(activate_exec)
        line = replace(line, "__VENV_DIR__" => venv_dir)
        line = replace(line, "__VENV_BIN_NAME__" => bin_name)
        write(io, string(line, "\n"))
      end
    end
  end

  # Create symlink to central registries
  if !isdir(registries_dest)
    symlink(registries_orig, registries_dest)
  end
end

"""
    venv(env_dirs::String...; clear::Bool=false, upgrade::Bool=false)

Create the listed environment directories.
"""
function venv(env_dirs::String...; clear::Bool=false, upgrade::Bool=false, help::Bool=false)
  # Print usage if no environment directories given
  if help || isempty(env_dirs)
    usage()
  # Create each environment directory provided if directories provided
  else
    for env_dir in env_dirs
      create(env_dir, clear, upgrade)
    end
  end
end

end
