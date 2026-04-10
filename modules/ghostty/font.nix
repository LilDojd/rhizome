{
  flake.modules.homeManager.gui =
    hmArgs@{ ... }:
    {
      programs.ghostty.settings = {
        font-size = 12;
        font-family = hmArgs.config.stylix.fonts.monospace.name;

        font-variation = [
          "wght=200"
          "wdth=100"
          "slnt=0"
        ];
        font-variation-bold = [
          "wght=300"
          "wdth=100"
          "slnt=0"
        ];
        font-variation-bold-italic = [
          "wght=300"
          "wdth=100"
          "slnt=-9.625"
        ];
        font-variation-italic = [
          "wght=300"
          "wdth=100"
          "slnt=-9.625"
        ];

        font-feature = [
          "calt"
          "ss01"
          "ss02"
          "ss03"
          "ss04"
          "ss05"
          "ss06"
          "ss07"
          "ss08"
          "ss09"
          "ss10"
          "liga"
        ];
      };
    };
}
