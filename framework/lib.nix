{ lib, ... }:
{
  _module.args.lib = lib.extend (_: prev: { utils = import ../lib prev; });
}
