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
