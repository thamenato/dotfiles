{
  programs.nixvim = {
    plugins.luasnip = {
      enable = true;

      fromSnipmate = [
        {paths = ./snippets/sh.snippets;}
      ];

      luaConfig.post = ''
        require("luasnip.loaders.from_snipmate").lazy_load()
      '';
    };
  };
}
