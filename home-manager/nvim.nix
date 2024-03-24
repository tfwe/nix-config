{
config,
pkgs,
...
}:
{
   programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    defaultEditor = true;
    extraPackages = with pkgs; [
      unzip
      python3
      nodejs
      gcc
      gnumake
      xclip
    ];
    plugins = [
      {
        plugin = pkgs.vimPlugins.nvchad;
      }
    ];
  };
  xdg.configFile.nvim = {
    source = pkgs.vimPlugins.nvchad.src;
    recursive = true;
  };
}
