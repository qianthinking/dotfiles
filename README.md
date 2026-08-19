## Installation

```sh
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply qianthinking
```

Based on the [Chezmoi](https://www.chezmoi.io/) project.

On macOS, `chezmoi apply` renders the repository source
`chezmoi/dot_Brewfile.tmpl` to `~/.Brewfile`, then installs its formulae and
casks with Homebrew Bundle. Chrome and iTerm2 use Homebrew's safe `--adopt`
behavior: an existing app is adopted only when its artifact is identical;
otherwise Homebrew stops without overwriting it.

## Legacy Repository
[YADR](https://github.com/qianthinking/dotfiles-yadr)
