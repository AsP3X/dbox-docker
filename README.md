# Development Container Setup

A comprehensive Docker-based development environment with Neovim, Node.js version management, and modern development tools.

## Overview

This Docker container provides a fully configured development environment based on Ubuntu 24.04, featuring:

- **Neovim** with AstroNvim configuration
- **Node Version Manager (nvm)** for flexible Node.js version management
- **Zoxide** for intelligent directory navigation
- **oh-my-zsh** - A delightful community-driven framework for managing zsh configuration
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

- **oh-my-zsh** - Zsh configuration framework with plugins and themes
- **Zoxide** - Smart directory navigation (use `z` command)
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

NVM is automatically initialized in `.zshrc` (for zsh), `.bashrc`, and `.profile`, making it available in:
- Interactive shells (zsh and bash)
- Non-interactive shells
- Scripts

## oh-my-zsh

### Overview

oh-my-zsh is a delightful, open source, community-driven framework for managing your zsh configuration. It comes bundled with thousands of helpful functions, helpers, plugins, themes, and a few things that make you shout "OH MY ZSHELL!".

### Default Shell

Zsh with oh-my-zsh is set as the default shell for the container. When you start an interactive session, you'll automatically use zsh.

### Configuration

oh-my-zsh is pre-configured with:
- **powerlevel10k theme** - A fast and highly customizable theme
- NVM integration for Node.js version management
- Zoxide integration for smart directory navigation
- Use `z` command for zoxide's smart directory navigation, `cd` remains the standard command

### Customization

You can customize oh-my-zsh by editing `~/.zshrc`:

```bash
# Change theme (default: powerlevel10k)
ZSH_THEME="powerlevel10k/powerlevel10k"  # or any other theme from ~/.oh-my-zsh/themes/

# Enable/disable plugins
plugins=(git nvm zoxide)  # Add or remove plugins as needed
```

### powerlevel10k Theme

The container comes with the **powerlevel10k** theme pre-installed and configured. This theme provides:
- Fast prompt rendering
- Rich git status information
- Customizable appearance
- Built-in configuration wizard (run `p10k configure` after first login)

To customize the theme, run:
```bash
p10k configure
```

This will launch an interactive configuration wizard to customize colors, icons, and prompt elements.

### Available Plugins

oh-my-zsh comes with many plugins. Some useful ones include:
- `git` - Git aliases and functions
- `docker` - Docker aliases
- `npm` - npm aliases
- `python` - Python aliases
- `zoxide` - Zoxide integration (already configured)

See the [oh-my-zsh wiki](https://github.com/ohmyzsh/ohmyzsh/wiki) for more information and available plugins.

## Zoxide (Smart Directory Navigation)

### Overview

Zoxide provides intelligent directory navigation that learns your habits. Use the `z` command for smart navigation, while `cd` remains the standard command.

### Usage

Use `z` for smart directory navigation:

```bash
# Navigate to a frequently used directory
z project

# Navigate with partial match
z proj

# Use regular cd for standard navigation
cd /path/to/directory
cd ..
```

### Zoxide Commands

- `z <directory>` - Jump to a directory using smart matching
- `zi <directory>` - Interactive directory selection
- `zoxide query <pattern>` - Query the database
- `zoxide add <directory>` - Manually add a directory

### Configuration

Zoxide is automatically initialized in `.zshrc` (for zsh), `.bashrc`, and `.profile`. The `z` command is available for smart directory navigation.

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

- `~/.zshrc` - Zsh configuration (oh-my-zsh)
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
├── .oh-my-zsh/           # oh-my-zsh installation
├── .zshrc                # Zsh configuration (oh-my-zsh)
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
# For zsh
eval "$(zoxide init zsh)"

# For bash
eval "$(zoxide init bash)"
```

### oh-my-zsh Not Loading

If oh-my-zsh doesn't load automatically, ensure you're using zsh:

```bash
# Check current shell
echo $SHELL

# Switch to zsh if needed
zsh
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
- **oh-my-zsh**: Latest version
- **Zsh**: Latest version from Ubuntu repositories
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
