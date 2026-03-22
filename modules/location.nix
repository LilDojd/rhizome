{ lib, ... }:
{
  options.location = {
    latitude = lib.mkOption {
      type = lib.types.numbers.between (-90) 90;
      default = 24.45;
    };
    longitude = lib.mkOption {
      type = lib.types.numbers.between (-180) 180;
      default = 54.65;
    };
  };
}
