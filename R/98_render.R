### R/render.R
### Run this from the project root:
### source("R/render.R")

library(quarto)
library(fs)


if (capabilities("cairo")) {
  options(bitmapType = "cairo")
}


out_dir <- "results"


if (!dir.exists(out_dir)) {
  dir.create(out_dir, recursive = TRUE)
}

message("------------------------------------------------")
message("Step 1: Rendering project (In-place)...")
message("------------------------------------------------")

quarto::quarto_render(as_job = FALSE)

message("Rendering finished. Starting manual file move...")

# --------------------------------------------------------------------
# Helper to move files robustly
# --------------------------------------------------------------------
move_project_files <- function(src_folder, dest_folder) {
  
  # Find HTML files and their corresponding _files folders
  html_files <- list.files(src_folder, pattern = "\\.html$", full.names = TRUE)
  
  for (file in html_files) {
    filename <- basename(file)
    
    source_html <- file
    dest_html   <- file.path(dest_folder, filename)
    
    source_supp <- sub("\\.html$", "_files", file) # The support folder (images/libs)
    dest_supp   <- file.path(dest_folder, basename(source_supp))
    
    message(paste("Moving:", filename, "->", dest_folder))
    
    file.copy(from = source_html, to = dest_html, overwrite = TRUE)
    unlink(source_html)
    
    if (dir.exists(source_supp)) {
      if(dir.exists(dest_supp)) unlink(dest_supp, recursive = TRUE)
      
      file.copy(from = source_supp, to = dest_folder, recursive = TRUE)
      unlink(source_supp, recursive = TRUE)
    }
  }
}

# --------------------------------------------------------------------
# Execute Moves
# --------------------------------------------------------------------

# Move files from R/ folder to results/
move_project_files("R", out_dir)

# Move files from doc/ folder to results/
# move_project_files("doc", out_dir) 

message("------------------------------------------------")
message("SUCCESS: Project rendered and files moved to '", out_dir, "'")