# 🧩 Linux Essentials (010-160) — A From-Scratch Lab I Can Reproduce

**By: Jahson Jno-Baptiste — a note to future me**

If you’re rereading this, remember the point wasn’t to “do a bunch of commands.” It was to turn **Linux fundamentals**—files, shells, packages, users, permissions, services, storage, networking, and basic scripting—into **muscle memory** across **two families** of Linux. I built the lab to bounce between **Ubuntu 24.04** (Debian lineage, `apt`) and **Rocky 10** (RHEL lineage, `dnf`), because 010-160 asks you to recognize common ground and spot family differences without guessing. I took most screenshots on **Rocky** while verifying each task on both VMs. This is the path I followed, start to finish, with the checks that kept me honest.

---

## Why two distros and two NIC stories mattered

I stood up two VMs in VMware with modest specs (2 vCPU, 7-8 GB RAM, \~40 GB disk). Ubuntu was my “Debian view,” Rocky the “RHEL view.” The decision that paid off later was treating them like cousins, not twins:

* **Service names** differ (`ssh` on Ubuntu vs `sshd` on Rocky).
* **Logs** differ (Ubuntu’s `/var/log/syslog` vs Rocky’s `/var/log/messages` + journal).
* **Package tools** differ (`apt/apt-show` vs `dnf/info`), including metadata language.
* **Networking tools** rhyme but vary in config style (Ubuntu’s **Netplan** vs Rocky’s **nmcli** usage).

Before I touched anything, I verified reality with `uname -a`, `cat /etc/os-release`, and `hostnamectl`. That tiny identity check saved me from “why isn’t ssh started” moments that were really just service-name drift.

> **Muscle memory rule #1:** verify what box you’re on, what kernel you’re on, and what init you’re under **before** changing anything.

---

## First-boot hygiene: patch, man pages, integration

Both VMs got immediate updates (`apt update && apt upgrade -y` on Ubuntu; `dnf -y upgrade` on Rocky). I installed **open-vm-tools** so copy/paste, time sync, and graceful shutdown worked. I added `man-db` / `man-pages` so help was local, and a minimal toolbelt (`curl`, `wget`, `nano`, `less`). This is boring on purpose: **security begins with patching** and **productivity begins with man pages**.

**Proof points I captured:** distro release banners (`lsb_release -a` on Ubuntu, `/etc/redhat-release` on Rocky) and the post-upgrade kernel from `uname -r`.

---

## Finding help like a grown-up (Objectives 1 & 2)

I practiced **three help paths** and when to use each:

* `man <cmd>` when I need the canonical description and options.
* `<cmd> --help` for a quick syntax jog.
* `type` / `which` when a name could be a shell builtin, alias, or a path (e.g., `type ls`).

It sounds basic, but exam questions sneak in **“how do you know what you’re calling?”**. I turned that into a reflex.

**Screenshot evidence:** `uname -a` + a `man ls` snippet.

---

## Navigating and manipulating files without fear (Objective 2)

I drilled absolute vs relative paths (`cd /etc` vs `cd -`), visibility (`ls -lah`), and **idempotent directory creation** (`mkdir -p ~/lab/a/b/c`). I made copies that preserved permissions/times (`cp -a`), renamed with `mv`, and removed recursively **intentionally** with `rm -r`.

The aha wasn’t the commands—it was remembering that **the shell expands globs** (`*.log`) **before** the command sees them, and that quotes control expansion and spacing. I reinforced this with a quick `tree -L 2 ~/lab` after a few moves so I **proved** the structure, not just hoped.

**Screenshot evidence:** `tree` view of `~/lab` and a simple find/glob example.

---

## Viewing, paging, grepping, and piping (Objective 3)

I practiced **paging logs** (`less`), **slicing** (`head`, `tail`, `-F` to follow), and **filtering** with `grep -i`. Then I chained them:

* `dmesg | grep -i usb` to scan the kernel ring for hot-plug events.
* `grep -RinE 'ERROR|WARN' /var/log 2>/dev/null | head` to triage.

Two habits stuck: **use a pager** when the output can explode, and **capture your assumptions** in a short pipeline. The exam expects you to know these primitives; the job expects you to chain them without hesitation.

**Screenshot evidence:** your piping/grep capture.

---

## Package managers: APT vs DNF (Objective 3)

Same workflow, two families:

