# claude-code-nix

Nix flake packaging [Claude Code](https://code.claude.com) from the
official prebuilt binaries published on npm
(`@anthropic-ai/claude-code-<platform>`), instead of compiling from
source.

- `hashes.json` pins the latest stable version plus the sha512 integrity
  hash of every supported platform tarball. It is refreshed four times a
  day by a GitHub Action (`scripts/update.py`); each successful update is
  smoke-built on x86_64-linux before landing.
- Fetches prefer the npmmirror.com registry mirror (byte-identical
  tarballs, much faster from mainland China) and fall back to
  registry.npmjs.org.

## Usage

```nix
{
  inputs.claude-code-nix.url = "github:jerryfound/claude-code-nix";

  # In your overlay stack:
  #   claude-code-nix.overlays.default
  # or directly:
  #   claude-code-nix.packages.<system>.claude-code
}
```

Supported systems: `x86_64-linux`, `aarch64-linux`, `x86_64-darwin`,
`aarch64-darwin`.

The wrapper sets `DISABLE_AUTOUPDATER=1` and puts `ripgrep` on `PATH`;
on Linux the binary is auto-patched and `bubblewrap`/`socat`/`procps`
are added to `PATH`.
