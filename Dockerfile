# My shell env built on Archlinux.
# docker manager for docker.
# sync docker directory of host machine.
#
# Usage:
#     `docker run -it -v /var/run/docker.sock:/var/run/docker.sock u1and0/myenv tmux`

FROM u1and0/neovim:latest

LABEL maintainer="${LOUSER} <e01.ando60@gmail.com>"\
      description="zplug in archlinux"\
      description.ja="zplug in archlinux"\
      version="zplug myenv"

# Reinstall packages required by zplug
RUN pacman -S --noconfirm zsh awk git &&\
    yes | yay -Scc

RUN rm .gitconfig && rm -rf dotfiles .git &&\
    git clone  --depth 1 https://github.com/u1and0/dotfiles.git &&\
    : "Replace dotfiles" &&\
    mv -f "${HOME}/dotfiles/.git" "${HOME}" &&\
    git reset --hard &&\
    rm -rf "${HOME}/dotfiles" &&\
    rmdir ${HOME}/{bacpac,pyenv} &&\
    git clone --depth 1 https://github.com/zplug/zplug ${HOME}/.zplug

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

# Install docker
RUN yes | pacman -S docker
