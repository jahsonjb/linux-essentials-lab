# 🐧 Linux Essentials Lab (LPI 010-160)

This project documents my hands-on practice for the **Linux Essentials (010-160)** exam objectives.  
The lab was built with **VMware Workstation/Fusion**, using both **Rocky Linux 9 (Minimal)** and **Ubuntu 24.04 LTS**.  

Most screenshots were taken in **Rocky Linux**, but I worked across both VMs to highlight the similarities and differences between Debian-based and RHEL-based systems.

---

## 🎯 Learning Objectives (mapped to 010-160)

- Linux & open source basics (distros, licensing, help systems)  
- Navigation & files (paths, wildcards, text viewing)  
- Command line power (pipes, redirection, search, editors)  
- OS & processes (boot, services, logs, hardware)  
- Security & permissions (users, groups, chmod/chown, ACLs)  
- Networking basics (IPs, routes, name resolution, firewalls)  
- Package managers (APT on Ubuntu, DNF on Rocky)  
- Scripting & automation (bash fundamentals, cron)  

---

## 🧱 Lab Topology

**VM 1: Rocky Linux 9 (Minimal)**  
- 2 vCPU, 2–4 GB RAM, 30 GB disk  
- NAT adapter (VMnet8)  
- Packages: `open-vm-tools`, `curl`, `wget`, `nano`, `less`, `man-pages`

**VM 2: Ubuntu 24.04 LTS**  
- 2 vCPU, 2–4 GB RAM, 30 GB disk  
- NAT adapter (VMnet8)  
- Packages: `open-vm-tools`, `curl`, `wget`, `nano`, `less`, `man-db`

---

## 🖼️ Screenshots

### 1. System Identity & Help
Checking kernel, distro info, and manual pages.  
Commands: `uname -a`, `/etc/os-release`, `man ls`.

![System Identity](screenshots/rocky_system_identify.png)

---

### 2. Navigation & Files
Directory navigation, hidden files, creating/moving files, and tree view.  
Commands: `pwd`, `ls -lah`, `mkdir -p`, `tree`.

![Navigation](screenshots/02_navigation.png)

---

### 3. Packages & Repos
Working with both **APT (Ubuntu)** and **DNF (Rocky)** to install, inspect, and remove packages.  
Example: `dnf info htop` (Rocky) and `apt show htop` (Ubuntu).

![Packages](screenshots/03_packages.png)

---

### 4. Users, Groups, Permissions
Creating users, assigning groups, and applying permissions/ACLs.  
Commands: `id labuser`, `chmod`, `chown`, `setfacl`.

![Permissions](screenshots/04_permissions.png)

---

### 5. Processes & Services
Monitoring and managing services with **systemd**.  
Commands: `ps aux`, `systemctl status ssh`, `journalctl -u ssh`.

![Processes](screenshots/05_processes.png)

---

### 6. Hardware & Storage
Inspecting CPU, disks, and filesystems. Creating a loopback “disk,” mounting it, and updating `/etc/fstab`.  
Commands: `lscpu`, `lsblk -f`, `df -hT`, `losetup`, `mount`.

![Storage](screenshots/06_storage.png)

---

### 7. Networking Basics
Inspecting addresses, routes, and DNS resolution. Configuring firewalls with `ufw` (Ubuntu) and `firewalld` (Rocky).  
Commands: `ip a`, `ip r`, `ping`, `host example.com`.

![Networking](screenshots/07_networking.png)

---

### 8. Bash & Cron
Writing a backup script, making it executable, and scheduling it with `cron`.  
File: `~/bin/quickbackup.sh`

![Scripting](screenshots/08_scripting.png)

---

### 9. Break/Fix Drills
- DNS misconfiguration and recovery  
- `fstab` typo detection  

![Break Fix](screenshots/09_breakfix.png)

---

## ✅ Self-Test Checklist

- Identify kernel & distro (`uname -r`, `/etc/os-release`)  
- Navigate with absolute/relative paths and wildcards  
- Install/remove packages with APT and DNF  
- Manage users, groups, and permissions (chmod, chown, ACL)  
- Inspect processes/services with `systemctl` and `journalctl`  
- Configure IPs, routes, and firewalls  
- Write/run a bash script and schedule with `cron`  
- Mount and test filesystems with `/etc/fstab`  
- Troubleshoot common break/fix scenarios (DNS, fstab)  

---

## 📚 Notes

This lab shows practical Linux skills across **two families of distributions**:  
- **Debian-based (Ubuntu)** → APT package manager  
- **RHEL-based (Rocky)** → DNF package manager  

Practicing on both clarified differences in package handling, service names, log locations, and firewall tools.

