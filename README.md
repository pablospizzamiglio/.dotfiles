# .dotfiles

## Requirements

- GNU Stow
- zsh
- zsh-autosuggestions
- zsh-syntax-highlighting

## How to Install

Clone into `$HOME` and then run:

```shell
cd dotfiles

stow --no-folding -R */
```

## How to Remove

```shell
stow -D */
```

## How to Re-apply

```shell
stow --no-folding -R */
```
