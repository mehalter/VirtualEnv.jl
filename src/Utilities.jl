"""
    assets_dir()

Helper function to create assets path
"""
assets_dir() = normpath(joinpath(dirname(@__FILE__), "..", "assets"))

"""
    check_exists(path::String)

Helper function to check if necessary files exist on the system
"""
function check_exists(path::String)
  if !ispath(path)
    throw(ErrorException(string("Necessary path doesn't exist on system: ", path)))
  end
end

"""
    sym_or_cp(path_orig::String, path_dest::String, sym::Bool)

Helper function that if sym is true, symlink the original path to the destination
if sym is false, cp the original path to the destination
"""
function sym_or_cp(path_orig::String, path_dest::String, sym::Bool, upgrade::Bool)
  if upgrade
    rm(path_dest; force=true)
  end
  if !ispath(path_dest)
    if sym
      symlink(path_orig, path_dest)
    else
      cp(path_orig, path_dest; follow_symlinks=true)
    end
  end
end
