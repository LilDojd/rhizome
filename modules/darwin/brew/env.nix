{
  flake.modules.darwin.pc =
    { config, ... }:
    {
      environment = {
        variables = {
          # Do not send analytic data to Homebrew
          HOMEBREW_NO_ANALYTICS = "1";
          # Don't allow insecure redirects
          HOMEBREW_NO_INSECURE_REDIRECT = "1";
          HOMEBREW_NO_ENV_HINTS = "0";
        };
        systemPath = [ config.homebrew.brewPrefix ];
      };
    };
}
