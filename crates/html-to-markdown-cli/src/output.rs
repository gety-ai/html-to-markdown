// reason: CLI application modules do not expose docs to users; doc coverage not required
#![allow(missing_docs)]

use crate::args::Cli;
use std::fs;
use std::path::PathBuf;

pub fn write_output(output_path: Option<PathBuf>, content: &str) -> Result<(), Box<dyn std::error::Error>> {
    match output_path {
        Some(path) => {
            fs::write(&path, content.as_bytes())
                .map_err(|e| format!("Error writing to file '{}': {}", path.display(), e))?;
        }
        None => {
            print!("{content}");
        }
    }
    Ok(())
}

pub fn output_debug_info(cli: &Cli, msg: &str) {
    if cli.debug {
        eprintln!("{msg}");
    }
}
