# claude-box

Run [Claude Code](https://claude.ai/code) in an isolated [Podman](https://podman.io/) container, mounting your current project as the workspace.

The goal is to remove the need to review and approve every command Claude runs, or to maintain a list of pre-approved commands. Running Claude Code inside a container makes this safer — it has access only to the current directory, not the rest of the host filesystem.

The container image is built automatically on first use and cached for subsequent runs. Claude's configuration and session data (`~/.claude`) are mounted from the host so they persist across invocations.

> [!WARNING]
> Claude Code is launched in **dangerous mode** (`--dangerously-skip-permissions`), meaning it will execute commands without asking for confirmation. The container limits the blast radius, but it does **not** make this fully safe. Prompt injection attacks can still instruct Claude to steal the contents of your working directory.

## Features

- **Isolation** — Claude Code runs in a container with access only to the current directory and your Claude config, nothing else on the host.
- **Custom base images** — layer Claude Code on top of any Debian/Ubuntu or RHEL/Fedora/UBI image to give Claude the exact toolchain your project needs.
- **Per-project configuration** — commit a `.config/claude-box.conf` to pin the base image for a project (`claude-box init`).
- **SELinux-aware** — volume mounts are labelled correctly for SELinux hosts (Fedora, RHEL).

## Installation

```sh
make install
```

This copies `claude-box` to `~/.local/bin` and the `Dockerfile` to `~/.local/share/claude-box`. Make sure `~/.local/bin` is in your `PATH`.

## Usage

```sh
# Launch Claude Code in the current directory
claude-box

# Pin a custom base image for a project and save it to .config/claude-box.conf
claude-box init -b ghcr.io/myorg/dev:latest

# Launch in a specific directory without cd-ing there first
claude-box -C ~/projects/myapp

# Rebuild the container image (e.g. after updating the base image)
claude-box --rebuild

# Pass arguments directly to claude
claude-box -- --model claude-opus-4-6
```
