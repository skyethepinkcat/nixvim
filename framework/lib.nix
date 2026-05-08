{ lib, ... }:
{
  _module.args.lib = lib.extend (_: _: { utils = import ../lib; });
}
