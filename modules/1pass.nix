{
  config,
  lib,
  ...
}:
{
  nixpkgs.config.allowUnfreePackages = [
    "1password"
    "1password-cli"
    "1password-gui"
  ];

  flake.modules =
    let
      getOnePassGui =
        {
          osConfig ? null,
          pkgs,
          ...
        }:
        if osConfig == null then pkgs._1password-gui else osConfig.programs._1password-gui.package;
      flakeCommon =
        { pkgs, ... }:
        let
          username = config.flake.meta.owner.username;
        in
        {
          programs._1password.enable = true;

          programs._1password-gui = {
            enable = true;
          }
          // lib.optionalAttrs (pkgs.stdenv.hostPlatform.isLinux) {
            polkitPolicyOwners = [ username ];
          };
        };
    in
    {
      homeManager.base =
        hmArgs@{ pkgs, ... }:
        let
          onePassGui = getOnePassGui hmArgs;
          onePassPath =
            if pkgs.stdenv.hostPlatform.isDarwin then
              ''"~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"''
            else
              "~/.1password/agent.sock";
          onePassOpSshSign =
            if pkgs.stdenv.hostPlatform.isDarwin then
              "/Applications/1Password.app/Contents/MacOS/op-ssh-sign"
            else
              "${onePassGui}/bin/op-ssh-sign";
        in
        {
          programs.ssh = {
            extraConfig = ''
              Host *
                IdentityAgent ${onePassPath}
            '';
          };
          programs.jujutsu = {

            settings = {
              signing = {
                backends.ssh = {
                  program = onePassOpSshSign;
                };
              };

            };
          };
        };

      homeManager.gui =
        { config, pkgs, ... }:
        let
          nativeHosts =
            if pkgs.stdenv.hostPlatform.isDarwin then
              "Library/Application Support/LibreWolf/NativeMessagingHosts"
            else
              "${config.programs.librewolf.configPath}/native-messaging-hosts";
          mozillaHosts =
            if pkgs.stdenv.hostPlatform.isDarwin then
              "Library/Application Support/Mozilla/NativeMessagingHosts"
            else
              ".mozilla/native-messaging-hosts";
        in
        {
          # 1Password maintains this manifest; LibreWolf uses a different directory.
          home.file."${nativeHosts}/com.1password.1password.json" =
            lib.mkIf config.programs.librewolf.enable
              {
                source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/${mozillaHosts}/com.1password.1password.json";
              };
        };

      homeManager.hyprland =
        hmArgs@{ pkgs, ... }:
        let
          onePassGui = getOnePassGui hmArgs;
        in
        {

          xdg.desktopEntries = {
            "com.onepassword.OnePassword" = {
              name = "1Password";
              genericName = "Password Manager";
              exec = "${lib.getExe onePassGui} --ozone-platform=x11 %U";
              terminal = false;
              type = "Application";
              icon = "1password";
              categories = [
                "Utility"
                "Security"
              ];
              mimeType = [
                "x-scheme-handler/onepassword"
                "x-scheme-handler/op"
              ];
            };
          };

          wayland.windowManager.hyprland.settings.on = [
            {
              _args = [
                "hyprland.start"
                (lib.generators.mkLuaInline "function() hl.exec_cmd(${builtins.toJSON "${lib.getExe' pkgs.coreutils "sleep"} 2 && ${lib.getExe onePassGui} --ozone-platform=x11 --silent"}) end")
              ];
            }
          ];
          wayland.windowManager.hyprland.settings.window_rule = lib.mkBefore [
            {
              match.class = "^(1Password)$";
              match.float = true;
              center = true;
            }
          ];
        };

      nixos.foundation = {
        imports = [ flakeCommon ];
        environment.etc."1password/custom_allowed_browsers".text = "librewolf\n";
        environment.persistence."/persistent".users.${config.flake.meta.owner.username}.directories = [
          ".mozilla"
          ".config/1Password"
          "1Password"
        ];
      };

      darwin.foundation = {
        imports = [ flakeCommon ];
      };
    };
}
