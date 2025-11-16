### R/render.R
### Run this from the project root:
### source("R/render.R")

library(quarto)

message("Rendering project…")
quarto::quarto_render(as_job=FALSE)
message("Rendering finished.")


# --------------------------------------------------------------------
# Helper function to flatten directories
# --------------------------------------------------------------------

flatten_dir <- function(src, dest) {
  if (dir.exists(src)) {
    message("Flattening: ", src, " → ", dest)
    
    files <- list.files(src, full.names = TRUE)
    
    # Move files into destination
    for (f in files) {
      file.copy(
        from = f,
        to   = dest,
        overwrite = TRUE,
        recursive = TRUE
      )
    }
    
    # Remove the now-empty source folder
    unlink(src, recursive = TRUE)
  } else {
    message("Skipping (folder does not exist): ", src)
  }
}



flatten_dir("results/R", "results")

flatten_dir("results/doc", "doc")

message("All done. Output successfully flattened.")
