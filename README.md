# grimmstation-void

> A complete, laptop-tuned **Void Linux + Sway** desktop, ported from the
> Arch-based [grimmstation](https://codeberg.org/bibjaw99/grimmstation) dotfiles
> and rebuilt for **xbps + runit + elogind**, with **wofi**, **zsh + starship**,
> **tuigreet** login and **PipeWire** audio. One script turns a freshly
> installed machine into this whole environment.
>
> **Built for:** Dell Latitude 5490 · i5-8250U · Intel UHD 620 · 16 GB · UEFI · ext4
> **Void flavour:** glibc + runit

## Table of contents

1. Read this first · 2. Glossary · 3. What's in this desktop ·
4. Before you install · 5. Installing Void · 6. First boot · 7. The installer ·
8. Reboot & log in · 9. Your screen · 10. The 12 keys · 11. Full keys ·
12. Everyday how-to · 13. Software · 14. runit vs systemd · 15. xbps ·
16. Sway · 17. The Sway stack · 18. zsh + starship · 19. Grimm Neovim ·
20. Laptop power · 21. Sound · 22. Customising · 23. Troubleshooting ·
24. App-by-app · 25. Cheat sheet · 26. Credits

---

## 1. Read this first

Coming from Linux Mint, five things feel new; none are hard:

1. **You install software by typing one command** (this repo does the big first
   batch for you).
2. **No systemd.** Void uses **runit** (simpler). Section 14.
3. **Rolling release** — no version upgrades, just update often.
4. **The window manager tiles** — Sway arranges windows; you drive it from the
   keyboard. Section 10 gives you the starter keys.
5. **It's Wayland** — modern display tech, already wired for you.

> Don't fight it into behaving like Mint. Give it a week; the keyboard-driven
> tiling flow is the point and gets fast quickly.

## 2. Glossary

- **Compositor / WM:** draws & arranges windows — here, **Sway**.
- **Wayland:** modern display system (replaces X11).
- **Tiling:** windows auto-arrange, no overlap.
- **runit:** Void's init system. **xbps:** its package manager (like apt).
- **service/daemon:** background program. **repo:** the software library.
- **dotfiles:** config files (this repo). **symlink:** a file pointer.
- **$mod / Super:** the ⊞ key, Sway's modifier.
- **greetd/tuigreet:** the login screen. **elogind:** power/seat handling.
- **PipeWire:** sound. **wofi:** launcher. **Waybar:** top bar.

## 3. What's in this desktop

Sway (WM) · Waybar (bar) · wofi (launcher) · greetd+tuigreet (login) ·
zsh+starship (shell) · foot (terminal) · PCManFM + lf (files) · Firefox ·
Neovim (editor) · PipeWire (sound) · swaylock+swayidle (lock/idle) ·
elogind+TLP+thermald (power) · grim+swappy (screenshots) · mako (notifications) ·
blueman (bluetooth) · optional Flatpak + KVM/virt-manager.

## 4. Before you install

USB stick (4 GB+), ~20 min.

**Download:** x86_64 **glibc base** live image from
<https://voidlinux.org/download/>.

**Write it:** Linux → `sudo dd if=void-live-*.iso of=/dev/sdX bs=4M status=progress oflag=sync`
(sdX = the USB, not a partition). Windows → Rufus in DD mode.

**Dell Latitude 5490 BIOS (F2 at the logo):** Secure Boot **Disabled**, SATA
Operation **AHCI**, Virtualization (VT-x) & VT for Direct I/O **Enabled**, boot
mode **UEFI**. Save, then F12 to boot the USB.

## 5. Installing Void

Boot the USB, log in `root` / `voidlinux`, run `void-installer`. Choose: your
keyboard; connect network; **Source: Network**; hostname; locale/timezone; root
password; create your user **in the `wheel` group**; **GRUB** bootloader;
guided whole-disk partitioning with ~512 MB EFI (`/boot/efi`, FAT32) + the rest
**ext4** at `/`. Install, `reboot`, pull the USB. You now have a bare text
system.

## 6. First boot

```sh
su -
xbps-install -Suy git sudo
echo "%wheel ALL=(ALL:ALL) ALL" > /etc/sudoers.d/wheel
chmod 440 /etc/sudoers.d/wheel
usermod -aG wheel YOURUSERNAME
exit

mkdir -p "$HOME/workstationdots"
git clone https://github.com/YOURNAME/grimmstation-void "$HOME/workstationdots/grimmstation"
bash "$HOME/workstationdots/grimmstation/install_scripts/install.sh"
```

(No Wi-Fi yet? Use Ethernet for the install; `nmtui` handles Wi-Fi afterward.)

## 7. The installer

Runs in order: system sync → Intel graphics + thermald → power
(TLP/elogind/brightness) → PipeWire → directories → all packages →
copy+symlink dotfiles (old ones backed up to `~/.config.backup/`) → zsh →
tuigreet + keyring → runit services. Safe to re-run.

Extras: `bash install_scripts/scripts/install_with_flatpak.sh` and
`bash install_scripts/scripts/setup_virtualization.sh`. Then `sudo reboot`.

## 8. Reboot & log in

tuigreet appears (gruvbox yellow). Username remembered; type password, Enter.
Session `start-sway` preselected (F3 to change). You land in Sway: wallpaper +
bar, no windows (normal).

**Do these five now:** 1) terminal `Super`+`Return`; 2) Wi-Fi `nmtui`;
3) `vainfo` shows `iHD`; 4) `bat` for battery; 5) close/open the lid → resume
**locked**.

