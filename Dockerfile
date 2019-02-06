FROM u1and0/neovim:latest

LABEL maintainer="${LOUSER} <e01.ando60@gmail.com>"\
      description="zplug in archlinux"\
      description.ja="zplug in archlinux"\
      version="zplug myenv"

# Reinstall packages required by zplug
RUN pacman -Syu --noconfirm zsh awk git &&\
    git clone --depth 1 https://github.com/zplug/zplug ${HOME}/.zplug &&\
    yes | yay -Scc

# Install zplug plugins
RUN zsh -ic "source /root/.zshrc &&\
            source /root/.zplug/init.zsh &&\
            source /root/.zplug.zsh &&\
            zplug install"

# Install tmux && tmux-plugins
WORKDIR /root
RUN git submodule update --init --recursive &&\
    pacman -Syy --noconfirm tmux &&\
    ${HOME}/.tmux/plugins/tpm/scripts/install_plugins.sh &&\
    yes | yay -Scc

# Disable suspend @Neovim
RUN echo "nnoremap <C-Z> <nop>" >> /root/.config/nvim/keymap.rc.vim

### User setting ###
ENV SHELL="/usr/bin/zsh"
ENTRYPOINT ["/usr/bin/zsh"]
