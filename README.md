# google-translate.nvim

As a developer, we are often asked to change some text in our code base. It gets kind of annoying when there's like different languages to change.

I am lazy, so I made this plugin.

![demo](/screenshot/translate.nvim.gif "Optional Title")

## Prerequisites

- `curl`
- `gcloud` CLI tool, authenticated with your Google account.

## Installation

set `GOOGLE_API_PROJECT_ID`

```shell
export GOOGLE_API_PROJECT_ID="<your project id>"
```

Example:

```shell
export GOOGLE_API_PROJECT_ID="neovim-api"
```

* [lazy.nvim](https://github.com/folke/lazy.nvim)
```lua
{
  'kiddos/google-translate.nvim',
  config = function()
    require('google-translate').setup()
  end,
}
```

* [packer.nvim](https://github.com/wbthomason/packer.nvim)

```lua
use {
  'kiddos/translate.nvim',
  config = function()
    require('google-translate').setup()
  end,
}
```

## Setting

add your own language

```lua
vim.api.nvim_create_user_command('TranslateJP', function() require('google-translate').translate('ja') end, { range = true })
```

## Existing Commands

```vim
:TranslateCN
:TranslateTW
:TranslateEN
:DetectLanguage
:ListLanguages
```
