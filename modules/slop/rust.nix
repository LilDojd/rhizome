{ inputs, ... }:
{
  flake.modules.homeManager.slop.dendriticSlop.skills = inputs.dendritic-slop.skillSets.rust;
}
