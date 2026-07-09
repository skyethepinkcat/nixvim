{
  lib,
  pkgs,
  ...
}:
{
  filetype.extension.rpy = "renpy";
  extraPlugins = [
    (pkgs.vimUtils.buildVimPlugin {
      name = "renpy";
      src = pkgs.fetchFromGitHub {
        repo = "renpy-syntax.nvim";
        owner = "inzoiniac";
        rev = "3838f6b";
        hash = "sha256-S+ia73LYjwFd+zUnZVncfZG/UiQuJeH+Hn7bj4/HX3c=";
      };
    })
  ];
}
