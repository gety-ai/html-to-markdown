# Check Minimum Supported Rust Version (MSRV)
# Validates that installed rustc meets the package's minimum version requirement.

extract_semver <- function(version_string) {
  m <- regmatches(version_string, regexec("(\\d+\\.\\d+\\.\\d+)", version_string))
  if (length(m[[1]]) >= 2) m[[1]][2] else NA_character_
}

desc <- read.dcf("DESCRIPTION")

if (!"SystemRequirements" %in% colnames(desc)) {
  stop("SystemRequirements not found in DESCRIPTION.")
}

sysreqs <- desc[, "SystemRequirements"]

if (!grepl("cargo", sysreqs, ignore.case = TRUE)) {
  stop("SystemRequirements must mention Cargo.")
}
if (!grepl("rustc", sysreqs, ignore.case = TRUE)) {
  stop("SystemRequirements must mention rustc.")
}

new_path <- paste0(
  Sys.getenv("PATH"),
  ":",
  paste0(Sys.getenv("HOME"), "/.cargo/bin")
)
Sys.setenv("PATH" = new_path)

cargo_version <- tryCatch(
  system("cargo --version", intern = TRUE),
  error = function(e) {
    stop(
      "cargo not found. Please install Rust: https://www.rust-lang.org/tools/install",
      call. = FALSE
    )
  }
)

rustc_version <- tryCatch(
  system("rustc --version", intern = TRUE),
  error = function(e) {
    stop(
      "rustc not found. Please install Rust: https://www.rust-lang.org/tools/install",
      call. = FALSE
    )
  }
)

parts <- strsplit(sysreqs, ",\\s*")[[1]]
rustc_part <- parts[grepl("rustc", parts)]
msrv <- extract_semver(rustc_part)
current_version <- extract_semver(rustc_version)

if (!is.na(msrv) && !is.na(current_version)) {
  if (utils::compareVersion(msrv, current_version) == 1) {
    stop(
      sprintf(
        "Minimum supported Rust version is %s but installed rustc is %s. Please update Rust.",
        msrv,
        current_version
      ),
      call. = FALSE
    )
  }
}

message(sprintf("Using %s", cargo_version))
message(sprintf("Using %s", rustc_version))
