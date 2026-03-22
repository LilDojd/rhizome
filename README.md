# LilDojd/rhizome

Georgy Andreev's [Nix](https://nix.dev)-powered system configuration repository.
Manages NixOS and nix-darwin hosts, home-manager modules, and development environments declaratively.

> [!NOTE]
> If you have any questions or suggestions, feel free to use the discussions feature or contact me.

<a href="https://github.com/LilDojd/rhizome/actions/workflows/check.yaml?query=branch%3Amain">
<img
  alt="CI status"
  src="https://img.shields.io/github/actions/workflow/status/LilDojd/rhizome/check.yaml?style=for-the-badge&branch=main&label=Check"
>
</a>

[![FlakeHub](https://img.shields.io/endpoint?url=https://flakehub.com/f/LilDojd/rhizome/badge)](https://flakehub.com/flake/LilDojd/rhizome)

## Acknowledgements

> [!IMPORTANT]
> This repository is heavily inspired by [@mightyiam](https://github.com/mightyiam)'s
> infrastructure repo. The architecture, patterns, and much of the tooling
> originate from his work. All praise should go to him.

## NixOS configurations

Configurations are declared by prefixing a module's name.

> [!TIP]
> This spares me of some boilerplate.
> For example, see [`darkforest/imports`](modules/darkforest/imports.nix).

## Running checks on GitHub Actions

Workflow files are generated using
[the _files_ flake-parts module](https://github.com/mightyiam/files).
For better visibility, a job is spawned for each flake check dynamically.

> [!NOTE]
> Running this repository's flake checks on GitHub Actions is merely a bonus
> and possibly more of a liability.

> [!TIP]
> To prevent runners from running out of space,
> the action [Nothing but Nix](https://github.com/marketplace/actions/nothing-but-nix)
> is used.

See [`modules/meta/ci.nix`](modules/meta/ci.nix).

## Generated files

The following files in this repository are generated and checked
using [the _files_ flake-parts module](https://github.com/mightyiam/files):

- `.github/workflows/check.yaml`
- `.gitignore`
- `LICENSE`
- `README.md`

