# Ultimate Docker Media Server: With 60+ Docker Compose Apps \[2024\]

May 16, 2024January 19, 2024 by [Anand](https://www.smarthomebeginner.com/author/anand/ "View all posts by Anand")

Build a robust and featureful home media server with Docker. This step-by-step guide is part of the Docker Server series by Anand.

![Ultimate Docker Media Server](Ultimate%20Docker%20Media%20Server%20With%2060+%20Docker%20Compose%20Apps%20[2024]_files/Docker-Series-02-Docker-Stack-740x416.webp "Ultimate Docker Media Server: With 60+ Docker Compose Apps [2024] 1")

[Docker](https://www.docker.com/) can help you build a **Home Media Server** in just minutes without complex setups. In this post, I will show you how to build a perfect Docker media server using Docker and Ubuntu.

When I say, Media Server, I mean an all-in-one media server built with Docker wthat ill automate media download, organization, streaming, and sharing with family/friends.

**Note:** If you prefer the convenience of automating everything presented in this guide + more (e.g. Traefik, Authelia, Backups, Portainer, Homepage, etc.), then check out [Auto-Traefik Script](https://www.smarthomebeginner.com/auto-traefik-version-3-0/).

Note that this is a "basic" level post on how to set up a perfect **home media server using Docker** only, which is better suited for accessing stuff from inside your network. Reverse Proxy and secure external access will be covered later in the series.

##### Ultimate Docker Server Series:

This post is part of the Docker Server Tutorial Series, which includes the following individual chapters/parts:

1.  [Ultimate Docker Server: Getting Started with OS Preparation](https://www.smarthomebeginner.com/ultimate-docker-server-1-os-preparation/) \[[VIDEO](https://youtu.be/-ZSQdJ62r-Q)\] \[2024\]
2.  [Docker Media Server Ubuntu/Debian with 60+ Awesome Apps](https://www.smarthomebeginner.com/docker-media-server-2024/) \[[VIDEO](https://youtu.be/THuLgGwq0vg)\] \[2024\]
3.  ZeroTier [VPN](https://www.smarthomebeginner.com/go/surfshark-vpn "Surfshark") Ubuntu, Docker, Synology, Windows: Secure on-the-go access \[coming soon\]
4.  Nginx Proxy Manager Docker Compose Guide: Simplest Reverse Proxy \[coming soon\]
5.  Traefik Reverse Proxy
    - Traefik v3: [Ultimate Traefik v3 Docker Compose Guide \[2024\]: LE, SSL, Reverse Proxy](https://www.smarthomebeginner.com/traefik-v3-docker-compose-guide-2024/) \[2024\]
    - Traefik v2: [Ultimate Traefik Docker Compose Guide: LE, SSL, Reverse Proxy](https://www.smarthomebeginner.com/traefik-docker-compose-guide-2024/) \[2024\]
6.  [Authelia Docker Compose Guide: Secure 2-Factor Authentication](https://www.smarthomebeginner.com/authelia-docker-compose-guide-2024/) \[2024\]
7.  [Google OAuth Docker Compose Guide: Multi-Factor Authentication](https://www.smarthomebeginner.com/google-oauth-traefik-forward-auth-2024/) \[2024\]
8.  [Docker Security Practices for Homelab: Secrets, Firewall, and more](https://www.smarthomebeginner.com/traefik-docker-security-best-practices/)
9.  [Cloudflare Settings for Docker Traefik Stacks](https://www.smarthomebeginner.com/cloudflare-settings-for-traefik-docker/)
10. Implementing a Backup System for Docker Traefik Stack \[coming soon\]
11. [Automate the Whole Process with Auto-Traefik Script](https://www.smarthomebeginner.com/auto-traefik/)

It is best to follow the series from the beginning so you not only understand **WHAT** to do but also **WHY** we do it.

This post is written with a lot of details to help newbies get started on this journey. It may look long but the process itself should take less than an hour.

If you have already reviewed [part 1](https://www.smarthomebeginner.com/ultimate-docker-server-1-os-preparation/) of this series, let's get started with building the perfect Docker media server stack with Ubuntu 22.04 LTS Jammy Jellyfish.

Table of Contents \[[show](#)\]

- [Docker Media Server Guide](#Docker_Media_Server_Guide)
  - [Objectives of this Home and Media Server with Docker](#Objectives_of_this_Home_and_Media_Server_with_Docker)
  - [How Everything Fit Together - The Big Picture](#How_Everything_Fit_Together_-_The_Big_Picture)
  - [My Proxmox Home Server](#My_Proxmox_Home_Server)
  - [Apps for Docker Media Server](#Apps_for_Docker_Media_Server)
- [What is Docker?](#What_is_Docker)
  - [OK Great, but why build a Media Server on Docker?](#OK_Great_but_why_build_a_Media_Server_on_Docker)
  - [What is Docker Compose?](#What_is_Docker_Compose)
- [Requirements for Media Server Docker Stack](#Requirements_for_Media_Server_Docker_Stack)
  - [1\. Install Docker and Docker Compose](#1_Install_Docker_and_Docker_Compose)
  - [2\. Adding User to Docker Group](#2_Adding_User_to_Docker_Group)
- [Setting Up the Docker Environment](#Setting_Up_the_Docker_Environment)
  - [1\. Folders and Files](#1_Folders_and_Files)
  - [2\. Docker Root Folder Permissions](#2_Docker_Root_Folder_Permissions)
  - [3\. Environmental Variables (.env) + Permissions](#3_Environmental_Variables_env_Permissions)
  - [4\. Create Docker Compose Folder](#4_Create_Docker_Compose_Folder)
  - [5\. Docker and Docker Compose Usage](#5_Docker_and_Docker_Compose_Usage)
    - [Starting Containers using Docker Compose](#Starting_Containers_using_Docker_Compose)
    - [See Docker Containers](#See_Docker_Containers)
    - [Check Docker Container Logs](#Check_Docker_Container_Logs)
    - [Stopping / Restarting Containers using Docker Compose](#Stopping_Restarting_Containers_using_Docker_Compose)
    - [Docker Cleanup](#Docker_Cleanup)
- [Building Docker Media Server](#Building_Docker_Media_Server)
  - [Start the Docker Compose File](#Start_the_Docker_Compose_File)
    - [1\. Define Docker Compose File Basics](#1_Define_Docker_Compose_File_Basics)
    - [2\. Define Default Network](#2_Define_Default_Network)
  - [Start Adding Docker Media Server Containers](#Start_Adding_Docker_Media_Server_Containers)
  - [Core Services](#Core_Services)
    - [1\. Socket Proxy - Secure Proxy for the Docker Socket](#1_Socket_Proxy_-_Secure_Proxy_for_the_Docker_Socket)
    - [2\. Portainer - WebUI for Containers](#2_Portainer_-_WebUI_for_Containers)
    - [3\. Dozzle - Real-time Docker Log Viewer](#3_Dozzle_-_Real-time_Docker_Log_Viewer)
    - [4\. Homepage - Application Dashboard](#4_Homepage_-_Application_Dashboard)
  - [Media Server Apps](#Media_Server_Apps)
    - [5\. Plex - Media Server](#5_Plex_-_Media_Server)
  - [Adding Additional Apps to the Docker Stack](#Adding_Additional_Apps_to_the_Docker_Stack)
    - [6\. Jellyfin - Free and Awesome Media Server](#6_Jellyfin_-_Free_and_Awesome_Media_Server)
    - [7\. SABnzbd - Binary newsgrabber (NZB downloader)](#7_SABnzbd_-_Binary_newsgrabber_NZB_downloader)
    - [8\. qBittorrent - Torrent downloader](#8_qBittorrent_-_Torrent_downloader)
    - [9\. Radarr - Movie management](#9_Radarr_-_Movie_management)
    - [10\. Sonarr - TV Shows Management](#10_Sonarr_-_TV_Shows_Management)
    - [11\. Bazarr - Subtitle Management](#11_Bazarr_-_Subtitle_Management)
    - [12\. Tautulli - Plex Statistics and Monitoring](#12_Tautulli_-_Plex_Statistics_and_Monitoring)
    - [13\. Uptime Kuma - Status Page & Monitoring Server](#13_Uptime_Kuma_-_Status_Page_Monitoring_Server)
    - [14\. MariaDB - MySQL Database](#14_MariaDB_-_MySQL_Database)
    - [15\. File Browser - File Explorer](#15_File_Browser_-_File_Explorer)
    - [16\. Docker Garbage Collector](#16_Docker_Garbage_Collector)
  - [The Final Docker Compose File](#The_Final_Docker_Compose_File)
  - [17-60 and More: Rest of the Apps](#17-60_and_More_Rest_of_the_Apps)
- [External Access to Apps](#External_Access_to_Apps)
- [Troubleshooting](#Troubleshooting)
- [Closing Thoughts](#Closing_Thoughts)

## Docker Media Server Guide

Here are the previous versions of this guide:

- [Ultimate Smart Home Media Server with Docker and Ubuntu 18.04 – Basic](https://www.smarthomebeginner.com/docker-home-media-server-2018-basic/)
- [Docker Media Server Ubuntu 22.04 with 23 Awesome Apps](https://www.smarthomebeginner.com/docker-media-server-2022/)

**Note:** My setup changes constantly and evolves. It is nearly impossible to keep this guide synced with my latest updates. Therefore, I strongly suggest that you use this guide to get started and use my GitHub repo and the [detailed commit notes](https://github.com/htpcBeginner/docker-traefik/commits/master) I publish, for changes, improvements, inspiration, and more.

If you prefer watching a video, check out the video version of this guide:

Ultimate Docker Server using Docker Compose: Getting Started from Scratch!

[![Ultimate Docker Server Using Docker Compose: Getting Started From Scratch!](https://www.smarthomebeginner.com/wp-content/plugins/wp-youtube-lyte/lyteCache.php?origThumbUrl=https%3A%2F%2Fi.ytimg.com%2Fvi%2FTHuLgGwq0vg%2F0.jpg "Ultimate Docker Media Server: With 60+ Docker Compose Apps [2024] 2")](https://youtu.be/THuLgGwq0vg)

[Watch this video on YouTube](https://youtu.be/THuLgGwq0vg).

This guide is an update based on the evolution of my own setup and to align with the best practices implemented in my [Auto-Traefik](https://www.smarthomebeginner.com/auto-traefik/) script.

In addition, I am also taking the "secure-by-design" approach and including Socket Proxy and Docker Secrets in this basic guide.

### Objectives of this Home and Media Server with Docker

As explained in [part 1](https://www.smarthomebeginner.com/ultimate-docker-server-1-os-preparation/), I separate my home server (_docker-compose-hs.yml_) and media server (_docker-compose-mds.yml_). I do this because:

1.  I constantly mess with my home server and I do not want my tinkering to bring down the media server.
2.  _\[Begin Rant\]_ Avoid having to deal with all my media consumers who take the whole setup for granted and do not appreciate what I do. _\[End Rant\]_

But for a typical user, both services may reside on just one Docker host.

One of the big tasks of a completely **automated media server** is media aggregation. For example, when a TV show episode becomes available, automatically download it, collect its poster, fanart, subtitle, etc., put them all in a folder of your choice (eg. inside your TV Shows folder), update your media library (eg. on [Jellyfin, Emby, or Plex](https://www.smarthomebeginner.com/plex-vs-emby-kodi-jellyfin-2020/)) and then send a notification to you (eg. Email, Mobile notification, etc.) saying your episode is ready to watch.

[

![Schematic Of Automatic Media Management](https://www.smarthomebeginner.com/images/2019/04/schematic-of-media-aggregation-740x370.jpg "Ultimate Docker Media Server: With 60+ Docker Compose Apps [2024] 3")

![Schematic Of Automatic Media Management](Ultimate%20Docker%20Media%20Server%20With%2060+%20Docker%20Compose%20Apps%20[2024]_files/schematic-of-media-aggregation-740x370.webp "Ultimate Docker Media Server: With 60+ Docker Compose Apps [2024] 3")](https://www.smarthomebeginner.com/images/2019/04/schematic-of-media-aggregation-scaled.jpg)

Example Schematic Of Automatic Media Management

Sounds awesome right?

### How Everything Fit Together - The Big Picture

Here is a list of functions I want my **comprehensive autonomous media server** to do:

- Automated TV Show download and organization
- Automated Movie download and organization
- On-demand or automated torrent download
- On-demand or automated NZB (Usenet) download
- Serve and Stream Media to Devices in the house and outside through internet
- On demand torrent and NZB search interface
- Act as a personal cloud server with secure file access anywhere
- Provide a unified interface to access all the apps
- Update all the apps automatically

### My Proxmox Home Server

My Proxmox Server runs my Home Server, Media/Database Server, and AdBlock/DNS Server as Ubuntu 22.04 LXC Containers. \[**Read:** [5 Best Mini PC for Proxmox Home Server \[2024\]](https://www.smarthomebeginner.com/best-mini-pc-for-proxmox-2024/)\]

I recently upgraded to the [TopTon V700 Mini PC](https://www.smarthomebeginner.com/go/ae-toptonv700) as Proxmox Host (for just $481) and it's been killing it.

[

![My Topton V700 Minipc From Aliexpress - Proxmox Server](https://www.smarthomebeginner.com/images/2024/02/topton-v700-mini-pc-740x296.jpg "Ultimate Docker Media Server: With 60+ Docker Compose Apps [2024] 4")

![My Topton V700 Minipc From Aliexpress - Proxmox Server](Ultimate%20Docker%20Media%20Server%20With%2060+%20Docker%20Compose%20Apps%20[2024]_files/topton-v700-mini-pc-740x296.webp "Ultimate Docker Media Server: With 60+ Docker Compose Apps [2024] 4")](https://www.smarthomebeginner.com/go/ae-toptonv700)

[Topton V700 Minipc From Aliexpress - $481](https://www.smarthomebeginner.com/Go/Ae-Toptonv700) - Proxmox Server

- [TopTon V700 Mini PC with Intel 13th Gen "Raptor Lake" i7-13800H](https://www.smarthomebeginner.com/go/ae-toptonv700) - $481
- 2x32GB [Crucial DDR5 4800MHz SO-DIMM RAM](https://www.amazon.com/dp/B09S2QLBWC/?tag=shbeg-20) - $163
- 2x2TB [Crucial T500 PCIe Gen4 M.2 NVME Drives](https://www.amazon.com/Crucial-Internal-Gaming-Desktop-Compatible/dp/B0CK2TC9XQ/?tag=shbeg-20) in ZFS RAID - $230
- 4TB [Crucial MX500 SATA III SSD](https://www.amazon.com/Crucial-MX500-NAND-Internal-560MB/dp/B09FRRWVWX/?tag=shbeg-20) for non-critical data, cache, etc. - $200

If you are ordering from AliExpress, remember 3 things: 1) Check with the seller if the item is in stock first, 2) Pick only sellers with a very high rating (>95% at least), and 3) Be prepared for delays/extended delivery times (in my case the seller asked for extra shipping time due to availability).

### Apps for Docker Media Server

There are several apps that can do such tasks and we have compiled them in our list of [60+ best Docker containers for home server beginners](https://www.smarthomebeginner.com/best-docker-containers-for-home-server/).

In this guide, I will cover a few examples starting with Socket Proxy, Portainer, Dozzle, and Plex to explain the Docker Concepts. Then, present a few more apps as concise examples. Finally, I will show you how to add literally 10s, 100s, of apps to your stack.

While I only cover a few apps here, you can add additional apps easily by copy-pasting Docker Compose snippets from my GitHub repo.

It may seem like a complex setup, but trust me, docker (along with Docker Compose) can make installation, migration, and maintenance of these home server apps easier.

There are separate posts focused on many of these apps that explain specific configurations in detail. These will be linked o along the way.

## What is Docker?

Before we get started with **building a docker media server**, it only makes sense to touch on Docker. We have already covered [What is Docker and how it compares to a Virtual Machine such as VirtualBox](https://www.smarthomebeginner.com/what-is-docker-docker-vs-virtualbox/). Therefore, we won't go into much detail here.

[

![Docker Vs Virtual Machines Made By Docker](https://www.smarthomebeginner.com/images/2016/11/Docker-vs-Virtual-Machines-740x268.png "Ultimate Docker Media Server: With 60+ Docker Compose Apps [2024] 5")

![Docker Vs Virtual Machines Made By Docker](Ultimate%20Docker%20Media%20Server%20With%2060+%20Docker%20Compose%20Apps%20[2024]_files/Docker-vs-Virtual-Machines-740x268.webp "Ultimate Docker Media Server: With 60+ Docker Compose Apps [2024] 5")](https://www.smarthomebeginner.com/images/2016/11/Docker-vs-Virtual-Machines.png)

Docker Vs Virtual Machines Made By Docker

Briefly, Docker allows for operating-system-level virtualization. What this means is that applications can be installed inside virtual "containers", completely isolated from the host operating system.

Unlike a virtual machine, which needs guest OS for each of the virtual machines, a Docker container does not need a separate Operating system. So docker containers can be created and destroyed in seconds. The containers also boot in seconds and so your app is ready to roll very quickly.

Docker works natively on Linux, but is also available for Mac and Windows.

> ##### Recommended Guides on Docker:
>
> - [The Docker Book: Containerization is the new virtualization](https://www.amazon.com/Docker-Book-Containerization-new-virtualization-ebook/dp/B00LRROTI4/?tag=htpcbeg-20)
> - [Docker Cookbook: Solutions and Examples](https://www.amazon.com/product/dp/149191971X/?tag=htpcbeg-20)

### OK Great, but why build a Media Server on Docker?

Again, this has been explained in detail in my original [docker guide](https://www.smarthomebeginner.com/docker-home-media-server-2018-basic/?preview=true#OK_Great_but_why_build_a_Docker_Media_Server).

The traditional way of _building a Home Media Server_ involves setting up the operating system, adding repositories, downloading the apps, installing the pre-requisites/dependencies, installing the app, and configuring the app.

This is cumbersome on Linux and requires extensive commandline work.

[

![Search For Containerized Apps On Docker Store](https://www.smarthomebeginner.com/images/2018/04/docker-store-for-containers-740x264.png "Ultimate Docker Media Server: With 60+ Docker Compose Apps [2024] 6")

![Search For Containerized Apps On Docker Store](Ultimate%20Docker%20Media%20Server%20With%2060+%20Docker%20Compose%20Apps%20[2024]_files/docker-store-for-containers-740x264.webp "Ultimate Docker Media Server: With 60+ Docker Compose Apps [2024] 6")](https://www.smarthomebeginner.com/images/2018/04/docker-store-for-containers.png)

Search For Containerized Apps On Docker Store

In Docker, [home server apps](https://www.smarthomebeginner.com/best-home-server-apps/) such as Radarr, Sonarr, Plex, etc. can be installed with ease without worrying about pre-requisites or incompatibilities. All requirements are already pre-packaged with each container.

Most well-known apps are already containerized by the Docker community and available through the [Docker Store](https://hub.docker.com/). Many of them even have example Docker compose files. \[**Read:** [Podman vs Docker](https://www.smarthomebeginner.com/podman-vs-docker/)\]

### What is Docker Compose?

Docker already makes installation of applications easier. But it gets even better. With **Docker Compose**, you can edit the compose file to set some configuration parameters (e.g.. download directory, seed ratio, etc.) and run the file and all your containerized apps can be configured and started with just one command.

But wait, there is more. Once you create your docker compose files, it becomes so much easier to migrate your apps, rebuild your servers, etc. I have moved my setup to many servers. All I have to do is install Ubuntu Server, copy over my Docker data folder (or Docker Root Folder as we will call it in this guide), edit my environmental variables, and start the stack from compose file.

All the 50 or so apps I have defined in my compose files are up in minutes and continue from where I left off in my previous server.

> A Docker Compose file is like a template of all the apps in your docker stack with their basic configuration. You can even share your template with others, just like I am doing in this guide.

The scope of this post is to build a Docker-Compose media server. However, there are other methods to simplify installation of Docker containers (e.g. Portainer, Ansible, etc.). Explaining those methods is outside the scope of this post.

## Requirements for Media Server Docker Stack

Having a [Ubuntu](https://www.ubuntu.com/) or Debian system ready is a basic requirement of this guide. Windows and Mac users check out [Docker Desktop](https://www.docker.com/products/docker-desktop/).

At this point, the assumption is that you already have Ubuntu running and have prepared the operating system as detailed in the preparatory guide ([Part 1](https://www.smarthomebeginner.com/ultimate-docker-server-1-os-preparation/) of this series).

You could install any flavor of Ubuntu or Debian. Previously, I have used Pop OS and Linux Mint with this setup, with no issues.

Note that we are not talking about domain names, Cloudflare, port forwarding, etc. This is because the intent of this post is to build a Docker Home Media Server for internal use. Exposing the apps for external access will be covered in the later parts of this series.

### 1\. Install Docker and Docker Compose

First, we need to install Docker and Docker Compose. This has been covered in detail in my [Ubuntu Docker installation guide](https://www.smarthomebeginner.com/install-docker-on-ubuntu-22-04/#Install_Docker_on_Ubuntu_2204).

Install Docker on Ubuntu (with Compose) - Don't Do It WRONG

[![Install Docker On Ubuntu (With Compose) - Don'T Do It Wrong](https://www.smarthomebeginner.com/wp-content/plugins/wp-youtube-lyte/lyteCache.php?origThumbUrl=https%3A%2F%2Fi.ytimg.com%2Fvi%2FnwFh4JBGD_0%2F0.jpg "Ultimate Docker Media Server: With 60+ Docker Compose Apps [2024] 7")](https://youtu.be/nwFh4JBGD_0)

[Watch this video on YouTube](https://youtu.be/nwFh4JBGD_0).

But, the easiest way to install Docker and Docker Compose, irrespective of the OS, is using the [official convenience script](https://docs.docker.com/engine/install/debian/#install-using-the-convenience-script). It is as easy as running the following two commands:

1

2

` curl -fsSL https:``//get``.docker.com -o get-docker.sh `

`sudo` `sh get-docker.sh`

After Docker is installed, you may verify their installation and versions using the following commands:

[

![Docker And Docker Compose Versions](https://www.smarthomebeginner.com/images/2024/01/docker-and-docker-compose-versions-740x464.jpg "Ultimate Docker Media Server: With 60+ Docker Compose Apps [2024] 8")

![Docker And Docker Compose Versions](Ultimate%20Docker%20Media%20Server%20With%2060+%20Docker%20Compose%20Apps%20[2024]_files/docker-and-docker-compose-versions-740x464.webp "Ultimate Docker Media Server: With 60+ Docker Compose Apps [2024] 8")](https://www.smarthomebeginner.com/images/2024/01/docker-and-docker-compose-versions.jpg)

Docker And Docker Compose Versions

### 2\. Adding User to Docker Group

In [part 1](https://www.smarthomebeginner.com/ultimate-docker-server-1-os-preparation/), we added a new user called "anand". Notice in the picture above that the user had to use sudo to see Docker and Docker Compose versions.

One way to get around using sudo with every Docker command is to add the user "anand" to "docker" group:

1

`sudo` `adduser anand docker`

In my first Docker home server guide, I suggested [adding yourself or the user that will run the docker stack to the **docker** group](https://www.smarthomebeginner.com/docker-home-media-server-2018-basic/?preview=true#Add_Linux_User_to_Docker_Group) to avoid having to add **sudo** for all docker commands.

It is still OK to do this in a Docker homelab environment if you implement other [Docker best security practices](https://www.smarthomebeginner.com/traefik-docker-security-best-practices/).

However, I do not do this (I have gotten used to sudoing on demand) and so in this guide, I will include **sudo** in front of docker commands.

Plus, I recommend setting up [Bash Aliases](https://github.com/htpcBeginner/docker-traefik/blob/master/shared/config/bash_aliases), which simplifies issuing long/complex commands. Here is a video guide on how I use bash aliases.

Simplify Docker, Docker Compose, and Linux Commands with Bash Aliases

[![Simplify Docker, Docker Compose, And Linux Commands With Bash Aliases](https://www.smarthomebeginner.com/wp-content/plugins/wp-youtube-lyte/lyteCache.php?origThumbUrl=https%3A%2F%2Fi.ytimg.com%2Fvi%2FUx9khKhqhcg%2F0.jpg "Ultimate Docker Media Server: With 60+ Docker Compose Apps [2024] 9")](https://youtu.be/Ux9khKhqhcg)

[Watch this video on YouTube](https://youtu.be/Ux9khKhqhcg).

## Setting Up the Docker Environment

The groundwork is done. We have the server, operating system, and Docker in place. Let us start laying the foundation for us to start building our perfect media server Docker stack.

### 1\. Folders and Files

With the launch of Auto-Traefik, I changed my Docker Root Folder structure from what was described in my [2018](https://www.smarthomebeginner.com/docker-home-media-server-2018-basic/#Docker_Folder_and_Permissions) and [2022](https://www.smarthomebeginner.com/docker-media-server-2022/#1_Folders_and_Files) guides. I did this to 1) align with what the Auto-Traefik Script does and make it compatible with this guide and vice versa, and 2) simplify syncing all my Docker configuration files between 5 hosts and still keep them segregated.

I have a specific folder structure I use for my setup; with everything I need to manage the server in one place. This is the base of all of my Docker guides and the GitHub repo.

So here it goes:

[

![Docker Root Folder And Files](https://www.smarthomebeginner.com/images/2024/01/docker-root-folder-and-files-2024-1-740x209.jpg "Ultimate Docker Media Server: With 60+ Docker Compose Apps [2024] 10")

![Docker Root Folder And Files](Ultimate%20Docker%20Media%20Server%20With%2060+%20Docker%20Compose%20Apps%20[2024]_files/docker-root-folder-and-files-2024-1-740x209.webp "Ultimate Docker Media Server: With 60+ Docker Compose Apps [2024] 10")](https://www.smarthomebeginner.com/images/2024/01/docker-root-folder-and-files-2024-1.jpg)

Docker Root Folder And Files

As you can see above, I have a **docker** folder in my home directory. This is the root Docker data folder. Let us call this **DOCKER ROOT FOLDER**. This will house all our docker-related folders and files:

- **appdata** - this folder will store the data for all our apps and services. Create this (and the folders listed below) using the following command:

  1

  `mkdir` `/home/anand/docker/appdata`

- **compose** - this folder will have a subfolder for each host, inside which all the individual Docker Compose files will be stored.
- _logs_ - to centralize all relevant logs. I use this to store my script logs, traefik logs, etc. Although you can customize your apps (e.g. Nginx Proxy Manager) to store logs in this folder, we won't cover that in this guide. So, you can safely ignore it for this guide.
- _scripts_ - to store all scripts. I use this folder to store my scripts for rClone, systemd, backup, etc. You can safely ignore it folder for this guide.
- **secrets** - to store credentials used by apps securely. See [Docker secrets](https://www.smarthomebeginner.com/traefik-docker-security-best-practices/#8_Use_Docker_Secrets). Notice that the folder is owned by root and permissions are set to 600, using the following commands:

  1

  2

  `sudo` `chown` `root:root` `/home/anand/docker/secrets`

  `sudo` `chmod` `600` `/home/anand/docker/secrets`

- _shared_ - to store shared information. I save a lot of things in this folder that I share between 5 docker hosts (e.g. SSH config, .bash_aliases, etc.). For this guide, you can ignore it.
- **.env** - to store credentials used by apps securely as variable names. This way I won't have to use real values in **docker-compose-udms.yml** (for security). And, I can use the variable names in many places. Notice that the file is owned by root and permissions are set to 600. Create the empty file and set its permissions as shown below:

  1

  2

  3

  `touch` ` /home/anand/docker/``.``env `

  `sudo` `chown` `root:root` ` /home/anand/docker/``.``env `

  `sudo` `chmod` `600` ` /home/anand/docker/``.``env `

- **docker-compose-udms.yml** - this is our template or configuration file for all our services. We will create this later in the guide. Note that my actual Docker Compose files (e.g. in the Github repo) have hostname as the suffix to separate them by host. We will call this file the **Master Docker Compose File** - you will see why later. Create this empty file using the following command:

  1

  `touch` ` /home/anand/docker/docker-compose-udms``.yml `

As in the description of each folder (and in **bold** font), you will need only a few from the above list for this basic docker media server guide.

But, if you start here and continue to follow my other guides, you will have to create the rest later on.

### 2\. Docker Root Folder Permissions

Assuming that you have created the files and folders listed above, let us set the right permissions for them. We will need **acl** for this. If it is not installed, install it using:

1

`sudo` `apt` `install` `acl`

Next, set the permission for **/home/anand/docker** folder (**anand** being the username of the user) as follows:

1

2

3

4

5

`sudo` `chmod` `775` `/home/anand/docker`

`sudo` `setfacl -Rdm u:anand:rwx` `/home/anand/docker`

`sudo` `setfacl -Rm u:anand:rwx` `/home/anand/docker`

`sudo` `setfacl -Rdm g:docker:rwx` `/home/anand/docker`

`sudo` `setfacl -Rm g:docker:rwx` `/home/anand/docker`

You may also have to set acls on your media folder or the **DATADIR** path you will define in the later steps or apps such a sonarr, radarr, etc. may through permissions error.

The above commands provide access to the contents of the docker root folder (both existing and new stuff) to the docker group. Some may disagree with the liberal permissions above but again this is for home use and it is restrictive enough.

**Note:** After doing the above, you will notice a "+" at the end of permissions (e.g. drwxrwxr-x+) for docker root folder and its contents (as in the picture above). This indicates that ACL is set for the folder/file.

In my experience, this has addressed many permissions issues I have faced in the past due to containers not being able to access the contents of docker root folder.

### 3\. Environmental Variables (.env) + Permissions

We are going to put some frequently used information in a common location and call it up as needed using variable names. This is what setting up environmental variables means in simple terms.

So, if you haven't already created, create and set restrictive permissions for **.env** file. The dot in front is not a typo, it hides the file in directory listings. From inside **docker root folder:**

1

2

3

`touch` ` .``env `

`sudo` `chown` ` root:root .``env `

`sudo` `chmod` ` 600 .``env `

From now on, to edit the **.env** file you will have to be either logged in as **root** or elevate your privileges by using **sudo**. Let us now open the file for editing:

1

`sudo` `nano` ` /home/anand/docker/``.``env `

Add the following environmental variables to it:

1

2

3

4

5

6

7

`PUID=1000`

`PGID=1000`

` TZ=``"Europe/Zurich" `

` USERDIR=``"/home/anand" `

` DOCKERDIR=``"/home/anand/docker" `

` DATADIR=``"/media/storage" `

` HOSTNAME=``"udms" `

**Replace/Configure:**

1.  **PUID** and **PGID** - the user ID and group ID of the Linux user (anand), who we want to run the home server apps as. Both of these can be obtained using the **id** command as shown below.

    [

    ![User Id And Group Id](https://www.smarthomebeginner.com/images/2024/01/user-id-and-group-id-740x61.jpg "Ultimate Docker Media Server: With 60+ Docker Compose Apps [2024] 11")

    ![User Id And Group Id](Ultimate%20Docker%20Media%20Server%20With%2060+%20Docker%20Compose%20Apps%20[2024]_files/user-id-and-group-id-740x61.webp "Ultimate Docker Media Server: With 60+ Docker Compose Apps [2024] 11")](https://www.smarthomebeginner.com/images/2024/01/user-id-and-group-id.jpg)

    User Id And Group Id

    As in the above picture, we are going to use 1000 for both PUID and PGID.

2.  **TZ** - the time zone that you want to set for your containers. Get your TZ from this [timezone database](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones).
3.  **USERDIR** - the path to the home folder of the current user (typically /home/USER).
4.  **DOCKERDIR** - the docker root folder that will house all persistentt data folders for docker apps. We created this in the steps above.
5.  **DATADIR** - the data folder that stores your media, downloads, and other stuff. This could be an external drive or a network folder. \[**Read:** [Install and configure NFS server on Ubuntu for serving files](https://www.smarthomebeginner.com/install-configure-nfs-server-ubuntu/)\]
6.  **HOSTNAME** - is the name of your docker host. While it can be any name you choose, I recommend using the same as your Docker Host's hostname (can be found using the **hostname** command).

    These would be **hs**, **mds**, **ws**, **ds918**, and **dns** in my Github Repo files. For this tutorial, let's set it to "UDMS" for ultimate Docker media server.

Save and exit nano (**Ctrl X** followed by **Y** and **Enter**).

These environmental variables will be referred to using **$VARIABLE_NAME** throughout the docker-compose file. Their values will be automatically pulled from the environment file that we created/edited above.

As we go through this guide, we will continue to add more environmental variables to the **.env** file. You will find an example **.env** in my [GitHub repo](https://github.com/htpcBeginner/docker-traefik).

That's it, the basic prep work to build our docker home server is done.

Installing Docker and setting up the Docker environment as described above would have taken ~22 seconds using the [Auto-Traefik](https://www.smarthomebeginner.com/auto-traefik/) script. Take a look:

Auto Traefik 2 (Part 4) - Docker and Socket Proxy Setup

[![Auto Traefik 2 (Part 4) - Docker And Socket Proxy Setup](https://www.smarthomebeginner.com/wp-content/plugins/wp-youtube-lyte/lyteCache.php?origThumbUrl=https%3A%2F%2Fi.ytimg.com%2Fvi%2FTWsLUzK6DbM%2F0.jpg "Ultimate Docker Media Server: With 60+ Docker Compose Apps [2024] 12")](https://youtu.be/TWsLUzK6DbM)

[Watch this video on YouTube](https://youtu.be/TWsLUzK6DbM).

### 4\. Create Docker Compose Folder

A big change from my past guide is: previously I had one Docker Compose file with all services defined inside. With the launch of Auto-Traefik and the step to align both of them, I changed my setup to break up all the services into individual YML files.

Therefore, let's create the following folder for our host "udms":

1

`mkdir` `/home/anand/docker/compose/udms`

This **udms** folder will host all our docker compose YML files.

### 5\. Docker and Docker Compose Usage

In the past, we have listed a few good [docker and docker compose commands](https://www.smarthomebeginner.com/install-docker-on-ubuntu-22-04/#Basic_Docker_and_Docker-Compose_Commands) to know. But I will expand on them here anyway.

#### Starting Containers using Docker Compose

This section is an intro to some of the commands you will use later in this guide. Running them at this point in the guide will throw errors. After adding compose options for each container (note that we have not added these yet), I recommend saving, exiting, and running the compose file using the following command to check if the container app starts correctly.

**Note:** If you are using the new [Docker Compose V2](https://docs.docker.com/compose/#compose-v2-and-the-new-docker-compose-command), which is installed as a docker plugin, then use **docker compose** (without hyphen) instead of **docker-compose**.

At the time of writing this guide, only Synology is on the older version of Docker and requires manual installation of Docker Compose and **docker-compose** command.

1

`sudo` `docker compose -f` ` /home/anand/docker/docker-compose-udms``.yml up -d `

Replace **docker-compose-udms.yml** with the actual name of the compose file (mine varies depending on the host).

The `-d` option daemonizes it in the background. Without it, you will see real-time logs, which is another way of making sure no errors are thrown. Press `Ctrl + C` to exit out of the real-time logs.

Also notice we are using **sudo** in front because we chose not to add the user (anand) to docker group.

#### See Docker Containers

At any time, you can check all the docker containers you have on your system (both running and stopped) using the following command:

1

`sudo` `docker` `ps` `-a`

As an example, here is a list of my containers for now. "STATUS" column shows whether a container is running (for how long) or exited. The last column shows the friendly name of the container.

[

![Docker List Of Containers](https://www.smarthomebeginner.com/images/2024/01/docker-ps-740x169.jpg "Ultimate Docker Media Server: With 60+ Docker Compose Apps [2024] 13")

![Docker List Of Containers](Ultimate%20Docker%20Media%20Server%20With%2060+%20Docker%20Compose%20Apps%20[2024]_files/docker-ps-740x169.webp "Ultimate Docker Media Server: With 60+ Docker Compose Apps [2024] 13")](https://www.smarthomebeginner.com/images/2024/01/docker-ps.jpg)

Docker List Of Containers

Because I use Bash Aliases, **dps** = **sudo docker ps -a**.

#### Check Docker Container Logs

If you want to check the logs while the container starts you can use the following command:

1

`sudo` `docker compose -f` ` /home/anand/docker/docker-compose-udms``.yml logs `

Or,

1

`sudo` `docker logs`

In addition, you can also specify the name of the specific container at the end of the previous command if you want to see logs of a specific container. Here is a screenshot of the docker logs for my `transmission-vpn` container that was generated using the following command:

1

`sudo` `docker compose -f` ` /home/anand/docker/docker-compose-udms``.yml logs transmission-vpn `

I have now replaced my Transmission with [qBittorrent behind Gluetun VPN container](https://www.smarthomebeginner.com/gluetun-docker-guide/).

Finally, if you want to follow the logs in real-time (tailing), then use:

1

`sudo` `docker compose -f` ` /home/anand/docker/docker-compose-udms``.yml logs -tf --``tail``=``"50" ` `crowdsec`

This will show you the last 50 lines of the log, while following it in real-time.

[

![Docker Compose Real-Time Logs For Containers](https://www.smarthomebeginner.com/images/2024/01/dclogs-output-740x117.jpg "Ultimate Docker Media Server: With 60+ Docker Compose Apps [2024] 14")

![Docker Compose Real-Time Logs For Containers](Ultimate%20Docker%20Media%20Server%20With%2060+%20Docker%20Compose%20Apps%20[2024]_files/dclogs-output-740x117.webp "Ultimate Docker Media Server: With 60+ Docker Compose Apps [2024] 14")](https://www.smarthomebeginner.com/images/2024/01/dclogs-output.jpg)

Docker Compose Real-Time Logs For Containers

Because I use Bash Aliases, **dclogs** = **sudo docker compose -f /home/anand/docker/docker-compose-udms.yml logs**.

At any time, you can exit from the real-time logs screen by pressing `Ctrl + C`.

#### Stopping / Restarting Containers using Docker Compose

To stop any running docker container, use the following command:

1

`sudo` `docker compose -f` ` /home/anand/docker/docker-compose-udms``.yml stop CONTAINER-NAME `

Replace `CONTAINER-NAME` with the friendly name of the container. You can also replace `stop` with `restart`. To completely stop and remove containers, images, volumes, and networks (go back to how it was before running docker compose file), use the following command:

1

`sudo` `docker compose -f` ` /home/anand/docker/docker-compose-udms``.yml down `

#### Docker Cleanup

Remember, one of the biggest benefits of Docker is that it is extremely hard to mess up your host operating system. So, you can create and destroy containers at will. But over time leftover Docker images, containers, and volumes can take several GBs of space. So, at any time, you can run the following clean up scripts and re-run your docker-compose as described above.

1

2

3

`sudo` `docker system prune`

`sudo` `docker image prune`

`sudo` `docker volume prune`

These commands will remove any stray containers, volumes, and images that are not running or are not associated with any containers. Remember, even if you remove something that was needed you can always recreate it by just running the docker compose file.

> **Be the 1 in 200,000. Help us sustain what we do.**
>
> 47 / 150 by Dec 31, 2024
>
> [Join Us](https://www.smarthomebeginner.com/membership-account/memberships-products-services/) (starting from just $1.67/month)
>
> [Why did we start Memberships?](https://www.smarthomebeginner.com/state-of-the-site-2023/)

## Building Docker Media Server

Finally, we are now ready to start building our media server with Docker. Let us look at docker-compose examples for a **comprehensive autonomous media server** setup.

Many of the container images used in this guide are developed and maintained by the guys at LinuxServer.io. Please show your appreciation by [supporting their work](https://www.linuxserver.io/donate).

### Start the Docker Compose File

**Note:** Blank spaces, indentation, and alignment are extremely important in YAML. So, when typing or copy-pasting code, pay attention to spacing.

#### 1\. Define Docker Compose File Basics

Open the `docker-compose-udms.yml` file:

1

`nano` ` /home/anand/docker/docker-compose-udms``.yml `

Add the following line at the top:

version: "3.9"

**Update (March 21, 2024):** The version tag at the top of Docker compose file is now obsolete and throws a warning. This has been removed from my guides.

It basically says we are going to use [Docker Compose file format](https://docs.docker.com/compose/compose-file/compose-file-v3/) 3.9.

#### 2\. Define Default Network

Next, we will add the network block right below the version line, as shown below:

1

2

3

4

`########################### NETWORKS`

`networks:`

`default:`

`driver:` `bridge`

Note that **########################### NETWORKS** is ignored by Docker compose. With # in the front, this line is basically a comment and a visual demarcation within our long docker-compose-udms.yml file.

We are only defining one network called "default".

Until 2023, I used [Docker Extension Fields](https://www.smarthomebeginner.com/docker-media-server-2022/#3_Define_Extension_Fields) to reduce duplication of Docker Compose lines. I have moved away from it because 1) it reduced the readability of compose files and 2) for every guide I write, I had to explain extension fields. So, it has been removed in this update.

### Start Adding Docker Media Server Containers

As mentioned above, we will create individual YML files for each service. We will accomplish this using the **include** block in Docker Compose.

Right below the network block, let us start adding our services/containers. First, begin by adding the following lines, starting from **include:**:

1

2

3

4

5

6

7

8

9

`########################### NETWORKS`

`networks:`

`default:`

`driver:` `bridge`

`include:`

`########################### SERVICES`

`# PREFIX udms = Ultimate Docker Media Server`

`# HOSTNAME=udms - defined in .env`

Notice all the comments. As you will see below, we are going to use **udms** as prefix for the individual compose files.

**Note:** Note that everything within include should be indented by two blank spaces.

### Core Services

I call these core services because they are kind of the most basic/core apps in my stack. Let us begin by adding the comment line (**\# CORE**) below (don't ignore the 2 blank spaces in the front) under the include block.

1

2

3

4

5

6

7

8

9

10

11

`########################### NETWORKS`

`networks:`

`default:`

`driver:` `bridge`

`include:`

`########################### SERVICES`

`# PREFIX udms = Ultimate Docker Media Server`

`# HOSTNAME=udms - defined in .env`

`# CORE`

There are many services that I call "Core", in my [GitHub repo](https://github.com/htpcbeginner/docker-traefik). In this Docker server tutorial, I am only going to show Socket Proxy and Portainer.

#### 1\. [Socket Proxy](https://github.com/Tecnativa/docker-socket-proxy) - Secure Proxy for the Docker Socket

I did not include Socket Proxy in the previous version of this guide. Instead, it was explained as an [improvement](https://www.smarthomebeginner.com/traefik-docker-security-best-practices/#9_Use_a_Docker_Socket_Proxy). In this version of the guide, I am going to make it "secure-by-design" as much as possible. This is also the approach I have taken with Auto-Traefik.

So, what is a Docker Socket Proxy? Any time you expose the Docker socket to a service, you are making it easier for the container to gain root access on the host system.

But some apps require access to Docker socket and API (eg. Traefik, Glances, Dozzle, Watchtower, etc.).

If Traefik gets compromised, then your host system could be compromised. Traefik's own documentation lists using a Socket Proxy as a solution.

A socket proxy is like a firewall for the docker socket/API. You can allow or deny access to certain API.

##### Define socket_proxy Network

First, let us define a separate network for Socket Proxy called **socket_proxy**. Only those services connected to this network will have access to the Docker Socket.

Add **socket_proxy** network right below the default network (while respecting the indentations), as shown below:

1

2

3

4

5

6

7

8

9

10

11

12

13

14

15

16

17

`########################### NETWORKS`

`networks:`

`default:`

`driver:` `bridge`

`socket_proxy:`

`name:` `socket_proxy`

`driver:` `bridge`

`ipam:`

`config:`

`-` ` subnet``: ` `192.168.91.0/24`

`include:`

`########################### SERVICES`

`# PREFIX udms = Ultimate Docker Media Server`

`# HOSTNAME=udms - defined in .env`

`# CORE`

All services behind **socket_proxy** network will use IP addresses between 192.168.91.1 and 192.168.91.254. You may customize the subnet if you prefer.

Note that **192.168.91.0/24** subnet is just a random subnet I picked. This has nothing to do with what your LAN subnet is. In fact, it cannot be the same as your LAN subnet. 192.168.91.0/24 is used only within the Docker environment and typically, you would never have to use or remember IPs in this subnet. For most users, what I have provided above should work 'as-is'.

##### Create Socket Proxy Docker Compose

First, let's create the Socket Proxy Docker compose file. Head over to the [compose folder](https://github.com/htpcBeginner/docker-traefik/tree/master/compose) in my Github Repository, and then into any of the host folders. Find the compose file for Socket Proxy and copy the contents.

Create a file called **socket-proxy.yml** inside **/home/anand/docker/compose/udms**. Copy-paste the contents into **socket-proxy.yml** compose file (pay attention to blank spaces at the beginning of each line).

1

2

3

4

5

6

7

8

9

10

11

12

13

14

15

16

17

18

19

20

21

22

23

24

25

26

27

28

29

30

31

32

33

34

35

36

37

38

39

40

41

42

43

44

45

46

47

48

49

`services:`

`# Docker Socket Proxy - Security Enchanced Proxy for Docker Socket`

`socket-proxy:`

`container_name:` `socket-proxy`

`image:` `tecnativa/docker-socket-proxy`

`security_opt:`

`-` ` no-new-privileges``:``true `

`restart:` `unless-stopped`

`# profiles: ["core", "all"]`

`networks:`

`socket_proxy:`

`ipv4_address:` `192.168.91.254` `# You can specify a static IP`

`privileged:` `true` `# true for VM. false for unprivileged LXC container on Proxmox.`

`ports:`

`-` `"127.0.0.1:2375:2375"` `# Do not expose this to the internet with port forwarding`

`volumes:`

`-` `"/var/run/docker.sock:/var/run/docker.sock"`

`environment:`

`-` `LOG_LEVEL=info` `# debug,info,notice,warning,err,crit,alert,emerg`

`## Variables match the URL prefix (i.e. AUTH blocks access to /auth/* parts of the API, etc.).`

`# 0 to revoke access.`

`# 1 to grant access.`

`## Granted by Default`

`-` `EVENTS=1`

`-` `PING=1`

`-` `VERSION=1`

`## Revoked by Default`

`# Security critical`

`-` `AUTH=0`

`-` `SECRETS=0`

`-` `POST=1` `# Watchtower`

`# Not always needed`

`-` `BUILD=0`

`-` `COMMIT=0`

`-` `CONFIGS=0`

`-` `CONTAINERS=1` `# Traefik, Portainer, etc.`

`-` `DISTRIBUTION=0`

`-` `EXEC=0`

`-` `IMAGES=1` `# Portainer`

`-` `INFO=1` `# Portainer`

`-` `NETWORKS=1` `# Portainer`

`-` `NODES=0`

`-` `PLUGINS=0`

`-` `SERVICES=1` `# Portainer`

`-` `SESSION=0`

`-` `SWARM=0`

`-` `SYSTEM=0`

`-` `TASKS=1` `# Portainer`

`-` `VOLUMES=1` `# Portainer`

Here are some notes about the Socket Proxy Docker Compose:

- I have commented out **profiles**. If you copy-paste from my GitHub Repository, remember to do the same for all other apps. I use the Docker profiles for some automations. You do not need it when you start out.
- Unless you are running in an unprivileged Proxmox LXC container, privileged should be set to **true**.
- We are defining a static IP of 192.168.91.254 for the **socket-proxy** container, in the subnet we specified for **socket_proxy** network previously. Note the difference in container name (hyphen) and network name (underscore).
- Expose [port 2375 only to the internal network](https://github.com/htpcBeginner/docker-traefik/pull/88) (127.0.0.1:2375). The ports line instructs that port 2375 from inside the container (right side) is mapped to the port 2375 on the host machine (left side) only on the internal network interface (meaning other machines won't be able to connect to the port).

  Do not ever expose port 2375 to the internet. You will get hacked ([here is an example](https://github.com/htpcBeginner/docker-traefik/issues/85)). This is even more important for virtual private servers that typically expose all ports.

- In the **environment:** block we specify the Docker API section that we want to open up or close. I have added comments to describe which services require what API sections. For example, if you do not use WatchTower, you can enter **0** for several of the API sections.
- If you need to use a port other than 2375 on the host machine (may be its already occupied), you may customize the left side (to the colon) of the ports section (e.g. 127.0.0.1:**2376**:2375).

##### Port Availability

You may check if a port is occupied on the host machine using the following command:

##### Restricted Content

Additional explanations and bonus content are available exclusively for the following members only:

Silver - Monthly, Silver - Yearly, Gold - Monthly, Gold - Yearly, Diamond - Monthly, Diamond - Yearly, and Platinum Lifetime (All-Inclusive)

Please support us by becoming a member to unlock the content.  
[Join Now](https://www.smarthomebeginner.com/membership-account/memberships-products-services/)

This will show all ports on which some service is listening, as shown below:

[

![Listening Ports](https://www.smarthomebeginner.com/images/2024/01/listening-ports-e1705612567188-740x238.jpg "Ultimate Docker Media Server: With 60+ Docker Compose Apps [2024] 15")

![Listening Ports](data:image/svg+xml,%3Csvg%20xmlns=%22http://www.w3.org/2000/svg%22%20viewBox=%220%200%20740%20238%22%3E%3C/svg%3E "Ultimate Docker Media Server: With 60+ Docker Compose Apps [2024] 15")](https://www.smarthomebeginner.com/images/2024/01/listening-ports-e1705612567188.jpg)

Listening Ports - Already Occupied

##### Add Socket Proxy to the Docker Stack

We created the **socket-proxy.yml** file. Now we need to add it to our **docker-compose-udms.yml** (Master Docker Compose) file. To do so, add the path to the **socket-proxy.yml** file (compose/udms/socket-proxy.yml) under the include block, as shown below:

1

2

3

4

5

6

7

8

9

10

11

12

13

14

15

16

17

18

`########################### NETWORKS`

`networks:`

`default:`

`driver:` `bridge`

`socket_proxy:`

`name:` `socket_proxy`

`driver:` `bridge`

`ipam:`

`config:`

`-` ` subnet``: ` `192.168.91.0/24`

`include:`

`########################### SERVICES`

`# PREFIX udms = Ultimate Docker Media Server`

`# HOSTNAME=udms - defined in .env`

`# CORE`

`-` `compose/$HOSTNAME/socket-proxy.yml`

Save the Master Docker Compose file. Reminder that **$HOSTNAME** here will be replaced with **udms** automatically (as defined in the **.env** file).

##### Starting and Testing Containers

After saving the `docker-compose-udms.yml` file, run the following command to start the container and check if the app is accessible:

1

`sudo` `docker compose -f` ` /home/anand/docker/docker-compose-udms``.yml up -d `

If you copy-paste Docker Compose snippets from my repository, do not forget to comment out **profiles**. If you do not, you will see the "no service selected" error as shown below.

[

![No Service Selected](https://www.smarthomebeginner.com/images/2024/01/no-service-selected-740x42.jpg "Ultimate Docker Media Server: With 60+ Docker Compose Apps [2024] 16")

![No Service Selected](data:image/svg+xml,%3Csvg%20xmlns=%22http://www.w3.org/2000/svg%22%20viewBox=%220%200%20740%2042%22%3E%3C/svg%3E "Ultimate Docker Media Server: With 60+ Docker Compose Apps [2024] 16")](https://www.smarthomebeginner.com/images/2024/01/no-service-selected.jpg)

No Service Selected

If you prefer to use Docker Profiles, then "**\--profile profile_name**" should be included with all Docker Compose commands (e.g. sudo docker compose **\--profile all** -f /home/anand/docker/docker-compose-udms.yml up -d).

If Socket Proxy starts successfully, you should see the following:

[

![Socket Proxy Started](https://www.smarthomebeginner.com/images/2024/01/socket-proxy-started-740x57.jpg "Ultimate Docker Media Server: With 60+ Docker Compose Apps [2024] 17")

![Socket Proxy Started](data:image/svg+xml,%3Csvg%20xmlns=%22http://www.w3.org/2000/svg%22%20viewBox=%220%200%20740%2057%22%3E%3C/svg%3E "Ultimate Docker Media Server: With 60+ Docker Compose Apps [2024] 17")](https://www.smarthomebeginner.com/images/2024/01/socket-proxy-started.jpg)

Socket Proxy Started

Usually, I also like to check the logs to ensure there are no errors using the following command (or **dclogs** or **dclogs socket-proxy** aliases in my case):

1

`sudo` `docker compose -f` ` /home/anand/docker/docker-compose-udms``.yml logs -tf --``tail``=``"50" ` `socket-proxy`

[

![Socket Proxy Logs](https://www.smarthomebeginner.com/images/2024/01/socket-proxy-logs-740x97.jpg "Ultimate Docker Media Server: With 60+ Docker Compose Apps [2024] 18")

![Socket Proxy Logs](data:image/svg+xml,%3Csvg%20xmlns=%22http://www.w3.org/2000/svg%22%20viewBox=%220%200%20740%2097%22%3E%3C/svg%3E "Ultimate Docker Media Server: With 60+ Docker Compose Apps [2024] 18")](https://www.smarthomebeginner.com/images/2024/01/socket-proxy-logs.jpg)

Socket Proxy Logs

If everything looks OK in the logs, press **Ctrl+C** to exit.

**Note:** Repeat the above sequence of starting the stack and checking logs after adding each container to `docker-compose-udms.yml` file.

##### Not Using Socket Proxy

In case you decide not to use Socket Proxy, the way services such as Portainer, Dozzle, Traefik, etc. access the Docker Socket will change.

Instead of adding the **DOCKER_HOST** environmental variable (to services that support it) as shown below:

1

`DOCKER_HOST: tcp://socket-proxy:2375`

you have to provide direct access to Docker socket under **volumes** section:

1

`- /var/run/docker.sock:/var/run/docker.sock:ro`

Not only is Docker Socket Proxy strongly recommended, but it is also recommended to have separate socket proxy containers for each service that needs access to the Docker Socket. This way, you can fine tune the API access based on need, instead of setting a generic access rule for all services. But to keep things simple, I only use one Socket Proxy service.

#### 2\. [Portainer](https://www.portainer.io/) - WebUI for Containers

We have covered Portainer installation [docker run command](https://www.smarthomebeginner.com/install-portainer-using-docker/) and [docker-compose](https://www.smarthomebeginner.com/portainer-docker-compose-guide/) in detail. [Portainer](https://github.com/portainer/portainer) provides a WebUI to manage all your docker containers. I strongly recommend this for newbies.

[

![Portainer Webui For Docker](https://www.smarthomebeginner.com/images/2018/04/docker-portainer-screenshot-740x239.jpg "Ultimate Docker Media Server: With 60+ Docker Compose Apps [2024] 19")

![Portainer Webui For Docker](data:image/svg+xml,%3Csvg%20xmlns=%22http://www.w3.org/2000/svg%22%20viewBox=%220%200%20740%20239%22%3E%3C/svg%3E "Ultimate Docker Media Server: With 60+ Docker Compose Apps [2024] 19")](https://www.smarthomebeginner.com/images/2018/04/docker-portainer-screenshot.jpg)

Portainer - Webui To Manage Docker Containers

It even allows several advanced admin tasks, including setting up stacks, managing containers, volumes, networks, etc.

##### Create Portainer Docker Compose

Let's create the Portainer Docker compose file. Head over to the [compose folder](https://github.com/htpcBeginner/docker-traefik/tree/master/compose) in my Github Repository, and then into any of the host folders. Find the compose file for Portainer and copy the contents.

Create a file called **portainer.yml** inside **/home/anand/docker/compose/udms**. Copy-paste the contents into **portainer.yml** compose file (pay attention to blank spaces at the beginning of each line).

1

2

3

4

5

6

7

8

9

10

11

12

13

14

15

16

17

18

19

20

`services:`

`# Portainer - WebUI for Containers`

`portainer:`

`container_name:` `portainer`

`image:` ` portainer/portainer-ce``:``latest ` `# Use portainer-ee if you have a Business Edition license key`

`security_opt:`

`-` ` no-new-privileges``:``true `

`restart:` `unless-stopped`

`# profiles: ["core", "all"]`

`networks:`

`-` `socket_proxy`

`# command: -H unix:///var/run/docker.sock # # Use Docker Socket Proxy instead for improved security`

`command:` ` -H tcp``:``//socket-proxy``:``2375 `

`ports:`

`-` `"9000:9000"`

`volumes:`

`# - /var/run/docker.sock:/var/run/docker.sock:ro # # Use Docker Socket Proxy instead for improved security`

`-` ` $DOCKERDIR/appdata/portainer/data``:``/data ` `# Change to local directory if you want to save/transfer config locally`

`environment:`

`-` `TZ=$TZ`

Here are some notes about the Portainer Docker Compose:

- Once again, Docker profiles is commented out as explained previously.
- We are going to let Portainer access the Docker Socket via Socket Proxy. For this:
  1.  We add Portainer to the **socket_proxy** network.
  2.  We add **command: -H tcp://socket-proxy:2375** so portainer knows to connect to socket-proxy host on port 2375, instead of directly connecting to the Docker Socket.
  3.  With the above two done, we can comment out access to **docker.sock** under **volumes** section.
- The environmental variable **$DOCKERDIR** is already defined in our .env file.
- All Portainer data is being stored in a portainer-specific folder within **appdata**.
- You may [check the availability of port](#port-availability) 9000 on the Docker host as explained previously and if needed change port on the host machine (left side of the colon) to something else (e.g. - "**9001**:9000").

##### Add Portainer to the Docker Stack

We created the **portainer.yml** file. Now we need to add it to our **docker-compose-udms.yml** file. To do so, add the path to the **portainer.yml** (compose/udms/portainer.yml) file under the include block, as shown below:

1

2

3

4

5

6

7

8

9

10

11

12

13

14

15

16

17

18

19

`########################### NETWORKS`

`networks:`

`default:`

`driver:` `bridge`

`socket_proxy:`

`name:` `socket_proxy`

`driver:` `bridge`

`ipam:`

`config:`

`-` ` subnet``: ` `192.168.91.0/24`

`include:`

`########################### SERVICES`

`# PREFIX udms = Ultimate Docker Media Server`

`# HOSTNAME=udms - defined in .env`

`# CORE`

`-` `compose/$HOSTNAME/socket-proxy.yml`

`-` `compose/$HOSTNAME/portainer.yml`

Save the Master Docker Compose file. **$HOSTNAME** here will be replaced with **udms** automatically (as defined in the **.env** file).

##### Starting and Accessing Portainer

As [explained previously](#starting-and-testing-containers), start the container and check the logs to make sure Portainer docker container is working fine before proceeding. If Portainer started properly, it can be accessed in the following ways:

1.  **Using Docker Host IP:** In this tutorial, it is **http://192.168.1.100:9000**, since we are connecting container's port 9000 to the host's port 9000.

##### Forwarding Ports

You may be tempted to [port forward](https://www.smarthomebeginner.com/setup-port-forwarding-on-router/) 9000 from your router to the Docker host. This would allow you to access Portainer from the internet, using your WAN/Public IP. DO NOT DO THIS. It is a security risk. A secure way to access services outside your internet network is to use a reverse proxy like Nginx Proxy Manager or Traefik, which will be covered later in this Docker server tutorial series.

#### 3\. [Dozzle](https://dozzle.dev/) - Real-time Docker Log Viewer

Now that you understand the basic workflow of adding containers, let's simplify it a bit more for convenience using Dozzle.

[Dozzle](https://dozzle.dev/#more) is a simple and responsive application that provides you with a web-based interface to monitor your Docker container logs live. It doesn’t store log information; it is for live monitoring of your container logs only.

I quickly became a big fan of it. Dozzle allows you to monitor logs of all your docker containers in real-time. This helps to troubleshoot and fix issues.

[

![Docker Containers Monitoring And Logs ](https://www.smarthomebeginner.com/images/2024/01/dozzle-screenshot-740x255.jpg "Ultimate Docker Media Server: With 60+ Docker Compose Apps [2024] 20")

![Docker Containers Monitoring And Logs ](data:image/svg+xml,%3Csvg%20xmlns=%22http://www.w3.org/2000/svg%22%20viewBox=%220%200%20740%20255%22%3E%3C/svg%3E "Ultimate Docker Media Server: With 60+ Docker Compose Apps [2024] 20")](https://www.smarthomebeginner.com/images/2024/01/dozzle-screenshot.jpg)

Docker Containers Monitoring And Logs

I have covered [Dozzle logs viewer](https://www.smarthomebeginner.com/dozzle-docker-compose-guide/) for real-time logs viewing.">Dozzle Docker Compose installation in a separate guide for beginners, if you are interested.

##### Create Dozzle Docker Compose

Let's create the Dozzle Docker compose file. Head over to the [compose folder](https://github.com/htpcBeginner/docker-traefik/tree/master/compose) in my Github Repository, and then into any of the host folders. Find the compose file for Dozzle and copy the contents.

Create a file called **dozzle.yml** inside **/home/anand/docker/compose/udms**. Copy-paste the contents into **dozzle.yml** compose file (pay attention to blank spaces at the beginning of each line).

1

2

3

4

5

6

7

8

9

10

11

12

13

14

15

16

17

18

19

20

21

22

`services:`

`# Dozzle - Real-time Docker Log Viewer`

`dozzle:`

`image:` ` amir20/dozzle``:``latest `

`container_name:` `dozzle`

`security_opt:`

`-` ` no-new-privileges``:``true `

`restart:` `unless-stopped`

`# profiles: ["apps", "all"]`

`networks:`

`-` `socket_proxy`

`-` `default`

`ports:`

`-` `"8082:8080"`

`environment:`

`DOZZLE_LEVEL:` `info`

`DOZZLE_TAILSIZE:` `300`

`DOZZLE_FILTER:` `"status=running"`

`# DOZZLE_FILTER: "label=log_me" # limits logs displayed to containers with this label`

`DOCKER_HOST:` ` tcp``:``//socket-proxy``:``2375 `

`# volumes:`

`#  - /var/run/docker.sock:/var/run/docker.sock # Use Docker Socket Proxy instead for improved security`

Here are some notes about the Dozzle Docker Compose:

- Third Reminder: Docker profiles is commented out as explained previously.
- We are going to let Dozzle access the Docker Socket via Socket Proxy. For this, again:
  1.  We add Dozzle to the **socket_proxy** network.
  2.  We specify a custom Docker Host using the environment variable **DOCKER_HOST: tcp://socket-proxy:2375**.
  3.  With the above two done, we can comment out access to **docker.sock** under **volumes** section.
- We are also adding Dozzle to **default** network so it can see containers on that network.
- You may [check the availability of port](#port-availability) 8080 on the Docker host as explained previously. Mine was occupied so I changed it to 8082 on the Docker Host side.

There are a few more things you can customize in the environment variables, to your liking.

##### Add Dozzle to the Docker Stack

We created the **dozzle.yml** file. Now we need to add it to our **docker-compose-udms.yml** file. To do so, add the path to the **dozzle.yml** (compose/udms/dozzle.yml) file under the include block, as shown below:

1

2

3

4

5

6

7

8

9

10

11

12

13

14

15

16

17

18

19

20

`########################### NETWORKS`

`networks:`

`default:`

`driver:` `bridge`

`socket_proxy:`

`name:` `socket_proxy`

`driver:` `bridge`

`ipam:`

`config:`

`-` ` subnet``: ` `192.168.91.0/24`

`include:`

`########################### SERVICES`

`# PREFIX udms = Ultimate Docker Media Server`

`# HOSTNAME=udms - defined in .env`

`# CORE`

`-` `compose/$HOSTNAME/socket-proxy.yml`

`-` `compose/$HOSTNAME/portainer.yml`

`-` `compose/$HOSTNAME/dozzle.yml`

Save the Master Docker Compose file.

##### Starting and Accessing Dozzle

As [explained previously](#starting-and-testing-containers), start the container and check the logs to make sure Dozzle docker container is working fine before proceeding. If Dozzle started properly, it can be accessed in the following ways:

1.  **Using Docker Host IP:** In this tutorial, it is **http://192.168.1.100:8082**, since we are connecting container's port 8080 to the host's port 8082.

**FORWARDING PORTS:** DO NOT forward port 8082 on the router to the Docker Host to enable access outside your home. There are more secure alternatives as [explained above](#forwarding-ports).

##### Easier Log Viewing

Moving forward, you can leave the Dozzle window open while you add more services. As and when you add more containers, you can refresh the Dozzle window and follow the logs on Dozzle instead of command line interface.

[

![Viewing Docker Container Logs On Dozzle](https://www.smarthomebeginner.com/images/2024/01/dozzle-log-viewing-740x211.jpg "Ultimate Docker Media Server: With 60+ Docker Compose Apps [2024] 21")

![Viewing Docker Container Logs On Dozzle](data:image/svg+xml,%3Csvg%20xmlns=%22http://www.w3.org/2000/svg%22%20viewBox=%220%200%20740%20211%22%3E%3C/svg%3E "Ultimate Docker Media Server: With 60+ Docker Compose Apps [2024] 21")](https://www.smarthomebeginner.com/images/2024/01/dozzle-log-viewing.jpg)

Viewing Docker Container Logs On Dozzle

#### 4\. [Homepage](https://github.com/benphelps/homepage) - Application Dashboard

We are going to be adding a bunch of apps to our Docker server, which are only available on the internal network using **http://DOCKER-HOST-IP:PORT**. But what if you do not remember or want to remember all the port numbers?

This is where an application dashboard such as Homepage can come in handy. I started with [Organizer](https://github.com/causefx/Organizr), then moved to [Heimdall](https://heimdall.site/). I tried a few others such as [Dashy](https://dashy.to/), [Homarr](https://github.com/ajnart/homarr), and [Flame](https://github.com/pawelmalak/flame). To me, Homepage seems simple and easy to use.

[

![Homepage Application Dashboard](https://www.smarthomebeginner.com/images/2024/01/homepage-screenshot-740x313.jpg "Ultimate Docker Media Server: With 60+ Docker Compose Apps [2024] 22")

![Homepage Application Dashboard](data:image/svg+xml,%3Csvg%20xmlns=%22http://www.w3.org/2000/svg%22%20viewBox=%220%200%20740%20313%22%3E%3C/svg%3E "Ultimate Docker Media Server: With 60+ Docker Compose Apps [2024] 22")](https://www.smarthomebeginner.com/images/2024/01/homepage-screenshot.jpg)

Homepage Application Dashboard

##### Create Homepage Docker Compose

Let's create the Homepage Docker compose file. Head over to the [compose folder](https://github.com/htpcBeginner/docker-traefik/tree/master/compose) in my Github Repository, and then into any of the host folders. Find the compose file for Homepage and copy the contents.

Create a file called **homepage.yml** inside **/home/anand/docker/compose/udms**. Copy-paste the contents into **homepage.yml** compose file (pay attention to blank spaces at the beginning of each line).

1

2

3

4

5

6

7

8

9

10

11

12

13

14

15

16

17

18

19

20

`services:`

`# Homepage - Application Dashboard`

`homepage:`

`image:` ` ghcr.io/gethomepage/homepage``:``latest `

`container_name:` `homepage`

`security_opt:`

`-` ` no-new-privileges``:``true `

`restart:` `unless-stopped`

`# profiles: ["apps", "all"]`

`networks:`

`-` `socket_proxy`

`-` `default`

`ports:`

`-` `"3000:3000"`

`volumes:`

`-` ` $DOCKERDIR/appdata/homepage``:``/app/config `

`environment:`

`TZ:` `$TZ`

`PUID:` `$PUID`

`PGID:` `$PGID`

Here are some notes about the Homepage Docker Compose:

- Fourth Reminder: Docker profiles is commented out as explained previously.
- We are adding Homepage to **socket_proxy** network so it can interact with the Docker socket to read information on Docker containers. We are also making it part of the **default** network. Essentially, Homepage should be part of the networks of all the apps that you want it to interact with and get metrics. But if you are just adding a shortcut link to the app, then adding those networks is not needed.
- You may [check the availability of port](#port-availability) 3000 on the Docker host as explained previously. Mine was free on the Docker Host side.

##### Add Homepage to the Docker Stack

We created the **homepage.yml** file. Now we need to add it to our **docker-compose-udms.yml** file. To do so, add the path to the **homepage.yml** (compose/udms/homepage.yml) file under the include block, as shown below:

1

2

3

4

5

6

7

8

9

10

11

12

13

14

15

16

17

18

19

20

21

`########################### NETWORKS`

`networks:`

`default:`

`driver:` `bridge`

`socket_proxy:`

`name:` `socket_proxy`

`driver:` `bridge`

`ipam:`

`config:`

`-` ` subnet``: ` `192.168.91.0/24`

`include:`

`########################### SERVICES`

`# PREFIX udms = Ultimate Docker Media Server`

`# HOSTNAME=udms - defined in .env`

`# CORE`

`-` `compose/$HOSTNAME/socket-proxy.yml`

`-` `compose/$HOSTNAME/portainer.yml`

`-` `compose/$HOSTNAME/dozzle.yml`

`-` `compose/$HOSTNAME/homepage.yml`

Save the Master Docker Compose file.

##### Starting and Accessing Homepage

As [explained previously](#starting-and-testing-containers), start the container and check the logs to make sure Homepage docker container is working fine before proceeding. If Homepage started properly, it can be accessed in the following ways:

1.  **Using Docker Host IP:** In this tutorial, it is **http://192.168.1.100:3000**, since we are mapping container's port 3000 to the host's port 3000.

**FORWARDING PORTS:** DO NOT forward port 3000 on the router to the Docker Host to enable access outside your home. There are more secure alternatives as [explained above](#forwarding-ports).

### Media Server Apps

This section is why you are probably here. There are several [media server](https://www.smarthomebeginner.com/best-plex-alternatives-2022/), [live TV server](https://www.smarthomebeginner.com/best-tv-server-2023/), and [music server](https://www.smarthomebeginner.com/best-music-server-software-options/) options.

In my opinion, the best media server for videos are Plex and Jellyfin, depending on your needs. For music, I use Airsonic-Advanced due to its one main unique feature: being able to provide folder level access to users.

Let add the comment line (**\# MEDIA**) to the master Docker Compose file (don't ignore the 2 blank spaces in the front) under the include block.

1

2

3

4

5

6

7

8

9

10

11

12

13

14

15

16

17

18

19

20

21

22

`########################### NETWORKS`

`networks:`

`default:`

`driver:` `bridge`

`socket_proxy:`

`name:` `socket_proxy`

`driver:` `bridge`

`ipam:`

`config:`

`-` ` subnet``: ` `192.168.91.0/24`

`include:`

`########################### SERVICES`

`# PREFIX udms = Ultimate Docker Media Server`

`# HOSTNAME=udms - defined in .env`

`# CORE`

`-` `compose/$HOSTNAME/socket-proxy.yml`

`-` `compose/$HOSTNAME/portainer.yml`

`-` `compose/$HOSTNAME/dozzle.yml`

`-` `compose/$HOSTNAME/homepage.yml`

`# MEDIA`

There are many services that I call "Media", in my [GitHub repo](https://github.com/htpcbeginner/docker-traefik). In this Docker server tutorial, I am only going to show Plex and Jellyfin.

Installing Apps such as Portainer, Dozzle, etc. would take less than 20 seconds using the [Auto-Traefik](https://www.smarthomebeginner.com/auto-traefik/) script. Take a look:

Auto Traefik 2 (Part 8) - Adding Additional Apps to the Stack

[![Auto Traefik 2 (Part 8) - Adding Additional Apps To The Stack](https://www.smarthomebeginner.com/wp-content/plugins/wp-youtube-lyte/lyteCache.php?origThumbUrl=https%3A%2F%2Fi.ytimg.com%2Fvi%2FGK0YKA5q1XE%2F0.jpg "Ultimate Docker Media Server: With 60+ Docker Compose Apps [2024] 23")](https://youtu.be/GK0YKA5q1XE)

[Watch this video on YouTube](https://youtu.be/GK0YKA5q1XE).

#### 5\. [Plex](https://www.plex.tv/) - Media Server

Let's see how to add Plex Media Server to our Docker Stack. Here, I am going to introduce [Docker Secrets](https://www.smarthomebeginner.com/traefik-docker-security-best-practices/#8_Use_Docker_Secrets).

[Plex media server](https://www.plex.tv/) is a free media server that can stream local and internet content to you several of your devices. It has a server component that catalogs your media (movies, tv shows, photos, videos, music, etc.). \[**Read:** [10 Best Media Server for Plex + one SURPRISING bonus \[2022\]](https://www.smarthomebeginner.com/best-media-server-for-plex-2022/)\]

To stream, you need the client app installed on [compatible Plex client devices](https://www.smarthomebeginner.com/best-plex-client-devices-2022/). This can cost some money.

[

![Plex - Docker Media Server](https://www.smarthomebeginner.com/images/2018/04/plex-web-interface-740x289.jpg "Ultimate Docker Media Server: With 60+ Docker Compose Apps [2024] 24")

![Plex - Docker Media Server](data:image/svg+xml,%3Csvg%20xmlns=%22http://www.w3.org/2000/svg%22%20viewBox=%220%200%20740%20289%22%3E%3C/svg%3E "Ultimate Docker Media Server: With 60+ Docker Compose Apps [2024] 24")](https://www.smarthomebeginner.com/images/2018/04/plex-web-interface.jpg)

Plex Media Server

With free movies, TV, curated content, and Plexamp music, lifetime Plex Pass is a great value.

> ##### Best Plex Client Devices:
>
> 1.  [NVIDIA SHIELD TV Pro Home Media Server](https://www.amazon.com/dp/B07YP9FBMM/?tag=shbeg-20) - $199.99
>
>     ![Editors Pick](https://www.smarthomebeginner.com/images/2016/07/editors-pick.png "Ultimate Docker Media Server: With 60+ Docker Compose Apps [2024] 25")
>
>     ![Editors Pick](data:image/svg+xml,%3Csvg%20xmlns=%22http://www.w3.org/2000/svg%22%20viewBox=%220%200%2075%2020%22%3E%3C/svg%3E "Ultimate Docker Media Server: With 60+ Docker Compose Apps [2024] 25")
>
> 2.  [Amazon Fire TV Streaming Media Player](https://www.amazon.com/dp/B00U3FPN4U/?tag=htpcbeg-20) - $89.99
> 3.  [Roku Premiere+ 4K UHD](https://www.amazon.com/dp/B01LXUZPQU/?tag=htpcbeg-20) - $83.99
> 4.  [CanaKit Raspberry Pi 3 Complete Starter Kit](https://www.amazon.com/dp/B01C6Q2GSY/?tag=htpcbeg-20) - $69.99
> 5.  [Xbox One 500 GB Console](https://www.amazon.com/dp/B00KAI3KW2/?tag=htpcbeg-20) - $264.99

I have covered [Plex docker setup](https://www.smarthomebeginner.com/plex-docker-compose/) with Docker Compose, separately if you are interested.

##### Create Additional Environment Variables for Plex

First, we need to add some environment variables. Edit your **.env** file using:

1

`sudo` `nano` ` /home/anand/docker/``.``env `

Add the **SERVER_IP** and **LOCAL_IPS** variables at the end, as shown below:

1

2

3

4

5

6

7

8

9

`PUID=1000`

`PGID=1000`

` TZ=``"Europe/Zurich" `

` USERDIR=``"/home/anand" `

` DOCKERDIR=``"/home/anand/docker" `

` DATADIR=``"/media/storage" `

` HOSTNAME=``"udms" `

`SERVER_IP=192.168.1.100`

` LOCAL_IPS=127.0.0.1``/32``,10.0.0.0``/8``,192.168.0.0``/16``,172.16.0.0``/12 `

You may leave the **LOCAL_IPS** typically. However, be sure to change the **SERVER_IP** to your Docker host's LAN IP address.

##### Create Plex Claim Docker Secret

In addition to the environmental variables defined above, you will also have to define **PLEX_CLAIM**, which is your [Plex claim token](https://support.plex.tv/articles/204059436-finding-an-authentication-token-x-plex-token/).

If you are creating a brand new Plex server, you can skip this part for now as you won't have a claim token yet. You may come back and add it later on so Plex knows that this Plex server instance is claimed in your account.

Let's take this opportunity to learn about Docker Secrets. After you have obtained your claim token, add the following secrets section to **docker-compose-udms.yml**, right between the **networks** and **include** blocks:

1

2

3

4

`########################### SECRETS`

`secrets:`

`plex_claim:`

`file:` `$DOCKERDIR/secrets/plex_claim`

So far, the master Docker Compose file should look like this;

1

2

3

4

5

6

7

8

9

10

11

12

13

14

15

16

17

18

19

20

21

22

23

24

25

26

27

`########################### NETWORKS`

`networks:`

`default:`

`driver:` `bridge`

`socket_proxy:`

`name:` `socket_proxy`

`driver:` `bridge`

`ipam:`

`config:`

`-` ` subnet``: ` `192.168.91.0/24`

`########################### SECRETS`

`secrets:`

`plex_claim:`

`file:` `$DOCKERDIR/secrets/plex_claim`

`include:`

`########################### SERVICES`

`# PREFIX udms = Ultimate Docker Media Server`

`# HOSTNAME=udms - defined in .env`

`# CORE`

`-` `compose/$HOSTNAME/socket-proxy.yml`

`-` `compose/$HOSTNAME/portainer.yml`

`-` `compose/$HOSTNAME/dozzle.yml`

`-` `compose/$HOSTNAME/homepage.yml`

`# MEDIA`

You have defined a secret with the name **plex_claim**, which refers to the file **/home/anand/docker/secrets/plex_claim**. But this file doesn't exist. So, let's create it.

1

`sudo` `nano` `/home/anand/docker/secrets/plex_claim`

Note that you have to use **sudo** as the file is inside a secrets folder that is owned by the user **root**. What goes inside the file is only your Plex Claim token, like so:

[

![Docker Secrets Plex Claim](https://www.smarthomebeginner.com/images/2024/01/docker-secrets-plex-claim.jpg "Ultimate Docker Media Server: With 60+ Docker Compose Apps [2024] 26")

![Docker Secrets Plex Claim](data:image/svg+xml,%3Csvg%20xmlns=%22http://www.w3.org/2000/svg%22%20viewBox=%220%200%20415%2077%22%3E%3C/svg%3E "Ultimate Docker Media Server: With 60+ Docker Compose Apps [2024] 26")](https://www.smarthomebeginner.com/images/2024/01/docker-secrets-plex-claim.jpg)

Docker Secrets Plex Claim

Press **Ctrl X**, **Y**, and **Enter** to save and exit.

##### Create Plex Docker Compose

Let's create the Plex Docker compose file. But first, add the following to your **.env** file:

1

` LOCAL_IPS=127.0.0.1/32``,``10.0.0.0/8``,``192.168.0.0/16``,``172.16.0.0/12 `

We will use the **LOCAL_IPS** variable to let Plex know to treat the above IP ranges as local network.

Next, head over to the [compose folder](https://github.com/htpcBeginner/docker-traefik/tree/master/compose) in my GitHub Repository, and then into any of the host folders. Find the compose file for Plex and copy the contents.

Create a file called **plex.yml** inside **/home/anand/docker/compose/udms**. Copy-paste the contents into **plex.yml** compose file (pay attention to blank spaces at the beginning of each line).

1

2

3

4

5

6

7

8

9

10

11

12

13

14

15

16

17

18

19

20

21

22

23

24

25

26

27

28

29

30

31

32

33

34

35

36

37

38

`services:`

`# Plex - Media Server`

`plex:`

`image:` ` plexinc/pms-docker``:``plexpass `

`container_name:` `plex`

`networks:`

`-` `default`

`security_opt:`

`-` ` no-new-privileges``:``true `

`restart:` `"no"`

`# profiles: ["media", "all"]`

`devices:`

`-` ` /dev/dri``:``/dev/dri ` `# for hardware transcoding`

`ports:`

`-` `"32400:32400/tcp"`

`-` `"3005:3005/tcp"`

`-` `"8324:8324/tcp"`

`-` `"32469:32469/tcp"`

`-` `"1900:1900/udp"`

`-` `"32410:32410/udp"`

`-` `"32412:32412/udp"`

`-` `"32413:32413/udp"`

`-` `"32414:32414/udp"`

`volumes:`

`-` ` $DOCKERDIR/appdata/plex``:``/config `

`-` ` $DATADIR/data/media``:``/data/media1 ` `# Media Folder 1`

`-` ` $DATADIR/data2/media``:``/data/media2 ` `# Media Folder 2`

`-` ` /dev/shm``:``/data/transcode ` `# Offload transcoding to RAM if you have enough RAM`

`environment:`

`TZ:` `$TZ`

`HOSTNAME:` `"myPlex"`

`PLEX_CLAIM_FILE:` `/run/secrets/plex_claim` `# Not required initially`

`PLEX_UID:` `$PUID`

`PLEX_GID:` `$PGID`

`ADVERTISE_IP:` `"[http://](http://)$SERVER_IP:32400/"`

`ALLOWED_NETWORKS:` `$LOCAL_IPS`

`secrets:`

`-` `plex_claim`

Here are some notes about the Plex Docker Compose:

- Fourth Reminder: Docker profiles is commented out as explained previously.
- We are going to put Plex on the default network.
- Notice that I set the restart policy to "no" for Plex. You may change it to "unless-stopped" as with other containers in this guide.

  **Why did I set Plex to not auto start?** Because I want to ensure that my media folders are mounted before Plex (or other media servers) starts. I wrote a custom script for this, which you may find in the [scripts folder](https://github.com/htpcBeginner/docker-traefik/tree/master/scripts) of my GitHub repo. This script runs at boot time, waits for media folders to be mounted, and then starts all the media folder dependent containers.

  This is where I use **Docker Profiles**.

  ##### Restricted Content

  Additional explanations and bonus content are available exclusively for the following members only:

  Silver - Monthly, Silver - Yearly, Gold - Monthly, Gold - Yearly, Diamond - Monthly, Diamond - Yearly, and Platinum Lifetime (All-Inclusive)

  Please support us by becoming a member to unlock the content.  
  [Join Now](https://www.smarthomebeginner.com/membership-account/memberships-products-services/)

- If your docker host has a graphics card (you will see **/dev/dri**) that you can use for hardware accelerated transcoding then you can pass this on. We do this using the **devices**. This is especially useful for [NASes that support Plex](https://www.smarthomebeginner.com/best-nas-with-plex-server-support-2022/) (e.g. Synology).
- I am specifying two media folders, but you may have only one to pass on to Plex container.
- strong>/ dev/shm is the RAM memory, which we are passing for faster transcoding purposes. If you are short on memory, you could comment this out.
- Previously we defined the Docker Secret for Plex Claim Token. Skip this step if you are setting up a brand new Plex media server. To use it inside the container, we have to do two things:
  1.  Define a **secrets** section in the Docker Compose for Plex and list the name of the secret (**plex_claim**).
  2.  Set the environment variable **PLEX_CLAIM_FILE** to **/run/secrets/plex_claim**.
- We are also specifying the advertise IP using the environment variable **$SERVER_IP**. If you have multiple IPs for the server (e.g. multiple network interfaces), you can list them here separated by comma.
- We are also passing all the typical LAN subnets as **$LOCAL_IPS**. This helps Plex to treat all these networks as local. This is also helpful when you want to disable authentication on local network.
- Plex uses lots of ports. You may [check the availability of ports](#port-availability) on the Docker host as explained previously and make changes if necessary.

##### Creating Additional Docker Secrets

As shown above, the typical workflow to add more secrets involves:

1.  Create the secret file inside /home/user/docker/secrets folder, owned by root:root and with 600 permissions.
2.  [Define it globally](#create-docker-secret) in the master docker compose file
3.  [Call it](#define-docker-secrets-section) in the **secrets** section of the service
4.  [Set relevant environment variable](#use-secrets-in-environment) to **/run/secrets/secret_name**

Keep in mind that the Docker Image must support secrets feature for Docker Secrets to work. Not all of them do.

##### Add Plex to the Docker Stack

We created the **plex.yml** file. Now we need to add it to our **docker-compose-udms.yml** file. To do so, add the path to the **plex.yml** (compose/udms/plex.yml) file under the include block, as shown below:

1

2

3

4

5

6

7

8

9

10

11

12

13

14

15

16

17

18

19

20

21

22

23

24

25

26

27

28

`########################### NETWORKS`

`networks:`

`default:`

`driver:` `bridge`

`socket_proxy:`

`name:` `socket_proxy`

`driver:` `bridge`

`ipam:`

`config:`

`-` ` subnet``: ` `192.168.91.0/24`

`########################### SECRETS`

`secrets:`

`plex_claim:`

`file:` `$DOCKERDIR/secrets/plex_claim`

`include:`

`########################### SERVICES`

`# PREFIX udms = Ultimate Docker Media Server`

`# HOSTNAME=udms - defined in .env`

`# CORE`

`-` `compose/$HOSTNAME/socket-proxy.yml`

`-` `compose/$HOSTNAME/portainer.yml`

`-` `compose/$HOSTNAME/dozzle.yml`

`-` `compose/$HOSTNAME/homepage.yml`

`# MEDIA`

`-` `compose/$HOSTNAME/plex.yml`

Save the Master Docker Compose file.

##### Starting and Accessing Plex

As [explained previously](#starting-and-testing-containers), start the container and check the logs to make sure Plex docker container is working fine before proceeding. If Plex started properly, it can be accessed in the following ways:

1.  **Using Docker Host IP:** In this tutorial, it is **http://192.168.1.100:32400/web/**, since we are connecting container's port 32400 to the host's port 32400.

The first time you try to access a new Plex server you will either have to be on the local Plex server machine and use **http://localhost:32400/web** or use the IP address of the Plex server (e.g. **http://192.168.1.100:32400/web**). You will not be able to access the Plex server externally.

**FORWARDING PORTS:** Although it is relatively safe to forward 32400 from your router to the Plex Server for external access. It is still not recommended. There are more secure alternatives as [explained above](#forwarding-ports).

### Adding Additional Apps to the Docker Stack

With the above 4 apps (Socket Proxy, Portainer, Dozzle, and Plex), I have covered all the basics of creating Docker Server Stacks. So, **I hope you did not skip those sections**.

Moving forward, the concepts and workflow are the same. So, I will keep the explanations to a minimum and just list the steps for a few more apps as examples.

**Which media server(s) do you use?**

- Plex
- Jellyfin
- Emby
- Kodi
- Media Portal
- Subsonic
- Airsonic
- Madsonic
- Stremio
- Medusa
- Other

[View Results](#ViewPollResults "View Results Of This Poll")

![Loading ...](https://www.smarthomebeginner.com/wp-content/plugins/wp-polls/images/loading.gif "Loading ...")

![Loading ...](data:image/svg+xml,%3Csvg%20xmlns=%22http://www.w3.org/2000/svg%22%20viewBox=%220%200%2016%2016%22%3E%3C/svg%3E "Loading ...") Loading ...

#### 6\. [Jellyfin](https://jellyfin.org/) - Free and Awesome Media Server

[

![Jellyfin Media Server](https://www.smarthomebeginner.com/images/2023/04/jellyfin-interface-1-740x448.jpg "Ultimate Docker Media Server: With 60+ Docker Compose Apps [2024] 27")

![Jellyfin Media Server](data:image/svg+xml,%3Csvg%20xmlns=%22http://www.w3.org/2000/svg%22%20viewBox=%220%200%20740%20448%22%3E%3C/svg%3E "Ultimate Docker Media Server: With 60+ Docker Compose Apps [2024] 27")](https://www.smarthomebeginner.com/images/2023/04/jellyfin-interface-1.jpg)

Jellyfin Media Server

Jellyfin is the Free Software Media System that puts you in control of your media, allowing you to access, manage and stream from home or away. Jellyfin is the first choice for many because it is an [alternative to the proprietary Plex and Emby home media servers](https://www.smarthomebeginner.com/plex-vs-emby-kodi-jellyfin-2020/).

Jellyfin also supports several [client devices](https://www.smarthomebeginner.com/best-jellyfin-client-devices-2022/) and can be supercharged with several [awesome plugins](https://www.smarthomebeginner.com/best-jellyfin-plugins-2022/).

Jellyfin was originally forked from Emby 3.5, but eventually became its own application quite different from Emby. Jellyfin does not require a premium license or features for the same remote access for Plex and Emby. Though you may have to be a bit tech-savvy to use Jellyfin, those who do often never return to Plex or Emby again.

Jellyfin Docker installation be found in my [Jellyfin Docker Compose guide](https://www.smarthomebeginner.com/jellyfin-docker-compose/) or [GitHub repo](https://github.com/htpcbeginner/docker-traefik).

##### Jellyfin Docker Compose

Create Jellyfin Docker Compose File (/home/anand/docker/compose/udms/jellfin.yml), with the following contents:

1

2

3

4

5

6

7

8

9

10

11

12

13

14

15

16

17

18

19

20

21

22

23

24

25

26

`services:`

`# Jellyfin - Media Server`

`jellyfin:`

`image:` ` jellyfin/jellyfin``:``latest `

`container_name:` `jellyfin`

`networks:`

`-` `default`

`security_opt:`

`-` ` no-new-privileges``:``true `

`restart:` `"no"`

`# profiles: ["media", "all"]`

`user:` ` $PUID``:``$PGID `

`devices:`

`-` ` /dev/dri``:``/dev/dri ` `# for harware transcoding`

`ports:`

`-` `"8096:8096"`

`# - "8920:8920" # Emby also uses same port if running both`

`environment:`

`UMASK_SET:` `022`

`TZ:` `$TZ`

`volumes:`

`-` ` $DOCKERDIR/appdata/jellyfin``:``/config `

`-` ` $DATADIR/data/media``:``/data/media1 `

`-` ` $DATADIR/data2/media``:``/data/media2 `

`-` ` $EXTDIR/ssd/home-server/downloads``:``/data/downloads `

`-` ` /dev/shm``:``/data/transcode ` `# Offload transcoding to RAM if you have enough RAM`

##### Add Jellfin to the Docker Stack

Add Jellyfin to the master **docker-compose-udms.yml**:

1

2

3

4

`...`

`# MEDIA`

`-` `compose/$HOSTNAME/plex.yml`

`-` `compose/$HOSTNAME/jellyfin.yml`

[Start and test](#starting-and-testing-containers) the Jellyfin container. Jellyfin should be available at **http://192.168.1.100:8096**. Do not forward port 8096 on the router to the Jellyfin server. Instead use more [secure alternatives](#forwarding-ports).

#### 7\. [SABnzbd](https://sabnzbd.org/) - Binary newsgrabber (NZB downloader)

[

![Sabnzbd Usenet Downloader](https://www.smarthomebeginner.com/images/2014/03/sabnzbd-interface-ft.png "Ultimate Docker Media Server: With 60+ Docker Compose Apps [2024] 28")

![Sabnzbd Usenet Downloader](data:image/svg+xml,%3Csvg%20xmlns=%22http://www.w3.org/2000/svg%22%20viewBox=%220%200%20699%20378%22%3E%3C/svg%3E "Ultimate Docker Media Server: With 60+ Docker Compose Apps [2024] 28")](https://www.smarthomebeginner.com/images/2014/03/sabnzbd-interface-ft.png)

Sabnzbd Usenet Downloader

SABnzbd is an Open-Source Binary Newsreader that makes Usenet easy through automation. When you add an `.nzb` file, SABnzbd automatically verifies, repairs, extracts, and archives your download. Sonarr, Radarr, and Lidarr integrate with SABnzbd easily. \[**Read:** [Complete Usenet Guide: What is Usenet, Usenet vs torrents, Downloading Files](https://www.smarthomebeginner.com/complete-usenet-guide/)\]

SABnzbd can also handle RSS feeds. An easy setup wizard and self-analysis tools can be used to verify your setup.

You can manage SABnzbd through a web browser from just about any PC, smartphone, or Android device through the Glitter interface. Alternatively, you can use apps like LunaSea for Android and iOS, nzb360 for Android, and nzbUnity on the iPhone and iPad. SABnzbd runs on Windows, macOS, Unix, and NAS devices.

SABnzbd Docker-Compose can be found in my [GitHub repo](https://github.com/htpcbeginner/docker-traefik).

##### SABnzbd Docker Compose

Create SABnzbd Docker Compose File (/home/anand/docker/compose/udms/sabnzbd.yml), with the following contents:

1

2

3

4

5

6

7

8

9

10

11

12

13

14

15

16

17

18

19

20

21

`services:`

`# SABnzbd - Binary newsgrabber (NZB downloader)`

`sabnzbd:`

`image:` ` lscr.io/linuxserver/sabnzbd``:``latest `

`container_name:` `sabnzbd`

`security_opt:`

`-` ` no-new-privileges``:``true `

`restart:` `unless-stopped`

`# profiles: ["apps", "downloads", "all"]`

`networks:`

`-` `default`

`ports:`

`-` `"8084:8080"`

`volumes:`

`-` ` $DOCKERDIR/appdata/sabnzbd``:``/config `

`-` ` $DATADIR/downloads``:``/data/downloads `

`environment:`

`PUID:` `$PUID`

`PGID:` `$PGID`

`TZ:` `$TZ`

`UMASK_SET:` `002`

##### Add SABnzbd to the Docker Stack

Add SABnzbd to the master **docker-compose-udms.yml**:

1

2

3

4

`...`

`-` `compose/$HOSTNAME/jellyfin.yml`

`# DOWNLOADERS`

`-` `compose/$HOSTNAME/sabnzbd.yml`

[Start and test](#starting-and-testing-containers) the SABnzbd container. SABnzbd should be available at **http://192.168.1.100:8084**. Do not forward port 8084 on the router to the SABnzbd host server. Instead use more [secure alternatives](#forwarding-ports).

> **Show your support for FREE. Be the 1 in 200,000.**
>
> Get your [VPN](https://www.smarthomebeginner.com/go/surfshark-vpn "Surfshark") and USENET through our affiliate links (exclusive discounts):
>
> - **[SurfShark VPN](https://www.smarthomebeginner.com/go/surfshark-vpn):** 82% Off + 4 Months FREE, Wireguard support.
> - **[NewsHosting Usenet](https://www.smarthomebeginner.com/go/newshosting):** 58% Off, 5000+ Retention Days, Unlimited, VPN included.
> - **[Eweka Usenet](https://www.smarthomebeginner.com/go/eweka-usenet):** Lifetime Discount: EU and US Servers, Unlimited.

#### 8\. [qBittorrent](https://www.qbittorrent.org/) - Torrent downloader

[

![Qbittorrent Torrent Downloader](https://www.smarthomebeginner.com/images/2017/02/qBittorrent-Interface-740x394.png "Ultimate Docker Media Server: With 60+ Docker Compose Apps [2024] 29")

![Qbittorrent Torrent Downloader](data:image/svg+xml,%3Csvg%20xmlns=%22http://www.w3.org/2000/svg%22%20viewBox=%220%200%20740%20394%22%3E%3C/svg%3E "Ultimate Docker Media Server: With 60+ Docker Compose Apps [2024] 29")](https://www.smarthomebeginner.com/images/2017/02/qBittorrent-Interface.png)

Qbittorrent Torrent Downloader

qBittorrent is one of the best torrent clients you can use. It is fast, easy, and free to use. You can install it as a native macOS GUI app, or on Windows, Linux, and BSD. We have covered [qBittorrent installation on Linux](https://www.smarthomebeginner.com/install-qbittorrent-webui-ubuntu/) previously. But Docker is so much easier.

qBittorrent uses very little memory with light overhead, which makes it well-suited for home media servers. You can configure watch directories, bad peer blocklists, UPnP and NAT-PMP port forwarding, webseed support, tracker editing, global and per-torrent speed limits, and more. With an easy-to-use web interface, encryption, and peer exchange, qBittorrent opens magnetic links and handles DHT and µTP.

Along with Prowlarr, [torrent websites](https://www.smarthomebeginner.com/best-torrent-sites-in-2018-top-torrent-sites-in-2018/), or [private torrent trackers](https://www.smarthomebeginner.com/best-private-torrent-trackers/), you will have yourself a content aggregation machine.

If there is one Docker container that you need to put behind a secure VPN, then that would be your torrent client. Be sure to check out our [Docker Gluetun VPN Killswitch](https://www.smarthomebeginner.com/gluetun-docker-guide/) guide. Recommended [VPN provider](https://www.smarthomebeginner.com/go/surfshark-vpn "Surfshark"): [Surfshark](https://www.smarthomebeginner.com/go/surfshark-vpn "Surfshark") VPN (just $2.49 per month) with Wireguard support.

qBittorrent Docker-Compose can be found in my [GitHub repo](https://github.com/htpcbeginner/docker-traefik).

##### qBittorrent Docker Compose

Create qBittorrent Docker Compose File (/home/anand/docker/compose/udms/qbittorrent.yml), with the following contents:

1

2

3

4

5

6

7

8

9

10

11

12

13

14

15

16

17

18

19

20

21

`services:`

`# qBittorrent - Torrent downloader`

`qbittorrent:`

`image:` ` lscr.io/linuxserver/qbittorrent``:``latest `

`container_name:` `qbittorrent`

`security_opt:`

`-` ` no-new-privileges``:``true `

`restart:` `unless-stopped`

`# profiles: ["apps", "downloads", "all"]`

`networks:`

`-` `default`

`ports:`

`-` `"8081:8080"`

`volumes:`

`-` ` $DOCKERDIR/appdata/qbittorrent``:``/config `

`-` ` $DATADIR/downloads``:``/data/downloads ` `# Ensure that downloads folder is set to /data/downloads in qBittorrent`

`environment:`

`TZ:` `$TZ`

`PUID:` `$PUID`

`PGID:` `$PGID`

`UMASK_SET:` `002`

##### Add qBittorrent to the Docker Stack

Add qBittorrent to the master **docker-compose-udms.yml**:

1

2

3

4

`...`

`# DOWNLOADERS`

`-` `compose/$HOSTNAME/sabnzbd.yml`

`-` `compose/$HOSTNAME/qbittorrent.yml`

[Start and test](#starting-and-testing-containers) the qBittorrent container. qBittorrent should be available at **http://192.168.1.100:8081**. Do not forward port 8081 on the router to the qBittorrent host server. Instead use more [secure alternatives](#forwarding-ports).

#### 9\. [Radarr](https://radarr.video/) - Movie management

[

![Radarr - Movie Download And Organization](https://www.smarthomebeginner.com/images/2022/05/radarr-screenshot-740x426.jpg "Ultimate Docker Media Server: With 60+ Docker Compose Apps [2024] 30")

![Radarr - Movie Download And Organization](data:image/svg+xml,%3Csvg%20xmlns=%22http://www.w3.org/2000/svg%22%20viewBox=%220%200%20740%20426%22%3E%3C/svg%3E "Ultimate Docker Media Server: With 60+ Docker Compose Apps [2024] 30")](https://www.smarthomebeginner.com/images/2022/05/radarr-screenshot.jpg)

Radarr - Movie Download And Organization

Radarr is a Movie PVR. You add the movies you want to see to Radarr and it will search various BitTorrent and [Usenet providers](https://www.smarthomebeginner.com/go/newshosting "NewsHosting") for the movie. If it is available, Radarr will grab the index file and send it to your BitTorrent client or NZB client for downloading.

Once the download is complete it can rename your movie to a specified format and move it to a folder of your choice (movie library). It can even update your Plex library or notify you when a new movie is ready for you to watch. \[**Read:** [CouchPotato vs SickBeard, SickRage, or Sonarr for beginners](https://www.smarthomebeginner.com/couchpotato-vs-sickbeard-sickrage-sonarr/)\]

Radarr Docker-Compose can be found in my [GitHub repo](https://github.com/htpcbeginner/docker-traefik).

##### Radarr Docker Compose

Create Radarr Docker Compose File (/home/anand/docker/compose/udms/radarr.yml), with the following contents:

1

2

3

4

5

6

7

8

9

10

11

12

13

14

15

16

17

18

19

20

21

22

23

`services:`

`# Radarr - Movie management`

`radarr:`

`image:` ` lscr.io/linuxserver/radarr``:``latest `

`container_name:` `radarr`

`security_opt:`

`-` ` no-new-privileges``:``true `

`restart:` `"no"`

`# profiles: ["media", "arrs", "all"]`

`networks:`

`-` `default`

`ports:`

`-` `"7878:7878"`

`volumes:`

`-` ` $DOCKERDIR/appdata/radarr``:``/config `

`-` ` $DATADIR/data/media/movies``:``/data/movies1 `

`-` ` $DATADIR/data2/media/movies``:``/data/movies2 `

`-` ` $DATADIR/downloads``:``/data/downloads `

`-` `"/etc/localtime:/etc/localtime:ro"`

`environment:`

`TZ:` `$TZ`

`PUID:` `$PUID`

`PGID:` `$PGID`

It is important to have your Downloads folder and the media folders properly configured per [TRaSH Guides](https://trash-guides.info/Hardlinks/Hardlinks-and-Instant-Moves/) if you want to minimize I/O, space, and disk wear and tear.

##### Add Radarr to the Docker Stack

Add Radarr to the master **docker-compose-udms.yml**:

1

2

3

4

`...`

`-` `compose/$HOSTNAME/qbittorrent.yml`

`# PVRS`

`-` `compose/$HOSTNAME/radarr.yml`

[Start and test](#starting-and-testing-containers) the Radarr container. Radarr should be available at **http://192.168.1.100:7878**. Do not forward port 7878 on the router to the Radarr host server. Instead use more [secure alternatives](#forwarding-ports).

##### Referring to an App Inside Another App

Say you want to add SABnzbd as a download client inside Radarr, you can provide the host URL in two ways:

- Since both SABnzbd and Radarr belong to the same network (**default**), SABnzbd host URL can be **http://sabnzbd:8080**. Notice two things here:
  1.  **sabzbnd** is the name of the SABnzbd service we provided in the **sabnzbd.yml** docker compose file (**sabnzbd:**).
  2.  Since we are referring to SABnzbd using the hostname, we have to use the port number inside the container, which is 8080.
- You can also call SABnzbd inside Radarr, using the URL **http://192.168.1.100:8084** (the port we mapped 8080 to on the host side). If both SABnzbd and Radarr were on different docker networks, then this is the method that will work.

#### 10\. [Sonarr](https://sonarr.tv/) - TV Shows Management

[

![Sonarr - Tv Shows Download And Organization](https://www.smarthomebeginner.com/images/2018/03/sonarr-web-interface-740x220.png "Ultimate Docker Media Server: With 60+ Docker Compose Apps [2024] 31")

![Sonarr - Tv Shows Download And Organization](data:image/svg+xml,%3Csvg%20xmlns=%22http://www.w3.org/2000/svg%22%20viewBox=%220%200%20740%20220%22%3E%3C/svg%3E "Ultimate Docker Media Server: With 60+ Docker Compose Apps [2024] 31")](https://www.smarthomebeginner.com/images/2018/03/sonarr-web-interface.png)

Sonarr - Tv Shows Download And Organization

Sonarr (formerly NzbDrone) is a PVR for TV Shows. You add the shows you want to see to Sonarr and it will search various BitTorrent and [Usenet providers](https://www.smarthomebeginner.com/go/newshosting "NewsHosting") for the show episodes. If it is available, Sonarr will grab the index file and send it to your BitTorrent client or NZB client for downloading.

Once the download is complete it can rename your episode to a specified format and move it to a folder of your choice (TV Show library). It can even update your Plex library or notify you when a new episode is ready for you to watch.

Sonarr Docker-Compose can be found in my [GitHub repo](https://github.com/htpcbeginner/docker-traefik).

##### Sonarr Docker Compose

Create Sonarr Docker Compose File (/home/anand/docker/compose/udms/sonarr.yml), with the following contents:

1

2

3

4

5

6

7

8

9

10

11

12

13

14

15

16

17

18

19

20

21

22

23

24

`services:`

`# Sonarr - TV Shows Management`

`# Set url_base in sonarr settings if using PathPrefix`

`sonarr:`

`image:` ` lscr.io/linuxserver/sonarr``:``develop `

`container_name:` `sonarr`

`security_opt:`

`-` ` no-new-privileges``:``true `

`restart:` `"no"`

`# profiles: ["media", "arrs", "all"]`

`networks:`

`-` `default`

`ports:`

`-` `"8989:8989"`

`volumes:`

`-` ` $DOCKERDIR/appdata/sonar``:``/config `

`-` ` $DATADIR/data/media/shows``:``/data/shows1 `

`-` ` $DATADIR/data2/media/shows``:``/data/shows2 `

`-` ` $DATADIR/downloads``:``/data/downloads `

`-` `"/etc/localtime:/etc/localtime:ro"`

`environment:`

`TZ:` `$TZ`

`PUID:` `$PUID`

`PGID:` `$PGID`

##### Add Sonarr to the Docker Stack

Add Sonarr to the master **docker-compose-udms.yml**:

1

2

3

4

`...`

`# PVRS`

`-` `compose/$HOSTNAME/radarr.yml`

`-` `compose/$HOSTNAME/sonarr.yml`

[Start and test](#starting-and-testing-containers) the Sonarr container. Sonarr should be available at **http://192.168.1.100:8989**. Do not forward port 8989 on the router to the Sonarr host server. Instead use more [secure alternatives](#forwarding-ports).

#### 11\. [Bazarr](https://www.bazarr.media/) - Subtitle Management

[

![Bazarr - Subtitle Management For Media Servers](https://www.smarthomebeginner.com/images/2022/05/bazarr-subtitles-for-docker-media-server-740x294.jpg "Ultimate Docker Media Server: With 60+ Docker Compose Apps [2024] 32")

![Bazarr - Subtitle Management For Media Servers](data:image/svg+xml,%3Csvg%20xmlns=%22http://www.w3.org/2000/svg%22%20viewBox=%220%200%20740%20294%22%3E%3C/svg%3E "Ultimate Docker Media Server: With 60+ Docker Compose Apps [2024] 32")](https://www.smarthomebeginner.com/images/2022/05/bazarr-subtitles-for-docker-media-server.jpg)

Bazarr - Subtitle Management For Media Servers

Bazarr is a companion application to Sonarr and Radarr that manages and downloads subtitles. You can search automatically for missing subtitles and download them as they become available. You can find all matching subtitles, choose one, and download it directly to your media library.

Bazarr Docker-Compose can be found in my [GitHub repo](https://github.com/htpcbeginner/docker-traefik).

##### Bazarr Docker Compose

Create Bazarr Docker Compose File (/home/anand/docker/compose/udms/bazarr.yml), with the following contents:

1

2

3

4

5

6

7

8

9

10

11

12

13

14

15

16

17

18

19

20

`services:`

`# Bazarr - Subtitle Management`

`bazarr:`

`image:` `lscr.io/linuxserver/bazarr`

`container_name:` `bazarr`

`security_opt:`

`-` ` no-new-privileges``:``true `

`restart:` `"no"`

`# profiles: ["media", "arrs", "all"]`

`networks:`

`-` `default`

`ports:`

`-` `"6767:6767"`

`volumes:`

`-` ` $DOCKERDIR/appdata/bazarr``:``/config `

`-` ` $DATADIR/media``:``/data/media `

`environment:`

`TZ:` `$TZ`

`PUID:` `$PUID`

`PGID:` `$PGID`

##### Add Bazarr to the Docker Stack

Add Bazarr to the master **docker-compose-udms.yml**:

1

2

3

4

`...`

`-` `compose/$HOSTNAME/sonarr.yml`

`# COMPLEMENTARY APPS`

`-` `compose/$HOSTNAME/bazarr.yml`

[Start and test](#starting-and-testing-containers) the Bazarr container. Bazarr should be available at **http://192.168.1.100:6767**. Do not forward port 6767 on the router to the Bazarr host server. Instead use more [secure alternatives](#forwarding-ports).

#### 12\. [Tautulli](https://tautulli.com/) - Plex Statistics and Monitoring

[

![Tautulli (Aka Plexpy) - Monitoring Plex Usage](https://www.smarthomebeginner.com/images/2019/04/tautulli-screenshot-740x316.jpg "Ultimate Docker Media Server: With 60+ Docker Compose Apps [2024] 33")

![Tautulli (Aka Plexpy) - Monitoring Plex Usage](data:image/svg+xml,%3Csvg%20xmlns=%22http://www.w3.org/2000/svg%22%20viewBox=%220%200%20740%20316%22%3E%3C/svg%3E "Ultimate Docker Media Server: With 60+ Docker Compose Apps [2024] 33")](https://www.smarthomebeginner.com/images/2019/04/tautulli-screenshot.jpg)

Tautulli (Aka Plexpy) - Monitoring Plex Usage

Tautulli is a third-party app for monitoring and tracking Plex Media Server. You can see what has been watched, who watched it, when they watched it, and what device it was watched on. All statistics are displayed in a well-designed interface made of tables and graphs for easy viewing.

With Tautulli Remote you can view activity and stats away from home. Intuitive graphs allow you to view streaming trends. You can create newsletters for recently added media. You can see the watch history for all users. Tuatulli also allows you to view statistics and detailed media info about your Plex library and delete synced content.

Tautulli Docker-Compose can be found in my [GitHub repo](https://github.com/htpcbeginner/docker-traefik).

##### Tautulli Docker Compose

Create Tautulli Docker Compose File (/home/anand/docker/compose/udms/tautulli.yml), with the following contents:

1

2

3

4

5

6

7

8

9

10

11

12

13

14

15

16

17

18

19

20

`services:`

`# Tautulli - Plex statistics and monitoring`

`tautulli:`

`image:` ` lscr.io/linuxserver/tautulli``:``latest `

`container_name:` `tautulli`

`security_opt:`

`-` ` no-new-privileges``:``true `

`restart:` `"no"`

`# profiles: ["media", "all"]`

`networks:`

`-` `default`

`ports:`

`-` `"8181:8181"`

`volumes:`

`-` ` $DOCKERDIR/appdata/tautulli/config``:``/config `

`-` ` $DOCKERDIR/appdata/plex/Library/Application Support/Plex Media Server/Logs``:``/logs``:``ro ` `# For Tautulli Plex log viewer`

`environment:`

`TZ:` `$TZ`

`PUID:` `$PUID`

`PGID:` `$PGID`

##### Add Tautulli to the Docker Stack

Add Tautulli to the master **docker-compose-udms.yml**:

1

2

3

4

`...`

`# COMPLEMENTARY APPS`

`-` `compose/$HOSTNAME/bazarr.yml`

`-` `compose/$HOSTNAME/tautulli.yml`

[Start and test](#starting-and-testing-containers) the Tautulli container. Tautulli should be available at **http://192.168.1.100:8181**. Do not forward port 8181 on the router to the Tautulli host server. Instead use more [secure alternatives](#forwarding-ports).

#### 13\. [Uptime Kuma](https://uptime.kuma.pet/) - Status Page & Monitoring Server

[

![Uptime Kuma Monitoring](https://www.smarthomebeginner.com/images/2023/04/uptime-kuma-dashboard-740x361.jpg "Ultimate Docker Media Server: With 60+ Docker Compose Apps [2024] 34")

![Uptime Kuma Monitoring](data:image/svg+xml,%3Csvg%20xmlns=%22http://www.w3.org/2000/svg%22%20viewBox=%220%200%20740%20361%22%3E%3C/svg%3E "Ultimate Docker Media Server: With 60+ Docker Compose Apps [2024] 34")](https://www.smarthomebeginner.com/images/2023/04/uptime-kuma-dashboard.jpg)

Uptime Kuma Monitoring

Uptime Kuma is an open-source monitoring tool for services over HTTP, TCP, DNS, and other protocols. Uptime Kuma will send you notification alerts of downtime. You can also create custom status pages for users.

Combined with Prometheus, Uptime Kuma can display metrics about each monitoring target. There are pre-made Grafana dashboards available to pull the metrics from Prometheus and display them as nice monitoring dashboards.

Uptime Kuma Docker-Compose can be found in my [GitHub repo](https://github.com/htpcbeginner/docker-traefik).

##### Uptime-Kuma Docker Compose

Create Uptime-Kuma Docker Compose File (/home/anand/docker/compose/udms/uptime-kuma.yml), with the following contents:

1

2

3

4

5

6

7

8

9

10

11

12

13

`services:`

`# Uptime Kuma - Status Page & Monitoring Server`

`uptime-kuma:`

`image:` `louislam/uptime-kuma`

`container_name:` `uptime-kuma`

`security_opt:`

`-` ` no-new-privileges``:``true `

`restart:` `unless-stopped`

`# profiles: ["core", "all"]`

`networks:`

`-` `default`

`volumes:`

`-` ` $DOCKERDIR/appdata/uptime-kuma``:``/app/data `

##### Add Uptime-Kuma to the Docker Stack

Add Uptime-Kuma to the master **docker-compose-udms.yml**:

1

2

3

4

`...`

`-` `compose/$HOSTNAME/tautulli.yml`

`# MONITORING`

`-` `compose/$HOSTNAME/uptime-kuma.yml`

[Start and test](#starting-and-testing-containers) the Uptime-Kuma container. Uptime-Kuma should be available at **http://192.168.1.100:8182**. Do not forward port 8182 on the router to the Uptime-Kuma host server. Instead use more [secure alternatives](#forwarding-ports).

#### 14\. [MariaDB](https://mariadb.org/) - MySQL Database

You may have never used SQL commands, but you probably have heard of MySQL because of its many uses. [MySQL Community Edition](https://www.mysql.com/products/community/) is free but MySQL itself is a commercial application. The developers of MySQL developed MariaDB as an option that would always be free and open-source.

MariaDB Server is also developed to maintain compatibility with MySQL, allowing developers to use the same open-source code libraries for MariaDB as MySQL. Some names you might recognize, such as Wikipedia, DBS Bank, and ServiceNow use MariaDB, you can now recognize them as using MySQL.

MariaDB is a popular choice for self-hosting enthusiasts as a database for Home Assistant, [Authelia](https://www.smarthomebeginner.com/authelia-docker-compose-guide-2024/), [WordPress](https://www.smarthomebeginner.com/wordpress-on-docker-traefik/), Airsonic Advanced, and more.

MariaDB Docker-Compose can be found in my [GitHub repo](https://github.com/htpcbeginner/docker-traefik).

##### MariaDB Docker Compose

Create MariaDB Docker Compose File (/home/anand/docker/compose/udms/mariadb.yml), with the following contents:

1

2

3

4

5

6

7

8

9

10

11

12

13

14

15

16

17

18

19

20

21

22

23

`services:`

`# MariaDB - MySQL Database`

`# After starting container for first time dexec and mysqladmin -u root password <password>`

`mariadb:`

`container_name:` `mariadb`

`image:` `lscr.io/linuxserver/mariadb`

`networks:`

`-` `default`

`security_opt:`

`-` ` no-new-privileges``:``true `

`restart:` `unless-stopped`

`# profiles: ["dbs", "all"]`

`ports:`

`-` `"3306:3306"`

`volumes:`

`-` ` $DOCKERDIR/appdata/mariadb/data``:``/config `

`environment:`

`TZ:` `$TZ`

`PUID:` `$PUID`

`PGID:` `$PGID`

`FILE__MYSQL_ROOT_PASSWORD:` `/run/secrets/mysql_root_password` `# Note FILE__ (double underscore)`

`secrets:`

`-` `mysql_root_password`

Note that MariaDB root password is specified as a Docker Secret. In addition, **FILE\_\_MYSQL_ROOT_PASSWORD** has a double underscore.

##### Add MariaDB to the Docker Stack

Add MariaDB to the master **docker-compose-udms.yml**:

1

2

3

4

`...`

`-` `compose/$HOSTNAME/uptime-kuma.yml`

`# DATABASES`

`-` `compose/$HOSTNAME/mariadb.yml`

[Start and test](#starting-and-testing-containers) the MariaDB container.

#### 15\. [File Browser](https://filebrowser.org/) - File Explorer

[

![File Browser Interface - Also Has An Editor With Syntax Highlighting](https://www.smarthomebeginner.com/images/2022/05/filebrowser-screenshot-740x277.jpg "Ultimate Docker Media Server: With 60+ Docker Compose Apps [2024] 35")

![File Browser Interface - Also Has An Editor With Syntax Highlighting](data:image/svg+xml,%3Csvg%20xmlns=%22http://www.w3.org/2000/svg%22%20viewBox=%220%200%20740%20277%22%3E%3C/svg%3E "Ultimate Docker Media Server: With 60+ Docker Compose Apps [2024] 35")](https://www.smarthomebeginner.com/images/2022/05/filebrowser-screenshot.jpg)

File Browser Interface - Also Has An Editor With Syntax Highlighting

File Browser provides a web UI for managing files for multiple users in multiple directories. Each user can upload, delete, preview, rename and edit files in a specified directory. It is one the cleanest and easiest file managers for your home server.

All you must do is simply install File Browser on a server and point it to a directory path to access files through the web interface.

File Browser Docker-Compose can be found in my [GitHub repo](https://github.com/htpcbeginner/docker-traefik).

##### File Browser Docker Compose

Create File Browser Docker Compose File (/home/anand/docker/compose/udms/filebrowser.yml), with the following contents:

1

2

3

4

5

6

7

8

9

10

11

12

13

14

15

16

17

18

19

20

`services:`

`# File Browser - Explorer`

`filebrowser:`

`image:` ` filebrowser/filebrowser``:``s6 `

`container_name:` `filebrowser`

`security_opt:`

`-` ` no-new-privileges``:``true `

`restart:` `unless-stopped`

`# profiles: ["apps", "all"]`

`networks:`

`-` `default`

`ports:`

`-` `"81:80"`

`volumes:`

`-` ` $DOCKERDIR/appdata/filebrowser``:``/config `

`-` ` $USERDIR``:``/data/home `

`environment:`

`TZ:` `$TZ`

`PUID:` `$PUID`

`PGID:` `$PGID`

##### Add File Browser to the Docker Stack

Add File Browser to the master **docker-compose-udms.yml**:

1

2

3

4

`...`

`-` `compose/$HOSTNAME/tautulli.yml`

`# UTILITIES`

`-` `compose/$HOSTNAME/filebrowser.yml`

[Start and test](#starting-and-testing-containers) the File Browser container. File Browser should be available at **http://192.168.1.100:81**. Do not forward port 81 on the router to the File Browser host server. Instead use more [secure alternatives](#forwarding-ports).

#### 16\. [Docker Garbage Collector](https://hub.docker.com/r/eeacms/docker-gc)

After a while of tinkering with docker containers, stored orphan images and volumes can take up several gigabytes of space. While you can use `docker system prune`, Docker garbage collector automates the job for you. A good Docker garbage collection example can be found in the recently posted article [Docker Media Server guide](https://www.smarthomebeginner.com/docker-media-server-2022/#12_Docker-GC_-_Automatic_Docker_Garbage_Collection).

The best Docker images for garbage collection are [`docker-gc`](https://github.com/spotify/docker-gc) and [`docker-gc-cron`](https://github.com/clockworksoul/docker-gc-cron).

If you are considering `docker-gc`, one alternative you will immediately notice is [`spotify/docker-gc`](https://hub.docker.com/r/spotify/docker-gc/dockerfile). However, `spotify/docker-gc` is no longer being developed. Using `docker-gc-cron` is a great alternative because it is actively developed and, in fact, uses `spotify/docker-gc` under the hood.

##### Docker-GC Docker Compose

Create Docker-GC Docker Compose File (/home/anand/docker/compose/udms/docker-gc.yml), with the following contents:

1

2

3

4

5

6

7

8

9

10

11

12

13

14

15

16

17

18

19

20

21

22

23

24

`services:`

`# Docker-GC - Automatic Docker Garbage Collection`

`# Create docker-gc-exclude file`

`docker-gc:`

`image:` ` clockworksoul/docker-gc-cron``:``latest `

`container_name:` `docker-gc`

`security_opt:`

`-` ` no-new-privileges``:``true `

`restart:` `unless-stopped`

`# profiles: ["apps", "all"]`

`networks:`

`-` `socket_proxy`

`volumes:`

`# - /var/run/docker.sock:/var/run/docker.sock # Use Docker Socket Proxy instead for improved security`

`-` ` $DOCKERDIR/appdata/docker-gc/docker-gc-exclude``:``/etc/docker-gc-exclude `

`environment:`

`CRON:` `0 0 0 * * ?` `# Every day at midnight`

`FORCE_IMAGE_REMOVAL:` `1`

`FORCE_CONTAINER_REMOVAL:` `0`

`GRACE_PERIOD_SECONDS:` `604800`

`DRY_RUN:` `0`

`CLEAN_UP_VOLUMES:` `1`

`TZ:` `$TZ`

`DOCKER_HOST:` ` tcp``:``//socket-proxy``:``2375 `

The cron is set to clean the unused docker data every day at midnight.

##### Add Docker-GC to the Docker Stack

Add Docker-GC to the master **docker-compose-udms.yml**:

1

2

3

4

`...`

`-` `compose/$HOSTNAME/filebrowser.yml`

`# MAINTENANCE`

`-` `compose/$HOSTNAME/docker-gc.yml`

[Start and test](#starting-and-testing-containers) the Docker-GC container. There is no web interface for Docker Garbage Collector.

The only thing you need to remember is to create an empty **docker-gc-exclude** file, as docker cannot create files (only directories).

### The Final Docker Compose File

We have added about 15 apps to our Docker Media Server. At this point, your docker-compose-udms.yml should look like what is shown below:

As mentioned before, with this update, I have broken down each app into its own compose file. The result is a significantly smaller master Docker Compose file compared to what was presented in my previous guides. When you have to disable an app, all you have to do is comment out the app in file below.

1

2

3

4

5

6

7

8

9

10

11

12

13

14

15

16

17

18

19

20

21

22

23

24

25

26

27

28

29

30

31

32

33

34

35

36

37

38

39

40

41

42

43

44

45

46

47

48

`########################### NETWORKS`

`networks:`

`default:`

`driver:` `bridge`

`socket_proxy:`

`name:` `socket_proxy`

`driver:` `bridge`

`ipam:`

`config:`

`-` ` subnet``: ` `192.168.91.0/24`

`########################### SECRETS`

`secrets:`

`plex_claim:`

`file:` `$DOCKERDIR/secrets/plex_claim`

`mysql_root_password:`

`file:` `$DOCKERDIR/secrets/mysql_root_password`

`include:`

`########################### SERVICES`

`# PREFIX udms = Ultimate Docker Media Server`

`# HOSTNAME=udms - defined in .env`

`# CORE`

`-` `compose/$HOSTNAME/socket-proxy.yml`

`-` `compose/$HOSTNAME/portainer.yml`

`-` `compose/$HOSTNAME/dozzle.yml`

`-` `compose/$HOSTNAME/homepage.yml`

`# MEDIA`

`-` `compose/$HOSTNAME/plex.yml`

`-` `compose/$HOSTNAME/jellyfin.yml`

`# DOWNLOADERS`

`-` `compose/$HOSTNAME/sabnzbd.yml`

`-` `compose/$HOSTNAME/qbittorrent.yml`

`# PVRS`

`-` `compose/$HOSTNAME/radarr.yml`

`-` `compose/$HOSTNAME/sonarr.yml`

`# COMPLEMENTARY APPS`

`-` `compose/$HOSTNAME/bazarr.yml`

`-` `compose/$HOSTNAME/tautulli.yml`

`# MONITORING`

`-` `compose/$HOSTNAME/uptime-kuma.yml`

`# DATABASES`

`-` `compose/$HOSTNAME/mariadb.yml`

`# UTILITIES`

`-` `compose/$HOSTNAME/filebrowser.yml`

`# MAINTENANCE`

`-` `compose/$HOSTNAME/docker-gc.yml`

### 17-60 and More: Rest of the Apps

The media server apps listed above are what I consider as key to a kickass media server based on Docker. However, there are a few more apps that are nice to have.

This guide is already several thousand words long. So, I have included the docker compose examples for the following apps in my [Github Repo](https://github.com/htpcBeginner/docker-traefik).

[

![All Docker Compose Files](https://www.smarthomebeginner.com/images/2023/04/docker-containers-for-home-server-compose-files-740x190.jpg "Ultimate Docker Media Server: With 60+ Docker Compose Apps [2024] 36")

![All Docker Compose Files](data:image/svg+xml,%3Csvg%20xmlns=%22http://www.w3.org/2000/svg%22%20viewBox=%220%200%20740%20190%22%3E%3C/svg%3E "Ultimate Docker Media Server: With 60+ Docker Compose Apps [2024] 36")](https://www.smarthomebeginner.com/images/2023/04/docker-containers-for-home-server-compose-files-scaled.jpg)

All Docker Compose Files

Here are a few that are not listed in this article but available in the repository:

I constantly add/remove apps. So, there may be some new ones in the repository and some missing. I do not actively maintain this list. But at the time of writing this guide, I have the following Docker Compose YMLs, in addition to what was shared previously in this guide.

- **Media/Music:** Lidarr, Readarr, Prowlarr, Ombi, Handbrake, MakeMKV, MKVToolNix, Picard, Plex Meta Manager, Notifiarr, Ampache, Emby, Gonic, Navidrome, Funkwhale, Plex-Trakt-Sync, Tiny Media Manager, Cloudplow, Autoscan
- **Monitoring:** Grafana, Glances, Cadvisor, ha-dockermon, Youtube-DL Material, Loki, Promtail, Smokeping, Varken, Lidarr Exporter, Node Exporter, Prowlarr Exporter, Radarr Exporter, Sabnzbd Exporter, Sonarr Exporter
- **DNS/AdBlockers/VPN/Networking:** Unbound, Zerotier, Tailscale, DDNS Updater, PiHole
- **Databases:** PostgreSQL, InfluxDB, Prometheus, Redis, phpMyAdmin
- **Web:** php7, Nginx
- **Admin:** Guacamole
- **Security:** Crowdsec, Traefik Bouncer, Cloudflare Bouncer
- **File Managers:** Visual Studio Code Server, AutoIndex, Cloud9, Cloud-Commander, Dupeguru, PyRenamer
- **Photo Management:** Digikam, Photoprism, Photoshow
- **Others:** Homepage, Heimdall, jDownloader, APCUPSD, Cloud-Commander, Dupeguru, Flaresolver

If you are worried how you are going to keep all your Docker containers updated, then fear not. Our [Watchtower Docker Compose guide](https://www.smarthomebeginner.com/watchtower-docker-compose-2024/) is here to the rescue.

By now, you should be quite familiar with copy-pasting it from my GitHub repo and customizing any needed environmental variables. So, it should be a breeze to add the following apps to your setup if you choose to.

> **Be the 1 in 200,000. Help us sustain what we do.**
>
> 47 / 150 by Dec 31, 2024
>
> [Join Us](https://www.smarthomebeginner.com/membership-account/memberships-products-services/) (starting from just $1.67/month)
>
> [Why did we start Memberships?](https://www.smarthomebeginner.com/state-of-the-site-2023/)

## External Access to Apps

So, a 11,000-word post on how to setup a media server from scratch using Docker and Ubuntu. If this helped, I would greatly appreciate you showing your support of my work in one or more ways listed above.

As mentioned previously, the objective of this guide was to create a basic Docker media server stack that is accessible inside the home/local network. But what if you want to expose the apps to the internet so you have access to your apps on the go?

This topic will be covered in detail in the later parts of this tutorial series. But here is a summary of options. I will add more details and relevant links as those individual guides are published.

1.  **Wireguard:** With your server running Wireguard server and Wireguard client on the mobile, you VPN into your home/LAN network and have access to your Dockerized apps.

    > ##### Other Posts in the Wireguard Series:
    >
    > - [Wireguard VPN Intro in 15 min: Amazing new VPN Protocol](https://www.smarthomebeginner.com/wireguard-vpn-for-beginners/)
    > - [Complete Wireguard Setup in 20 min – Better Linux VPN Server](https://www.smarthomebeginner.com/linux-wireguard-vpn-server-setup/)
    > - [Wireguard Windows Setup: Powerful VPN for Windows](https://www.smarthomebeginner.com/wireguard-windows-setup/)
    > - [Wireguard Mac OS Client Setup – The sleek new VPN](https://www.smarthomebeginner.com/wireguard-mac-os-client-setup/)
    > - [Wireguard Android Client Setup – Simple and Secure VPN](https://www.smarthomebeginner.com/wireguard-android-client-setup/)
    > - [Ultimate WireGuard Docker Compose: with CF and Traefik Support](https://www.smarthomebeginner.com/wireguard-docker-compose-guide-2023/)

2.  **Overlay Mesh Network:** I use [ZeroTier](https://www.zerotier.com/) to tie all my Docker Hosts and mobile device together. Using this I can access all my apps while I am away. Another example is [Tailscale](https://tailscale.com/). Both ZeroTier and Tailscale have free plans. There is no need to open ports on the router, keeping malicious traffic away. I will cover this in more detail, later in this series.
3.  **Cloudflare Tunnels and Access:** With Cloudflare Tunnels and Access, you can secure have on the go access to your apps. There is no need to open ports on the router, which is awesome. Another benefit is you will also have SSL/HTTPS connection to your app for added security. This will also be covered in detail, later in this series.
4.  **Reverse Proxy:**, the last option is to add a Reverse Proxy. [Nginx Proxy Manager](https://www.smarthomebeginner.com/docker-media-server-2022/#1_Nginx_Proxy_Manager_-_Reverse_Proxy_with_LetsEncrypt) and [Traefik](https://www.smarthomebeginner.com/traefik-docker-compose-guide-2024/) are two common ones. Updated guides for both of these are in the plan for this series.

So be sure to watch out for updates to this Docker Server tutorial series in the coming days.

## Troubleshooting

If you follow the guide word-to-word, you should be fine. However, something may go wrong. Feel free to [join our discord community](https://www.smarthomebeginner.com/discord) to ask around or just chat with like-minded people. But before you do, here are some common mistakes and fixes for those.

##### Restricted Content

Additional explanations and bonus content are available exclusively for the following members only:

Silver - Monthly, Silver - Yearly, Gold - Monthly, Gold - Yearly, Diamond - Monthly, Diamond - Yearly, and Platinum Lifetime (All-Inclusive)

Please support us by becoming a member to unlock the content.  
[Join Now](https://www.smarthomebeginner.com/membership-account/memberships-products-services/)

## Closing Thoughts

Congratulations! But if you thought that you are done. You are wrong. Your journey is just getting started. Here are on out the possibilities are endless.

You could improve security by implementing [docker security practices](https://www.smarthomebeginner.com/traefik-docker-security-best-practices/) and [implement Cloudflare tweaks](https://www.smarthomebeginner.com/cloudflare-settings-for-traefik-docker/).

You could even replace Nginx Proxy Manager with [Traefik Reverse Proxy](https://www.smarthomebeginner.com/traefik-docker-compose-guide-2024/) for additional features. This would also enable you to add [Google OAuth](https://www.smarthomebeginner.com/google-oauth-traefik-forward-auth-2024/), or even your own [Multi-factor authentication system with Authelia](https://www.smarthomebeginner.com/authelia-docker-compose-guide-2024/).

You could add a [Docker WordPress stack](https://www.smarthomebeginner.com/wordpress-on-docker-traefik/), like I do, and host your own blog.

There are literally hundreds of self-hosted apps for your homelab: like [ad-blocking with PiHole](https://www.smarthomebeginner.com/run-pihole-in-docker-on-ubuntu-with-reverse-proxy/), or [AdGuard Home](https://www.smarthomebeginner.com/pi-hole-vs-adguard-home/). Add [NextCloud](https://www.smarthomebeginner.com/traefik-docker-nextcloud/) for your own Cloud storage, [Guacamole for VNC, SSH, SFTP, and RDP](https://www.smarthomebeginner.com/install-guacamole-on-docker/), or run [UniFi Controller](https://www.smarthomebeginner.com/install-unifi-controller-on-docker/) if you are into UniFi ecosystem. Checkout the many YML files in my [GitHub Repo](https://github.com/htpcBeginner/docker-traefik).

Whatever you decide to do, my hope was to share my knowledge and experience through this Docker media server guide and help you get started with your setup. If you have any comments or thoughts, feel free to comment below.

[Facebook](https://www.smarthomebeginner.com/#facebook "Facebook")[Twitter](https://www.smarthomebeginner.com/#twitter "Twitter")[Reddit](https://www.smarthomebeginner.com/#reddit "Reddit")[LinkedIn](https://www.smarthomebeginner.com/#linkedin "LinkedIn")[Share](https://www.addtoany.com/share#url=https%3A%2F%2Fwww.smarthomebeginner.com%2Fdocker-media-server-2024%2F&title=Ultimate%20Docker%20Media%20Server%3A%20With%2060%2B%20Docker%20Compose%20Apps%20%5B2024%5D)

### Related Posts:

- [

  ![Auto Traefik](https://www.smarthomebeginner.com/images/2023/09/auto-traefik-by-smarthomebeginner.jpg "Auto-Traefik: Dead Simple Traefik Reverse Proxy Automator for Docker")

  ![Auto Traefik](data:image/svg+xml,%3Csvg%20xmlns=%22http://www.w3.org/2000/svg%22%20viewBox=%220%200%201271%20715%22%3E%3C/svg%3E "Auto-Traefik: Dead Simple Traefik Reverse Proxy Automator for Docker")

  Auto-Traefik: Dead Simple Traefik Reverse Proxy…](https://www.smarthomebeginner.com/auto-traefik/)

- [

  ![auto traefik 2 ft](https://www.smarthomebeginner.com/images/2023/11/auto-traefik-2-ft.jpg "Auto-Traefik Version 2.0 - Free Options, UI, Authelia, Portainer, and more")

  ![auto traefik 2 ft](data:image/svg+xml,%3Csvg%20xmlns=%22http://www.w3.org/2000/svg%22%20viewBox=%220%200%20784%20441%22%3E%3C/svg%3E "Auto-Traefik Version 2.0 - Free Options, UI, Authelia, Portainer, and more")

  Auto-Traefik Version 2.0 - Free Options, UI,…](https://www.smarthomebeginner.com/auto-traefik-version-2-0/)

- [

  ![Auto-Traefik 3.0](https://www.smarthomebeginner.com/images/2024/03/Auto-Traefik-3.png "Auto-Traefik Version 3.0 - Backups, Guacamole, More Free Options, etc.")

  ![Auto-Traefik 3.0](data:image/svg+xml,%3Csvg%20xmlns=%22http://www.w3.org/2000/svg%22%20viewBox=%220%200%201280%20720%22%3E%3C/svg%3E "Auto-Traefik Version 3.0 - Backups, Guacamole, More Free Options, etc.")

  Auto-Traefik Version 3.0 - Backups, Guacamole, More…](https://www.smarthomebeginner.com/auto-traefik-version-3-0/)

- [

  ![Traefik Dashboard](https://www.smarthomebeginner.com/images/2023/10/traefik-dashboard.jpg "Traefik Auth Bypass: Conditionally Bypassing Forward Authentication")

  ![Traefik Dashboard](data:image/svg+xml,%3Csvg%20xmlns=%22http://www.w3.org/2000/svg%22%20viewBox=%220%200%202184%201247%22%3E%3C/svg%3E "Traefik Auth Bypass: Conditionally Bypassing Forward Authentication")

  Traefik Auth Bypass: Conditionally Bypassing Forward…](https://www.smarthomebeginner.com/traefik-auth-bypass/)

- [

  ![Proxmox Web Interface Traefik](https://www.smarthomebeginner.com/images/2023/12/proxmox-web-interface-traefik.jpg "How to put Proxmox Web Interface Behind Traefik?")

  ![Proxmox Web Interface Traefik](data:image/svg+xml,%3Csvg%20xmlns=%22http://www.w3.org/2000/svg%22%20viewBox=%220%200%201373%20752%22%3E%3C/svg%3E "How to put Proxmox Web Interface Behind Traefik?")

  How to put Proxmox Web Interface Behind Traefik?](https://www.smarthomebeginner.com/proxmox-web-interface-behind-traefik/)

- [

  ![Portainer Container Manager](https://www.smarthomebeginner.com/images/2023/03/portainer-container-manager.jpg "Portainer Docker Compose: FREE & MUST-HAVE Container Manager")

  ![Portainer Container Manager](data:image/svg+xml,%3Csvg%20xmlns=%22http://www.w3.org/2000/svg%22%20viewBox=%220%200%202162%201184%22%3E%3C/svg%3E "Portainer Docker Compose: FREE & MUST-HAVE Container Manager")

  Portainer Docker Compose: FREE & MUST-HAVE Container Manager](https://www.smarthomebeginner.com/portainer-docker-compose-guide/)

> **Be the 1 in 200,000. Help us sustain what we do.**
>
> 47 / 150 by Dec 31, 2024
>
> [Join Us](https://www.smarthomebeginner.com/membership-account/memberships-products-services/) (starting from just $1.67/month)
>
> [Why did we start Memberships?](https://www.smarthomebeginner.com/state-of-the-site-2023/)

Categories [Home Server](https://www.smarthomebeginner.com/home-server/) Tags [docker](https://www.smarthomebeginner.com/tag/docker/), [Guide](https://www.smarthomebeginner.com/tag/guide/), [home server](https://www.smarthomebeginner.com/tag/home-server-2/), [Members Only](https://www.smarthomebeginner.com/tag/members-only-content/), [ubuntu](https://www.smarthomebeginner.com/tag/ubuntu/)

[Ultimate Docker Server: Getting Started with OS Preparation \[Part 1\]](https://www.smarthomebeginner.com/ultimate-docker-server-1-os-preparation/)

[Get Auto-Traefik for FREE – Giveaway (no limit)](https://www.smarthomebeginner.com/auto-traefik-free-2024-01/)

![](https://secure.gravatar.com/avatar/5038190c1ce8da93329cc44d5b592149?s=100&d=monsterid&r=pg)

![](data:image/svg+xml,%3Csvg%20xmlns=%22http://www.w3.org/2000/svg%22%20viewBox=%220%200%20100%20100%22%3E%3C/svg%3E)

### Anand

Anand is a self-learned computer enthusiast, hopeless tinkerer (if it ain't broke, fix it), a part-time blogger, and a Scientist during the day. He has been blogging since 2010 on Linux, Ubuntu, Home/Media/File Servers, Smart Home Automation, and related HOW-TOs.

Load Comments

[Facebook](https://www.smarthomebeginner.com/#facebook)[Twitter](https://www.smarthomebeginner.com/#twitter)[Reddit](https://www.smarthomebeginner.com/#reddit)[LinkedIn](https://www.smarthomebeginner.com/#linkedin)[Share](https://www.addtoany.com/share#url=https%3A%2F%2Fwww.smarthomebeginner.com%2Fdocker-media-server-2024%2F&title=Ultimate%20Docker%20Media%20Server%3A%20With%2060%2B%20Docker%20Compose%20Apps%20%5B2024%5D%20%7C%20SHB)

[![](https://www.smarthomebeginner.com/wp-content/plugins/wp-youtube-lyte/lyteCache.php?origThumbUrl=https%3A%2F%2Fimg.youtube.com%2Fvi%2FUx9khKhqhcg%2Fhqdefault.jpg)](https://youtu.be/Ux9khKhqhcg)

Simplify Docker, Docker Compose, and Linux Commands with Bash Aliases

> **Be the 1 in 200,000. Help us sustain what we do.**
>
> 47 / 150 by Dec 31, 2024
>
> [Join Us](https://www.smarthomebeginner.com/membership-account/memberships-products-services/)
>
> [Why did we start Memberships?](https://www.smarthomebeginner.com/state-of-the-site-2023/)

[Twitter](https://twitter.com/anandslab) [Facebook](https://www.facebook.com/anandslab) [Instagram](https://www.instagram.com/smarthomebeginr) [LinkedIn](https://www.linkedin.com/company/anandslab) [YouTube](https://www.youtube.com/@anandslab) [GitHub](https://github.com/htpcbeginner) [Feed](https://www.smarthomebeginner.com/feed/) Subscribe

[

![SmartHomeBeginner Discord Community](https://www.smarthomebeginner.com/images/2022/05/join-discord-300x75.png "SmartHomeBeginner Discord Community")

![SmartHomeBeginner Discord Community](Ultimate%20Docker%20Media%20Server%20With%2060+%20Docker%20Compose%20Apps%20[2024]_files/join-discord-300x75.webp "SmartHomeBeginner Discord Community")](https://www.smarthomebeginner.com/discord/)

## Recent Posts

- [

  ![Traefik V3 Docker Compose](https://www.smarthomebeginner.com/images/2024/05/Docker-Series-05-Traefik-v3-150x84.png "Ultimate Traefik v3 Docker Compose Guide [2024]: LE, SSL, Reverse Proxy 37")

  ![Traefik V3 Docker Compose](Ultimate%20Docker%20Media%20Server%20With%2060+%20Docker%20Compose%20Apps%20[2024]_files/Docker-Series-05-Traefik-v3-150x84.webp "Ultimate Traefik v3 Docker Compose Guide [2024]: LE, SSL, Reverse Proxy 37")](https://www.smarthomebeginner.com/traefik-v3-docker-compose-guide-2024/)

  [Ultimate Traefik v3 Docker Compose Guide \[2024\]: LE, SSL, Reverse Proxy](https://www.smarthomebeginner.com/traefik-v3-docker-compose-guide-2024/)

- [

  ![Best Mini Pc For Proxmox](https://www.smarthomebeginner.com/images/2024/04/Best-Mini-PC-for-Proxmox-150x84.png "5 Best Mini PC for Proxmox Home Server [2024] 38")

  ![Best Mini Pc For Proxmox](Ultimate%20Docker%20Media%20Server%20With%2060+%20Docker%20Compose%20Apps%20[2024]_files/Best-Mini-PC-for-Proxmox-150x84.webp "5 Best Mini PC for Proxmox Home Server [2024] 38")](https://www.smarthomebeginner.com/best-mini-pc-for-proxmox-2024/)

  [5 Best Mini PC for Proxmox Home Server \[2024\]](https://www.smarthomebeginner.com/best-mini-pc-for-proxmox-2024/)

- [

  ![Google Oauth](https://www.smarthomebeginner.com/images/2024/04/Docker-Series-07-Google-OAuth-150x84.png "Google OAuth Traefik Forward Auth [2024]: Most Convenient MFA 39")

  ![Google Oauth](Ultimate%20Docker%20Media%20Server%20With%2060+%20Docker%20Compose%20Apps%20[2024]_files/Docker-Series-07-Google-OAuth-150x84.webp "Google OAuth Traefik Forward Auth [2024]: Most Convenient MFA 39")](https://www.smarthomebeginner.com/google-oauth-traefik-forward-auth-2024/)

  [Google OAuth Traefik Forward Auth \[2024\]: Most Convenient MFA](https://www.smarthomebeginner.com/google-oauth-traefik-forward-auth-2024/)

- [

  ![Vaultwarden Docker Compose](https://www.smarthomebeginner.com/images/2023/12/vaultwarden-install-header-1-150x84.webp "Vaultwarden Docker Compose + Detailed Configuration Guide 40")

  ![Vaultwarden Docker Compose](Ultimate%20Docker%20Media%20Server%20With%2060+%20Docker%20Compose%20Apps%20[2024]_files/vaultwarden-install-header-1-150x84.webp "Vaultwarden Docker Compose + Detailed Configuration Guide 40")](https://www.smarthomebeginner.com/vaultwarden-docker-compose-guide/)

  [Vaultwarden Docker Compose + Detailed Configuration Guide](https://www.smarthomebeginner.com/vaultwarden-docker-compose-guide/)

- [

  ![Auto-Traefik 3.0](https://www.smarthomebeginner.com/images/2024/03/Auto-Traefik-3-150x84.png "Auto-Traefik Version 3.0 - Backups, Guacamole, More Free Options, etc. 41")

  ![Auto-Traefik 3.0](Ultimate%20Docker%20Media%20Server%20With%2060+%20Docker%20Compose%20Apps%20[2024]_files/Auto-Traefik-3-150x84.webp "Auto-Traefik Version 3.0 - Backups, Guacamole, More Free Options, etc. 41")](https://www.smarthomebeginner.com/auto-traefik-version-3-0/)

  [Auto-Traefik Version 3.0 – Backups, Guacamole, More Free Options, etc.](https://www.smarthomebeginner.com/auto-traefik-version-3-0/)

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

window.lazySizesConfig=window.lazySizesConfig||{};window.lazySizesConfig.loadMode=1;var bU="https://www.smarthomebeginner.com/wp-content/plugins/wp-youtube-lyte/lyte/";var mOs=null;style = document.createElement("style");style.type = "text/css";rules = document.createTextNode(".lyte-wrapper-audio div, .lyte-wrapper div {margin:0px; overflow:hidden;} .lyte,.lyMe{position:relative;padding-bottom:56.25%;height:0;overflow:hidden;background-color:#777;} .fourthree .lyMe, .fourthree .lyte {padding-bottom:75%;} .lidget{margin-bottom:5px;} .lidget .lyte, .widget .lyMe {padding-bottom:0!important;height:100%!important;} .lyte-wrapper-audio .lyte{height:38px!important;overflow:hidden;padding:0!important} .lyMe iframe, .lyte iframe,.lyte .pL{position:absolute !important;top:0;left:0;width:100%;height:100%!important;background:no-repeat scroll center #000;background-size:cover;cursor:pointer} .tC{left:0;position:absolute;top:0;width:100%} .tC{background-image:linear-gradient(to bottom,rgba(0,0,0,0.6),rgba(0,0,0,0))} .tT{color:#FFF;font-family:Roboto,sans-serif;font-size:16px;height:auto;text-align:left;padding:5px 10px 50px 10px} .play{background:no-repeat scroll 0 0 transparent;width:88px;height:63px;position:absolute;left:43%;left:calc(50% - 44px);left:-webkit-calc(50% - 44px);top:38%;top:calc(50% - 31px);top:-webkit-calc(50% - 31px);} .widget .play {top:30%;top:calc(45% - 31px);top:-webkit-calc(45% - 31px);transform:scale(0.6);-webkit-transform:scale(0.6);-ms-transform:scale(0.6);} .lyte:hover .play{background-position:0 -65px;} .lyte-audio .pL{max-height:38px!important} .lyte-audio iframe{height:438px!important} .lyte .ctrl{background:repeat scroll 0 -220px rgba(0,0,0,0.3);width:100%;height:40px;bottom:0px;left:0;position:absolute;} .lyte-wrapper .ctrl{display:none}.Lctrl{background:no-repeat scroll 0 -137px transparent;width:158px;height:40px;bottom:0;left:0;position:absolute} .Rctrl{background:no-repeat scroll -42px -179px transparent;width:117px;height:40px;bottom:0;right:0;position:absolute;padding-right:10px;}.lyte-audio .play{display:none}.lyte-audio .ctrl{background-color:rgba(0,0,0,1)}.lyte .hidden{display:none}");if(style.styleSheet) { style.styleSheet.cssText = rules.nodeValue;} else {style.appendChild(rules);}document.getElementsByTagName("head")\[0\].appendChild(style); (function(){ var corecss = document.createElement('link'); var themecss = document.createElement('link'); var corecssurl = "https://www.smarthomebeginner.com/wp-content/plugins/syntaxhighlighter/syntaxhighlighter3/styles/shCore.css?ver=3.0.9b"; if ( corecss.setAttribute ) { corecss.setAttribute( "rel", "stylesheet" ); corecss.setAttribute( "type", "text/css" ); corecss.setAttribute( "href", corecssurl ); } else { corecss.rel = "stylesheet"; corecss.href = corecssurl; } document.head.appendChild( corecss ); var themecssurl = "https://www.smarthomebeginner.com/wp-content/plugins/syntaxhighlighter/syntaxhighlighter3/styles/shThemeDefault.css?ver=3.0.9b"; if ( themecss.setAttribute ) { themecss.setAttribute( "rel", "stylesheet" ); themecss.setAttribute( "type", "text/css" ); themecss.setAttribute( "href", themecssurl ); } else { themecss.rel = "stylesheet"; themecss.href = themecssurl; } document.head.appendChild( themecss ); })(); SyntaxHighlighter.config.strings.expandSource = '+ expand source'; SyntaxHighlighter.config.strings.help = '?'; SyntaxHighlighter.config.strings.alert = 'SyntaxHighlighter\\n\\n'; SyntaxHighlighter.config.strings.noBrush = 'Can\\'t find brush for: '; SyntaxHighlighter.config.strings.brushNotHtmlScript = 'Brush wasn\\'t configured for html-script option: '; SyntaxHighlighter.defaults\['pad-line-numbers'\] = false; SyntaxHighlighter.defaults\['toolbar'\] = false; SyntaxHighlighter.all(); // Infinite scroll support if ( typeof( jQuery ) !== 'undefined' ) { jQuery( function( $ ) { $( document.body ).on( 'post-load', function() { SyntaxHighlighter.highlight(); } ); } ); } div#toc\_container {width: 100%;}div#toc\_container ul li {font-size: 90%;} var fpframework\_countdown\_widget = {"AND":"and"}; var countVars = {"disqusShortname":"htpcbeginner"}; var embedVars = {"disqusConfig":{"integration":"wordpress 3.0.23"},"disqusIdentifier":"49578 https:\\/\\/www.smarthomebeginner.com\\/?p=49578","disqusShortname":"htpcbeginner","disqusTitle":"Ultimate Docker Media Server: With 60+ Docker Compose Apps \[2024\]","disqusUrl":"https:\\/\\/www.smarthomebeginner.com\\/docker-media-server-2024\\/","postId":"49578"}; var dclCustomVars = {"dcl\_progress\_text":"Loading..."}; var pollsL10n = {"ajax\_url":"https:\\/\\/www.smarthomebeginner.com\\/wp-admin\\/admin-ajax.php","text\_wait":"Your last request is still being processed. Please wait a while ...","text\_valid":"Please choose a valid poll answer.","text\_multiple":"Maximum number of choices allowed: ","show\_loading":"1","show\_fading":"1"}; var generatepressMenu = {"toggleOpenedSubMenus":"1","openSubMenuLabel":"Open Sub-Menu","closeSubMenuLabel":"Close Sub-Menu"}; var generatepressNavSearch = {"open":"Open Search Bar","close":"Close Search Bar"}; var BestAzon\_Configuration = {"Conf\_Subsc\_Model":"2","Amzn\_AfiliateID\_US":"shbeg-20","Amzn\_AfiliateID\_CA":"shbeg09-20","Amzn\_AfiliateID\_GB":"htpcbeg-21","Amzn\_AfiliateID\_DE":"htpcbeg08-21","Amzn\_AfiliateID\_FR":"htpcbeg02-21","Amzn\_AfiliateID\_ES":"htpcbeg0a-21","Amzn\_AfiliateID\_IT":"linuxp03-21","Amzn\_AfiliateID\_JP":"","Amzn\_AfiliateID\_IN":"htpcbeg0f-21","Amzn\_AfiliateID\_CN":"","Amzn\_AfiliateID\_MX":"","Amzn\_AfiliateID\_BR":"","Amzn\_AfiliateID\_AU":"shbeg05-22","Conf\_Custom\_Class":" BestAzon\_Amazon\_Link ","Conf\_New\_Window":"1","Conf\_Link\_Follow":"1","Conf\_Product\_Link":"1","Conf\_Tracking":"2","Conf\_Footer":"2","Conf\_Link\_Keywords":"\\/go\\/","Conf\_Hide\_Redirect\_Link":"1","Conf\_Honor\_Existing\_Tag":"1","Conf\_No\_Aff\_Country\_Redirect":"1","Conf\_GA\_Tracking":"2","Conf\_GA\_ID":"","Conf\_Source":"Wordpress-52"}; var tocplus = {"visibility\_show":"show","visibility\_hide":"hide","visibility\_hide\_by\_default":"1","width":"100%"}; if ( !!window.jQuery ) {(function($){$(document).ready(function(){if ( !!window.SLB && SLB.has\_child('View.init') ) { SLB.View.init({"ui\_autofit":true,"ui\_animate":false,"slideshow\_autostart":false,"slideshow\_duration":"6","group\_loop":true,"ui\_overlay\_opacity":"0.8","ui\_title\_default":false,"theme\_default":"slb\_black","ui\_labels":{"loading":"Loading","close":"Close","nav\_next":"Next","nav\_prev":"Previous","slideshow\_start":"Start slideshow","slideshow\_stop":"Stop slideshow","group\_status":"Item %current% of %total%"}}); } if ( !!window.SLB && SLB.has\_child('View.assets') ) { {$.extend(SLB.View.assets, {"1229502243":{"id":39957,"type":"image","internal":true,"source":"https:\\/\\/www.smarthomebeginner.com\\/images\\/2019\\/04\\/schematic-of-media-aggregation-scaled.jpg","title":"schematic of media aggregation","caption":"Schematic of Automatic Media Management","description":""},"2047212043":{"id":26044,"type":"image","internal":true,"source":"https:\\/\\/www.smarthomebeginner.com\\/images\\/2016\\/11\\/Docker-vs-Virtual-Machines.png","title":"Docker vs Virtual Machines made by docker","caption":"Docker vs Virtual Machines made by docker","description":"Docker vs Virtual Machines made by docker"},"64982157":{"id":37475,"type":"image","internal":true,"source":"https:\\/\\/www.smarthomebeginner.com\\/images\\/2018\\/04\\/docker-store-for-containers.png","title":"docker store for containers","caption":"Search for Containerized Apps on Docker Store","description":""},"1336463704":{"id":50306,"type":"image","internal":true,"source":"https:\\/\\/www.smarthomebeginner.com\\/images\\/2024\\/01\\/docker-and-docker-compose-versions.jpg","title":"docker and docker compose versions","caption":"Docker and Docker Compose Versions","description":""},"231478365":{"id":50580,"type":"image","internal":true,"source":"https:\\/\\/www.smarthomebeginner.com\\/images\\/2024\\/01\\/docker-root-folder-and-files-2024-1.jpg","title":"docker root folder and files 2024","caption":"Docker Root Folder and Files","description":""},"1112256648":{"id":50319,"type":"image","internal":true,"source":"https:\\/\\/www.smarthomebeginner.com\\/images\\/2024\\/01\\/user-id-and-group-id.jpg","title":"user id and group id","caption":"User Id And Group Id","description":""},"114706963":{"id":50336,"type":"image","internal":true,"source":"https:\\/\\/www.smarthomebeginner.com\\/images\\/2024\\/01\\/docker-ps.jpg","title":"docker ps","caption":"Docker List of Containers","description":""},"921617563":{"id":50338,"type":"image","internal":true,"source":"https:\\/\\/www.smarthomebeginner.com\\/images\\/2024\\/01\\/dclogs-output.jpg","title":"dclogs output","caption":"Docker Compose Real-time Logs for Containers","description":""},"1234452968":{"id":50347,"type":"image","internal":true,"source":"https:\\/\\/www.smarthomebeginner.com\\/images\\/2024\\/01\\/listening-ports-e1705612567188.jpg","title":"listening ports","caption":"Listening Ports - Already Occupied","description":""},"1552682593":{"id":50343,"type":"image","internal":true,"source":"https:\\/\\/www.smarthomebeginner.com\\/images\\/2024\\/01\\/no-service-selected.jpg","title":"no service selected","caption":"No Service Selected","description":""},"199581866":{"id":50344,"type":"image","internal":true,"source":"https:\\/\\/www.smarthomebeginner.com\\/images\\/2024\\/01\\/socket-proxy-started.jpg","title":"socket proxy started","caption":"Socket Proxy Started","description":""},"2003881028":{"id":50345,"type":"image","internal":true,"source":"https:\\/\\/www.smarthomebeginner.com\\/images\\/2024\\/01\\/socket-proxy-logs.jpg","title":"socket proxy logs","caption":"Socket Proxy Logs","description":""},"1294854741":{"id":37497,"type":"image","internal":true,"source":"https:\\/\\/www.smarthomebeginner.com\\/images\\/2018\\/04\\/docker-portainer-screenshot.jpg","title":"docker portainer screenshot","caption":"Portainer WebUI for Docker","description":""},"2096244405":{"id":50353,"type":"image","internal":true,"source":"https:\\/\\/www.smarthomebeginner.com\\/images\\/2024\\/01\\/dozzle-screenshot.jpg","title":"dozzle screenshot","caption":"Docker Containers Monitoring and Logs ","description":""},"499289432":{"id":50354,"type":"image","internal":true,"source":"https:\\/\\/www.smarthomebeginner.com\\/images\\/2024\\/01\\/dozzle-log-viewing.jpg","title":"dozzle log viewing","caption":"Viewing Docker Container Logs on Dozzle","description":""},"1084246590":{"id":50574,"type":"image","internal":true,"source":"https:\\/\\/www.smarthomebeginner.com\\/images\\/2024\\/01\\/homepage-screenshot.jpg","title":"homepage screenshot","caption":"Homepage Application Dashboard","description":""},"251996228":{"id":37508,"type":"image","internal":true,"source":"https:\\/\\/www.smarthomebeginner.com\\/images\\/2018\\/04\\/plex-web-interface.jpg","title":"plex web interface","caption":"Plex Web Interface","description":""},"26531321":{"id":50372,"type":"image","internal":true,"source":"https:\\/\\/www.smarthomebeginner.com\\/images\\/2024\\/01\\/docker-secrets-plex-claim.jpg","title":"docker secrets plex claim","caption":"Docker Secrets Plex Claim","description":""},"334916239":{"id":47016,"type":"image","internal":true,"source":"https:\\/\\/www.smarthomebeginner.com\\/images\\/2023\\/04\\/jellyfin-interface-1.jpg","title":"jellyfin interface","caption":"Jellyfin Media Server","description":""},"145029119":{"id":10770,"type":"image","internal":true,"source":"https:\\/\\/www.smarthomebeginner.com\\/images\\/2014\\/03\\/sabnzbd-interface-ft.png","title":"sabnzbd-interface-ft","caption":"Sabnzbd Usenet Downloader","description":""},"2076645343":{"id":29392,"type":"image","internal":true,"source":"https:\\/\\/www.smarthomebeginner.com\\/images\\/2017\\/02\\/qBittorrent-Interface.png","title":"qBittorrent Interface","caption":"qBittorrent Torrent Downloader","description":"qBittorrent Torrent Downloader"},"1498880418":{"id":45462,"type":"image","internal":true,"source":"https:\\/\\/www.smarthomebeginner.com\\/images\\/2022\\/05\\/radarr-screenshot.jpg","title":"radarr screenshot","caption":"Radarr Screenshot","description":""},"1244883071":{"id":37691,"type":"image","internal":true,"source":"https:\\/\\/www.smarthomebeginner.com\\/images\\/2018\\/03\\/sonarr-web-interface.png","title":"sonarr web interface","caption":"Sonarr - TV Shows Download and Organization","description":""},"1503606980":{"id":45482,"type":"image","internal":true,"source":"https:\\/\\/www.smarthomebeginner.com\\/images\\/2022\\/05\\/bazarr-subtitles-for-docker-media-server.jpg","title":"bazarr subtitles for docker media server","caption":"Bazarr - Subtitle Management for Media Servers","description":""},"1622097698":{"id":39827,"type":"image","internal":true,"source":"https:\\/\\/www.smarthomebeginner.com\\/images\\/2019\\/04\\/tautulli-screenshot.jpg","title":"tautulli screenshot","caption":"Tautulli (aka PlexPy) - Monitoring Plex Usage","description":""},"459898":{"id":47044,"type":"image","internal":true,"source":"https:\\/\\/www.smarthomebeginner.com\\/images\\/2023\\/04\\/uptime-kuma-dashboard.jpg","title":"uptime kuma dashboard","caption":"Uptime Kuma Monitoring","description":""},"1596982042":{"id":45454,"type":"image","internal":true,"source":"https:\\/\\/www.smarthomebeginner.com\\/images\\/2022\\/05\\/filebrowser-screenshot.jpg","title":"filebrowser screenshot","caption":"File Browser Interface - Also has a editor with syntax highlighting","description":""},"66511293":{"id":50402,"type":"image","internal":true,"source":"https:\\/\\/www.smarthomebeginner.com\\/images\\/2023\\/04\\/docker-containers-for-home-server-compose-files-scaled.jpg","title":"docker containers for home server compose files","caption":"All Docker Compose Files","description":""}});} } /\* THM \*/ if ( !!window.SLB && SLB.has_child('View.extend_theme') ) { SLB.View.extend_theme('slb_baseline',{"name":"Baseline","parent":"","styles":\[{"handle":"base","uri":"https:\\/\\/www.smarthomebeginner.com\\/wp-content\\/plugins\\/simple-lightbox\\/themes\\/baseline\\/css\\/style.css","deps":\[\]}\],"layout\_raw":"<div class=\\"slb_container\\"><div class=\\"slb_content\\">{{item.content}}<div class=\\"slb_nav\\"><span class=\\"slb_prev\\">{{ui.nav\_prev}}<\\/span><span class=\\"slb_next\\">{{ui.nav\_next}}<\\/span><\\/div><div class=\\"slb_controls\\"><span class=\\"slb_close\\">{{ui.close}}<\\/span><span class=\\"slb_slideshow\\">{{ui.slideshow\_control}}<\\/span><\\/div><div class=\\"slb_loading\\">{{ui.loading}}<\\/div><\\/div><div class=\\"slb_details\\"><div class=\\"inner\\"><div class=\\"slb_data\\"><div class=\\"slb_data_content\\"><span class=\\"slb_data_title\\">{{item.title}}<\\/span><span class=\\"slb_group_status\\">{{ui.group\_status}}<\\/span><div class=\\"slb_data_desc\\">{{item.description}}<\\/div><\\/div><\\/div><div class=\\"slb_nav\\"><span class=\\"slb_prev\\">{{ui.nav\_prev}}<\\/span><span class=\\"slb_next\\">{{ui.nav\_next}}<\\/span><\\/div><\\/div><\\/div><\\/div>"}); }if ( !!window.SLB && SLB.has_child('View.extend_theme') ) { SLB.View.extend_theme('slb_default',{"name":"Default (Light)","parent":"slb_baseline","styles":\[{"handle":"base","uri":"https:\\/\\/www.smarthomebeginner.com\\/wp-content\\/plugins\\/simple-lightbox\\/themes\\/default\\/css\\/style.css","deps":\[\]}\]}); }if ( !!window.SLB && SLB.has_child('View.extend_theme') ) { SLB.View.extend_theme('slb_black',{"name":"Default (Dark)","parent":"slb_default","styles":\[{"handle":"base","uri":"https:\\/\\/www.smarthomebeginner.com\\/wp-content\\/plugins\\/simple-lightbox\\/themes\\/black\\/css\\/style.css","deps":\[\]}\]}); }})})(jQuery);} if ( !!window.jQuery ) {(function($){$(document).ready(function(){if ( !!window.SLB ) { {$.extend(SLB, {"context":\["public","user_guest"\]});} }})})(jQuery);}

✓

Thanks for sharing!

[AddToAny](https://www.addtoany.com/ "Share Buttons")

[More…](#addtoany "Show all")

[AddToAny](https://www.addtoany.com/ "Share Buttons")

[More…](#addtoany "Show all")