* **Ubuntu APT:** `apt update`, `apt list --upgradable`, `apt install -y htop`, `apt show htop`, `apt remove`, `apt autoremove`.
* **Rocky DNF:** `dnf makecache`, `dnf check-update`, `dnf install -y htop`, `dnf info htop`, `dnf remove`, `dnf autoremove`.

What I internalized: **APT talks about indexes and candidates**; **DNF talks about repos and advisories**. Different vocabulary, same intent. I took side-by-side screenshots of `apt show htop` vs `dnf info htop` to cement the mental mapping.

---

## Users, groups, sudo (Objective 5)

I created a practice user on both systems (`adduser` on Ubuntu vs `useradd -m` on Rocky), then granted admin: Ubuntu’s **`sudo`** group vs Rocky’s **`wheel`**. `sudo -l` confirmed the rights. The reflex I built was **never to edit `/etc/sudoers` directly**; always use `visudo` or a drop-in under `/etc/sudoers.d/`.

**Screenshot evidence:** `id labuser` on both.

---

## Permissions and ACLs (Objective 5)

I drilled **symbolic and numeric mode** (`chmod 600` <=> `u=rw,go=`), ownership changes (`chown user:group`), **sticky bit** on shared dirs (`1777`), and **ACLs** for fine-grained exceptions:

* `setfacl -m u:labuser:r /etc/hosts` plus `getfacl` to verify.
* Default ACLs on a directory so **future** files inherit sane rules.

The win here was remembering **ACLs augment, not replace, POSIX perms**—and that “it works for me” often fails for a peer until the default ACL is set at the directory root.

**Screenshot evidence:** `getfacl /etc/hosts` and `ls -ld /srv/shared`.

---

## Processes, services, and logs (Objective 4)

I toggled muscle memories:

* **Process view:** `ps aux | head`, `pgrep -a <name>`, `top` (or `htop` when installed).
* **systemd controls:** `systemctl status ssh` (Ubuntu) / `status sshd` (Rocky), `enable --now`, restarts, and `is-enabled`.
* **Logs:** `journalctl -u ssh[ d] -n 50 --no-pager`, `journalctl -b | tail`.

The exact service name mismatch is where people usually stumble. I made “**check `systemctl status` before assuming**” a rule. That habit saved me from chasing phantom SSH problems.

**Screenshot evidence:** `systemctl status ssh` on both flavors.

---

## Hardware & storage without breaking anything (Objective 4)

I **observed before touching**: `lscpu`, `lsblk -f`, `df -hT`, and `du -h --max-depth=1 /var | sort -h`.

For hands-on, I created a **loopback disk** (safe practice): `dd` an image, `losetup` it, `mkfs.ext4`, mount under `/mnt/labdisk`, and (temporarily) add an `/etc/fstab` entry. Then I validated with `df -hT | grep labdisk` and `lsblk -f` showing the loop device. That gave me real **mkfs / mount / fstab** reps without touching real disks.

**Screenshot evidence:** `lsblk -f` with loop device and a `df -hT` extract.

> I later removed the `/etc/fstab` line and detached the loop device to avoid surprises—**cleanup is part of doing ops**.

---

## Networking & name resolution (Objectives 2 & 4)

I affirmed the basics:

* **Addresses & routes:** `ip a`, `ip r`.
* **Reachability:** `ping -c 3 1.1.1.1`, **HTTP check** with `curl -I https://example.com`.
* **Name resolution:** `getent hosts example.com` (nsswitch path), `host example.com` (direct DNS).

This is where I caught the most “gotchas”: the **default route** lives on the NAT interface; the **DNS tool** differs by family (`bind9-dnsutils` vs `bind-utils`). I noted both in the README so I stop re-Googling them.

**Screenshot evidence:** `ip a`, `ip r`, and a resolver check.

---

## Scripting & cron (Objective 3)

I wrote a **single-file backup script** with safe defaults:

* `#!/usr/bin/env bash` + `set -euo pipefail`.
* Tar `/etc` into a timestamped archive under `~/backups`.
* Printed the destination (`echo "Wrote $DEST"`) for clear evidence.

I ran it, then scheduled it with `crontab -e` (`30 2 * * * ...`). Finally, `crontab -l` and a log tail verified it ran. The point wasn’t the tarball; it was proving I can **write, run, schedule, and validate** a small automation without yak-shaving.

**Screenshot evidence:** script output + `crontab -l`.

