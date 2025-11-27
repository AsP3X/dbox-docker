ARG UBUNTU_VERSION="24.04"
FROM ubuntu:${UBUNTU_VERSION}

ARG UBUNTU_VERSION
ENV DEBIAN_FRONTEND=noninteractive \
    DOCKER_CHANNEL=stable \
    DOCKER_VERSION=29.0.4 \
    DOCKER_COMPOSE_VERSION=v2.40.3 \
    BUILDX_VERSION=v0.29.1 \
    DEBUG=false

RUN apt-get update && apt-get install -y --no-install-recommends \
    ssh curl wget btop postgresql git xz-utils \
    xclip xsel wl-clipboard \
    build-essential \
    ripgrep \
    python3 python3-pip python3-pynvim \
    nodejs npm \
    fd-find \
    sqlite3 \
    imagemagick \
    ghostscript \
    texlive-latex-base \
    trash-cli \
    libglib2.0-bin \
    ruby-full \
    zsh && \
    npm config set prefix /usr/local && \
    npm install -g tree-sitter-cli neovim @mermaid-js/mermaid-cli && \
    gem install neovim && \
    wget https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz -O /tmp/nvim.tar.gz && \
    tar -xzf /tmp/nvim.tar.gz -C /tmp && \
    cp -r /tmp/nvim-linux-x86_64/* /usr/local/ && \
    rm -rf /tmp/nvim.tar.gz /tmp/nvim-linux-x86_64 && \
    rm -rf /var/lib/apt/lists/*

# Install nvm (Node Version Manager)
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash

# Set NVM environment variables and add to shell profiles
ENV NVM_DIR=/root/.nvm
RUN echo 'export NVM_DIR="$HOME/.nvm"' >> ~/.bashrc && \
    echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"' >> ~/.bashrc && \
    echo '[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"' >> ~/.bashrc && \
    echo 'export NVM_DIR="$HOME/.nvm"' >> ~/.profile && \
    echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"' >> ~/.profile

# Install zoxide (smarter cd command)
RUN curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash && \
    echo 'eval "$(zoxide init bash)"' >> ~/.bashrc && \
    echo 'eval "$(zoxide init bash)"' >> ~/.profile && \
    echo 'alias cd="z"' >> ~/.bashrc && \
    echo 'alias cd="z"' >> ~/.profile

# Install oh-my-zsh
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# Install powerlevel10k theme
RUN git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

# Configure oh-my-zsh with powerlevel10k theme, nvm and zoxide support
RUN sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="powerlevel10k\/powerlevel10k"/' ~/.zshrc && \
    echo 'export NVM_DIR="$HOME/.nvm"' >> ~/.zshrc && \
    echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"' >> ~/.zshrc && \
    echo '[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"' >> ~/.zshrc && \
    echo 'eval "$(zoxide init zsh)"' >> ~/.zshrc && \
    echo 'alias cd="z"' >> ~/.zshrc && \
    chsh -s $(which zsh) || true

# Set zsh with oh-my-zsh as the default shell for the container
SHELL ["/usr/bin/zsh", "-c"]

RUN curl https://cursor.com/install -fsS | bash

# Install Astronvim and Cursor Agent Neovim integration
RUN mkdir -p /root/.config /root/.local/share/nvim /root/.local/state/nvim /root/.cache/nvim && \
    git clone --depth 1 https://github.com/AstroNvim/template /root/.config/nvim && \
    rm -rf /root/.config/nvim/.git && \
    mkdir -p /root/.config/nvim/lua/plugins && \
    cat <<'EOF' > /root/.config/nvim/lua/plugins/clipboard.lua
return {
  {
    "AstroNvim/astrocore",
    opts = {
      options = {
        opt = {
          -- Let the terminal handle mouse so right-click menu works
          mouse = "",
          -- Use system clipboard (when available) as default
          clipboard = "unnamedplus",
        },
      },
      mappings = {
        n = {
          -- Ctrl+C / Ctrl+V inside Neovim (buffer-local clipboard)
          ["<C-c>"] = { "yy", desc = "Copy line" },
          ["<C-v>"] = { "p",  desc = "Paste" },
        },
        v = {
          ["<C-c>"] = { "y",  desc = "Copy selection" },
          ["<C-v>"] = { "p",  desc = "Paste" },
        },
      },
    },
  },
}
EOF

# Cursor Agent keymaps & terminal integration for AstroNvim
RUN cat <<'EOF' > /root/.config/nvim/lua/plugins/cursor-agent.lua
return {
  {
    "AstroNvim/astrocore",
    opts = {
      mappings = {
        n = {
          -- Open a floating terminal running cursor-agent
          ["<leader>ca"] = {
            function()
              local ok, snacks = pcall(require, "snacks")
              if ok and snacks.terminal then
                snacks.terminal.open("cursor-agent")
              else
                vim.cmd "terminal cursor-agent"
              end
            end,
            desc = "Start Cursor Agent in terminal",
          },
        },
      },
    },
  },
}
EOF

# Simple cheatsheet accessible from inside Neovim
RUN cat <<'EOF' > /root/.config/nvim/lua/plugins/cheatsheet.lua
return {
  {
    "AstroNvim/astrocore",
    opts = {
      mappings = {
        n = {
          -- QWERTZ-friendly: leader + h + c  (Help Cheatsheet)
          ["<leader>hc"] = {
            function()
              local lines = {
                "AstroNvim / Cursor Container Cheatsheet",
                "=======================================",
                "",
                "General:",
                "  <leader>ca   - Open Cursor Agent terminal",
                "  <C-c>        - Copy (line / selection) inside Neovim",
                "  <C-v>        - Paste inside Neovim",
                "",
                "Clipboard / Host:",
                "  Use terminal right-click or Ctrl+Shift+C / Ctrl+Shift+V",
                "  to copy/paste between host and container.",
                "",
                "Help:",
                "  :checkhealth              - Show health status",
                "  :Lazy                     - Plugin manager UI",
                "  :Mason                    - LSP / DAP / formatter manager",
              }
              vim.cmd "ene"
              vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
              vim.bo.buflisted = false
              vim.bo.buftype = "nofile"
              vim.bo.swapfile = false
              vim.bo.modifiable = false
              vim.bo.readonly = true
              vim.cmd "normal! gg"
            end,
            desc = "Open container cheatsheet",
          },
        },
      },
    },
  },
}
EOF

# Disable unused providers and configure lazy / snacks to avoid health errors
RUN cat <<'EOF' > /root/.config/nvim/lua/plugins/providers.lua
return {
  {
    "folke/lazy.nvim",
    opts = {
      rocks = {
        enabled = false,
        hererocks = false,
      },
    },
  },
  {
    "AstroNvim/astrocore",
    opts = {
      diagnostics = {
        virtual_text = true,
      },
    },
    init = function()
      -- We rely on terminal clipboard; disable Neovim clipboard provider health checks
      vim.g.loaded_clipboard_provider = 0
    end,
  },
  {
    "folke/snacks.nvim",
    opts = {
      dashboard = { enabled = true },
      bigfile = { enabled = false },
      quickfile = { enabled = false },
      scroll = { enabled = false },
      statuscolumn = { enabled = true },
      words = { enabled = true },
      explorer = {
        enabled = true,
        trash = {
          enabled = true,
        },
      },
      image = {
        enabled = false, -- disable image rendering to avoid kitty/wezterm/ghostty + gs/latex/mmdc errors
      },
      lazygit = {
        enabled = true,
      },
      picker = {
        enabled = true,
        select = {
          enabled = true,
        },
      },
      input = {
        enabled = true,
      },
    },
    config = function(_, opts)
      local snacks = require "snacks"

      -- Add cheatsheet entry to Snacks dashboard
      opts.dashboard = opts.dashboard or {}
      opts.dashboard.sections = opts.dashboard.sections or {}
      table.insert(opts.dashboard.sections, {
        section = "keys",
        title = "Custom",
        keys = {
          {
            icon = " ",
            key = "H",
            desc = "Open Cheatsheet",
            action = function()
              -- Reuse the cheatsheet buffer logic from the mapping
              local lines = {
                "AstroNvim / Cursor Container Cheatsheet",
                "=======================================",
                "",
                "General:",
                "  <leader>ca   - Open Cursor Agent terminal",
                "  <C-c>        - Copy (line / selection) inside Neovim",
                "  <C-v>        - Paste inside Neovim",
                "",
                "Clipboard / Host:",
                "  Use terminal right-click or Ctrl+Shift+C / Ctrl+Shift+V",
                "  to copy/paste between host and container.",
                "",
                "Help:",
                "  <leader>hc   - Open this cheatsheet",
                "  :checkhealth  - Show health status",
                "  :Lazy         - Plugin manager UI",
                "  :Mason        - LSP / DAP / formatter manager",
              }
              vim.cmd "ene"
              vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
              vim.bo.buflisted = false
              vim.bo.buftype = "nofile"
              vim.bo.swapfile = false
              vim.bo.modifiable = false
              vim.bo.readonly = true
              vim.cmd "normal! gg"
            end,
          },
        },
      })

      snacks.setup(opts)

      -- Wire Snacks as default UI so health checks pass
      if snacks.input and snacks.input.input then
        vim.ui.input = snacks.input.input
      end
      if snacks.picker and snacks.picker.select then
        vim.ui.select = snacks.picker.select
      end
    end,
  },
}
EOF

# Set environment variables for Neovim
ENV XDG_CONFIG_HOME=/root/.config \
    XDG_DATA_HOME=/root/.local/share \
    XDG_STATE_HOME=/root/.local/state \
    XDG_CACHE_HOME=/root/.cache \
    PATH="/root/.local/bin:${PATH}" \
    LANG=C.UTF-8 \
    LC_ALL=C.UTF-8

# Verify installation and pre-initialize Astronvim to catch build errors
RUN nvim --version && \
    tree-sitter --version && \
    which xclip && \
    which rg && \
    which node && \
    which python3 && \
    chmod -R 755 /root/.config /root/.local && \
    nvim --headless "+checkhealth" "+wq /tmp/nvim-health.log" +qa 2>&1 || true && \
    cat /tmp/nvim-health.log 2>/dev/null | tail -100 || true
