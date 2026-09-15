# claude-code-nix

将 [Claude Code](https://code.claude.com) 的官方预编译 npm 二进制
（`@anthropic-ai/claude-code-<platform>`）打包为 Nix flake，不经过源码编译。

> [!NOTE]
> 本仓库是 [sadjow/claude-code-nix](https://github.com/sadjow/claude-code-nix)
> 的替代来源。**日常使用请优先选择原仓库**——它跟踪上游及时、用户面广；
> 只有当原仓库的下载源在你的环境下确实不可用时，再切换到本仓库。

## 与原仓库的差异

差异只在下载源，打包产物完全一致：

- 下载优先走 npmmirror registry 镜像，registry.npmjs.org 兜底。
  两个源的 tarball 字节相同（`dist.integrity` 一致），固定输出哈希相同。
- `hashes.json` 固定最新稳定版及各平台 tarball 的 sha512 integrity，
  由 GitHub Action 每天 4 次自动刷新（`scripts/update.py`），
  每次更新先在 x86_64-linux 上冒烟构建通过才提交。

## 使用

```nix
{
  inputs.claude-code-nix.url = "github:jerryfound/claude-code-nix";

  # 在 overlay 栈里:
  #   claude-code-nix.overlays.default
  # 或直接用:
  #   claude-code-nix.packages.<system>.claude-code
}
```

支持的系统：`x86_64-linux`、`aarch64-linux`、`x86_64-darwin`、`aarch64-darwin`。

wrapper 会设置 `DISABLE_AUTOUPDATER=1` 并把 `ripgrep` 加入 `PATH`；
Linux 下二进制经 autoPatchelf 处理，并额外引入 `bubblewrap`/`socat`/`procps`。
