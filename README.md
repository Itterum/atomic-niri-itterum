# niri-itterum

Personal Fedora Atomic image based on [Wayblue Niri](https://github.com/wayblueorg/wayblue).

Built with [BlueBuild](https://blue-build.org/).

## What

A derived image on top of `ghcr.io/wayblueorg/niri:latest` with personal package and Flatpak preferences:

- **helix** — modal text editor
- **starship** — cross-shell prompt (via COPR atim/starship)
- **quickshell** — scriptable shell and bar
- **dms** — display management (via COPR avengemedia/dms)
- **foot** — fast, minimal Wayland terminal
- **Homebrew** — user-space package manager (installed at runtime)
- **Brave Browser** — via Flathub
- **GNOME Loupe** — image viewer via Flathub

Wayblue Niri base already includes: niri, waybar, alacritty, fuzzel, swaylock,
swayidle, swaybg, SDDM, pipewire, wireplumber, thunar, dunst, rofi, grim, slurp,
blueman, NetworkManager, and more.

## Installation

### Rebase from an existing Fedora Atomic installation

> Two reboots are required: the first installs signing keys and policies.

Step 1 — rebase to the unsigned image to get signing keys:

    rpm-ostree rebase ostree-unverified-registry:ghcr.io/itterum/niri-itterum:latest
    systemctl reboot

Step 2 — rebase to the signed image:

    rpm-ostree rebase ostree-image-signed:docker://ghcr.io/itterum/niri-itterum:latest
    systemctl reboot

## Build

Images are built automatically on GitHub Actions and published to GHCR.

To build locally (requires `bluebuild` CLI):

    bluebuild build recipes/recipe.yml

## Signing

This image is signed with [cosign](https://github.com/sigstore/cosign).
The public key is available at `cosign.pub` in this repository.

To verify manually:

    cosign verify --key cosign.pub ghcr.io/itterum/niri-itterum:latest
