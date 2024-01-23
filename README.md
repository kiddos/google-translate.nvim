# google-translate.nvim

As a develop, we are often asked to change some text in our code base. It gets kind of annoying when there's like different languages to change.

I am lazy, So I made this plugin.

![demo](/screenshot/translate.nvim.gif "Optional Title")

## Installation

set `GOOGLE_APPLICATION_CREDENTIALS` and `GOOGLE_API_PROJECT_ID`

```shell
export GOOGLE_APPLICATION_CREDENTIALS="<your json file path here downloaded from google cloud console>"
export GOOGLE_API_PROJECT_ID="<your project id>"
```

Example:

```shell
export GOOGLE_APPLICATION_CREDENTIALS="$HOME/.local/neovim-api.json"
export GOOGLE_API_PROJECT_ID="neovim-api"
```

* [lazy.nvim](https://github.com/folke/lazy.nvim)
```lua
{
  '~/projects/google-translate.nvim',
  build = { 'pip install -r requirements.txt', ':UpdateRemotePlugins' },
  config = function()
    require('google-translate').setup()
  end,
}
```

* [packer.nvim](https://github.com/wbthomason/packer.nvim)

```lua
use {
  'kiddos/translate.nvim',
  run = { 'pip install -r requirements.txt', ':UpdateRemotePlugins' },
  config = function()
    require('google-translate').setup()
  end,
}
```

## Setting

add your own language

```lua
vim.api.nvim_create_user_command('TranslateJP', function() translate.translate('ja') end, opts)
```

## Existing Commands

```vim
:TranslateCN
:TranslateTW
:TranslateEN
```
