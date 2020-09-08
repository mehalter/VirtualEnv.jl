using Documenter

@info "Loading VirtualEnv"
using VirtualEnv

@info "Building Documenter.jl docs"
makedocs(
  modules   = [VirtualEnv],
  format    = Documenter.HTML(
    assets = ["assets/analytics.js"],
  ),
  sitename  = "VirtualEnv.jl",
  doctest   = false,
  checkdocs = :none,
  pages     = Any[
    "VirtualEnv.jl" => "index.md",
    "Library Reference" => "api.md",
  ]
)

@info "Deploying docs"
deploydocs(
  target = "build",
  repo   = "github.com/mehalter/VirtualEnv.jl.git",
  branch = "gh-pages"
)
