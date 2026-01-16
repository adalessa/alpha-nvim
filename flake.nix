{
  description = "Mi configuracion de Neovim para 2025";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixCats.url = "github:BirdeeHub/nixCats-nvim";

    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
    };

    plugins-treesitter-textobjects = {
      url = "github:nvim-treesitter/nvim-treesitter-textobjects/main";
      flake = false;
    };

    "plugins-laravel.nvim" = {
      url = "github:adalessa/laravel.nvim";
      flake = false;
    };

    "plugins-vesper.nvim" = {
      url = "github:datsfilipe/vesper.nvim";
      flake = false;
    };

    "plugins-neotest-pest" = {
      url = "github:V13Axel/neotest-pest";
      flake = false;
    };

    # see :help nixCats.flake.inputs
    # If you want your plugin to be loaded by the standard overlay,
    # i.e. if it wasnt on nixpkgs, but doesnt have an extra build step.
    # Then you should name it "plugins-something"
    # If you wish to define a custom build step not handled by nixpkgs,
    # then you should name it in a different format, and deal with that in the
    # overlay defined for custom builds in the overlays directory.
    # for specific tags, branches and commits, see:
    # https://nixos.org/manual/nix/stable/command-ref/new-cli/nix3-flake.html#examples
  };

  # see :help nixCats.flake.outputs
  outputs =
    {
      self,
      nixpkgs,
      ...
    }@inputs:
    let
      inherit (inputs.nixCats) utils;
      luaPath = ./.;
      forEachSystem = utils.eachSystem nixpkgs.lib.platforms.all;
      # the following extra_pkg_config contains any values
      # which you want to pass to the config set of nixpkgs
      # import nixpkgs { config = extra_pkg_config; inherit system; }
      # will not apply to module imports
      # as that will have your system values
      extra_pkg_config = {
        allowUnfree = true;
      };
      # management of the system variable is one of the harder parts of using flakes.

      # so I have done it here in an interesting way to keep it out of the way.
      # It gets resolved within the builder itself, and then passed to your
      # categoryDefinitions and packageDefinitions.

      # this allows you to use ${pkgs.system} whenever you want in those sections
      # without fear.

      # sometimes our overlays require a ${system} to access the overlay.
      # Your dependencyOverlays can either be lists
      # in a set of ${system}, or simply a list.
      # the nixCats builder function will accept either.
      # see :help nixCats.flake.outputs.overlays
      dependencyOverlays = # (import ./overlays inputs) ++
        [
          # This overlay grabs all the inputs named in the format
          # `plugins-<pluginName>`
          # Once we add this overlay to our nixpkgs, we are able to
          # use `pkgs.neovimPlugins`, which is a set of our plugins.
          (utils.sanitizedPluginOverlay inputs)
          # add any other flake overlays here.

          # when other people mess up their overlays by wrapping them with system,
          # you may instead call this function on their overlay.
          # it will check if it has the system in the set, and if so return the desired overlay
          # (utils.fixSystemizedOverlay inputs.codeium.overlays
          #   (system: inputs.codeium.overlays.${system}.default)
          # )
        ];

      # see :help nixCats.flake.outputs.categories
      # and
      # :help nixCats.flake.outputs.categoryDefinitions.scheme
      categoryDefinitions =
        {
          pkgs,
          settings,
          categories,
          extra,
          name,
          mkPlugin,
          ...
        }@packageDef:
        {
          # to define and use a new category, simply add a new list to a set here,
          # and later, you will include categoryname = true; in the set you
          # provide when you build the package using this builder function.
          # see :help nixCats.flake.outputs.packageDefinitions for info on that section.

          # lspsAndRuntimeDeps:
          # this section is for dependencies that should be available
          # at RUN TIME for plugins. Will be available to PATH within neovim terminal
          # this includes LSPs
          lspsAndRuntimeDeps = {
            php = with pkgs; {
              general = [ intelephense ];
            };

            go = with pkgs; [
              gopls
              gotools
              golangci-lint
              golangci-lint-langserver
            ];

            rust = with pkgs; [
              clippy
              rust-analyzer
            ];

            vue = with pkgs; [
              vue-language-server
              vtsls
            ];

            python = with pkgs; [
              python312Packages.python-lsp-server
            ];

            javascript = with pkgs; [
              typescript-language-server
            ];

            css = with pkgs; [
              tailwindcss-language-server
            ];

            cpp = with pkgs; [
              clang
            ];
            json = with pkgs; [
              jq
            ];

            lint = with pkgs; { };

            format = with pkgs; {
              laravel = [
                blade-formatter
              ];
              rust = [
                rustfmt
              ];
              lua = [
                stylua
              ];
            };

            extra = with pkgs; [
              lazygit
            ];

            debug = with pkgs; {
              php = [
                (import ./php-debug-adapter.nix { inherit pkgs fetchurl stdenv; })
              ];
            };

            neonixdev = {
              inherit (pkgs)
                nix-doc
                lua-language-server
                nixd
                nixfmt
                ;
            };

            general = with pkgs; [
              fd
              imagemagick
            ];
          };

          # This is for plugins that will load at startup without using packadd:
          startupPlugins = {
            general = with pkgs.vimPlugins; {
              always = [
                lze
                lzextras
                plenary-nvim
                (nvim-notify.overrideAttrs { doCheck = false; }) # TODO: remove overrideAttrs after check is fixed
              ];
              debug = [
                nvim-nio
              ];
              extra = [
                oil-nvim
                nvim-web-devicons
              ];
            };
            themer =
              with pkgs.vimPlugins;
              (builtins.getAttr (categories.colorscheme or "onedark") {
                # Theme switcher without creating a new category
                "onedark" = onedark-nvim;
                "catppuccin" = catppuccin-nvim;
                "catppuccin-mocha" = catppuccin-nvim;
                "tokyonight" = tokyonight-nvim;
                "tokyonight-day" = tokyonight-nvim;
                "vesper" = pkgs.neovimPlugins.vesper-nvim;
              });
          };

          # not loaded automatically at startup.
          # use with packadd and an autocommand in config to achieve lazy loading
          optionalPlugins = {
            debug = with pkgs.vimPlugins; {
              default = [
                nvim-dap
                nvim-dap-view
              ];
            };

            testing = with pkgs.vimPlugins; {
              always = [
                neotest
              ];
              lua = [ neotest-plenary ];
              go = [ neotest-golang ];
              php = [ neotest-phpunit ];
              pest = [
                pkgs.neovimPlugins.neotest-pest
              ];
            };

            format = with pkgs.vimPlugins; [
              conform-nvim
            ];

            neonixdev = with pkgs.vimPlugins; [
              lazydev-nvim
            ];

            general = with pkgs.vimPlugins; {
              blink = [
                blink-cmp
                blink-compat
                luasnip
                colorful-menu-nvim
                cmp-cmdline
              ];
              treesitter = [
                pkgs.neovimPlugins.treesitter-textobjects
                nvim-treesitter.withAllGrammars
              ];
              database = [
                vim-dadbod
                vim-dadbod-completion
                vim-dadbod-ui
              ];
              always = [
                direnv-vim
                nvim-lspconfig
                lualine-nvim
                gitsigns-nvim
                mini-surround
                harpoon2
                snacks-nvim
              ];
              extras = [
                fidget-nvim
                which-key-nvim
                vim-easy-align
                nvim-colorizer-lua
                diffview-nvim
                mini-ai
                undotree
                indent-blankline-nvim
                vim-startuptime
                vim-dispatch
                obsidian-nvim
              ];
            };

            copilot = with pkgs.vimPlugins; [
              blink-cmp-copilot
              copilot-lua
            ];

            php.laravel = [
              pkgs.neovimPlugins.laravel-nvim
              pkgs.vimPlugins.nui-nvim
            ];
          };

          # shared libraries to be added to LD_LIBRARY_PATH
          # variable available to nvim runtime
          sharedLibraries = {
            general = with pkgs; [
              # libgit2
            ];
          };

          # environmentVariables:
          # this section is for environmentVariables that should be available
          # at RUN TIME for plugins. Will be available to path within neovim terminal
          environmentVariables = {
            test = {
              CATTESTVAR = "It worked!";
            };
          };

          # If you know what these are, you can provide custom ones by category here.
          # If you dont, check this link out:
          # https://github.com/NixOS/nixpkgs/blob/master/pkgs/build-support/setup-hooks/make-wrapper.sh
          extraWrapperArgs = {
            test = [
              ''--set CATTESTVAR2 "It worked again!"''
            ];
          };

          # lists of the functions you would have passed to
          # python.withPackages or lua.withPackages

          # get the path to this python environment
          # in your lua config via
          # vim.g.python3_host_prog
          # or run from nvim terminal via :!<packagename>-python3
          pytho3.libraries = {
            test = (_: [ ]);
          };
          # populates $LUA_PATH and $LUA_CPATH
          extraLuaPackages = {
            test = [ (_: [ ]) ];
          };
        };

      # And then build a package with specific categories from above here:
      # All categories you wish to include must be marked true,
      # but false may be omitted.
      # This entire set is also passed to nixCats for querying within the lua.

      # see :help nixCats.flake.outputs.packageDefinitions
      packageDefinitions = {
        # These are the names of your packages
        # you can include as many as you wish.
        nvim =
          { pkgs, ... }:
          {
            # they contain a settings set defined above
            # see :help nixCats.flake.outputs.settings
            settings = {
              wrapRc = true;
              # IMPORTANT:
              # your alias may not conflict with your other packages.
              aliases = [ "vim" ];
              neovim-unwrapped = inputs.neovim-nightly-overlay.packages.${pkgs.stdenv.hostPlatform.system}.neovim;
            };
            # and a set of categories that you want
            # (and other information to pass to lua)
            categories = {
              general = true;
              neonixdev = true;
              debug = true;
              testing = true;
              format = true;

              copilot = true;
              cpp = true;
              go = true;
              rust = true;
              php = {
                laravel = true;
              };
              python = true;
              javascript = true;

              vue = {
                path = "${pkgs.vue-language-server}/lib/language-tools/packages/language-server";
              };

              lspDebugMode = false;

              themer = true;
              colorscheme = "vesper";
            };
            extra = {
              nixdExtras = {
                nixpkgs = "import ${pkgs.path} {}";
              };
            };
          };
        nvim-work =
          { pkgs, ... }:
          {
            settings = {
              wrapRc = true;
              # IMPORTANT:
              # your alias may not conflict with your other packages.
              aliases = [
                "nvim"
                "vim"
              ];
              neovim-unwrapped = inputs.neovim-nightly-overlay.packages.${pkgs.stdenv.hostPlatform.system}.neovim;
            };

            categories = {
              general = true;
              neonixdev = true;
              debug = true;
              testing = true;
              format = true;

              copilot = true;

              go = true;
              javascript = true;

              makefile = true;
              php = {
                laravel = false;
                symfony = true;
              };

              lspDebugMode = false;

              themer = true;
              colorscheme = "vesper";
            };

            extra = {
              nixdExtras = {
                nixpkgs = "import ${pkgs.path} {}";
              };
            };
          };
      };
      # In this section, the main thing you will need to do is change the default package name
      # to the name of the packageDefinitions entry you wish to use as the default.
      defaultPackageName = "nvim";
    in

    # see :help nixCats.flake.outputs.exports
    forEachSystem (
      system:
      let
        nixCatsBuilder = utils.baseBuilder luaPath {
          inherit
            nixpkgs
            system
            dependencyOverlays
            extra_pkg_config
            ;
        } categoryDefinitions packageDefinitions;
        defaultPackage = nixCatsBuilder defaultPackageName;
        # this is just for using utils such as pkgs.mkShell
        # The one used to build neovim is resolved inside the builder
        # and is passed to our categoryDefinitions and packageDefinitions
        pkgs = import nixpkgs { inherit system; };
      in
      {
        # these outputs will be wrapped with ${system} by utils.eachSystem

        # this will make a package out of each of the packageDefinitions defined above
        # and set the default package to the one passed in here.
        packages = utils.mkAllWithDefault defaultPackage;

        # choose your package for devShell
        # and add whatever else you want in it.
        devShells = {
          default = pkgs.mkShell {
            name = defaultPackageName;
            packages = [ defaultPackage ];
            inputsFrom = [ ];
            shellHook = "";
          };
        };

      }
    )
    // (
      let
        # we also export a nixos module to allow reconfiguration from configuration.nix
        nixosModule = utils.mkNixosModules {
          inherit
            defaultPackageName
            dependencyOverlays
            luaPath
            categoryDefinitions
            packageDefinitions
            extra_pkg_config
            nixpkgs
            ;
        };
        # and the same for home manager
        homeModule = utils.mkHomeModules {
          inherit
            defaultPackageName
            dependencyOverlays
            luaPath
            categoryDefinitions
            packageDefinitions
            extra_pkg_config
            nixpkgs
            ;
        };
      in
      {

        # these outputs will be NOT wrapped with ${system}

        # this will make an overlay out of each of the packageDefinitions defined above
        # and set the default overlay to the one named here.
        overlays = utils.makeOverlays luaPath {
          inherit nixpkgs dependencyOverlays extra_pkg_config;
        } categoryDefinitions packageDefinitions defaultPackageName;

        nixosModules.default = nixosModule;
        homeModules.default = homeModule;

        inherit utils nixosModule homeModule;
        inherit (utils) templates;
      }
    );
}
