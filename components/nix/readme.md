nix
===

Home Manager configuration that installs Hyprland with Nix on the work machine.

`components/hypr` is written in Hyprland's Lua config format and is developed on
Arch, which ships a recent Hyprland. The Hyprland packaged by the work machine's
distribution is too old to read the Lua config. This component installs the same
Hyprland version as Arch on the work machine, so `components/hypr` runs there
unchanged.

Only the `work` profile uses this component. Machines without Nix are not
affected.


Design decisions
----------------

### Scope: Hyprland and the programs it starts, nothing else

The only problem Nix solves here is the Hyprland version gap. Other components
either work across the versions that distributions ship (git, tmux, dunst), or
get harder to run when installed by Nix on a non-NixOS system: GPU applications
need extra driver setup, programs that authenticate through PAM cannot get the
setuid helper they need, and a login shell from `/nix` is lost if Nix breaks.
They stay with the system package manager. Extend the scope only when another
component hits a concrete version problem.

### Home Manager installs packages; `install.py` still makes the links

`install.py` keeps creating every symlink, including `~/.config/hypr`, so link
definitions exist in one place and machines without Nix keep working.
Home Manager does not manage any file under `components/`. Configuration edits
take effect without `home-manager switch`, just as on Arch.

### A component, not a flake at the repository root

The flake references no files outside this directory, so it fits the existing
layout where everything lives under `components/` and profiles choose what to
install. `install.py` links this directory to `~/.config/home-manager`, the
conventional Home Manager location, so the flake has the same path on every
machine regardless of where the repository is cloned. Move the flake to the
repository root if it ever needs to manage the whole repository (for example,
if Home Manager takes over the links).

### Hyprland comes from nixpkgs, not from the Hyprland flake

The Hyprland flake can pin an exact release tag, but its binaries are cached
only on Hyprland's own Cachix, which drops older builds. Pinning a tag that
is not the latest release therefore usually means compiling Hyprland on every
machine. nixpkgs builds are served from `cache.nixos.org` and keep Hyprland,
its portal backend and Mesa on one nixpkgs revision.

The cost is that the Hyprland version follows nixpkgs, which can lag behind
Arch or skip a release. The version assertion in `home.nix` (next section)
detects that.

### `hyprlandVersion` must equal the version on Arch

Arch is where `components/hypr` is written and tested, so the Hyprland version
on Arch is the reference. `home.nix` records it in `hyprlandVersion` and
asserts that nixpkgs provides exactly that version. If `nix flake update`
brings a different version, evaluation fails before anything on the machine
changes.

nixpkgs tracks `nixos-unstable` because Arch ships new Hyprland releases within
days; stable NixOS branches stay on older releases.

### GPU: `targets.genericLinux` instead of nixGL

Nix-built programs on a non-NixOS system cannot load the system's GPU drivers.
`targets.genericLinux.enable` makes Home Manager provide Nix-built Mesa at
`/run/opengl-driver`. nixGL would solve the same problem by setting
`LD_LIBRARY_PATH`, which leaks into every program started from Hyprland and
breaks system programs that then load Nix libraries. On non-NixOS systems,
`start-hyprland` refuses to start without nixGL unless `/run/opengl-driver`
exists (`start/src/helpers/Nix.cpp` in the Hyprland source).

### hyprlock stays a system package

Unlocking needs PAM and the setuid `unix_chkpwd` helper, and the Nix store
cannot contain setuid binaries, so a Nix-built hyprlock cannot verify
passwords on a non-NixOS system. hyprlock talks to Hyprland through a Wayland
protocol, so a system hyprlock works with a newer Hyprland. `hyprlock.conf`
must stay readable by the hyprlock version on the work machine.

### hypridle, hyprpaper and waybar come from Nix

`hyprland.lua` starts them, and their configs in this repository are written
against the versions on Arch. The work distribution may ship older versions
or none. Unlike hyprlock, they do not need PAM. hyprpaper renders with EGL,
which the drivers from `targets.genericLinux` provide, so the Nix versions work
without further setup.

### Screen sharing goes through Home Manager's `xdg.portal`

The portal backend, `xdg-desktop-portal-hyprland`, speaks Hyprland-specific
protocols and has to come from the same nixpkgs as Hyprland. Home Manager
installs the Nix portal frontend together with the backend and points the
frontend at them through `NIX_XDG_DESKTOP_PORTAL_DIR`. This wiring depends on
environment variables reaching D-Bus-activated services, so screen sharing is
the part most likely to break; it is one of the setup checks below.

### The username is read from the environment

Usernames differ between machines and are not kept in this repository.
`home.nix` reads `USER` and `HOME`, which Nix only allows with `--impure`.

### The session is started by a wrapper installed by hand

Display managers list sessions from `/usr/share/wayland-sessions` only, do not
expand `~` in `Exec=`, and do not run the login shell. Home Manager cannot
write outside `$HOME`, so `session/` holds a session file and a wrapper script
that are copied with sudo once. The wrapper puts `~/.nix-profile/bin` before
`/usr/bin`, because `start-hyprland` finds `Hyprland` through `PATH` and the
hypr and waybar scripts must call the Nix `hyprctl`, not the system's older
one. `zshenv` puts the Nix profile first for the same reason, so `hyprctl` in
a terminal is the Nix one too. On machines without Nix the line is a no-op.


Setup
-----

1. Install Nix (multi-user) and enable flakes
   (`experimental-features = nix-command flakes` in `/etc/nix/nix.conf`).
2. Create the links: `./install.py work`.
3. Apply the configuration. On the first run, `nix run` fetches Home Manager,
   since it is not installed yet. `--inputs-from` makes it the revision pinned
   in `flake.lock`:

   ```
   nix run --inputs-from ~/.config/home-manager home-manager -- switch --impure --flake ~/.config/home-manager#work
   ```

   After that:

   ```
   home-manager switch --impure --flake ~/.config/home-manager#work
   ```

4. Run the GPU setup command that `switch` prints (`sudo .../non-nixos-gpu-setup`).
5. Install the session:

   ```
   sudo install -m 755 components/nix/session/hyprland-nix-session /usr/local/bin/
   sudo install -m 644 components/nix/session/hyprland-nix.desktop /usr/share/wayland-sessions/
   ```

6. Log in to "Hyprland (Nix)" and confirm:
   - windows render (GPU drivers are found)
   - the display manager starts the session
   - hyprlock unlocks with the correct password
   - screen sharing works in a browser
   - key bindings that run programs work, including the scripts that call `hyprctl`

The existing awesome session remains available if any of these fail.


Updating Hyprland
-----------------

When pacman upgrades Hyprland on Arch:

1. Set `hyprlandVersion` in `home.nix` to the new version.
2. Run `nix flake update` in this directory. If the assertion fails, nixpkgs
   does not have the version yet; revert `flake.lock` and try again later.
3. Commit `home.nix` and `flake.lock`, then run `home-manager switch` on the
   work machine.
4. Log out and back in. The running Hyprland keeps using the old binary while
   `hyprctl` is already the new one, and a `hyprctl` that does not match the
   running Hyprland can fail, breaking the key bindings and waybar scripts
   that call it.
5. If `switch` reports that GPU drivers require an update, run the printed sudo
   command again.
