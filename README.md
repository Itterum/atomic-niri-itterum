# atomic-niri-itterum

[English](#english) · [Русский](#русский)

## English

Personal Fedora Atomic images built with [BlueBuild](https://blue-build.org/) on top of [Wayblue](https://github.com/wayblueorg/wayblue). The project provides a ready-to-use [Niri](https://github.com/YaLTeR/niri) desktop with [DankMaterialShell](https://github.com/AvengeMedia/DankMaterialShell), separate images for laptops and NVIDIA desktops, and a curated set of applications and defaults.

> This is a personal project intended primarily for the author's own systems. Its contents and configuration may change without notice.

### Image variants

| Image | Base image | Intended hardware |
| --- | --- | --- |
| `atomic-niri-itterum` | `ghcr.io/wayblueorg/niri:latest` | Laptops and systems without the NVIDIA Open kernel modules |
| `atomic-niri-itterum-nvidia` | `ghcr.io/wayblueorg/niri-nvidia-open:latest` | Desktops with supported NVIDIA GPUs |

Both variants share the modules defined in [`recipes/common.yml`](recipes/common.yml).

### Included software and configuration

The images add or configure:

- DankMaterialShell (DMS) and Quickshell;
- `greetd` with `dms-greeter` as the graphical login screen;
- Homebrew for Linux, initialized by `brew-setup.service`;
- Ghostty, Helix, Zed, and the ChatGPT desktop app;
- GNOME Keyring with PAM integration;
- Brave, Telegram Desktop, Flatseal, KeePassXC, Obsidian, LocalSend, and GNOME Boxes as system Flatpaks;
- a custom Niri configuration with DMS integration and personal overrides.

At image build time, SDDM is disabled, `greetd` is enabled, and the default systemd target is set to `graphical.target`.

### User configuration

Before the Niri user service starts, the image runs initialization helpers for Niri, Helix, and Zed.

- Niri's main `config.kdl` and `itterum.kdl` are refreshed from `/usr/share/atomic-niri-itterum/niri/` on every service start. Other Niri/DMS files are copied only when they do not already exist.
- Helix and Zed defaults are copied once. Their marker files are stored in `~/.local/state/atomic-niri-itterum/`, so existing user configuration is preserved after initialization.

The resulting user configuration is stored under `~/.config/niri`, `~/.config/helix`, and `~/.config/zed`.

### Installation

Choose the image matching your hardware:

```bash
# Laptop / non-NVIDIA variant:
IMAGE=atomic-niri-itterum

# Or, for the NVIDIA Open variant, use:
# IMAGE=atomic-niri-itterum-nvidia
```

The first rebase uses an unverified transport so the deployment can install the signing policy and public key included in the image:

```bash
sudo rpm-ostree rebase \
  ostree-unverified-registry:ghcr.io/itterum/${IMAGE}:latest
systemctl reboot
```

After rebooting, inspect the active deployment:

```bash
rpm-ostree status
```

Then switch to the signed transport and reboot again:

```bash
sudo rpm-ostree rebase \
  ostree-image-signed:docker://ghcr.io/itterum/${IMAGE}:latest
systemctl reboot
```

`rpm-ostree status` should now show the selected image through the signed transport.

### Updating and rollback

Pull the newest deployment and reboot:

```bash
sudo rpm-ostree upgrade
systemctl reboot
```

Return to the previous deployment if necessary:

```bash
sudo rpm-ostree rollback
systemctl reboot
```

Use `rpm-ostree status` to inspect all available deployments.

### Building locally

Install the [BlueBuild CLI](https://blue-build.org/how-to/setup/) and build the required recipe:

```bash
# Laptop / non-NVIDIA image
bluebuild build recipes/laptop.yml

# NVIDIA Open image
bluebuild build recipes/desktop.yml
```

The recipes are organized as follows:

```text
recipes/
├── common.yml   # Shared packages, files, scripts, Flatpaks, and signing
├── laptop.yml   # Wayblue Niri image
└── desktop.yml  # Wayblue Niri NVIDIA Open image
```

### CI and publishing

The `bluebuild` GitHub Actions workflow builds both recipes:

- daily at 06:00 UTC;
- on pushes to `main` and `experiment/**` (except documentation-only changes);
- for pull requests;
- on manual dispatch.

The workflow is intended to publish builds to GHCR only from the `main` branch. Pull requests and experiment branches build the images for validation without publishing them.

> **Known issue:** the current publish condition checks for `refs/head/main` instead of `refs/heads/main`. Until that condition is corrected, builds from `main` are not pushed to GHCR automatically.

### Signing

Published images are signed with [cosign](https://github.com/sigstore/cosign). The public key is stored in [`cosign.pub`](cosign.pub).

Verify an image manually with:

```bash
cosign verify \
  --key cosign.pub \
  ghcr.io/itterum/atomic-niri-itterum:latest
```

For the NVIDIA image, replace the image name with `atomic-niri-itterum-nvidia`.

---

## Русский

Персональные образы Fedora Atomic, собираемые с помощью [BlueBuild](https://blue-build.org/) на базе [Wayblue](https://github.com/wayblueorg/wayblue). Проект предоставляет готовое окружение [Niri](https://github.com/YaLTeR/niri) с [DankMaterialShell](https://github.com/AvengeMedia/DankMaterialShell), отдельные образы для ноутбуков и настольных ПК с NVIDIA, а также подобранный набор приложений и настроек.

> Это персональный проект, предназначенный прежде всего для систем автора. Его состав и конфигурация могут изменяться без предупреждения.

### Варианты образа

| Образ | Базовый образ | Целевое оборудование |
| --- | --- | --- |
| `atomic-niri-itterum` | `ghcr.io/wayblueorg/niri:latest` | Ноутбуки и системы без открытых модулей ядра NVIDIA |
| `atomic-niri-itterum-nvidia` | `ghcr.io/wayblueorg/niri-nvidia-open:latest` | Настольные ПК с поддерживаемыми видеокартами NVIDIA |

Оба варианта используют общие модули из [`recipes/common.yml`](recipes/common.yml).

### Программы и настройки

В образы добавлены или настроены:

- DankMaterialShell (DMS) и Quickshell;
- `greetd` с `dms-greeter` в качестве графического экрана входа;
- Homebrew для Linux, инициализируемый службой `brew-setup.service`;
- Ghostty, Helix, Zed и настольное приложение ChatGPT;
- GNOME Keyring с интеграцией PAM;
- Brave, Telegram Desktop, Flatseal, KeePassXC, Obsidian, LocalSend и GNOME Boxes в виде системных Flatpak-приложений;
- собственная конфигурация Niri с интеграцией DMS и персональными дополнениями.

Во время сборки образа SDDM отключается, `greetd` включается, а системной целью systemd по умолчанию становится `graphical.target`.

### Пользовательская конфигурация

Перед запуском пользовательской службы Niri образ выполняет скрипты инициализации Niri, Helix и Zed.

- Основные файлы Niri `config.kdl` и `itterum.kdl` обновляются из `/usr/share/atomic-niri-itterum/niri/` при каждом запуске службы. Остальные файлы Niri/DMS копируются, только если их ещё нет в пользовательской конфигурации.
- Настройки Helix и Zed копируются один раз. Файлы-маркеры хранятся в `~/.local/state/atomic-niri-itterum/`, поэтому существующая пользовательская конфигурация после инициализации сохраняется.

Итоговые настройки размещаются в `~/.config/niri`, `~/.config/helix` и `~/.config/zed`.

### Установка

Выберите образ, соответствующий оборудованию:

```bash
# Ноутбук / вариант без NVIDIA:
IMAGE=atomic-niri-itterum

# Или для варианта с NVIDIA Open используйте:
# IMAGE=atomic-niri-itterum-nvidia
```

При первом переходе используется непроверяемый транспорт, чтобы новая система могла установить включённые в образ политику подписи и открытый ключ:

```bash
sudo rpm-ostree rebase \
  ostree-unverified-registry:ghcr.io/itterum/${IMAGE}:latest
systemctl reboot
```

После перезагрузки проверьте активное развёртывание:

```bash
rpm-ostree status
```

Затем переключитесь на проверяемый транспорт и снова перезагрузите систему:

```bash
sudo rpm-ostree rebase \
  ostree-image-signed:docker://ghcr.io/itterum/${IMAGE}:latest
systemctl reboot
```

Теперь `rpm-ostree status` должен показывать выбранный образ через проверяемый транспорт.

### Обновление и откат

Загрузите новое развёртывание и перезагрузите систему:

```bash
sudo rpm-ostree upgrade
systemctl reboot
```

При необходимости вернитесь к предыдущему развёртыванию:

```bash
sudo rpm-ostree rollback
systemctl reboot
```

Команда `rpm-ostree status` показывает все доступные развёртывания.

### Локальная сборка

Установите [BlueBuild CLI](https://blue-build.org/how-to/setup/) и соберите нужный рецепт:

```bash
# Образ для ноутбука / без NVIDIA
bluebuild build recipes/laptop.yml

# Образ с NVIDIA Open
bluebuild build recipes/desktop.yml
```

Структура рецептов:

```text
recipes/
├── common.yml   # Общие пакеты, файлы, скрипты, Flatpak и подпись
├── laptop.yml   # Образ Wayblue Niri
└── desktop.yml  # Образ Wayblue Niri NVIDIA Open
```

### CI и публикация

Workflow `bluebuild` в GitHub Actions собирает оба рецепта:

- ежедневно в 06:00 UTC;
- при отправке изменений в `main` и `experiment/**`, кроме изменений только в документации;
- для pull request;
- при ручном запуске.

Workflow предназначен для публикации образов в GHCR только из ветки `main`. Для pull request и экспериментальных веток выполняется проверочная сборка без публикации.

> **Известная проблема:** текущее условие публикации проверяет `refs/head/main` вместо `refs/heads/main`. Пока условие не исправлено, сборки из `main` не отправляются в GHCR автоматически.

### Подпись

Опубликованные образы подписываются с помощью [cosign](https://github.com/sigstore/cosign). Открытый ключ находится в файле [`cosign.pub`](cosign.pub).

Проверить образ вручную можно командой:

```bash
cosign verify \
  --key cosign.pub \
  ghcr.io/itterum/atomic-niri-itterum:latest
```

Для образа с NVIDIA замените его имя на `atomic-niri-itterum-nvidia`.
