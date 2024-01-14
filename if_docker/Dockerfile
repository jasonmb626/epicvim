###############################     Base    #################################################
FROM alpine:3.18 as base

ARG UID=1000
ARG GID=1000

#These (esp the LANG variable) make sure tmux outputs UTF-8. Needed for special chars
ENV GDM_LANG=en_US.UTF-8
ENV LANG=en_US.UTF-8
ENV HISTFILE=/home/app/.local/share/bash/bash_history
ENV ZDOTDIR=/home/app/.config/zsh/
ENV XDG_CACHE_HOME=/home/app/.local/cache

WORKDIR /app
RUN apk add -U py3-pip npm zsh\
    && addgroup -g ${GID} app \
    && adduser -D -u ${UID} -G app -s /bin/zsh app \
    && chmod 777 /tmp \
    && mkdir -p /app/node_modules\
    && chown -R app:app /app

USER app:app
RUN python3 -m venv /home/app/.venvs/app

COPY requirements.txt /tmp
RUN source /home/app/.venvs/app/bin/activate\
    && pip3 install -r /tmp/requirements.txt && rm /tmp/requirements.txt

###############################     Prod    #################################################
FROM base as prod

COPY app/. .
RUN if [[ -s package.json ]]; then\
        npm install;\
    fi

CMD ["node", "app.js"]

#############################   Development   ################################################
FROM base as dev

USER root

RUN apk add git\ 
         lua-dev luarocks stylua\
         lazygit openssh\
         tmux neovim neovim-doc\
         procps\
         tmux\
         ripgrep\
         alpine-sdk\
         tree-sitter tree-sitter-cli\
         wl-clipboard\
         sudo \
         unzip gzip fd mercurial wget\
    && npm install -g neovim\
    && mkdir -p /etc/sudoers.d && echo 'app ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers.d/app \
    && mkdir -p /home/app/.config/tmux \
    && chown -R app:app /home/app/.config\
    && mkdir -p /home/app/.local \
    && chown -R app:app /home/app/.local \
    && cat <<EOF >/tmp/zshrc_preamble
    source /home/app/.venvs/app/bin/activate
    mkdir -p /home/app/.local/share/zsh
    mkdir -p /home/app/.local/share/tmux/plugins/
    if [[ "\$(ls -1 /home/app/.local/share/tmux/plugins/ | wc -l )" -eq 0 ]]; then
        /home/app/.config/tmux/plugins/tpm/scripts/install_plugins.sh
        tmux source ~/.config/tmux/tmux.conf
    fi
    if [[ ! -x /home/app/.local/share/nvim/lazy/nvim-treesitter/parser/markdown.so ]]; then
        if [[ -x /home/app/.config/nvim/if_docker/auto_install_dependencies.sh ]]; then
            /home/app/.config/nvim/if_docker/auto_install_dependencies.sh >/dev/null 2>&1
            echo "\nNeovim packages are installing in the background. Please wait before starting up neovim."
            echo "This usually happens only on a fresh install."
            echo "Sleeping 30 seconds."
            sleep 30
            PID=\$(ps aux | grep 'nvim --headless -c TSInstall! markdown' | grep -v grep | awk '{print \$2}')
            kill \$PID
            echo "You may now start neovim. Additional LSPs, formatters, and linters may install on startup."
            echo "Once there is no longer feedback that new tools are installing, we recommend restarting neovim one more time."
        fi
    fi
    if [[ -d /app/node_modules ]]; then
        size_of=\$(du /app/node_modules | tail -n 1 | awk {'print \$1'})
        if [[ \$size_of -eq 0 ]]; then
            echo -e "\\n\\tNode modules folder is empty. If this is a node project you may need to run 'npm i'\\n"
        fi
    fi
EOF

USER app:app
COPY requirements-dev.txt /tmp
RUN source /home/app/.venvs/app/bin/activate\
    && pip3 install --upgrade pip \
    && pip3 install -r /tmp/requirements-dev.txt && rm /tmp/requirements-dev.txt\
    && pip3 install pynvim pylint\
    && mkdir -p /home/app/.config/tmux/plugins && chown app:app /home/app/.config/tmux/plugins/ \
    && git clone https://github.com/tmux-plugins/tpm /home/app/.config/tmux/plugins/tpm \
    && git clone https://github.com/jasonmb626/epicvim.git /home/app/.config/nvim \
    && git clone https://github.com/jasonmb626/dotfiles-dev.git /tmp/dotfiles-dev \
    && cat /tmp/dotfiles-dev/tmux/tmux.conf | sed 's/set -g prefix C-a/set -g prefix C-x/' | \
    sed 's/bind-key C-a send-prefix/bind-key C-x send-prefix/' > /home/app/.config/tmux/tmux.conf \
    && mv /tmp/dotfiles-dev/zsh /home/app/.config/ && rm -fr /tmp/dotfiles-dev \
    && /bin/zsh -c "source /home/app/.config/zsh/.zshrc" \
    && mv /home/app/.config/zsh/.zshrc /tmp/.zshrc \
    && cat /tmp/zshrc_preamble /tmp/.zshrc > /home/app/.config/zsh/.zshrc \
    && rm /tmp/zshrc_preamble /tmp/.zshrc

CMD ["tmux"]