---

## Break/Fix drills (because production won’t be kind)

I practiced two deliberate failures and clean recoveries:

1. **Bad DNS** (edit `/etc/resolv.conf` to a bogus IP), then observe `apt`/`dnf` failures and **repair** by restoring DNS via Netplan/NM or DHCP.
2. **Bad `/etc/fstab` line**, test with `mount -a` (expect error), then **remove the typo** and re-test until clean.

I intentionally **skipped the firewall-lockout drill** in this pass to keep the portfolio sequence tight; I’ve done it elsewhere and know how quickly it can derail the flow when you’re collecting screenshots.

> **Muscle memory rule #2:** make one change, validate, and don’t stack unknowns. The “tiny break” approach makes your fixes tiny too.

**Screenshot evidence:** the `mount -a` error then a clean run; DNS failure snippet then a successful `apt update`/`dnf makecache`.

---

## What I actually **learned** (beyond commands)

* **Identify first, act second.** `os-release` + `systemctl status` + `journalctl` tell you what box you’re really on and what it’s actually doing.
* **Debian vs RHEL is 80% overlap, 20% vocabulary.** `apt show` vs `dnf info`, `ssh` vs `sshd`, `syslog` vs `messages`—know the mapping, not just the commands.
* **Permissions aren’t just chmod.** ACLs and the sticky bit make shared spaces sane; default ACLs prevent “works for me” drift.
* **fstab is powerful and fragile.** Test with `mount -a` before you trust it to boot.
* **Pipes and pagers are force multipliers.** Most “how do I find X” questions become a three-stage pipeline and a `less`.

---

## Where I tripped (and why it mattered)

* I initially tailed the **wrong log file** on Rocky (went to `syslog` muscle memory). Fix: when in doubt, **journalctl -u <unit> -b** wins.
* I forgot that Ubuntu’s SSH service is **`ssh`**, not `sshd`. Fix: **stop assuming**; `systemctl list-units --type=service | grep ssh` is cheap.
* I wrote an `/etc/fstab` entry by device node the first time. I rewrote it to use **UUID**, because device enumeration can change.

Tiny slips; useful corrections.

---

## Evidence trail (what’s in `screenshots/`)

I organized screenshots in a reader-friendly order so a reviewer sees a **story**, not a dump:

* **System identity** (`rocky_system_identify`, `SYSTEM_IDENTIFY_ubuntu`, `ROCKY_RELEASE`, `UBUNTU_RELEASE`).
* **VM configs** (`rocky_vm_config`, `ubuntu_vm_config`).
* **Navigation & files** (`file_navigation`, `file_manipulation`, `tree_and_find`, `find`).
* **Text + pipes** (`man_ls`, `Piping`, `nano_and_script`, `script_output`).
* **Packages** (`package_manager`).
* **Users & groups** (`add_user`).
* **Permissions & ACLs** (`permissions_and_owners`, `ACLS`, `shared`).
* **Processes/services/logs** (`processes_services_and_logs`, `system_inspection`).
* **Storage & mounts** (`disks_and_mounts`, `fix_fstab`).
* **Networking & DNS** (`networking`, `name_resolution`).
* **Cron** (`crontab`).
* **Break/fix DNS** (`break_and_fix_dns_rocky`).

Every image ties back to a command or outcome I can reproduce.

---

## If I rerun this tomorrow (improvements I’d make)

1. **Stronger storage reps:** add a tiny **LVM-on-loopback** exercise so I practice `pvcreate/vgcreate/lvcreate` + `fstab` without touching real disks.
2. **Service health checks:** follow a unit with `systemd-analyze blame` and `journalctl -p warning -b` to establish a habit of checking **boot health**.
3. **Automation stub:** bundle a small `make lab-check` that reruns the evidence commands and writes to a dated `lab-report.txt`. That turns “I did it” into “I can prove it in 90 seconds.”

---

## The takeaway to carry

The best part of this lab wasn’t a particular command; it was the **rhythm**:

1. **Identify** the system and state.
2. **Change one thing** on purpose.
3. **Verify** immediately with a relevant command.
4. **Capture evidence** (screenshot or saved output).
5. **Clean up** anything you won’t keep.

That rhythm is exactly what 010-160 (and real ops) reward. Future me: when you feel rusty, open the repo, rebuild the two VMs, and walk this path again. The knowledge is in your head; the confidence is in the **checks**.
