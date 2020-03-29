""" VirtualEnv

Module to provide the ability to create self-contained julia virtual environments.

"""
module VirtualEnv

export venv

assetsdir() = normpath(joinpath(dirname(@__FILE__), "..", "assets"))

function venv(env::String)
  if ispath(env)
    println("ERROR: Folder ", env, " exists")
    exit(1)
  end

  venv_dir = abspath(env)
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



end
