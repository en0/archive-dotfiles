# Vim8 / NeoVim

This is my vim setup for typescript and python. To get this running you need to do 3 things.

1. Install python3
2. Install neovim
3. Install Vim-Plug

## Install Python 3.

Python 2 is laughably out dated - It has served us for many years but in 2
short years it will be dead.  It is time to move python3 and don't look back.


[Python Download](https://www.python.org/downloads/)


After you install python3 i highly recomend you setup a virtual environment.
Why? Glad you asked... Well, your operation system expects specific versions of
python to be installed so that it can do it's job for you (unless you are using
windows...).  Since we don't want to impact any of that well oiled machine, you
should stay out of the os implementation of python.  If you doubt me, 
[read this](https://pages.charlesreid1.com/dont-sudo-pip/).


### Create a virtual environment

We still want python 3. And, handy thing, python3 comes with `venv`
built-in!

```bash
python3 -m venv $HOME/.venv
echo 'source $HOME/.venv/bin/activate' >> .zshrc # if your_age > 45: use .bashrc
```

Next, make sure it worked by closeing your terminal, and reopening it. Or, if
you are a terminal ninja, re-source your rc and check which python binary is used.

```bash
which python
```

The resulting text from the above command should say something like
`/home/your_user/.venv/bin/python`. If it does not, do not continue. Pain and
suffering lay ahead.  Unless you know what you are doing then, who am i to
stand in your way.

## Install NeoVim

NeoVim is an extension of VIM. It suports co-process, asynchronous plugins and
maintains backwards-compatibility with existing vim plugins. You can install it
using brew, apt, or download.  Full details [here](https://neovim.io/).


After you have neovim, You need to add language extentions to python (and
nodejs if you would like)

```bash
pip install neovim

#optional: nodejs
npm install -g neovim
```

## Install Vim-Plug

Plug.vim is a plugin manager. It simplifies installing plugins and makes your
vimrc more portable between systems.  For full details, check out
[vim-plug](https://github.com/junegunn/vim-plug).

### Unix and Unix-like systems

```bash
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
```

# Wrap it up

After all that. we can install this loanly little init.vim file. Run the
following command in the same folder as this readme:

```bash
mkdir -p $HOME/.config/nvim/ && cp init.vim ~/.config/nvim/init.vim
nvim -c "PlugInstall"
```

All set!

