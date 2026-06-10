//! Tier-1 processing-instruction skip (Phase X).
//!
//! `<?...?>` and `<?>` are HTML processing instructions / malformed PI
//! markers.  Tier-2's `tl::parse` discards them entirely.  Tier-1 used
//! to emit them as literal text (`<?>`), breaking byte-equality on
//! mdn-array which has a stray `<?>` between `</script>` and `<section>`.

#![cfg(feature = "testkit")]

use html_to_markdown_rs::{ConversionOptions, TierStrategy, convert};

fn tier1(html: &str) -> String {
    let opts = ConversionOptions {
        tier_strategy: TierStrategy::Tier1,
        extract_metadata: false,
        ..ConversionOptions::default()
    };
    convert(html, Some(opts)).unwrap().content.unwrap_or_default()
}

#[test]
fn empty_pi_dropped() {
    let out = tier1("<p>a<?>b</p>");
    assert!(!out.contains("<?>"), "PI leaked: {out:?}");
    assert!(out.contains("ab"), "neighbours collapsed: {out:?}");
}

#[test]
fn xml_pi_dropped() {
    let out = tier1(r#"<p>before<?xml version="1.0"?>after</p>"#);
    assert!(!out.contains("<?"), "PI leaked: {out:?}");
    assert!(out.contains("beforeafter"), "neighbours collapsed: {out:?}");
}

#[test]
fn pi_outside_paragraph() {
    // mdn-array's actual pattern: PI between </script> and <section>.
    let html = "<p>x</p><?> <section><p>y</p></section>";
    let out = tier1(html);
    assert!(!out.contains("<?>"), "PI leaked: {out:?}");
}