## 9. Your screen

**Top bar:** left = launcher icon + workspaces + window title; center = clock;
right = network, disk, CPU, CPU temp, brightness, memory, volume, battery.
**Workspaces 1–8** are themed: 1 terminal · 2 browser · 3 dev/DB · 4 files ·
5 chat · 6 design · 7 office/PDF · 8 system.

## 10. The 12 keys

`Super` = ⊞ key. **Every everyday action is a single chord (no double-press).**

| Do | Press |
| --- | --- |
| Terminal | `Super`+`Return` |
| App launcher | `Super`+`d` |
| Browser | `Super`+`b` |
| Window switcher | `Super`+`` ` `` (backtick) |
| Emoji picker | `Super`+`e` |
| Power menu | `Super`+`Shift`+`e` |
| Close window | `Super`+`Shift`+`q` |
| Lock | `Super`+`Shift`+`x` |
| Fullscreen | `Super`+`m` |
| Move focus | `Super`+`h`/`j`/`k`/`l` |
| Go to workspace | `Super`+`1`…`8` |
| Reload Sway | `Super`+`Shift`+`r` |

## 11. Full keys

**Apps (direct):** `Super`+`Return` terminal · `Super`+`b` browser ·
`Super`+`Shift`+`b` incognito · `Super`+`Shift`+`Return` file manager.

**Menus (direct):** `Super`+`d` launcher · `Super`+`Shift`+`d` run ·
`Super`+`` ` `` window switcher · `Super`+`e` emoji · `Super`+`Shift`+`e` power.

**Windows:** `Super`+`h/j/k/l` focus (or arrows) · `+Shift` move · `+Ctrl`
resize · `Super`+`a`/`Super`+`Shift`+`a` split V/H · `Super`+`Shift`+`o` cycle
layout · `Super`+`m` fullscreen · `Super`+`space` float+center ·
`Super`+`n` tiling/floating focus toggle · `Super`+`u`/`i` focus parent/child ·
`Super`+`Shift`+`q` close · `Super`+`Shift`+`r` reload.

**Workspaces:** `Super`+`1..8` go · `+Shift` send · `Super`+`Tab` next ·
`Alt`+`Tab` previous.

**Grouped modes (press trigger, then a bare letter; `Escape` exits):**
- **Open app** `Super`+`o` → `p` PDF · `m` music · `b` bluetooth · `a` audio ·
  `w` wallpapers
- **Swap windows** `Super`+`Shift`+`s` → `h/j/k/l`
- **Scripts** `Super`+`Shift`+`g` → `b` waybar theme · `t` night-light ·
  `w` wallpaper · `x` run a script
- **Bookmarks** `Super`+`Shift`+`w` → `m` tab · `Shift`+`m` private · `n` window ·
  `c` category
- **Notifications** `Super`+`Shift`+`m` → `m` restore · `Shift`+`m` dismiss all

**Hardware:** brightness `Super`+`F4/F3`; volume `Super`+`F7/F6/F5`; media
`Super`+`Shift`+arrows; `Print` screenshot; `Super`+`Print` annotate.

Source of truth: `config_dotfiles/config/sway/keymaps.conf`.

## 12. Everyday how-to

Open any app → `Super`+`d`, type, Enter. Two windows side by side → open one,
`Super`+`Shift`+`a`, open the second. Emoji → `Super`+`e`. Screenshot+annotate →
`Super`+`Print`. Wallpaper → drop into `~/Pictures/backgrounds`, then
`Super`+`Shift`+`g` `w`. Lock → `Super`+`Shift`+`x`. Power → `Super`+`Shift`+`e`.

## 13. Software

