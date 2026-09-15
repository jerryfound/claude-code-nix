# claude-code-nix

将 [Claude Code](https://code.claude.com) 的官方预编译 npm 二进制
（`@anthropic-ai/claude-code-<platform>`）打包为 Nix flake，无需从源码编译。

> [!NOTE]
> 本仓库是 [sadjow/claude-code-nix](https://github.com/sadjow/claude-code-nix)
> 的备选来源。**日常使用请优先选择原仓库**——它跟进上游更及时、用户更多；
> 只有当原仓库的下载源在你的环境下确实不可用时，再切换到本仓库。

## 与原仓库的差异

差异只在下载源，打包产物完全一致：

- 下载优先走 npmmirror registry 镜像，registry.npmjs.org 兜底。
  两个源的压缩包内容逐字节相同（`dist.integrity` 一致），固定输出哈希也相同。
- `hashes.json` 锁定最新稳定版及各平台压缩包的 sha512 完整性哈希，
  由 GitHub Action 每天 4 次自动刷新（`scripts/update.py`），
  每次更新先在 x86_64-linux 上完成构建和版本冒烟测试后才提交。

## 使用

```nix
{
  inputs.claude-code-nix.url = "github:jerryfound/claude-code-nix";

  # 在 overlay 列表里:
  #   claude-code-nix.overlays.default
  # 或直接用:
  #   claude-code-nix.packages.<system>.claude-code
}
```

支持的系统：`x86_64-linux`、`aarch64-linux`、`x86_64-darwin`、`aarch64-darwin`。

包装器（wrapper）会设置 `DISABLE_AUTOUPDATER=1` 并把 `ripgrep` 加入 `PATH`；
Linux 下的二进制先经 autoPatchelf 修正动态链接，再额外把
`bubblewrap`/`socat`/`procps` 加入 `PATH`。
