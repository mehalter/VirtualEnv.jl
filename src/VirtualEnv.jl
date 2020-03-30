""" VirtualEnv

Module to provide the ability to create self-contained julia virtual environments.

"""
module VirtualEnv

export venv

assetsdir() = normpath(joinpath(dirname(@__FILE__), "..", "assets"))

function create(env_dir::String)
  if Sys.iswindows()
    throw(ErrorException("Windows is not currently supported"))
  end
  if ispath(env_dir)
    throw(ErrorException(string("Folder ", env_dir, " exists")))
  end

  venv_dir = abspath(env_dir)
  bin_name = "bin"
  bin_dir = joinpath(venv_dir, bin_name)
  julia_exec = ENV["_"]
  activate_exec = joinpath(assetsdir(), "activate")

  mkpath(bin_dir)
  symlink(julia_exec, joinpath(bin_dir, "julia"))
  open(joinpath(bin_dir, "activate"), "w") do io
    for line in eachline(activate_exec)
      line = replace(line, "__VENV_DIR__" => venv_dir)
      line = replace(line, "__VENV_BIN_NAME__" => bin_name)
      write(io, string(line, "\n"))
    end
  end
end

"""
    venv(env_dirs::String...)

Create the listed environment directories.
"""
function venv(env_dirs::String...)
  for env_dir in env_dirs
    create(env_dir)
  end
end

end
