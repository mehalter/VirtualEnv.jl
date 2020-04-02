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
  # Create variables for use throughout
  venv_dir = abspath(env_dir)
  venv_prompt = basename(venv_dir)
  if Sys.iswindows()
    exec_name = "julia.exe"
    sym = false
  else
    exec_name = "julia"
    sym = true
  end

  julia_depot     = get(ENV, "JULIA_DEPOT_PATH", joinpath(Sys.homedir(), ".julia"))
  julia_install   = abspath(joinpath(Sys.BINDIR, ".."))
  julia_lib       = joinpath(julia_install, "lib")
  julia_libexec   = joinpath(julia_install, "libexec")
  julia_share     = joinpath(julia_install, "share", "julia")

  activate_exec   = joinpath(assets_dir(), "activate")
  registries_orig = joinpath(julia_depot, "registries")

  bin_dest         = joinpath(venv_dir, "bin")
  activate_dest   = joinpath(bin_dest, "activate")
  lib_dest        = joinpath(venv_dir, "lib")
  libexec_dest    = joinpath(venv_dir, "libexec")
  share_dir       = joinpath(venv_dir, "share")
  share_dest      = joinpath(share_dir, "julia")

  venv_depot      = joinpath(venv_dir, ".julia")
  registries_dest = joinpath(venv_depot, "registries")

  # Check that dependent files exist on the system
  check_exists(julia_lib)
  check_exists(julia_libexec)
  check_exists(julia_share)
  check_exists(activate_exec)

  # Create environment directory
  if ispath(venv_dir) && clear
    rm(venv_dir; force=true, recursive=true)
  end
  mkpath(bin_dest)
  mkpath(share_dir)
  mkpath(venv_depot)

  # Create julia installation
  for file in readdir(Sys.BINDIR)
    sym_or_cp(joinpath(Sys.BINDIR, file), joinpath(bin_dest, file), sym, upgrade)
  end
  sym_or_cp(julia_lib, lib_dest, sym, upgrade)
  sym_or_cp(julia_libexec, libexec_dest, sym, upgrade)
  sym_or_cp(julia_share, share_dest, sym, upgrade)

  # Create activate executable
  for file in readdir(assets_dir())
    file_orig = joinpath(assets_dir(), file)
    file_dest = joinpath(bin_dest, file)
    if !isfile(file_dest)
      open(file_dest, "w") do io
        for line in eachline(file_orig)
          line = replace(line, "__VENV_DIR__" => venv_dir)
          line = replace(line, "__VENV_PROMPT__" => venv_prompt)
          line = replace(line, "__DEPOT_DIR__" => venv_depot)
          write(io, string(line, "\n"))
        end
      end
    end
  end

  # Create symlink to central registries
  if ispath(registries_orig)
    sym_or_cp(registries_orig, registries_dest, sym, false)
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
