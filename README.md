# atomic-niri-itterum

Personal Fedora Atomic image based on [Bazzite DX](https://github.com/ublue-os/bazzite-dx), built with [BlueBuild](https://blue-build.org/).

The goal is to keep the complete Bazzite DX GNOME/NVIDIA experience while adding Niri as an alternative Wayland session and gradually building a personal Niri + DMS desktop on top of it.

> This is a personal image and is primarily intended for my own systems. It may change at any time.

## Base image

This image is built on:

```text
ghcr.io/ublue-os/bazzite-dx-nvidia-gnome:stable
```

That means the existing Bazzite DX stack remains available, including GNOME, GDM, NVIDIA support, gaming features, developer tooling, Homebrew integration, and the rest of the Bazzite ecosystem.

Niri is installed alongside GNOME rather than replacing it, so both sessions can be selected from GDM.

## Added packages

The current image adds:

- [Niri](https://github.com/YaLTeR/niri) — scrollable-tiling Wayland compositor
- [DankMaterialShell](https://github.com/AvengeMedia/DankMaterialShell) — desktop shell for Niri
- [Helix](https://helix-editor.com/) — modal text editor

DMS packages are installed from the `avengemedia/danklinux` and `avengemedia/dms` COPR repositories.

The Niri/DMS configuration is intentionally still minimal while the setup is being tested and refined.

## Installation

### Rebase from another Fedora Atomic / Universal Blue image

The first switch to this image uses an unverified transport so the deployment can install the signing policy and public key shipped by the image.

```bash
sudo rpm-ostree rebase \
  ostree-unverified-registry:ghcr.io/itterum/atomic-niri-itterum:latest

systemctl reboot
```

After reboot, verify that the system is running the custom image:

```bash
rpm-ostree status
```

Then switch to the signed transport:

```bash
sudo rpm-ostree rebase \
  ostree-image-signed:docker://ghcr.io/itterum/atomic-niri-itterum:latest

systemctl reboot
```

After the second reboot, `rpm-ostree status` should show something similar to:

```text
ostree-image-signed:docker://ghcr.io/itterum/atomic-niri-itterum:latest
```

## Updating

Once the system is already rebased to this image, another rebase is not required for normal updates.

Pull the newest image with:

```bash
sudo rpm-ostree upgrade
systemctl reboot
```

The `latest` tag is rebuilt by GitHub Actions from the current recipe.

## Rollback

Previous deployments remain available through rpm-ostree.

To roll back to the previous deployment:

```bash
sudo rpm-ostree rollback
systemctl reboot
```

You can inspect all available deployments with:

```bash
rpm-ostree status
```

## Building

Images are built automatically with GitHub Actions and published to GHCR.

The BlueBuild recipe is located at:

```text
recipes/recipe.yml
```

To build locally with the BlueBuild CLI:

```bash
bluebuild build recipes/recipe.yml
```

## Signing

Images are signed with [cosign](https://github.com/sigstore/cosign).

The public key is stored in this repository as:

```text
cosign.pub
```

A published image can be verified manually with:

```bash
cosign verify \
  --key cosign.pub \
  ghcr.io/itterum/atomic-niri-itterum:latest
```

## Current status

The current setup is deliberately small and stable enough for daily testing:

```text
Bazzite DX GNOME NVIDIA
├── GNOME
├── Niri
├── DankMaterialShell
└── Helix
```

The next steps will be decided after using the image for a while. Possible future additions include a curated default Niri/DMS configuration, session-specific DMS startup, additional desktop utilities, and further image cleanup.