`xi PKG` install · `up` update all · `search X` find · `xr PKG` remove ·
`xclean` clean · `list` installed. Flatpak (if set up):
`flatpak install flathub <id>`. Try `xi` first; Flatpak for big GUI apps not in
the repo.

## 14. runit vs systemd

Void uses **runit**, a tiny service supervisor, not systemd. A service is a
directory in `/etc/sv/NAME`; you **enable** it by symlinking into
`/var/service/`, and runit starts and supervises it.

| Task | systemd | runit |
| --- | --- | --- |
| Enable+start | `systemctl enable --now NAME` | `sudo ln -s /etc/sv/NAME /var/service/` |
| Disable | `systemctl disable NAME` | `sudo rm /var/service/NAME` |
| Start/stop | `systemctl start/stop NAME` | `sudo sv up/down NAME` |
| Restart | `systemctl restart NAME` | `sudo sv restart NAME` |
| Status | `systemctl status NAME` | `sudo sv status NAME` |
| Logs | `journalctl -u NAME` | `tail -f /var/log/socklog/*/current` |

Consequences: **no journalctl** (logs are plain files via `socklog-void`);
**no user units** (that's why PipeWire/swayidle start from Sway autostart);
**no timers** (use cron); **logind = elogind** (gives passwordless suspend).
A service only exists to enable *after* its package is installed. Note the
bluetooth service is `bluetoothd`.

## 15. xbps

Void's package manager: fast, one repo, rolling.

| Task | apt | xbps |
| --- | --- | --- |
| Update | `apt update && apt upgrade` | `xbps-install -Suy` |
| Install | `apt install PKG` | `xbps-install PKG` |
| Remove | `apt remove PKG` | `xbps-remove PKG` |
| Search | `apt search X` | `xbps-query -Rs X` |
| Info | `apt show PKG` | `xbps-query -R PKG` |
| Owns file | `dpkg -S FILE` | `xbps-query -o FILE` |
| Clean | `apt clean` | `xbps-remove -Oo` |

Flags: `-S` sync · `-u` update · `-y` yes · `-R` remote · `-o` orphans ·
`-O` clean cache · `-f` force. Extra repos: nonfree (installer enables it),
`void-repo-multilib` for 32-bit. `sudo xmirror` picks a faster mirror. If an
install "isn't found", `search` for it (Void may have renamed it). Update
weekly with `up`; reboot after kernel/driver updates.

## 16. Sway

A tiling Wayland compositor (i3-compatible). Opening a window splits the focused
container (direction set by `Super`+`a` / `Super`+`Shift`+`a`). Focus moves with
`Super`+`h/j/k/l`. Config files in `~/.config/sway/`: `variables.conf` (apps,
colors), `keymaps.conf` (keys), `workspaces.conf` (app→workspace),
`windowrules.conf` (per-app rules), `lookAndFeel.conf` (borders/gaps/fonts),
`devices.conf` (monitor+touchpad), `autostart.conf` (session start). Reload with
`Super`+`Shift`+`r`. Handy: `swaymsg -t get_outputs`, `swaymsg reload`,
`swaymsg exit`. Multi-monitor: add an `output NAME { mode ... pos X Y }` line to
`devices.conf`.

## 17. The Sway stack

**Core:** sway · wayland/-protocols · xorg-server-xwayland (X11 apps) ·
qt6-wayland. **Bar/launcher/notify:** Waybar · wofi · mako.
**Wallpaper/lock/idle:** swaybg · swaylock (`-f`) · swayidle.
**Screenshots/clipboard:** grim · slurp · swappy · wl-clipboard · wtype.
**Portals:** xdg-desktop-portal (+wlr screenshot/screencast, +gtk file dialogs).
**Session/power:** elogind · dbus · polkit+mate-polkit · gnome-keyring.
**Look/input:** lxappearance · wlsunset · brightnessctl · playerctl.
**Fonts:** nerd-fonts-ttf · noto/dejavu/terminus. **Audio:** pipewire ·
wireplumber.

## 18. zsh + starship

bash-compatible shell + a fast prompt. You gain: smart tab completion,
`Ctrl+r` fuzzy history (fzf), grey autosuggestions (`→` accepts), live syntax
highlighting, vi keybindings (`Esc`). Config: `~/.zshrc`, `~/.alias`,
`~/.config/starship.toml`. Plugins: autosuggestions, syntax-highlighting,
completions, fzf. Want bash back? `chsh -s /bin/bash`.

## 19. Grimm Neovim

Full Neovim config. Modal: Normal by default, `i` insert, `Esc` back. **First
launch downloads plugins (needs internet, ~1 min)**; let it finish, reopen.
Included: lazy.nvim (`:Lazy`), Mason (`:Mason`), mini.files (tree),
Snacks.nvim (fuzzy find), LSP+completion, Gitsigns, Treesitter. Survival:
`i`/`Esc`, `:w` save, `:q` quit, `:wq`, `:q!`, `h/j/k/l` move, `/text` search,
`u`/`Ctrl+r` undo/redo, `dd`/`yy`/`p`. Press `Space` (leader) and wait for a
popup listing shortcuts. Run `vimtutor` once.

## 20. Laptop power

Close lid → suspend; open → resume **locked**. Idle 5 min → lock; 10 → screen
off. Power button → suspend (not shutdown). Battery via **TLP** (`power` =
`sudo tlp-stat -s`, tune `/etc/tlp.conf`). Thermal via **thermald**. Low-battery
warnings at 30%/20%. Brightness keys work without root. Clock re-syncs on resume
(**chrony**). Lid/power behaviour:
`/etc/elogind/logind.conf.d/10-grimmstation.conf`.

> No `acpid` here — elogind handles ACPI; running both causes double-suspend.

## 21. Sound

PipeWire starts with the session. Volume `Super`+`F7/F6/F5`. Mixer: `wiremix` or
`pavucontrol`. Silent? Check `groups` has `audio` and `pgrep -a pipewire`; log
out/in after first install.

## 22. Customising

Packages: `install_scripts/package_lists/*.txt`. Display/touchpad:
`config/sway/devices.conf`. Launcher look: `config/wofi/style.css`. Prompt:
`config/starship.toml`. Keys: `config/sway/keymaps.conf` then
`Super`+`Shift`+`r`. Battery: `/etc/tlp.conf`. After editing a repo dotfile,
re-run `bash install_scripts/scripts/symlink_configs.sh`.

## 23. Troubleshooting

- **Resume flashes desktop / no lock:** `pgrep -a swayidle`; swaylock uses `-f`
  (this build does).
- **Double-suspend / instant wake:** acpid is installed — disable it
  (`sudo rm /var/service/acpid`, `sudo mv /etc/acpi/events/anything{,.disabled}`).
- **Brightness keys dead:** `groups | grep video`; log out/in after install.
- **No sound:** `pgrep -a pipewire`; `groups` has `audio`.
- **No video accel:** `vainfo` should show `iHD`.
- **Power menu asks for a password:** `dbus` up + logged in via tuigreet.
- **Keyring keeps prompting:** confirm `pam_gnome_keyring` in `/etc/pam.d/greetd`.
- **Temp warning silent:** `lm_sensors` installed; `sudo sensors-detect --auto`
  once if needed.
- **Battery drains fast:** `sudo tlp-stat -s`; tune `/etc/tlp.conf`.
- **Wi-Fi didn't reconnect after resume:** `sudo sv restart NetworkManager`.
- **Package "not found":** `search <partial>`.
- **Keep healthy:** run `up` weekly.

## 24. App-by-app

Sway (WM) · Waybar (bar) · wofi (launcher) · foot (terminal) · PCManFM/lf
(files) · Firefox · Neovim · mako (notifications) · swaylock/swayidle · grim/
swappy (screenshots) · blueman (bluetooth) · wiremix/pavucontrol (audio) ·
zathura (PDF) · ristretto (images) · mpv (video) · btop (monitor) · starship
(prompt) · TLP/thermald/elogind (power).

## 25. Cheat sheet

```
LAUNCH   Super+Return terminal   Super+d launcher   Super+b browser
         Super+`  window switch  Super+e emoji      Super+Shift+e power
WINDOWS  Super+h/j/k/l focus   +Shift move   +Ctrl resize
         Super+m fullscreen    Super+space float   Super+Shift+q close
WORKSPC  Super+1..8 switch     Super+Shift+1..8 send
MODES    Super+o open-app   Super+Shift+g scripts   Super+Shift+w bookmarks
         Super+Shift+s swap Super+Shift+m notify
SYSTEM   Super+Shift+x lock    Print / Super+Print screenshot
         Super+Shift+r reload sway
SHELL    up update  xi PKG install  search X  list  bat battery  power TLP
SERVICE  sudo sv status NAME   sudo ln -s /etc/sv/NAME /var/service/
```

## 26. Credits

Dotfiles and Sway design by **bibjaw99** (grimmstation). Void port and install
tooling (xbps / runit / elogind / wofi / zsh / laptop power) adapted from it for
the Dell Latitude 5490. Keymap retuned for direct one-chord ergonomics.
