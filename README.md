# Development Container Setup

A comprehensive Docker-based development environment with Neovim, Node.js version management, and modern development tools.

## Overview

This Docker container provides a fully configured development environment based on Ubuntu 24.04, featuring:

- **Neovim** with AstroNvim configuration
- **Node Version Manager (nvm)** for flexible Node.js version management
- **Zoxide** for intelligent directory navigation
- **Cursor Agent** integration
- Comprehensive development tooling

## Features

### Core Tools

- **Neovim** - Latest version with AstroNvim distribution
- **Node.js & npm** - System-wide installation plus nvm for version management
- **Python 3** - With pip and pynvim support
- **Ruby** - Full Ruby installation with gem support
- **Git** - Version control system
- **PostgreSQL** - Database client tools
- **SQLite3** - Lightweight database

### Development Utilities

- **ripgrep (rg)** - Fast text search
- **fd-find** - Fast file finder
- **btop** - System monitor
- **tree-sitter-cli** - Syntax tree parser
- **mermaid-cli** - Diagram generation
- **ImageMagick & Ghostscript** - Image processing
- **LaTeX** - Document typesetting
- **trash-cli** - Safe file deletion

### Shell Enhancements

- **Zoxide** - Smart directory navigation (replaces `cd`)
- **NVM** - Node Version Manager (v0.40.3)

## Building the Container

### Prerequisites

- Docker installed on your system
- Git (for cloning the repository)

### Build Command

```bash
docker build -t dev-container .
```

### Build with Custom Ubuntu Version

```bash
docker build --build-arg UBUNTU_VERSION="22.04" -t dev-container .
```

## Configuration Options

### Environment Variables

The Dockerfile supports the following build arguments:

- `UBUNTU_VERSION` - Ubuntu version to use (default: `24.04`)

### Runtime Environment Variables

- `NVM_DIR` - Path to nvm installation (`/root/.nvm`)
- `XDG_CONFIG_HOME` - Configuration directory (`/root/.config`)
- `XDG_DATA_HOME` - Data directory (`/root/.local/share`)
- `XDG_STATE_HOME` - State directory (`/root/.local/state`)
- `XDG_CACHE_HOME` - Cache directory (`/root/.cache`)
- `LANG` / `LC_ALL` - Locale settings (`C.UTF-8`)

## Usage

### Running the Container

```bash
docker run -it --rm dev-container
```

### Running with Volume Mounts

```bash
docker run -it --rm \
  -v $(pwd):/workspace \
  -w /workspace \
  dev-container
```

### Running with SSH Agent

```bash
docker run -it --rm \
  -v $(pwd):/workspace \
  -v $SSH_AUTH_SOCK:/ssh-agent \
  -e SSH_AUTH_SOCK=/ssh-agent \
  -w /workspace \
  dev-container
```

## Node Version Manager (nvm)

### Installing Node.js Versions

```bash
# Install latest LTS version
nvm install --lts

# Install specific version
nvm install 20.10.0

# Install latest version
nvm install node
```

### Using Node.js Versions

```bash
# Use a specific version
nvm use 20.10.0

# Set default version
nvm alias default 20.10.0

# List installed versions
nvm list

# List available versions
nvm list-remote
```

### NVM Configuration

NVM is automatically initialized in both `.bashrc` and `.profile`, making it available in:
- Interactive shells
- Non-interactive shells
- Scripts

## Zoxide (Smart Directory Navigation)

### Overview

Zoxide replaces the traditional `cd` command with intelligent directory navigation that learns your habits.

### Usage

The `cd` command is aliased to `z`, so you can use it normally:

```bash
# Navigate to a frequently used directory
cd project

# Navigate with partial match
cd proj

# Navigate to parent directory (still works)
cd ..

# Navigate with absolute path (still works)
cd /path/to/directory
```

### Zoxide Commands

- `z <directory>` - Jump to a directory (aliased as `cd`)
- `zi <directory>` - Interactive directory selection
- `zoxide query <pattern>` - Query the database
- `zoxide add <directory>` - Manually add a directory

### Configuration

Zoxide is automatically initialized in both `.bashrc` and `.profile`. The `cd` alias is configured to use `z` for seamless integration.

## Neovim Configuration

### AstroNvim Setup

The container includes a pre-configured AstroNvim installation with custom plugins and keymaps.

### Custom Keymaps

- `<leader>ca` - Open Cursor Agent in terminal
- `<leader>hc` - Open container cheatsheet
- `<C-c>` - Copy (line in normal mode, selection in visual mode)
- `<C-v>` - Paste

### Clipboard Integration

- Uses system clipboard when available
- Terminal clipboard via right-click or Ctrl+Shift+C/V
- Internal Neovim clipboard with Ctrl+C/V

### Neovim Commands

- `:checkhealth` - Show health status
- `:Lazy` - Plugin manager UI
- `:Mason` - LSP/DAP/formatter manager

### Custom Plugins

The configuration includes:

1. **clipboard.lua** - Clipboard configuration and keymaps
2. **cursor-agent.lua** - Cursor Agent integration
3. **cheatsheet.lua** - Built-in cheatsheet
4. **providers.lua** - Provider configuration and Snacks UI setup

### Snacks UI Features

- Dashboard with custom cheatsheet entry
- File explorer with trash support
- LazyGit integration
- Picker and input UI components

## Cursor Agent Integration

Cursor Agent is automatically installed and can be launched from Neovim using `<leader>ca` or directly from the terminal:

```bash
cursor-agent
```

## Customization

### Adding Custom Neovim Plugins

Create a new plugin file in `/root/.config/nvim/lua/plugins/`:

```lua
-- /root/.config/nvim/lua/plugins/my-plugin.lua
return {
  {
    "username/plugin-name",
    config = function()
      -- Plugin configuration
    end,
  },
}
```

### Modifying Shell Configuration

Edit the following files in the container:

- `~/.bashrc` - Bash configuration
- `~/.profile` - Profile configuration

### Installing Additional Tools

You can install additional tools by:

1. **Modifying the Dockerfile** - Add packages to the `apt-get install` command
2. **Using npm/gem/pip** - Install packages at runtime
3. **Using nvm** - Install different Node.js versions

## File Structure

```
/root/
├── .config/
│   └── nvim/              # Neovim configuration
│       └── lua/
│           └── plugins/   # Custom plugins
├── .local/
│   ├── bin/              # Local binaries
│   ├── share/            # Shared data
│   ├── state/            # State files
│   └── cache/            # Cache files
├── .nvm/                 # NVM installation
├── .bashrc               # Bash configuration
└── .profile              # Profile configuration
```

## Troubleshooting

### NVM Not Available

If nvm commands aren't available, source the profile:

```bash
source ~/.bashrc
# or
source ~/.profile
```

### Zoxide Not Working

Ensure zoxide is initialized:

```bash
eval "$(zoxide init bash)"
```

### Neovim Health Check

Run a health check to diagnose issues:

```bash
nvim --headless "+checkhealth" +qa
```

### Rebuilding the Container

If you make changes to the Dockerfile:

```bash
docker build --no-cache -t dev-container .
```

## Version Information

- **Ubuntu**: 24.04 (configurable)
- **NVM**: v0.40.3
- **Neovim**: Latest release
- **AstroNvim**: Latest template version

## License

This setup is provided as-is for development purposes.

## Contributing

To contribute improvements:

1. Make changes to the Dockerfile
2. Test the build
3. Update this README if needed
4. Commit and push changes
