# Translate.nvim

As a develop, we are often asked to change some text in our code base. It gets kind of annoying when there's like different languages to change.

I am lazy, So I made this plugin.

![demo](/screenshot/translate.nvim.gif "Optional Title")

## Installation

set `GOOGLE_TRANSLATE_API_KEY`
```shell
export GOOGLE_TRANSLATE_API_KEY="<your key here>"
```

install using [packer.nvim](https://github.com/wbthomason/packer.nvim)

```lua
use {
  'kiddos/translate.nvim',
  rocks = {
    'lua-cjson',
    'luasec',
  }
}
```

```
local translate = require('translate')
translate.setup()
```

add your own language

```lua
vim.api.nvim_create_user_command('TranslateJP', function() translate.translate('ja') end, opts)
```
