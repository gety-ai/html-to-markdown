#!/usr/bin/env python3
"""
Vendor html-to-markdown-rs core crate into R package.

This script:
1. Reads workspace.dependencies and version from root Cargo.toml
2. Copies crates/html-to-markdown/ to packages/r/src/rust/vendor/html-to-markdown-rs/
3. Replaces workspace = true with explicit values in the vendored Cargo.toml
"""

import os
import re
import shutil
import sys
from pathlib import Path

try:
    import tomllib
except ImportError:
    import tomli as tomllib  # type: ignore


def get_repo_root() -> Path:
    """Get repository root directory."""
    repo_root_env = os.environ.get("REPO_ROOT")
    if repo_root_env:
        return Path(repo_root_env)

    script_dir = Path(__file__).parent.absolute()
    return (script_dir / ".." / ".." / "..").resolve()


def read_toml(path: Path) -> dict[str, object]:
    """Read a TOML file and return its contents."""
    with path.open("rb") as f:
        return tomllib.load(f)


def get_workspace_config(repo_root: Path) -> tuple[str, dict[str, object], dict[str, object]]:
    """Extract version, package metadata, and dependencies from root Cargo.toml."""
    data = read_toml(repo_root / "Cargo.toml")
    ws = data.get("workspace", {})
    version = ws.get("package", {}).get("version", "0.0.0")
    pkg = ws.get("package", {})
    deps = ws.get("dependencies", {})
    return version, pkg, deps


def format_dependency(name: str, dep_spec: object) -> str:
    """Format a dependency spec for Cargo.toml."""
    if isinstance(dep_spec, str):
        return f'{name} = "{dep_spec}"'
    if isinstance(dep_spec, dict):
        parts: list[str] = []

        package = dep_spec.get("package")
        if package:
            parts.append(f'package = "{package}"')

        version = dep_spec.get("version", "")
        parts.append(f'version = "{version}"')

        features = dep_spec.get("features", [])
        if features:
            features_str = ", ".join(f'"{f}"' for f in features)
            parts.append(f"features = [{features_str}]")

        default_features = dep_spec.get("default-features")
        if default_features is False:
            parts.append("default-features = false")

        spec_str = ", ".join(parts)
        return f"{name} = {{ {spec_str} }}"

    return f'{name} = "{dep_spec}"'


def _replace_package_fields(content: str, version: str, pkg: dict[str, object]) -> str:
    """Replace package-level workspace inheritance fields."""
    content = re.sub(r"^version\.workspace = true$", f'version = "{version}"', content, flags=re.MULTILINE)
    content = re.sub(
        r"^edition\.workspace = true$", f'edition = "{pkg.get("edition", "2024")}"', content, flags=re.MULTILINE
    )
    content = re.sub(
        r"^rust-version\.workspace = true$",
        f'rust-version = "{pkg.get("rust-version", "1.85")}"',
        content,
        flags=re.MULTILINE,
    )

    authors = pkg.get("authors", [])
    if authors:
        authors_str = ", ".join(f'"{a}"' for a in authors)
        content = re.sub(r"^authors\.workspace = true$", f"authors = [{authors_str}]", content, flags=re.MULTILINE)

    for field in ("license", "repository", "homepage", "documentation"):
        default = "MIT" if field == "license" else ""
        content = re.sub(
            rf"^{field}\.workspace = true$",
            f'{field} = "{pkg.get(field, default)}"',
            content,
            flags=re.MULTILINE,
        )

    return re.sub(r"^\[lints\]\nworkspace = true\n?", "", content, flags=re.MULTILINE)


def _make_fields_replacer(dep_name: str, dep_spec: object) -> callable:
    """Create a regex replacer that merges workspace dep spec with extra fields."""

    def replacer(match: re.Match[str]) -> str:
        other_fields_str = match.group(1).strip()
        base_spec = format_dependency(dep_name, dep_spec)

        if " = { " not in base_spec:
            version_val = base_spec.split(" = ", 1)[1].strip('"')
            spec_part = f'version = "{version_val}"'
        else:
            spec_part = base_spec.split(" = { ", 1)[1].rstrip("}")

        existing_keys: set[str] = set()
        for raw_part in spec_part.split(","):
            stripped = raw_part.strip()
            if "=" in stripped:
                existing_keys.add(stripped.split("=")[0].strip())

        filtered_fields: list[str] = []
        for raw_field in other_fields_str.split(","):
            stripped = raw_field.strip()
            if stripped and "=" in stripped:
                if stripped.split("=")[0].strip() not in existing_keys:
                    filtered_fields.append(stripped)
            elif stripped:
                filtered_fields.append(stripped)

        if filtered_fields:
            return f"{dep_name} = {{ {spec_part}, {', '.join(filtered_fields)} }}"
        return f"{dep_name} = {{ {spec_part} }}"

    return replacer


def replace_workspace_refs(toml_path: Path, version: str, pkg: dict[str, object], deps: dict[str, object]) -> None:
    """Replace workspace references with explicit values in vendored Cargo.toml."""
    with toml_path.open() as f:
        content = f.read()

    content = _replace_package_fields(content, version, pkg)

    for name, dep_spec in deps.items():
        pattern_dotted = rf"^{re.escape(name)}\.workspace = true$"
        content = re.sub(pattern_dotted, format_dependency(name, dep_spec), content, flags=re.MULTILINE)

        pattern_simple = rf"^{re.escape(name)} = \{{ workspace = true \}}$"
        content = re.sub(pattern_simple, format_dependency(name, dep_spec), content, flags=re.MULTILINE)

        pattern_extra = rf"^{re.escape(name)} = \{{ workspace = true, (.+?) \}}$"
        content = re.sub(pattern_extra, _make_fields_replacer(name, dep_spec), content, flags=re.MULTILINE | re.DOTALL)

    with toml_path.open("w") as f:
        f.write(content)


def main() -> None:
    """Vendor the html-to-markdown-rs core crate into the R package."""
    repo_root = get_repo_root()
    src_crate = repo_root / "crates" / "html-to-markdown"
    dest_vendor = repo_root / "packages" / "r" / "src" / "rust" / "vendor" / "html-to-markdown-rs"

    print("=== Vendoring html-to-markdown-rs core crate ===")

    if not src_crate.exists():
        print(f"Error: Source crate not found at {src_crate}", file=sys.stderr)
        sys.exit(1)

    version, pkg, deps = get_workspace_config(repo_root)
    print(f"Workspace version: {version}")

    if dest_vendor.exists():
        shutil.rmtree(dest_vendor)
        print("Cleaned existing vendor directory")

    shutil.copytree(src_crate, dest_vendor)
    print("Copied crates/html-to-markdown/ -> vendor/html-to-markdown-rs/")

    for artifact_dir in ["target", ".fastembed_cache"]:
        artifact = dest_vendor / artifact_dir
        if artifact.exists():
            shutil.rmtree(artifact)

    for pattern in ["*.swp", "*.bak", "*.tmp", "*~"]:
        for f in dest_vendor.rglob(pattern):
            f.unlink()

    vendor_toml = dest_vendor / "Cargo.toml"
    if vendor_toml.exists():
        replace_workspace_refs(vendor_toml, version, pkg, deps)
        print("Updated vendor/html-to-markdown-rs/Cargo.toml")

    print(f"\nVendoring complete (version: {version})")


if __name__ == "__main__":
    try:
        main()
    except Exception as e:
        print(f"Error: {e}", file=sys.stderr)
        sys.exit(1)
