//! Benchmark harness library for html-to-markdown-rs.
//!
//! Provides fixture loading, timing, snapshot comparison, and survey utilities
//! consumed by the `htmbench` binary.

// reason: benchmark harness is an internal dev tool, not a published library.
// missing_errors_doc / missing_panics_doc are acceptable in internal harness code.
// module_name_repetitions is suppressed because benchmark type names naturally
// repeat the "bench" prefix for clarity at the harness call sites.
#![allow(
    clippy::missing_errors_doc,
    clippy::missing_panics_doc,
    clippy::module_name_repetitions
)]

pub mod bench;
pub mod fixture;
pub mod oracle;
pub mod schema;
pub mod survey;
