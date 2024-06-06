# Ultimate Docker Server: Getting Started with OS Preparation \[Part 1\]

May 2, 2024January 18, 2024 by [Anand](https://www.smarthomebeginner.com/author/anand/ "View all posts by Anand")

This multi-part Docker Server tutorial covers everything on how to setup your home/media/web server, and more using Docker Compose. This is the way I do it.

[Facebook](https://www.smarthomebeginner.com/#facebook "Facebook")[Twitter](https://www.smarthomebeginner.com/#twitter "Twitter")[Reddit](https://www.smarthomebeginner.com/#reddit "Reddit")[LinkedIn](https://www.smarthomebeginner.com/#linkedin "LinkedIn")[Share](https://www.addtoany.com/share#url=https%3A%2F%2Fwww.smarthomebeginner.com%2Fultimate-docker-server-1-os-preparation%2F&title=Ultimate%20Docker%20Server%3A%20Getting%20Started%20with%20OS%20Preparation%20%5BPart%201%5D)

![Docker Server Tutorials 1 Os Preparation](Ultimate%20Docker%20Server%20Getting%20Started%20with%20OS%20Preparation%20[Part%201]_files/Docker-Series-01-Intro-and-OS-Prep-740x416.webp "Ultimate Docker Server: Getting Started with OS Preparation [Part 1] 1")

Many people have emailed me after reading [Docker](https://www.smarthomebeginner.com/docker-media-server-2022/) and [Traefik](https://www.smarthomebeginner.com/traefik-docker-compose-guide-2024/) guides, asking how I prep my _Docker Server_ OS before starting to build my stack. Or, what to do after setting up a Docker stack.

That got me thinking. It's time to revise my Docker and Traefik guides anyways. So why not do a full series of posts from beginning to end on how I build my Docker Stack for Home Server, Media Server, Web Server, DNS/Adblock Server, and Synology NAS.

Note that what I will cover in this series is my actual setup that I have continued to improve over 6 years, not some random tutorial based on theory.

So, I decided to put together this series:

##### Ultimate Docker Server Series:

This post is part of the Docker Server Tutorial Series, which includes the following individual chapters/parts:

1.  [Ultimate Docker Server: Getting Started with OS Preparation](https://www.smarthomebeginner.com/ultimate-docker-server-1-os-preparation/) \[[VIDEO](https://youtu.be/-ZSQdJ62r-Q)\] \[2024\]
2.  [Docker Media Server Ubuntu/Debian with 60+ Awesome Apps](https://www.smarthomebeginner.com/docker-media-server-2024/) \[[VIDEO](https://youtu.be/THuLgGwq0vg)\] \[2024\]
3.  ZeroTier [VPN](https://www.smarthomebeginner.com/go/surfshark-vpn "Surfshark") Ubuntu, Docker, Synology, Windows: Secure on-the-go access \[coming soon\]
4.  Nginx Proxy Manager Docker Compose Guide: Simplest Reverse Proxy \[coming soon\]
5.  Traefik Reverse Proxy
    - v3: [Ultimate Traefik v3 Docker Compose Guide: Best Reverse Proxy](https://www.smarthomebeginner.com/traefik-v3-docker-compose-guide-2024/) \[[VIDEO](https://youtu.be/KMZIyoZ3jWM)\] \[2024\]
    - v2: [Ultimate Traefik Docker Compose Guide: LE, SSL, Reverse Proxy](https://www.smarthomebeginner.com/traefik-docker-compose-guide-2024/) \[2024\]
6.  [Authelia Docker Compose Guide: Secure 2-Factor Authentication](https://www.smarthomebeginner.com/authelia-docker-compose-guide-2024/) \[2024\]
7.  [Google OAuth Docker Compose Guide: Multi-Factor Authentication](https://www.smarthomebeginner.com/google-oauth-traefik-forward-auth-2024/) \[2024\]
8.  [Docker Security Practices for Homelab: Secrets, Firewall, and more](https://www.smarthomebeginner.com/traefik-docker-security-best-practices/)
9.  [Cloudflare Settings for Docker Traefik Stacks](https://www.smarthomebeginner.com/cloudflare-settings-for-traefik-docker/)
10. Implementing a Backup System for Docker Traefik Stack \[coming soon\]
11. [Automate the Whole Process with Auto-Traefik Script](https://www.smarthomebeginner.com/auto-traefik/)

It is best to follow the series from the beginning so you not only understand **WHAT** to do but also **WHY** we do it.

This post covers all the basic and good-to-know information before starting the **Docker Server setup**.

Table of Contents \[[show](#)\]

- [Automating the Docker Reverse Proxy Stack Setup](#Automating_the_Docker_Reverse_Proxy_Stack_Setup)
- [My Environment](#My_Environment)
  - [My Docker Server Hosts](#My_Docker_Server_Hosts)
  - [My GitHub Repository](#My_GitHub_Repository)
  - [Using the Docker Compose from My Github Repo](#Using_the_Docker_Compose_from_My_Github_Repo)
  - [Typical Target Users](#Typical_Target_Users)
- [Choosing Right OS for Docker Server](#Choosing_Right_OS_for_Docker_Server)
- [Preparing Ubuntu/Debian for Docker Server](#Preparing_UbuntuDebian_for_Docker_Server)
  - [1\. Create a New User](#1_Create_a_New_User)
  - [2\. Update the OS](#2_Update_the_OS)
  - [3\. Secure SSH Access](#3_Secure_SSH_Access)
  - [4\. Install Basic/Required Packages](#4_Install_BasicRequired_Packages)
  - [5\. Perform Server Tweaks](#5_Perform_Server_Tweaks)
  - [6\. Enable Firewall](#6_Enable_Firewall)
- [Concluding Remarks](#Concluding_Remarks)

## Automating the Docker Reverse Proxy Stack Setup

If you have not heard of [Auto-Traefik](https://www.smarthomebeginner.com/auto-traefik/), then you should consider checking out this post or watching the video series below:

Playlist: Auto Traefik 2 - Docker, Traefik, SSL, Authelia, and more in minutes

Watch this playlist [on YouTube](https://www.youtube.com/playlist?list=PL1Hno7tIbSWViTyCXl9xNdXXU-1bVxIFD)

Auto-Traefik was launched as a perk to my supporters and to find a way to financially support what I do with this site.

**🔥 Giveaway!** [Get Auto-Traefik for FREE](https://www.smarthomebeginner.com/auto-traefik-free-2024-01/) (no limit).

With the launch of this video series, I am revising all my guides to align with what I have implemented with Auto-Traefik.

Everything that the Auto-Traefik Script does should be possible by following this series without paying for Auto-Traefik. But my hope is that you continue to support my work by becoming a member.

> **Be the 1 in 200,000. Help us sustain what we do.**
>
> 57 / 150 by Dec 31, 2024
>
> You will gain benefits such as discord roles, exclusive content, ad-free browsing, raffles, and more.
>
> [Become a Sponsor](https://www.smarthomebeginner.com/membership-account/memberships-products-services/) (starting from just $1.67/month)
>
> [Why did we start Memberships?](https://www.smarthomebeginner.com/state-of-the-site-2023/)

## My Environment

Wait why do I need to read about some random guy's environment?

You do not have to. But I publish all my "real" setup on my [Github Repo](https://github.com/htpcbeginner/docker-traefik). Since I sync all Docker related configuration files between all m Docker hosts (more on this below), it is important to differentiate them with prefixes, suffixes, folders, etc.

Therefore, to follow my guides and GitHub repo, it can be beneficial to understand my environment.

Mini Homelab Tour - I do a LOT with this Little Proxmox Server and 100+ Docker Apps

[![Mini Homelab Tour - I Do A Lot With This Little Proxmox Server And 100+ Docker Apps](https://www.smarthomebeginner.com/wp-content/plugins/wp-youtube-lyte/lyteCache.php?origThumbUrl=https%3A%2F%2Fi.ytimg.com%2Fvi%2FGfzgNJAM19o%2F0.jpg "Ultimate Docker Server: Getting Started with OS Preparation [Part 1] 2")](https://youtu.be/GfzgNJAM19o)

[Watch this video on YouTube](https://youtu.be/GfzgNJAM19o).

### My Docker Server Hosts

I have 5 docker hosts. I sync all my Docker stacks using Syncthing and push the files to GitHub so I can share with the community.

Syncing also allows me to have a backup of one system's configuration file in all the other hosts.

For this reason, where applicable, I segregate or name files/folders with their hostname (for example: **hs** for Home Server):

- **docker-compose-hs.yml:** Docker Compose for Home Server on Ubuntu Server Proxmox LXC Container.
- **docker-compose-mds.yml:** Docker Compose for Media/Database Server on Ubuntu Server Proxmox LXC Container.
- **docker-compose-dns.yml:** Docker Compose for AdBlock/ DNS Server on Raspberry Pi 4B
- **docker-compose-ws.yml:** Docker Compose for Web Server on [Digital Ocean](https://www.smarthomebeginner.com/go/digital-ocean "Digital Ocean") [VPS](https://www.smarthomebeginner.com/go/vultr "Vultr"), which powers this website.
- **docker-compose-ds918.yml:** Docker Compose for Synology DS918+ NAS.

This is the reason why even the [Auto-Traefik](https://www.smarthomebeginner.com/auto-traefik/) script creates files and folders with hostname as suffix/prefix where applicable.

You may not have to Sync or push the files out to GitHub. Therefore, you may omit the hostname (adjust wherever applicable). But eventually if you plan to go towards a multi-host setup without getting into Docker Swarm etc., then my way could help.

### My GitHub Repository

In my [GitHub Repo](https://github.com/htpcBeginner/docker-traefik), you see the current working version of my **Docker server** stacks.

[

![Anand'S Docker Traefik Github Repository](https://www.smarthomebeginner.com/images/2024/01/docker-traefik-repository-740x257.jpg "Ultimate Docker Server: Getting Started with OS Preparation [Part 1] 3")

![Anand'S Docker Traefik Github Repository](data:image/svg+xml,%3Csvg%20xmlns=%22http://www.w3.org/2000/svg%22%20viewBox=%220%200%20740%20257%22%3E%3C/svg%3E "Ultimate Docker Server: Getting Started with OS Preparation [Part 1] 3")](https://www.smarthomebeginner.com/images/2024/01/docker-traefik-repository.jpg)

Anand's Docker Traefik Github Repository

This Docker series is fully based on my GitHub repository.

My setup constantly evolves. It is nearly impossible to keep updating my guides to keep up with all the updates to my setup. But this series should give you a good foundation to implement any future Github repor changes or delayed guide-updates.

### Using the Docker Compose from My Github Repo

Even though all Docker files from my hosts are all combined and pushed to the repo, the compose files are all located in the folder called, well, **compose**.

[

![Docker Compose Yml Files](https://www.smarthomebeginner.com/images/2024/01/docker-compose-files.jpg "Ultimate Docker Server: Getting Started with OS Preparation [Part 1] 4")

![Docker Compose Yml Files](data:image/svg+xml,%3Csvg%20xmlns=%22http://www.w3.org/2000/svg%22%20viewBox=%220%200%20537%20245%22%3E%3C/svg%3E "Ultimate Docker Server: Getting Started with OS Preparation [Part 1] 4")](https://www.smarthomebeginner.com/images/2024/01/docker-compose-files.jpg)

Docker Compose Yml Files

The **archives** folder has all my old/unused Docker Compose files, the **hs** folder has all my home server Docker Compose YMLs, the **mds** folder has all my media/database server Docker Compose YMLs, and so on.

The docker compose examples can be copy-pasted as-is from one file to another, in most cases. In fact, you might even find the same the same service on multiple hosts (e.g. Traefik, Socket Proxy, Portainer, etc.).

### Typical Target Users

If you are reading this, there is a high chance that you are trying to setup your Home Media Server.

A Home Media Server is a server located in your home network that acts as a central data storage and serving device. It is a key part of most "homelabs".

Typically, a home server is always on, has tons of storage capacity and ready to serve files (including media) when the need arises. We have covered several home server topics in great detail in the past. If you do not yet have a home server or are considering building one, then read this summary on the [most common NAS or Home Server uses](https://www.smarthomebeginner.com/nas-home-server-uses/).

[

![My Topton V700 Minipc From Aliexpress - Proxmox Server](https://www.smarthomebeginner.com/images/2024/02/topton-v700-mini-pc-740x296.jpg "Ultimate Docker Server: Getting Started with OS Preparation [Part 1] 5")

![My Topton V700 Minipc From Aliexpress - Proxmox Server](data:image/svg+xml,%3Csvg%20xmlns=%22http://www.w3.org/2000/svg%22%20viewBox=%220%200%20740%20296%22%3E%3C/svg%3E "Ultimate Docker Server: Getting Started with OS Preparation [Part 1] 5")](https://www.smarthomebeginner.com/go/ae-toptonv700)

[Topton V700 Minipc From Aliexpress - $481](https://www.smarthomebeginner.com/Go/Ae-Toptonv700) - Proxmox Server

If you are ordering from AliExpress, remember 3 things: 1) Check with the seller if the item is in stock first, 2) Pick only sellers with a very high rating (>95% at least), and 3) Be prepared for delays/extended delivery times (in my case the seller asked for extra shipping time due to availability).

In my case, my Proxmox Server runs my Home Server, Media/Database Server, and AdBlock/DNS Server as Ubuntu 22.04 LXC Containers. I recently upgraded to the [TopTon V700 Mini PC](https://www.smarthomebeginner.com/go/ae-toptonv700) as Proxmox Host (for just $481, tax included) and it's been killing it:

- [TopTon V700 Mini PC with Intel 13th Gen "Raptor Lake" i7-13800H](https://www.smarthomebeginner.com/go/ae-toptonv700) - $481
- 2x32GB [Crucial DDR5 4800MHz SO-DIMM RAM](https://www.amazon.com/dp/B09S2QLBWC/?tag=shbeg-20) - $163
- 2x2TB [Crucial T500 PCIe Gen4 M.2 NVME Drives](https://www.amazon.com/Crucial-Internal-Gaming-Desktop-Compatible/dp/B0CK2TC9XQ/?tag=shbeg-20) in ZFS RAID - $230
- 4TB [Crucial MX500 SATA III SSD](https://www.amazon.com/Crucial-MX500-NAND-Internal-560MB/dp/B09FRRWVWX/?tag=shbeg-20) for non-critical data, cache, etc. - $200

The principles discussed in this Docker Server series also apply to the setup of any Docker Stack, including web servers. For simplicity, I will generically refer to them as "**Docker Server**". \[**Read:** [5 Best Mini PC for Proxmox Home Server \[2024\]](https://www.smarthomebeginner.com/best-mini-pc-for-proxmox-2024/)\]

## Choosing Right OS for Docker Server

Let's start with choosing the best operating system for your Docker stack. We have a separate article that discusses all the [best home server OS option](https://www.smarthomebeginner.com/best-home-server-os-2023/)s available for you.

In my opinion, Ubuntu Server (or Debian Server) is the best one to choose if you like building things from scratch and learning along the way. Maybe I am biased due to my 14 years of experience with Ubuntu, but it won't be a wrong choice.

An even more ideal setup is to run a Type 1 hypervisor and virtualize your Docker server in a container or virtual machine. \[**Read:** [Proxmox vs ESXi: 9 Compelling reasons why my choice was clear](https://www.smarthomebeginner.com/proxmox-vs-esxi/)\]

[

![Proxmox Web Interface](https://www.smarthomebeginner.com/images/2024/01/proxmox-web-interface-1-740x380.jpg "Ultimate Docker Server: Getting Started with OS Preparation [Part 1] 6")

![Proxmox Web Interface](data:image/svg+xml,%3Csvg%20xmlns=%22http://www.w3.org/2000/svg%22%20viewBox=%220%200%20740%20380%22%3E%3C/svg%3E "Ultimate Docker Server: Getting Started with OS Preparation [Part 1] 6")](https://www.smarthomebeginner.com/images/2024/01/proxmox-web-interface-1.jpg)

Proxmox Web Interface

With VMware free version and perpetual licenses going away, this is the best time to make the switch Proxmox VE.

Having said that, the docker compose examples in this guide will also work on Network Attached Storage devices such as Synology or QNAP:

- [Ultimate Synology NAS Docker Compose Media Server](https://www.smarthomebeginner.com/synology-nas-docker-media-server-2022/)
- [Ultimate QNAP Docker Compose and Container Station Guide](https://www.smarthomebeginner.com/qnap-docker-compose-guide-2023/)

## Preparing Ubuntu/Debian for Docker Server

At this point, I will assume that you have a freshly installed Ubuntu/Debian operating system with nothing done after.

Docker on Proxmox LXC 🚀 Zero Bloat and Pure Performance!

[![Docker On Proxmox Lxc 🚀 Zero Bloat And Pure Performance!](https://www.smarthomebeginner.com/wp-content/plugins/wp-youtube-lyte/lyteCache.php?origThumbUrl=https%3A%2F%2Fi.ytimg.com%2Fvi%2F-ZSQdJ62r-Q%2F0.jpg "Ultimate Docker Server: Getting Started with OS Preparation [Part 1] 7")](https://youtu.be/-ZSQdJ62r-Q)

[Watch this video on YouTube](https://youtu.be/-ZSQdJ62r-Q).

### 1\. Create a New User

Some operating systems allow the creation of a non-root user during installation and some do not. If you did not create a primary user during setup, use the following commands to create it:

1

2

`sudo` `adduser anand`

`sudo` `adduser anand` `sudo`

With the first command, we are adding a new user called "anand". The second command I am adding "anand" to the "sudo" group, so I have the privilege to use **sudo** command.

### 2\. Update the OS

Most fresh OS installations lack all the security and package updates. So, let's take care of that next.

Run the following commands to refresh the packages list and install any updates.

1

2

`sudo` `apt update`

`sudo` `apt upgrade`

### 3\. Secure SSH Access

Until this point, you are probably physically in front of the server or a web-based console offered by the host/provider (e.g. Proxmox or [VPS](https://www.smarthomebeginner.com/go/vultr "Vultr") provider such as [Digital Ocean](https://www.smarthomebeginner.com/go/digital-ocean "Digital Ocean")).

Let's enable SSH access. Edit **/etc/ssh/sshd_config** using the following command:

1

`nano` `/etc/ssh/sshd_config`

Find the port line, uncomment it by removing the # in front (if it has one) and change the port number from default 22 to something random (e.g. 2053).

1

`port 2053`

Restart SSH server using the following command:

1

`sudo` `systemctl restart sshd`

Note that changing port number is the absolute minimum if you are going to open the SSH port to the internet. Using key-based authentication instead of passwords, specifying the allowed users list, disabling password authentication, etc. are strongly urged - not discussed in this series.

In addition, an intrusion prevention system such as CrowdSec + Host Firewall Bouncer is also recommended (you may do this using our CrowdSec Docker guides, after completing this series).

> ##### **How-To Series:** Crowd Security Intrusion Prevention System
>
> 1.  [Crowdsec Docker Compose Guide Part 1: Powerful IPS with Firewall Bouncer](https://www.smarthomebeginner.com/crowdsec-docker-compose-1-fw-bouncer/)
> 2.  [CrowdSec Docker Part 2: Improved IPS with Cloudflare Bouncer](https://www.smarthomebeginner.com/crowdsec-cloudflare-bouncer/)
> 3.  [CrowdSec Docker Part 3: Traefik Bouncer for Additional Security](https://www.smarthomebeginner.com/crowdsec-traefik-bouncer/)
> 4.  [CrowdSec Multiserver Docker (Part 4): For Ultimate Protection](https://www.smarthomebeginner.com/crowdsec-multiserver-docker/)

### 4\. Install Basic/Required Packages

At this point, you may SSH into your server and continue remotely if you prefer. Let's install some basic/required packages (based on my experience).

1

`sudo` `apt` `install` `ca-certificates curl gnupg lsb-release ntp htop zip unzip gnupg apt-transport-https ca-certificates net-tools ncdu apache2-utils`

**zip** and **unzip** are for compression, **net-tools** is to check port usage and availability, **htop** provides a nice UI to see running processes, and **ncdu** helps visualize disk space usage.

### 5\. Perform Server Tweaks

A few final system configuration tweaks to enhance the performance and handling of large list of files (e.g. Plex/Jellyfin metadata). Edit **/etc/sysctl.conf** using the following command:

1

`sudo` `nano` ` /etc/sysctl``.conf `

Add the following 3 lines at the end of the file:

1

2

3

`vm.swappiness=10`

`vm.vfs_cache_pressure = 50`

`fs.inotify.max_user_watches=262144`

Save and exit by pressing **Ctrl X**, **Y**, and **Enter**. That is all the prep work I do before I start building my **Docker server stack**.

### 6\. Enable Firewall

Ubuntu/Debian systems come with a built-in firewall called UFW (Universal Firewall). It is disabled by default.

Let's start by adding some default policies (deny all incoming and allow all outgoing) and then allow incoming connections only from your local network (e.g. 192.168.1.0/24). Customize the network subnet based on your situation.

1

2

3

`sudo` `ufw default deny incoming`

`sudo` `ufw default allow outgoing`

`sudo` ` ufw allow from 192.168.1.0``/24 `

This will allow all connections from devices in the IP range 192.168.1.1 to 192.168.1.254.

This is a good starting point. But as we go through this series, we will keep modifying these firewall rules.

Then let's activate UFW using the command:

1

`sudo` `ufw` `enable`

Finally check the status of UFW using **sudo ufw status**, you should see that it is active with the rule we added above:

[

![Ufw Allow Local Network](https://www.smarthomebeginner.com/images/2024/02/ufw-rules-for-local-network.jpg "Ultimate Docker Server: Getting Started with OS Preparation [Part 1] 8")

![Ufw Allow Local Network](data:image/svg+xml,%3Csvg%20xmlns=%22http://www.w3.org/2000/svg%22%20viewBox=%220%200%20672%20164%22%3E%3C/svg%3E "Ultimate Docker Server: Getting Started with OS Preparation [Part 1] 8")](https://www.smarthomebeginner.com/images/2024/02/ufw-rules-for-local-network.jpg)

Ufw Allow Local Network

## Concluding Remarks

If you have decided to follow this series and do things the way I do it, great. **Keep in mind that my way is not the only way or even the best way.**

But in the last 5 years or so of hosting my Docker Traefik repository (2.4k stars until Jan 2024) and the guides, I have yet to receive feedback saying my way sucks. So, I feel quite confident that it will meet most typical user's needs.

In addition, this website itself runs on the Docker web server stack in a production server on Digital Ocean. It has been performing well in handling the load and keeping everything secure.

If you do other things on your OS before getting started, be sure to share with the rest of us in the comments below.

That said, there may be other better ways to accomplish the same thing. Feel free to share them in the comments. With this series, I hope to teach my readers how they can replicate my Docker server stacks. So, let's begin the ride.

[Facebook](https://www.smarthomebeginner.com/#facebook "Facebook")[Twitter](https://www.smarthomebeginner.com/#twitter "Twitter")[Reddit](https://www.smarthomebeginner.com/#reddit "Reddit")[LinkedIn](https://www.smarthomebeginner.com/#linkedin "LinkedIn")[Share](https://www.addtoany.com/share#url=https%3A%2F%2Fwww.smarthomebeginner.com%2Fultimate-docker-server-1-os-preparation%2F&title=Ultimate%20Docker%20Server%3A%20Getting%20Started%20with%20OS%20Preparation%20%5BPart%201%5D)

### Related Posts:

- [

  ![Redis Docker Compose](https://www.smarthomebeginner.com/images/2022/05/redis-docker-compose-ft-1.jpg "Redis Docker Compose Install: With 2 SAVVY Use Cases")

  ![Redis Docker Compose](data:image/svg+xml,%3Csvg%20xmlns=%22http://www.w3.org/2000/svg%22%20viewBox=%220%200%201100%20628%22%3E%3C/svg%3E "Redis Docker Compose Install: With 2 SAVVY Use Cases")

  Redis Docker Compose Install: With 2 SAVVY Use Cases](https://www.smarthomebeginner.com/redis-docker-compose-example/)

- [

  ![CrowdSec Traefik Bouncer](https://www.smarthomebeginner.com/images/2022/11/crowdsec-traefik-bouncer.jpg "CrowdSec Docker Part 3: Traefik Bouncer for Additional Security")

  ![CrowdSec Traefik Bouncer](data:image/svg+xml,%3Csvg%20xmlns=%22http://www.w3.org/2000/svg%22%20viewBox=%220%200%20862%20513%22%3E%3C/svg%3E "CrowdSec Docker Part 3: Traefik Bouncer for Additional Security")

  CrowdSec Docker Part 3: Traefik Bouncer for…](https://www.smarthomebeginner.com/crowdsec-traefik-bouncer/)

- [

  ![Proxmox Web Interface Traefik](https://www.smarthomebeginner.com/images/2023/12/proxmox-web-interface-traefik.jpg "How to put Proxmox Web Interface Behind Traefik?")

  ![Proxmox Web Interface Traefik](data:image/svg+xml,%3Csvg%20xmlns=%22http://www.w3.org/2000/svg%22%20viewBox=%220%200%201373%20752%22%3E%3C/svg%3E "How to put Proxmox Web Interface Behind Traefik?")

  How to put Proxmox Web Interface Behind Traefik?](https://www.smarthomebeginner.com/proxmox-web-interface-behind-traefik/)

- [

  ![Traefik Multiple Hosts on Single Gateway Router](https://www.smarthomebeginner.com/images/2023/07/Traefik-Multiple-Hosts-but-Single-Gateway-Router.png "Multiple Traefik Instances on Different Domains/Hosts and One External IP")

  ![Traefik Multiple Hosts on Single Gateway Router](data:image/svg+xml,%3Csvg%20xmlns=%22http://www.w3.org/2000/svg%22%20viewBox=%220%200%201280%20720%22%3E%3C/svg%3E "Multiple Traefik Instances on Different Domains/Hosts and One External IP")

  Multiple Traefik Instances on Different…](https://www.smarthomebeginner.com/multiple-traefik-instances/)

- [

  ![InfluxDB Docker Compose](https://www.smarthomebeginner.com/images/2023/04/influxdb-docker-compose-ft.jpg "InfluxDB Docker Compose: An efficient timeseries DB for Metrics")

  ![InfluxDB Docker Compose](data:image/svg+xml,%3Csvg%20xmlns=%22http://www.w3.org/2000/svg%22%20viewBox=%220%200%201951%201059%22%3E%3C/svg%3E "InfluxDB Docker Compose: An efficient timeseries DB for Metrics")

  InfluxDB Docker Compose: An efficient timeseries DB…](https://www.smarthomebeginner.com/influxdb-docker-compose-guide/)

- [

  ![Auto Traefik](https://www.smarthomebeginner.com/images/2023/09/auto-traefik-by-smarthomebeginner.jpg "Auto-Traefik: Dead Simple Traefik Reverse Proxy Automator for Docker")

  ![Auto Traefik](data:image/svg+xml,%3Csvg%20xmlns=%22http://www.w3.org/2000/svg%22%20viewBox=%220%200%201271%20715%22%3E%3C/svg%3E "Auto-Traefik: Dead Simple Traefik Reverse Proxy Automator for Docker")

  Auto-Traefik: Dead Simple Traefik Reverse Proxy…](https://www.smarthomebeginner.com/auto-traefik/)

> **Be the 1 in 200,000. Help us sustain what we do.**
>
> 57 / 150 by Dec 31, 2024
>
> [Join Us](https://www.smarthomebeginner.com/membership-account/memberships-products-services/) (starting from just $1.67/month)
>
> [Why did we start Memberships?](https://www.smarthomebeginner.com/state-of-the-site-2023/)

Categories [Home Server](https://www.smarthomebeginner.com/home-server/) Tags [docker](https://www.smarthomebeginner.com/tag/docker/), [proxmox](https://www.smarthomebeginner.com/tag/proxmox/), [ubuntu](https://www.smarthomebeginner.com/tag/ubuntu/)

[How to put Proxmox Web Interface Behind Traefik?](https://www.smarthomebeginner.com/proxmox-web-interface-behind-traefik/)

[Ultimate Docker Media Server: With 60+ Docker Compose Apps \[2024\]](https://www.smarthomebeginner.com/docker-media-server-2024/)

![](https://secure.gravatar.com/avatar/5038190c1ce8da93329cc44d5b592149?s=100&d=monsterid&r=pg)

![](data:image/svg+xml,%3Csvg%20xmlns=%22http://www.w3.org/2000/svg%22%20viewBox=%220%200%20100%20100%22%3E%3C/svg%3E)

### Anand

Anand is a self-learned computer enthusiast, hopeless tinkerer (if it ain't broke, fix it), a part-time blogger, and a Scientist during the day. He has been blogging since 2010 on Linux, Ubuntu, Home/Media/File Servers, Smart Home Automation, and related HOW-TOs.

Load Comments

[Facebook](https://www.smarthomebeginner.com/#facebook)[Twitter](https://www.smarthomebeginner.com/#twitter)[Reddit](https://www.smarthomebeginner.com/#reddit)[LinkedIn](https://www.smarthomebeginner.com/#linkedin)[Share](https://www.addtoany.com/share#url=https%3A%2F%2Fwww.smarthomebeginner.com%2Fultimate-docker-server-1-os-preparation%2F&title=Ultimate%20Docker%20Server%3A%20Getting%20Started%20with%20OS%20Preparation%20%5BPart%201%5D%20%7C%20SHB)

[![](https://www.smarthomebeginner.com/wp-content/plugins/wp-youtube-lyte/lyteCache.php?origThumbUrl=https%3A%2F%2Fimg.youtube.com%2Fvi%2FKMZIyoZ3jWM%2Fhqdefault.jpg)](https://youtu.be/KMZIyoZ3jWM)

Master Traefik 3 in 60 min: Best Docker Reverse Proxy

> **Be the 1 in 200,000. Help us sustain what we do.**
>
> 57 / 150 by Dec 31, 2024
>
> [Join Us](https://www.smarthomebeginner.com/membership-account/memberships-products-services/)
>
> [Why did we start Memberships?](https://www.smarthomebeginner.com/state-of-the-site-2023/)

[Twitter](https://twitter.com/anandslab) [Facebook](https://www.facebook.com/anandslab) [Instagram](https://www.instagram.com/smarthomebeginr) [LinkedIn](https://www.linkedin.com/company/anandslab) [YouTube](https://www.youtube.com/@anandslab) [GitHub](https://github.com/htpcbeginner) [Feed](https://www.smarthomebeginner.com/feed/) Subscribe

[

![SmartHomeBeginner Discord Community](https://www.smarthomebeginner.com/images/2022/05/join-discord-300x75.png "SmartHomeBeginner Discord Community")

![SmartHomeBeginner Discord Community](Ultimate%20Docker%20Server%20Getting%20Started%20with%20OS%20Preparation%20[Part%201]_files/join-discord-300x75.webp "SmartHomeBeginner Discord Community")](https://www.smarthomebeginner.com/discord/)

## Recent Posts

- [

  ![Bash Aliases For Docker](https://www.smarthomebeginner.com/images/2024/05/bash-aliases-for-Docker-150x84.webp "Simplify Docker, Docker Compose, and Linux Commands with Bash Aliases 9")

  ![Bash Aliases For Docker](Ultimate%20Docker%20Server%20Getting%20Started%20with%20OS%20Preparation%20[Part%201]_files/bash-aliases-for-Docker-150x84.webp "Simplify Docker, Docker Compose, and Linux Commands with Bash Aliases 9")](https://www.smarthomebeginner.com/bash-aliases-for-docker-and-linux/)

  [Simplify Docker, Docker Compose, and Linux Commands with Bash Aliases](https://www.smarthomebeginner.com/bash-aliases-for-docker-and-linux/)

- [

  ![Traefik V3 Docker Compose](https://www.smarthomebeginner.com/images/2024/05/Docker-Series-05-Traefik-v3-150x84.png "Ultimate Traefik v3 Docker Compose Guide [2024]: LE, SSL, Reverse Proxy 10")

  ![Traefik V3 Docker Compose](Ultimate%20Docker%20Server%20Getting%20Started%20with%20OS%20Preparation%20[Part%201]_files/Docker-Series-05-Traefik-v3-150x84.webp "Ultimate Traefik v3 Docker Compose Guide [2024]: LE, SSL, Reverse Proxy 10")](https://www.smarthomebeginner.com/traefik-v3-docker-compose-guide-2024/)

  [Ultimate Traefik v3 Docker Compose Guide \[2024\]: LE, SSL, Reverse Proxy](https://www.smarthomebeginner.com/traefik-v3-docker-compose-guide-2024/)

- [

  ![Best Mini Pc For Proxmox](https://www.smarthomebeginner.com/images/2024/04/Best-Mini-PC-for-Proxmox-150x84.png "5 Best Mini PC for Proxmox Home Server [2024] 11")

  ![Best Mini Pc For Proxmox](Ultimate%20Docker%20Server%20Getting%20Started%20with%20OS%20Preparation%20[Part%201]_files/Best-Mini-PC-for-Proxmox-150x84.webp "5 Best Mini PC for Proxmox Home Server [2024] 11")](https://www.smarthomebeginner.com/best-mini-pc-for-proxmox-2024/)

  [5 Best Mini PC for Proxmox Home Server \[2024\]](https://www.smarthomebeginner.com/best-mini-pc-for-proxmox-2024/)

- [

  ![Google Oauth](https://www.smarthomebeginner.com/images/2024/04/Docker-Series-07-Google-OAuth-150x84.png "Google OAuth Traefik Forward Auth [2024]: Most Convenient MFA 12")

  ![Google Oauth](Ultimate%20Docker%20Server%20Getting%20Started%20with%20OS%20Preparation%20[Part%201]_files/Docker-Series-07-Google-OAuth-150x84.webp "Google OAuth Traefik Forward Auth [2024]: Most Convenient MFA 12")](https://www.smarthomebeginner.com/google-oauth-traefik-forward-auth-2024/)

  [Google OAuth Traefik Forward Auth \[2024\]: Most Convenient MFA](https://www.smarthomebeginner.com/google-oauth-traefik-forward-auth-2024/)

- [

  ![Vaultwarden Docker Compose](https://www.smarthomebeginner.com/images/2023/12/vaultwarden-install-header-1-150x84.webp "Vaultwarden Docker Compose + Detailed Configuration Guide 13")

  ![Vaultwarden Docker Compose](Ultimate%20Docker%20Server%20Getting%20Started%20with%20OS%20Preparation%20[Part%201]_files/vaultwarden-install-header-1-150x84.webp "Vaultwarden Docker Compose + Detailed Configuration Guide 13")](https://www.smarthomebeginner.com/vaultwarden-docker-compose-guide/)

  [Vaultwarden Docker Compose + Detailed Configuration Guide](https://www.smarthomebeginner.com/vaultwarden-docker-compose-guide/)

[Post Archives](https://www.smarthomebeginner.com/archives/)

## Disclaimers and Disclosures

All information on smarthomebeginner.com is for informational purposes only. No media or entertainment content is hosted on this site. Visitors are solely responsible for abiding by any pertinent local or international laws. Our authors and editors will often recommend products we believe to be useful for our readers. We may receive an affiliate commission from product sales generated through these affiliate links from third-parties, including Amazon. By proceeding you acknowledge that you have read and understood our full [disclaimer](https://www.smarthomebeginner.com/about/disclaimer/).

- [About Us](https://www.smarthomebeginner.com/about/)
- [Advertise Here](https://sales.mediavine.com/smart-home-beginner)
- [Disclaimer](https://www.smarthomebeginner.com/about/disclaimer/)
- [Privacy Policy](https://www.smarthomebeginner.com/about/privacy-policy/)
- [Comments Policy](https://www.smarthomebeginner.com/about/comments-policy/)
- [Sitemap](https://www.smarthomebeginner.com/sitemap_index.xml)
- [Contact Us](https://www.smarthomebeginner.com/contact/)

Copyright © 2024 HTPCBEGINNER LLC. All Rights Reserved · No reproduction without permission

!function(){"use strict";if("querySelector"in document&&"addEventListener"in window){var e=document.body;e.addEventListener("mousedown",function(){e.classList.add("using-mouse")}),e.addEventListener("keydown",function(){e.classList.remove("using-mouse")})}}();

.lazyload{display:none;}

window.lazySizesConfig=window.lazySizesConfig||{};window.lazySizesConfig.loadMode=1;var bU="https://www.smarthomebeginner.com/wp-content/plugins/wp-youtube-lyte/lyte/";var mOs=null;style = document.createElement("style");style.type = "text/css";rules = document.createTextNode(".lyte-wrapper-audio div, .lyte-wrapper div {margin:0px; overflow:hidden;} .lyte,.lyMe{position:relative;padding-bottom:56.25%;height:0;overflow:hidden;background-color:#777;} .fourthree .lyMe, .fourthree .lyte {padding-bottom:75%;} .lidget{margin-bottom:5px;} .lidget .lyte, .widget .lyMe {padding-bottom:0!important;height:100%!important;} .lyte-wrapper-audio .lyte{height:38px!important;overflow:hidden;padding:0!important} .lyMe iframe, .lyte iframe,.lyte .pL{position:absolute !important;top:0;left:0;width:100%;height:100%!important;background:no-repeat scroll center #000;background-size:cover;cursor:pointer} .tC{left:0;position:absolute;top:0;width:100%} .tC{background-image:linear-gradient(to bottom,rgba(0,0,0,0.6),rgba(0,0,0,0))} .tT{color:#FFF;font-family:Roboto,sans-serif;font-size:16px;height:auto;text-align:left;padding:5px 10px 50px 10px} .play{background:no-repeat scroll 0 0 transparent;width:88px;height:63px;position:absolute;left:43%;left:calc(50% - 44px);left:-webkit-calc(50% - 44px);top:38%;top:calc(50% - 31px);top:-webkit-calc(50% - 31px);} .widget .play {top:30%;top:calc(45% - 31px);top:-webkit-calc(45% - 31px);transform:scale(0.6);-webkit-transform:scale(0.6);-ms-transform:scale(0.6);} .lyte:hover .play{background-position:0 -65px;} .lyte-audio .pL{max-height:38px!important} .lyte-audio iframe{height:438px!important} .lyte .ctrl{background:repeat scroll 0 -220px rgba(0,0,0,0.3);width:100%;height:40px;bottom:0px;left:0;position:absolute;} .lyte-wrapper .ctrl{display:none}.Lctrl{background:no-repeat scroll 0 -137px transparent;width:158px;height:40px;bottom:0;left:0;position:absolute} .Rctrl{background:no-repeat scroll -42px -179px transparent;width:117px;height:40px;bottom:0;right:0;position:absolute;padding-right:10px;}.lyte-audio .play{display:none}.lyte-audio .ctrl{background-color:rgba(0,0,0,1)}.lyte .hidden{display:none}");if(style.styleSheet) { style.styleSheet.cssText = rules.nodeValue;} else {style.appendChild(rules);}document.getElementsByTagName("head")\[0\].appendChild(style); (function(){ var corecss = document.createElement('link'); var themecss = document.createElement('link'); var corecssurl = "https://www.smarthomebeginner.com/wp-content/plugins/syntaxhighlighter/syntaxhighlighter3/styles/shCore.css?ver=3.0.9b"; if ( corecss.setAttribute ) { corecss.setAttribute( "rel", "stylesheet" ); corecss.setAttribute( "type", "text/css" ); corecss.setAttribute( "href", corecssurl ); } else { corecss.rel = "stylesheet"; corecss.href = corecssurl; } document.head.appendChild( corecss ); var themecssurl = "https://www.smarthomebeginner.com/wp-content/plugins/syntaxhighlighter/syntaxhighlighter3/styles/shThemeDefault.css?ver=3.0.9b"; if ( themecss.setAttribute ) { themecss.setAttribute( "rel", "stylesheet" ); themecss.setAttribute( "type", "text/css" ); themecss.setAttribute( "href", themecssurl ); } else { themecss.rel = "stylesheet"; themecss.href = themecssurl; } document.head.appendChild( themecss ); })(); SyntaxHighlighter.config.strings.expandSource = '+ expand source'; SyntaxHighlighter.config.strings.help = '?'; SyntaxHighlighter.config.strings.alert = 'SyntaxHighlighter\\n\\n'; SyntaxHighlighter.config.strings.noBrush = 'Can\\'t find brush for: '; SyntaxHighlighter.config.strings.brushNotHtmlScript = 'Brush wasn\\'t configured for html-script option: '; SyntaxHighlighter.defaults\['pad-line-numbers'\] = false; SyntaxHighlighter.defaults\['toolbar'\] = false; SyntaxHighlighter.all(); // Infinite scroll support if ( typeof( jQuery ) !== 'undefined' ) { jQuery( function( $ ) { $( document.body ).on( 'post-load', function() { SyntaxHighlighter.highlight(); } ); } ); } div#toc\_container {width: 100%;}div#toc\_container ul li {font-size: 90%;} var fpframework\_countdown\_widget = {"AND":"and"}; var countVars = {"disqusShortname":"htpcbeginner"}; var embedVars = {"disqusConfig":{"integration":"wordpress 3.0.23"},"disqusIdentifier":"50278 https:\\/\\/www.smarthomebeginner.com\\/?p=50278","disqusShortname":"htpcbeginner","disqusTitle":"Ultimate Docker Server: Getting Started with OS Preparation \[Part 1\]","disqusUrl":"https:\\/\\/www.smarthomebeginner.com\\/ultimate-docker-server-1-os-preparation\\/","postId":"50278"}; var dclCustomVars = {"dcl\_progress\_text":"Loading..."}; var pollsL10n = {"ajax\_url":"https:\\/\\/www.smarthomebeginner.com\\/wp-admin\\/admin-ajax.php","text\_wait":"Your last request is still being processed. Please wait a while ...","text\_valid":"Please choose a valid poll answer.","text\_multiple":"Maximum number of choices allowed: ","show\_loading":"1","show\_fading":"1"}; var generatepressMenu = {"toggleOpenedSubMenus":"1","openSubMenuLabel":"Open Sub-Menu","closeSubMenuLabel":"Close Sub-Menu"}; var generatepressNavSearch = {"open":"Open Search Bar","close":"Close Search Bar"}; var BestAzon\_Configuration = {"Conf\_Subsc\_Model":"2","Amzn\_AfiliateID\_US":"shbeg-20","Amzn\_AfiliateID\_CA":"shbeg09-20","Amzn\_AfiliateID\_GB":"htpcbeg-21","Amzn\_AfiliateID\_DE":"htpcbeg08-21","Amzn\_AfiliateID\_FR":"htpcbeg02-21","Amzn\_AfiliateID\_ES":"htpcbeg0a-21","Amzn\_AfiliateID\_IT":"linuxp03-21","Amzn\_AfiliateID\_JP":"","Amzn\_AfiliateID\_IN":"htpcbeg0f-21","Amzn\_AfiliateID\_CN":"","Amzn\_AfiliateID\_MX":"","Amzn\_AfiliateID\_BR":"","Amzn\_AfiliateID\_AU":"shbeg05-22","Conf\_Custom\_Class":" BestAzon\_Amazon\_Link ","Conf\_New\_Window":"1","Conf\_Link\_Follow":"1","Conf\_Product\_Link":"1","Conf\_Tracking":"2","Conf\_Footer":"2","Conf\_Link\_Keywords":"\\/go\\/","Conf\_Hide\_Redirect\_Link":"1","Conf\_Honor\_Existing\_Tag":"1","Conf\_No\_Aff\_Country\_Redirect":"1","Conf\_GA\_Tracking":"2","Conf\_GA\_ID":"","Conf\_Source":"Wordpress-52"}; var tocplus = {"visibility\_show":"show","visibility\_hide":"hide","visibility\_hide\_by\_default":"1","width":"100%"}; if ( !!window.jQuery ) {(function($){$(document).ready(function(){if ( !!window.SLB && SLB.has\_child('View.init') ) { SLB.View.init({"ui\_autofit":true,"ui\_animate":false,"slideshow\_autostart":false,"slideshow\_duration":"6","group\_loop":true,"ui\_overlay\_opacity":"0.8","ui\_title\_default":false,"theme\_default":"slb\_black","ui\_labels":{"loading":"Loading","close":"Close","nav\_next":"Next","nav\_prev":"Previous","slideshow\_start":"Start slideshow","slideshow\_stop":"Stop slideshow","group\_status":"Item %current% of %total%"}}); } if ( !!window.SLB && SLB.has\_child('View.assets') ) { {$.extend(SLB.View.assets, {"1177629734":{"id":50283,"type":"image","internal":true,"source":"https:\\/\\/www.smarthomebeginner.com\\/images\\/2024\\/01\\/docker-traefik-repository.jpg","title":"docker traefik repository","caption":"Anand's Docker Traefik Github Repository","description":""},"1803886743":{"id":50286,"type":"image","internal":true,"source":"https:\\/\\/www.smarthomebeginner.com\\/images\\/2024\\/01\\/docker-compose-files.jpg","title":"docker compose files","caption":"Docker Compose YML files","description":""},"1621082844":{"id":50298,"type":"image","internal":true,"source":"https:\\/\\/www.smarthomebeginner.com\\/images\\/2024\\/01\\/proxmox-web-interface-1.jpg","title":"proxmox web interface","caption":"Proxmox Web Interface","description":""},"1679750895":{"id":50366,"type":"image","internal":true,"source":"https:\\/\\/www.smarthomebeginner.com\\/images\\/2024\\/02\\/ufw-rules-for-local-network.jpg","title":"ufw rules for local network","caption":"UFW Allow Local Network","description":""}});} } /\* THM \*/ if ( !!window.SLB && SLB.has_child('View.extend_theme') ) { SLB.View.extend_theme('slb_baseline',{"name":"Baseline","parent":"","styles":\[{"handle":"base","uri":"https:\\/\\/www.smarthomebeginner.com\\/wp-content\\/plugins\\/simple-lightbox\\/themes\\/baseline\\/css\\/style.css","deps":\[\]}\],"layout\_raw":"<div class=\\"slb_container\\"><div class=\\"slb_content\\">{{item.content}}<div class=\\"slb_nav\\"><span class=\\"slb_prev\\">{{ui.nav\_prev}}<\\/span><span class=\\"slb_next\\">{{ui.nav\_next}}<\\/span><\\/div><div class=\\"slb_controls\\"><span class=\\"slb_close\\">{{ui.close}}<\\/span><span class=\\"slb_slideshow\\">{{ui.slideshow\_control}}<\\/span><\\/div><div class=\\"slb_loading\\">{{ui.loading}}<\\/div><\\/div><div class=\\"slb_details\\"><div class=\\"inner\\"><div class=\\"slb_data\\"><div class=\\"slb_data_content\\"><span class=\\"slb_data_title\\">{{item.title}}<\\/span><span class=\\"slb_group_status\\">{{ui.group\_status}}<\\/span><div class=\\"slb_data_desc\\">{{item.description}}<\\/div><\\/div><\\/div><div class=\\"slb_nav\\"><span class=\\"slb_prev\\">{{ui.nav\_prev}}<\\/span><span class=\\"slb_next\\">{{ui.nav\_next}}<\\/span><\\/div><\\/div><\\/div><\\/div>"}); }if ( !!window.SLB && SLB.has_child('View.extend_theme') ) { SLB.View.extend_theme('slb_default',{"name":"Default (Light)","parent":"slb_baseline","styles":\[{"handle":"base","uri":"https:\\/\\/www.smarthomebeginner.com\\/wp-content\\/plugins\\/simple-lightbox\\/themes\\/default\\/css\\/style.css","deps":\[\]}\]}); }if ( !!window.SLB && SLB.has_child('View.extend_theme') ) { SLB.View.extend_theme('slb_black',{"name":"Default (Dark)","parent":"slb_default","styles":\[{"handle":"base","uri":"https:\\/\\/www.smarthomebeginner.com\\/wp-content\\/plugins\\/simple-lightbox\\/themes\\/black\\/css\\/style.css","deps":\[\]}\]}); }})})(jQuery);} if ( !!window.jQuery ) {(function($){$(document).ready(function(){if ( !!window.SLB ) { {$.extend(SLB, {"context":\["public","user_guest"\]});} }})})(jQuery);}

✓

Thanks for sharing!

[AddToAny](https://www.addtoany.com/ "Share Buttons")

[More…](#addtoany "Show all")

[AddToAny](https://www.addtoany.com/ "Share Buttons")

[More…](#addtoany "Show all")
