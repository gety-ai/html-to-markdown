//! Option decoding for R bindings.

use extendr_api::prelude::*;

/// Decode an R ExternalPtr or NULL into ConversionOptions.
///
/// Accepts:
/// - ExternalPtr<ConversionOptions> (from $default() or builder methods) — unwraps and converts
/// - NULL — returns default ConversionOptions
///
/// This function is a placeholder that handles the core ExternalPtr case. Full list-based
/// field parsing can be added by the project if needed for advanced use cases.
pub fn decode_options(options: Robj) -> std::result::Result<crate::ConversionOptions, String> {
    if options.is_null() {
        return Ok(crate::ConversionOptions::default().into());
    }

    // Accept the wrapper struct returned by `ConversionOptions$default()` / builder methods,
    // which extendr exposes as an `ExternalPtr`. The binding struct is returned directly
    // from the #[extendr] impl methods, so unwrap it as the binding type.
    if let Ok(ext) = ExternalPtr::<crate::ConversionOptions>::try_from(&options) {
        // Clone the binding struct and convert to core type via the generated From impl
        return Ok((*ext).clone().into());
    }

    // If unwrapping as ExternalPtr failed, the input is not a valid options object
    Err("options must be NULL, or an ExternalPtr from ConversionOptions$default()".to_string())
}
