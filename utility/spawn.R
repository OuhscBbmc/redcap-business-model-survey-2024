# Install remotes & pluripotent if not already installed.  pluripotent won't reinstall if it's already up-to-date.
if( !requireNamespace("remotes") ) utils::install.packages("remotes")
remotes::install_github("OuhscBbmc/pluripotent")

# Discover repo name & parent directory.
project_name          <- basename(normalizePath(".."))
project_path          <- normalizePath("..")
project_parent_path   <- normalizePath("..\\..")
config_path           <- file.path(project_path, "config.yml")

if ("utility" != sub("^.+/(.+)$", "\\1", getwd()))  {
  stop(
    "You probably are not in the right directory.\n",
    "Close all RStudio instances and reopen with just the 'spawn.R' file.\n",
    "Note that this is one of the rare times that you do NOT use the .rproj file to open RStudio."
  )
}

# Copy remote files to the current repo.
pluripotent::start_r_analysis_skeleton(
  project_name          = project_name,
  destination_directory = project_parent_path
)

# Initialize values in config.yml
pluripotent::populate_config(
  path_in       = config_path,
  project_name  = project_name
)

warning("Now close RStudio and open the *.Rproj file in the repo's root directory.")
