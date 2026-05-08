{ lib, ... }:
{
  _module.args.utils = import ../lib lib;
}
