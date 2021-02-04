# zeta-tomorrow

zeta-tomorrow is based on [zeta](https://github.com/skylerlee/zeta-zsh-theme), a theme for the ZSH shell. Yet, a few changes have been made:

  - it uses `➜` instead of `ζ` as prompt indicator.
  - together with [yadm-prompt](https://github.com/janebuoy/yadm-prompt) it displays the yadm status of the current directory.
  - displays IP address if connected through SSH

## Usage

Copy both theme files to `~/.oh-my-zsh/custom/themes/`:

```
$ curl -fsSL "https://raw.githubusercontent.com/janebuoy/zeta-tomorrow/main/zeta-tomorrow-{local,remote}.zsh-theme" -o ~/.oh-my-zsh/custom/themes/zeta-tomorrow-#1.zsh-theme
```

Add the following to your `.zshrc`:

```
if [[ -n $SSH_CONNECTION ]]; then                                               
    ZSH_THEME="zeta-tomorrow-remote"                              
    else                                                                            
    ZSH_THEME="zeta-tomorrow-local"
fi 
```
