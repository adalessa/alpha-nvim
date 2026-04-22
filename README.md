# Alpha-Nvim

[English](#english) | [Español](#español)

## English

### Introduction

Welcome to Alpha-Nvim, my Neovim configuration for 2025. The goal of this configuration is to leverage the best of the Nix ecosystem while being fully functional without it. This is made possible thanks to the excellent work of [nixCats](https://github.com/BirdeeHub/nixCats-nvim) who have created this integration.

### Features

- Seamless integration with Nix.
- Can be used without Nix.
- Automatically handles package management.

### Installation

#### Using Nix

If you use Nix, this configuration includes a flake that you can integrate directly into your setup or run with `nix run`.

#### Without Nix

If you don't use Nix, you can clone this repository like any other configuration. The nixCats wrapper ensures that both approaches will work seamlessly.

### Usage

When starting in a Nix environment, packages already obtained by Nix will not be downloaded by lazy. However, it will still work even if not included with Nix, as lazy will download them.

### External Dependencies

This configuration relies on several external tools and language servers to provide a complete development experience. When using Nix, these dependencies are automatically managed. If you're not using Nix, you'll need to install these dependencies manually:

#### General Tools
- Git and GitHub CLI ([`gh`](https://github.com/cli/cli))
- [Lazygit](https://github.com/jesseduffield/lazygit)
- [ImageMagick](https://github.com/ImageMagick/ImageMagick)
- [jq](https://github.com/jqlang/jq)
- [Lua Language Server](https://github.com/LuaLS/lua-language-server)
- [Nixd](https://github.com/nix-community/nixd) and [nixfmt-rfc-style](https://github.com/nix-community/nixfmt)
- [Stylua](https://github.com/JohnnyMorganz/StyLua)
- [PHP Debug Adapter](https://github.com/xdebug/vscode-php-debug)

#### Laravel Development
- [Phpactor](https://github.com/phpactor/phpactor)
- [Blade formatter](https://github.com/shufo/blade-formatter)

#### Go Development
- [Go](https://github.com/golang/go)
- [Gopls](https://github.com/golang/tools/tree/master/gopls)
- [Go tools](https://github.com/golang/tools)

#### Python Development
- [Python 3.12](https://github.com/python/cpython)
- [Python LSP Server](https://github.com/python-lsp/python-lsp-server)

#### JavaScript/Web Development
- [Node.js](https://github.com/nodejs/node)
- [TypeScript Language Server](https://github.com/typescript-language-server/typescript-language-server)
- [Tailwind CSS Language Server](https://github.com/tailwindlabs/tailwindcss-intellisense)
- [Emmet Language Server](https://github.com/aca/emmet-ls)

## Español

### Introducción

Bienvenido a Alpha-Nvim, mi configuración de Neovim para este 2025. El objetivo de esta configuración es obtener lo mejor del mundo de Nix, pero pudiendo funcionar completamente sin él. Esto se logra gracias al excelente trabajo de [nixCats](https://github.com/BirdeeHub/nixCats-nvim) quienes han creado esta integración.

### Características

- Integración perfecta con Nix.
- Puede ser utilizado sin Nix.
- Manejo automático de paquetes.

### Instalación

#### Usando Nix

Si usas Nix, esta configuración incluye un flake que puedes integrar directamente en tu configuración o ejecutar con `nix run`.

#### Sin Nix

Si no usas Nix, puedes clonar este repositorio como cualquier otra configuración. El wrapper de nixCats asegura que ambos enfoques funcionen sin problemas.


Cuando iniciamos en un ambiente de Nix, los paquetes ya obtenidos por Nix no serán descargados por lazy. Sin embargo, incluso funcionará si no se incluye con Nix, ya que lazy los descargará.

### Dependencias Externas

Esta configuración depende de varias herramientas externas y servidores de lenguaje para proporcionar una experiencia de desarrollo completa. Al usar Nix, estas dependencias se gestionan automáticamente. Si no estás usando Nix, necesitarás instalar estas dependencias manualmente:

#### Herramientas Generales
- Git y GitHub CLI ([`gh`](https://github.com/cli/cli))
- [Lazygit](https://github.com/jesseduffield/lazygit)
- [ImageMagick](https://github.com/ImageMagick/ImageMagick)
- [jq](https://github.com/jqlang/jq)
- [Servidor de Lenguaje Lua](https://github.com/LuaLS/lua-language-server)
- [Nixd](https://github.com/nix-community/nixd) y [nixfmt-rfc-style](https://github.com/nix-community/nixfmt)
- [Stylua](https://github.com/JohnnyMorganz/StyLua)
- [Adaptador de Depuración PHP](https://github.com/xdebug/vscode-php-debug)

#### Desarrollo Laravel
- [Phpactor](https://github.com/phpactor/phpactor)
- [Formateador de Blade](https://github.com/shufo/blade-formatter)

#### Desarrollo Go
- [Go](https://github.com/golang/go)
- [Gopls](https://github.com/golang/tools/tree/master/gopls)
- [Herramientas de Go](https://github.com/golang/tools)

#### Desarrollo Python
- [Python 3.12](https://github.com/python/cpython)
- [Servidor LSP de Python](https://github.com/python-lsp/python-lsp-server)

#### Desarrollo JavaScript/Web
- [Node.js](https://github.com/nodejs/node)
- [Servidor de Lenguaje TypeScript](https://github.com/typescript-language-server/typescript-language-server)
- [Servidor de Lenguaje Tailwind CSS](https://github.com/tailwindlabs/tailwindcss-intellisense)
- [Servidor de Lenguaje Emmet](https://github.com/aca/emmet-ls)
