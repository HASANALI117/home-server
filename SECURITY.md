# 20 Docker Security Best Practices – Hardening Traefik Docker Stack

May 7, 2024September 30, 2020 by [Anand](https://www.smarthomebeginner.com/author/anand/ "View all posts by Anand")

![Security For Docker Traefik Stack](20%20Docker%20Security%20Best%20Practices%20-%20Hardening%20Traefik%20Docker%20Stack_files/docker-traefik-security-ft-740x416.webp "20 Docker Security Best Practices - Hardening Traefik Docker Stack 1")

**With increasing docker applications and images, security for docker containers requires more attention than ever before. These Docker Security best practices will help you harden your docker host and applications.**

Starting with our original [Docker media server guide](https://www.smarthomebeginner.com/docker-home-media-server-2018-basic/), followed by [Traefik v1 reverse proxy tutorial](https://www.smarthomebeginner.com/traefik-reverse-proxy-tutorial-for-docker/), and the current [Docker Home Server with Traefik v2](https://www.smarthomebeginner.com/traefik-2-docker-tutorial/), hundreds of thousands of users have successfully built their apps based on Docker. \[**Read:** [What is Docker: Docker vs VirtualBox, Home Server with Docker](https://www.smarthomebeginner.com/what-is-docker-docker-vs-virtualbox/)\]

All though all these guides have security information scattered around, we have never had one guide describing the best practices for _Docker security_. And, this guide will address that gap.

I will mention upfront that I am NOT an expert in **Docker Security**. Rather, the focus of this guide will be to showcase the Docker security measures I have put in place, based my own research, to harden my Traefik Docker stack.

This is a basic docker security checklist and certainly NOT an exhaustive guide for enterprise or DevOps applications.

Table of Contents \[[show](#)\]

- [Docker Security Issues](#Docker_Security_Issues)
- [Docker Security Best Practices](#Docker_Security_Best_Practices)
  - [Securing the Docker Host](#Securing_the_Docker_Host)
    - [1\. Keep Docker Host Up-to-date](#1_Keep_Docker_Host_Up-to-date)
    - [2\. Use a Firewall](#2_Use_a_Firewall)
    - [3\. Use a Reverse Proxy](#3_Use_a_Reverse_Proxy)
  - [Securing Docker](#Securing_Docker)
    - [4\. Do not Change Docker Socket Ownership](#4_Do_not_Change_Docker_Socket_Ownership)
    - [5\. Do not Run Docker Containers as Root](#5_Do_not_Run_Docker_Containers_as_Root)
    - [6\. Use Privileged Mode Carefully](#6_Use_Privileged_Mode_Carefully)
    - [7\. Use Trusted Docker Images](#7_Use_Trusted_Docker_Images)
    - [8\. Use Docker Secrets](#8_Use_Docker_Secrets)
    - [9\. Use a Docker Socket Proxy](#9_Use_a_Docker_Socket_Proxy)
    - [10\. Change DOCKER_OPTS to Respect IP Table Firewall](#10_Change_DOCKER_OPTS_to_Respect_IP_Table_Firewall)
    - [11\. Control Docker Resource Usage](#11_Control_Docker_Resource_Usage)
  - [Securing Docker Applications using Traefik](#Securing_Docker_Applications_using_Traefik)
    - [12\. Rate Limit](#12_Rate_Limit)
    - [13\. Traefik Security Headers](#13_Traefik_Security_Headers)
    - [14\. TLS Options](#14_TLS_Options)
    - [15\. Multifactor Authentication](#15_Multifactor_Authentication)
  - [CloudFlare Settings](#CloudFlare_Settings)
    - [16\. Secure Docker Containers Using Cloudflare](#16_Secure_Docker_Containers_Using_Cloudflare)
  - [Other Security Improvements for Docker Traefik Stack](#Other_Security_Improvements_for_Docker_Traefik_Stack)
    - [17\. Fail2ban](#17_Fail2ban)
    - [18\. Docker Bench Security](#18_Docker_Bench_Security)
    - [19\. RBAC](#19_RBAC)
    - [20\. Container Vulnerability Scanner](#20_Container_Vulnerability_Scanner)
- [Final Thoughts on Docker Security Tips](#Final_Thoughts_on_Docker_Security_Tips)

## Docker Security Issues

Why do we need to secure Docker?

Well, like any piece of software, Docker has vulnerabilities. If docker security vulnerabilities are not hardened, it can lead to a disaster. Here are some example scenarios:

- Running a container as root or elevated privileges can open the door for an app to take over your Docker host.
- Untrusted docker images can have malicious code that could compromise sensitive data or even intentionally expose it.
- Docker services can intentionally or unintentionally consume your host resources, leading to failure or resources being unavailable to other apps.
- Exposing docker socket, which is owned by root, to containers can lead to a full-system takeover. For example, [Traefik requires access to the docker socket](https://docs.traefik.io/providers/docker/#docker-api-access). So if you use Traefik and if Traefik is compromised, then then your system is compromised as well.
- Improperly protected (eg. weak Authentication system) can compromise your web apps.
- Docker malware can use your resources for unintended purposes (eg. Crypto mining).

There are a lot more examples. There was a time when Docker was not ready for production. Even now, many believe that to be the case.

Personally, I have implemented several security measures over the last couple of years. This has given me enough confidence to move this WordPress blog from a traditional LEMP stack to a Docker Traefik Stack. \[**Read:** [WordPress on Docker with Nginx, Traefik, LE SSL, Security, and Speed](https://www.smarthomebeginner.com/wordpress-on-docker-traefik/)\]

In this guide, I will share some of the **best Docker Security practices** I have implemented.

My setup is constantly changing/evolving. I will try my best to keep this post up-to-date. For my current setup, always check my [GitHub Repo](https://github.com/htpcBeginner/docker-traefik).

## Docker Security Best Practices

Securing Docker and its applications can generally be split into several categories. Let us look both simple and some advanced security measures in each of these categories.

> **Be the 1 in 200,000. Help us sustain what we do.**
>
> 56 / 150 by Dec 31, 2024
>
> [Join Us](https://www.smarthomebeginner.com/membership-account/memberships-products-services/) (starting from just $1.67/month)
>
> [Why did we start Memberships?](https://www.smarthomebeginner.com/state-of-the-site-2023/)

Before proceding, ensure that you have Docker and Docker compose installed:

- [Install Docker and Docker Compose on Ubuntu 22.04 Jammy Jellyfish](https://www.smarthomebeginner.com/install-docker-on-ubuntu-22-04/)
- [Install Docker and Docker Compose on Ubuntu 20.04 Focal Fossa](https://www.smarthomebeginner.com/install-docker-on-ubuntu-20-04/)

### Securing the Docker Host

The first category covers all the different things that you can to secure your docker host.

#### 1\. Keep Docker Host Up-to-date

Really no explanation needed here. This is the simplest of the Docker security best practices and it literally takes seconds.

Keep your docker host system up-to-date on security updates. In my Linux based Docker Traefik stack, I frequently refresh the packages and update the system using the following commands:

1

2

`sudo apt-get update`

`sudo apt-get upgrade`

#### 2\. Use a Firewall

A good Docker security practice is to block access to unnecessary ports. I do this using Universal Firewall (UFW) on Debian/Ubuntu systems. As shown in the screenshot below, I only allow access on ports 80 and 443, which are used by traefik. There are other ports that I only allow access from the local private network (192.168.0.0/16).

[

![Ufw Allowed Ports List - Docker Security](https://www.smarthomebeginner.com/images/2020/09/ufw-ports-allowed-list.png "20 Docker Security Best Practices - Hardening Traefik Docker Stack 2")

![Ufw Allowed Ports List - Docker Security](data:image/svg+xml,%3Csvg%20xmlns=%22http://www.w3.org/2000/svg%22%20viewBox=%220%200%20539%20266%22%3E%3C/svg%3E "20 Docker Security Best Practices - Hardening Traefik Docker Stack 2")](https://www.smarthomebeginner.com/images/2020/09/ufw-ports-allowed-list.png)

Ufw Allowed Ports List

**Caution:** Docker does not appear to respect IP Table firewall rules ([GitHub Issue #690](https://github.com/docker/for-linux/issues/690)). The developers have not fixed this in more than a year. A workaround described later in this guide is required for firewall rules to work.

If you are using a [virtual private server](https://www.smarthomebeginner.com/go/vultr "Vultr") on Cloud, your provider may also offer a firewall. For example, I use (and recommend) [Digital Ocean](https://www.smarthomebeginner.com/go/digital-ocean "Digital Ocean") and I have their firewall enabled to allow only certain ports to forward to the droplet.

[

![Inbound Firewall Rules In Digital Ocean](https://www.smarthomebeginner.com/images/2020/09/inbound-firewall-rules-on-digital-ocean-740x147.png "20 Docker Security Best Practices - Hardening Traefik Docker Stack 3")

![Inbound Firewall Rules In Digital Ocean](data:image/svg+xml,%3Csvg%20xmlns=%22http://www.w3.org/2000/svg%22%20viewBox=%220%200%20740%20147%22%3E%3C/svg%3E "20 Docker Security Best Practices - Hardening Traefik Docker Stack 3")](https://www.smarthomebeginner.com/images/2020/09/inbound-firewall-rules-on-digital-ocean.png)

Inbound Firewall Rules In [Digital Ocean](https://www.smarthomebeginner.com/go/digital-ocean "Digital Ocean")

#### 3\. Use a Reverse Proxy

Many of the docker apps listed in my [Docker Traefik guide](https://www.smarthomebeginner.com/traefik-2-docker-tutorial/), including Traefik, require ports to be exposed to the internet to be able to access the UI from anywhere.

The best way is to not expose any ports to the internet and instead [VPN](https://www.smarthomebeginner.com/go/surfshark-vpn "Surfshark") into your private network and access the apps locally. But this is too cumbersome and putting apps behind a reverse proxy is a convenient but worse alternative.

You will need to [setup port forwarding](https://www.smarthomebeginner.com/setup-port-forwarding-on-router/) on your internet gateway to forward certain ports to the Docker host.

[

![Traefik 2 Dashboard](https://www.smarthomebeginner.com/images/2020/09/traefik-2-dashboard-740x353.png "20 Docker Security Best Practices - Hardening Traefik Docker Stack 4")

![Traefik 2 Dashboard](data:image/svg+xml,%3Csvg%20xmlns=%22http://www.w3.org/2000/svg%22%20viewBox=%220%200%20740%20353%22%3E%3C/svg%3E "20 Docker Security Best Practices - Hardening Traefik Docker Stack 4")](https://www.smarthomebeginner.com/images/2020/09/traefik-2-dashboard.png)

Traefik 2 Dashboard

I strongly recommend not exposing all the docker apps to the internet. Instead, put them behind a reverse proxy. I use, Traefik and expose only ports 80 and 443 to the internet. Even the traefik dashboard which uses port 8080 is behind a reverse proxy.

### Securing Docker

The next category is a big one: Docker. Let us go through, what I consider, a **Docker security checklist** to ensure your setup is protected.

#### 4\. Do not Change Docker Socket Ownership

Do not mess with the ownership of Docker Socket (/var/run/docker.sock in Linux). By default the socket is owned by **root** user and **docker** group.

[

![Docker Socket Owned By Root For Additional Docker Security](https://www.smarthomebeginner.com/images/2020/09/docker-socket-ownership.png "20 Docker Security Best Practices - Hardening Traefik Docker Stack 5")

![Docker Socket Owned By Root For Additional Docker Security](data:image/svg+xml,%3Csvg%20xmlns=%22http://www.w3.org/2000/svg%22%20viewBox=%220%200%20467%2034%22%3E%3C/svg%3E "20 Docker Security Best Practices - Hardening Traefik Docker Stack 5")](https://www.smarthomebeginner.com/images/2020/09/docker-socket-ownership.png)

Docker Socket Ownership

For convenience sake, I have recommended [adding yourself (your username) to the **docker** group](https://www.smarthomebeginner.com/docker-home-media-server-2018-basic/#Add_Linux_User_to_Docker_Group), in the past.

The benefit is that you can run docker commands without having to use sudo. But this is a security risk. I have moved away from it and do not recommend it.

#### 5\. Do not Run Docker Containers as Root

The default behavior is for containers to run as root user inside the container, which gives root privileges. This is a security risk.

One of the best Docker security practices is to run the container as non-root user (UID not 0). Reputed and trusted images use this good security practice while building images. For example, LinuxServer.io provides docker images for several home server apps. Their images allow explicitly specifying the UID and GID as environmental variables.

If you followed my [Docker Traefik guide](https://www.smarthomebeginner.com/traefik-2-docker-tutorial/), this should look what is shown in the code block below.

1

2

3

`environment:`

`- PUID=$PUID`

`- PGID=$PGID`

#### 6\. Use Privileged Mode Carefully

The default behavior is for Docker containers to run in "unprivileged" mode. This means these containers cannot run a docker daemon inside themselves. This also disallows the use of host devices or certain kernel functions.

This is usually done by adding the following line to services:

1

`privileged: true`

Some services require privileged mode. For example, only four services in [my Docker compose file](https://github.com/htpcBeginner/docker-traefik) use the privileged mode:

- Home Assistant - For accessing the Z-wave USB controller
- Socket Proxy - A requirement for Socket proxy, which enhances the security
- Glances - For system monitoring
- APCUPSD - For APC UPS Daemon to communicate with the UPS via USB

In such situations, only use docker images from trusted sources (more on this later). An even better approach is to use [docker capabilities](https://github.com/htpcBeginner/docker-traefik).

In addition, adding the following line makes sure that the containers do not gain additional privileges:

1

2

`security_opt:`

`- no-new-privileges:true`

#### 7\. Use Trusted Docker Images

When possible, always use images from verified publishers or official sources as shown below.

[

![Official Images On Docker Hub Offer Docker Container Security](https://www.smarthomebeginner.com/images/2020/09/docker-hub-official-images-740x286.png "20 Docker Security Best Practices - Hardening Traefik Docker Stack 6")

![Official Images On Docker Hub Offer Docker Container Security](data:image/svg+xml,%3Csvg%20xmlns=%22http://www.w3.org/2000/svg%22%20viewBox=%220%200%20740%20286%22%3E%3C/svg%3E "20 Docker Security Best Practices - Hardening Traefik Docker Stack 6")](https://www.smarthomebeginner.com/images/2020/09/docker-hub-official-images.png)

Official Images On Docker Hub

This gives immediate trust and ensures Docker container security.

With unpopular images, it is difficult to predict or guess if Docker security best practices were followed/implemented.

Unfortunately, for many home server apps such as Sonarr, Radarr, etc. there are no "official" or "verified" publishers. Therefore, you will have to go based on the popularity of the image (number of downloads/stars).

#### 8\. Use Docker Secrets

Specifying all your sensitive information (eg, API keys) in the **.env** file, **/etc/environment**, or **docker-compose.yml** file can be a security risk.

This is exactly why [Docker secrets](https://www.docker.com/blog/docker-secrets-management/) was introduced: to manage sensitive data.

Implementing Docker secrets for your stack is a multistep process.

##### A. Create Secrets Folder

First, create a **secrets** folder inside the [docker root folder](https://www.smarthomebeginner.com/traefik-2-docker-tutorial/#Create_Docker_Root_Folder_and_Set_Permissions).

[

![As A Docker Docker Best Practice, Secrets Folder Must Be Owned By Root](https://www.smarthomebeginner.com/images/2020/08/docker-secrets-folder-permissions.png "20 Docker Security Best Practices - Hardening Traefik Docker Stack 7")

![As A Docker Docker Best Practice, Secrets Folder Must Be Owned By Root](data:image/svg+xml,%3Csvg%20xmlns=%22http://www.w3.org/2000/svg%22%20viewBox=%220%200%20491%2020%22%3E%3C/svg%3E "20 Docker Security Best Practices - Hardening Traefik Docker Stack 7")](https://www.smarthomebeginner.com/images/2020/08/docker-secrets-folder-permissions.png)

Docker Secrets Folder Permissions

Set permissions of this folder to **600**, owned by the user **root** and group **root**.

1

2

`sudo chown root:root ~/docker/secrets`

`sudo chmod 600 ~/docker/secrets`

This makes this folder accessible only to the root user, adding a layer of security while accessing sensitive information.

##### B. Create Secret Files

Next, you will have to put your sensitive information in a file. As an example, let us define a secret for Cloudflare account email.

Let's create a file inside the **secrets** folder with the name **cloudflare_email**. Remember that you will need root permissions to create the file. On my Ubuntu system, I use:

1

`sudo su`

followed by:

1

`nano cloudflare_email`

You could use any other text editor.

In the file, the only thing that needs to be added is your Cloudflare account email, as can be seen in my [GitHub Repo](https://github.com/htpcBeginner/docker-traefik/tree/master/secrets_example).

Save and exit.

##### C. Define Secrets in Docker Compose File

Now that the Docker secret is created, let define it in the Docker compose file. This is done using the **secrets:** block.

The example below shows two secrets: cloudflare_email and cloudflare_api_key.

1

2

3

4

5

6

`########################### SECRETS`

`secrets:`

`cloudflare_email:`

`file: $SECRETSDIR/cloudflare_email`

`cloudflare_api_key:`

`file: $SECRETSDIR/cloudflare_api_key`

**$SECRETSDIR** is the environmental variable that contains the path to Docker secrets folder. You can set this up as explained in my [Docker Traefik 2 guide](https://www.smarthomebeginner.com/traefik-2-docker-tutorial/#Setting_Up_Environmental_Variables_for_Docker_and_Docker_Compose).

More examples are shown in my [GitHub Repo](https://github.com/htpcBeginner/docker-traefik).

##### D. Use the Secrets in Docker Services

Once defined globally, we can use the secrets in the docker-compose snippets for individual services. Since we added Cloudflare account details as Docker secrets, let us see how to use them in the docker-compose snippet for Traefik.

First, we have to make the secrets available inside the Traefik container. To do this, you have to add the following block to the docker-compose snippet for Traefik:

1

2

3

`secrets:`

`- cloudflare_email`

`- cloudflare_api_key`

What this does is that it makes the secret file available at **/run/secrets** folder inside the container.

Next, we can set the environment variables to read sensitive data from these secret files using the **environment:** block, as shown below:

1

2

3

`environment:`

`- CF_API_EMAIL_FILE=/run/secrets/cloudflare_email`

`- CF_API_KEY_FILE=/run/secrets/cloudflare_api_key`

Notice that the environmental variables now have **\_FILE** appended at the end. Don't miss this or it won't work.

Save and recreate the service (in this case Traefik) and check the logs for any errors. If Traefik is unable to read the secrets correctly, you will see it as an error in the logs.

In order for Docker secrets to work properly, the container's base image must support it. If the image is a reputed/trusted image, the chances are very high that the developers have implemented _Docker security best practices_, including Docker secrets.

I have moved pretty much all my sensitive information to Docker secrets.

#### 9\. Use a Docker Socket Proxy

Any time you expose the Docker socket to a service, you are making it easier for the container to gain root access on the host system.

But, some apps require access to Docker socket and API (eg. Traefik, Glances, Dozzle, Watchtower, etc.).

If Traefik gets compromised, then your host system could be compromised. [Traefik's own documentation](https://doc.traefik.io/traefik/providers/docker/#docker-api-access) lists using a Socket Proxy as a solution.

A socket proxy is like a firewall for the docker socket/API. You can allow or deny access to certain API.

I started with [Tecnativa's Socket Proxy](https://hub.docker.com/r/tecnativa/docker-socket-proxy) but recently moved to [FluenceLab's Socket Proxy](https://hub.docker.com/r/fluencelabs/docker-socket-proxy) as it provided [more granular control](https://github.com/htpcBeginner/docker-traefik/pull/76).

As always, refer to my [GitHub Repo](https://github.com/htpcBeginner/docker-traefik) for the current version as I keep my repo more frequently updated than this post.

Add the network to your compose file (ignore the first line if you already have a **networks:** block):

1

2

3

4

5

6

7

`networks:`

`socket_proxy:`

`name: socket_proxy`

`driver: bridge`

`ipam:`

`config:`

`- subnet: 192.168.91.0/24`

And finally, here the docker-compose snippet to add socket proxy for improving docker security:

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

`# Docker Socket Proxy - Security Enchanced Proxy for Docker Socket`

`socket-proxy:`

`container_name: socket-proxy`

`image: tecnativa/docker-socket-proxy`

`restart: always`

`networks:`

`socket_proxy:`

`ipv4_address: 192.168.91.254 # You can specify a static IP`

`# privileged: true # true for VM. False for unprivileged LXC container.`

`ports:`

`- "127.0.0.1:2375:2375" # Port 2375 should only ever get exposed to the internal network. When possible use this line.`

`# I use the next line instead, as I want portainer to manage multiple docker endpoints within my home network.`

`# - "2375:2375"`

`volumes:`

`- "/var/run/docker.sock:/var/run/docker.sock"`

`environment:`

`- LOG_LEVEL=info # debug,info,notice,warning,err,crit,alert,emerg`

`## Variables match the URL prefix (i.e. AUTH blocks access to /auth/* parts of the API, etc.).`

`# 0 to revoke access.`

`# 1 to grant access.`

`## Granted by Default`

`- EVENTS=1`

`- PING=1`

`- VERSION=1`

`## Revoked by Default`

`# Security critical`

`- AUTH=0`

`- SECRETS=0`

`- POST=1 # Watchtower`

`# Not always needed`

`- BUILD=0`

`- COMMIT=0`

`- CONFIGS=0`

`- CONTAINERS=1 # Traefik, portainer, etc.`

`- DISTRIBUTION=0`

`- EXEC=0`

`- IMAGES=1 # Portainer`

`- INFO=1 # Portainer`

`- NETWORKS=1 # Portainer`

`- NODES=0`

`- PLUGINS=0`

`- SERVICES=1 # Portainer`

`- SESSION=0`

`- SWARM=0`

`- SYSTEM=0`

`- TASKS=1 # Portainer`

`- VOLUMES=1 # Portainer`

**Caution:** Do not ever expose port 2375 to the internet. You will get hacked ([here is an example](https://github.com/htpcBeginner/docker-traefik/issues/85)). This is even more important for virtual private servers that typically expose all ports. Enable a firewall to allow only ports 80 and 443 (and block the rest) to passthrough to your server and also implement the Docker IP Tables workaround described later in this guide.

In addition, [port 2375 should only ever get exposed to the internal network](https://github.com/htpcBeginner/docker-traefik/pull/88) (127.0.0.1:2375).

In the **environment:** block we specify the Docker API section that we want to open up or close. I have added comments to describe which services require what API sections. For example, if you do not use WatchTower, you can enter **0** for several of the API sections.

Once the Socket proxy container starts, you can replace the direct access to Docker socket with the Socket Proxy for all the services that require it. This can be done in several ways, depending on how the container image supports it.

For Traefik, replace the following CLI argument (if you use CLI arguments instead of static configurations):

1

`- --providers.docker.endpoint=unix:///var/run/docker.sock`

with

1

`- --providers.docker.endpoint=tcp://socket-proxy:2375`

For other services, you may remove specifying Docker Socket as a volume (the following line under **volumes:**):

1

`- /var/run/docker.sock:/var/run/docker.sock:ro`

and add the **DOCKER_HOST** environmental variable as shown below:

1

`DOCKER_HOST: tcp://socket-proxy:2375`

This is what I do for Glances, WatchTower, and Dozzle. If you are lost, check [my Docker Compose file](https://github.com/htpcBeginner/docker-traefik) to see how this is done.

Recreate your stack and your services should be using the secure Docker socket proxy instead of the docker socket.

#### 10\. Change DOCKER_OPTS to Respect IP Table Firewall

I accidentally stumbled upon this issue. I enabled UFW like I always do on my Digital Ocean [VPS](https://www.smarthomebeginner.com/go/vultr "Vultr") and blocked everything except 80 and 443. I unintentionally tried to access one of the services using the port number and was shocked that I was connected.

Upon digging further, I came across [this open issue on GitHub](https://github.com/docker/for-linux/issues/690). Why this has been open for more than a year despite the huge number of people requesting a fix is beyond me.

So if you have Socket proxy enabled and firewall enabled, due to the security flaw in docker, hackers can still hack into your system using the socket proxy port (2375).

Fortunately, there is a workaround. On Ubuntu/Debian based systems, edit **/etc/default/docker** and add the following line:

1

`DOCKER_OPTS="--iptables=false"`

Save the file and restart the docker service.

Try to confirm the fix by accessing one of your services using WAN-IP:PORT.

#### 11\. Control Docker Resource Usage

I loved being able set resources for Docker services. Unfortunately, this is only possible with [Docker-Compose version 2](https://docs.docker.com/compose/compose-file/compose-file-v2/#cpu-and-other-resources) or Docker Swarm mode.

If you are using either of those, you can set [resource limits for Docker services](https://docs.docker.com/config/containers/resource_constraints/).

Here is a docker-compose example for setting resource limits in Docker Swarm mode:

1

2

3

4

5

6

7

8

`deploy:`

`resources:`

`limits:`

`cpus: '0.50'`

`memory: 50M`

`reservations:`

`cpus: '0.25'`

`memory: 20M`

By setting resource limits, you can restrict any service that goes rogue and hogs your system resources.

### Securing Docker Applications using Traefik

There are things that can be done on Traefik side to harden your stack against malicious attacks. Let us look at some of the Traefik security measures that can be implemented.

I continue to make changes to my setup. For the current set of Traefik security middleware, always check my [GitHub Repo](https://github.com/htpcBeginner/docker-traefik).

#### 12\. Rate Limit

Rate limiting is quite common to mitigate brute force or denial of service attacks. In my Traefik Docker stack, I have a [middleware to define rate-limiting](https://github.com/htpcBeginner/docker-traefik).

1

2

3

4

`middlewares-rate-limit:`

`rateLimit:`

`average: 100`

`burst: 50`

The above generic set of numbers work great for me. It can be customized to your situation using Traefik's documentation on [rate-limiting](https://doc.traefik.io/traefik/middlewares/http/ratelimit/).

#### 13\. Traefik Security Headers

Security headers are basic requirements for a website's security. They protect against various attacks, including XSS, click-jacking, code injection, and more.

Explaining the purpose of these headers is beyond the scope of this post.

Here are the Traefik security headers I have defined as middleware:

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

`middlewares-secure-headers:`

`headers:`

`accessControlAllowMethods:`

`- GET`

`- OPTIONS`

`- PUT`

`accessControlMaxAge: 100`

`hostsProxyHeaders:`

`- "X-Forwarded-Host"`

`sslRedirect: true`

`stsSeconds: 63072000`

`stsIncludeSubdomains: true`

`stsPreload: true`

`forceSTSHeader: true`

`# frameDeny: true #overwritten by customFrameOptionsValue`

`customFrameOptionsValue: "allow-from https:example.com" #CSP takes care of this but may be needed for organizr.`

`contentTypeNosniff: true`

`browserXssFilter: true`

`# sslForceHost: true # add sslHost to all of the services`

`# sslHost: "example.com"`

`referrerPolicy: "same-origin"`

`# Setting contentSecurityPolicy is more secure but it can break things. Proper auth will reduce the risk.`

`# the below line also breaks some apps due to 'none' - sonarr, radarr, etc.`

`# contentSecurityPolicy: "frame-ancestors '*.example.com:*';object-src 'none';script-src 'none';"`

`featurePolicy: "camera 'none'; geolocation 'none'; microphone 'none'; payment 'none'; usb 'none'; vr 'none';"`

`customResponseHeaders:`

`X-Robots-Tag: "none,noarchive,nosnippet,notranslate,noimageindex,"`

`server: ""`

There was a [bug in Traefik](https://github.com/traefik/traefik/issues/5568) that prevented one from defining security headers in both dynamic and static configuration. That has since been closed.

So it is now possible to add **sslForceHost** and **sslHost** to individual services, if you prefer, for additional security.

#### 14\. TLS Options

TLS options allow the configuration of TLS connections to secure the connection between the client and your service. More explanation can be found in [Traefik's TLS Documentation](https://doc.traefik.io/traefik/https/tls/).

In my setup, I have defined the following TLS options for Traefik:

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

`tls:`

`options:`

`default:`

`minVersion: VersionTLS12`

`sniStrict: true`

`cipherSuites:`

`- TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256`

`- TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384`

`- TLS_ECDHE_ECDSA_WITH_CHACHA20_POLY1305`

`- TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256`

`- TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384`

`- TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305`

`- TLS_AES_128_GCM_SHA256`

`- TLS_AES_256_GCM_SHA384`

`- TLS_CHACHA20_POLY1305_SHA256`

`curvePreferences:`

`- CurveP521`

`- CurveP384`

#### 15\. Multifactor Authentication

This one is becoming more and more obvious/must-have. If you have not protected your docker apps with multi-factor authentication, do it right now. I have tested and used two authentication systems: Google OAuth and Authelia.

##### Google OAuth for Docker Apps

Refer to our detailed guide on setting up [Google OAuth for Docker](https://www.smarthomebeginner.com/google-oauth-with-traefik-2-docker/).

I started with Google OAuth, which worked great and there was minimal maintenance.

##### Authelia Self-Hosted MFA for Docker Apps

Mid-2020 (during the COVID-19 pandemic), I made the switch to Authelia. Authelia offers a lot more control but that also means more maintenance. \[**Read:** [Authelia Tutorial – Protect your Docker Traefik stack with Private MFA](https://www.smarthomebeginner.com/docker-authelia-tutorial/)\]

As mentioned before, this website now runs on Docker Traefik 2 stack with multifactor authentication from Authelia with Duo Push notification. I love it. But I have also run into minor issues and had to recreate Authelia to get back in business.

### CloudFlare Settings

Not everybody uses Cloudflare. In my Docker Traefik guide, I recommended using Cloudflare for all the very nice features it offers even in the free plan.

In [Cloudflare settings for Docker](https://www.smarthomebeginner.com/cloudflare-settings-for-traefik-docker/) post, I described all the different Cloudflare settings and how to optimize them for Docker security and performance.

#### 16\. Secure Docker Containers Using Cloudflare

For details, review the post linked above. Here is a summary of the key Cloudflare settings to enhance the security of Docker containers when exposed to the internet.

- **Cloudflare Proxy** - Enabled to utilize Cloudflare's security and performance enhancements.

  [

  ![Cloudflare Dns Entries](https://www.smarthomebeginner.com/images/2020/06/cloudflare-dns-entries-740x226.png "20 Docker Security Best Practices - Hardening Traefik Docker Stack 8")

  ![Cloudflare Dns Entries](data:image/svg+xml,%3Csvg%20xmlns=%22http://www.w3.org/2000/svg%22%20viewBox=%220%200%20740%20226%22%3E%3C/svg%3E "20 Docker Security Best Practices - Hardening Traefik Docker Stack 8")](https://www.smarthomebeginner.com/images/2020/06/cloudflare-dns-entries.png)

  Cloudflare Dns Entries

- **SSL Mode** - Full or Strict. This encrypts the connection between origin server to Cloudflare and from Cloudflare to client.
- **Edge Certificates**:
  - **Always Use HTTPS**: ON
  - **HTTP Strict Transport Security (HSTS)**: Enable (Be Cautious)
  - **Minimum TLS Version**: 1.2
  - **Opportunistic Encryption**: ON
  - **TLS 1.3**: ON
  - **Automatic HTTPS Rewrites**: ON
  - **Certificate Transparency Monitoring**: ON
- Firewall Rules - Create rules to allow or deny certain traffic (eg. I only allow traffic from US to my private apps as I access it only from the United States).

  [

  ![Cloudflare Firewall Rules](https://www.smarthomebeginner.com/images/2020/06/cloudflare-firewall-rules.png "20 Docker Security Best Practices - Hardening Traefik Docker Stack 9")

  ![Cloudflare Firewall Rules](data:image/svg+xml,%3Csvg%20xmlns=%22http://www.w3.org/2000/svg%22%20viewBox=%220%200%20740%20335%22%3E%3C/svg%3E "20 Docker Security Best Practices - Hardening Traefik Docker Stack 9")](https://www.smarthomebeginner.com/images/2020/06/cloudflare-firewall-rules.png)

  Cloudflare Firewall Rules

- **Firewall Settings**:
  - **Security Level**: High
  - **Bot Fight Mode**: ON
  - **Challenge Passage**: 30 Minutes
  - **Browser Integrity Check**: ON

Those are the Docker security-related Cloudflare settings. To optimize performance-related settings, refer to my [Cloudflare settings for Docker post](https://www.smarthomebeginner.com/cloudflare-settings-for-traefik-docker/).

> **Be the 1 in 200,000. Help us sustain what we do.**
>
> 56 / 150 by Dec 31, 2024
>
> [Join Us](https://www.smarthomebeginner.com/membership-account/memberships-products-services/) (starting from just $1.67/month)
>
> [Why did we start Memberships?](https://www.smarthomebeginner.com/state-of-the-site-2023/)

### Other Security Improvements for Docker Traefik Stack

All the above docker security best practices are what I have implemented so far. But there are more and I strongly recommend exploring the following for added security.

#### 17\. Fail2ban

[Fail2ban](https://www.fail2ban.org/wiki/index.php/Main_Page) scans your log files and bans IP address that shows malicious intent (eg. looking for exploits, password failures, etc.). When a suspicious activity is found, it updates the firewall rules to block the IP address for a specified amount of time.

The reason I have not given this a priority is that I have [Authelia authentication system](https://www.smarthomebeginner.com/docker-authelia-tutorial/), which has a built-in login limits. But this is still something I plan to implement in the future for improving the security of Docker apps as well as other services.

#### 18\. Docker Bench Security

The [Docker Bench for Security](https://github.com/docker/docker-bench-security) is a script that checks for dozens of common best-practices around deploying Docker containers in production.

This is quite easy to implement and I will add it to my stack in the near future.

#### 19\. RBAC

RBAC is role-based access control. If you are an enterprise or have multiple users, this is a must-have. It can be quite expensive to implement but [portainer makes it super easy](https://www.funkypenguin.co.nz/note/docker-rbac-with-portainer/) (as a sidenote FunkyPenguin's cookbook is awesome...check it out if you haven't) for a nominal fee.

#### 20\. Container Vulnerability Scanner

The last on the list of best practices for docker security is a vulnerability scanner. There are a few examples here but I will list just one: Clair.

[Clair](https://github.com/quay/clair) is an open-source project for the static analysis of vulnerabilities in application containers.  
It uses the Clair API to index the container images and then matches it against known docker security vulnerabilities.

This is also something I would love to implement at some point in the future.

## Final Thoughts on Docker Security Tips

As I said at the beginning of the guide, I am not an expert on Docker or Security. As with everything on this site, I research, learn, try, and then share what I learned with the community.

Docker security is an important subject that requires serious consideration. This Docker security guide is meant to be a starting point for beginners and by no means exhaustive. I strongly suggest continuing to look for additional security measures or even enlist professional help to harden your docker stack.

The docker container security measures I have put in place have worked well for me so far. I will continue to explore more and keep this guide updated. Meanwhile, I hope that the Docker security best practices listed in this guide serves as Docker security checklist and strengthens your setup.

[Facebook](https://www.smarthomebeginner.com/#facebook "Facebook")[Twitter](https://www.smarthomebeginner.com/#twitter "Twitter")[Reddit](https://www.smarthomebeginner.com/#reddit "Reddit")[LinkedIn](https://www.smarthomebeginner.com/#linkedin "LinkedIn")[Share](https://www.addtoany.com/share#url=https%3A%2F%2Fwww.smarthomebeginner.com%2Ftraefik-docker-security-best-practices%2F&title=20%20Docker%20Security%20Best%20Practices%20%E2%80%93%20Hardening%20Traefik%20Docker%20Stack)

### Related Posts:

- [

  ![Proxmox Web Interface Traefik](https://www.smarthomebeginner.com/images/2023/12/proxmox-web-interface-traefik.jpg "How to put Proxmox Web Interface Behind Traefik?")

  ![Proxmox Web Interface Traefik](data:image/svg+xml,%3Csvg%20xmlns=%22http://www.w3.org/2000/svg%22%20viewBox=%220%200%201373%20752%22%3E%3C/svg%3E "How to put Proxmox Web Interface Behind Traefik?")

  How to put Proxmox Web Interface Behind Traefik?](https://www.smarthomebeginner.com/proxmox-web-interface-behind-traefik/)

- [

  ![Redis Docker Compose](https://www.smarthomebeginner.com/images/2022/05/redis-docker-compose-ft-1.jpg "Redis Docker Compose Install: With 2 SAVVY Use Cases")

  ![Redis Docker Compose](data:image/svg+xml,%3Csvg%20xmlns=%22http://www.w3.org/2000/svg%22%20viewBox=%220%200%201100%20628%22%3E%3C/svg%3E "Redis Docker Compose Install: With 2 SAVVY Use Cases")

  Redis Docker Compose Install: With 2 SAVVY Use Cases](https://www.smarthomebeginner.com/redis-docker-compose-example/)

- [

  ![Dozzle Docker Compose](https://www.smarthomebeginner.com/images/2023/03/dozzle-docker-compose-ft.jpg "Dozzle Docker Compose: Simple Docker Logs Viewer")

  ![Dozzle Docker Compose](data:image/svg+xml,%3Csvg%20xmlns=%22http://www.w3.org/2000/svg%22%20viewBox=%220%200%202094%201128%22%3E%3C/svg%3E "Dozzle Docker Compose: Simple Docker Logs Viewer")

  Dozzle Docker Compose: Simple Docker Logs Viewer](https://www.smarthomebeginner.com/dozzle-docker-compose-guide/)

- [

  ![Portainer Container Manager](https://www.smarthomebeginner.com/images/2023/03/portainer-container-manager.jpg "Portainer Docker Compose: FREE & MUST-HAVE Container Manager")

  ![Portainer Container Manager](data:image/svg+xml,%3Csvg%20xmlns=%22http://www.w3.org/2000/svg%22%20viewBox=%220%200%202162%201184%22%3E%3C/svg%3E "Portainer Docker Compose: FREE & MUST-HAVE Container Manager")

  Portainer Docker Compose: FREE & MUST-HAVE Container Manager](https://www.smarthomebeginner.com/portainer-docker-compose-guide/)

- [

  ![Bash Aliases for Docker](https://www.smarthomebeginner.com/images/2024/05/bash-aliases-for-Docker.webp "Simplify Docker, Docker Compose, and Linux Commands with Bash Aliases")

  ![Bash Aliases for Docker](data:image/svg+xml,%3Csvg%20xmlns=%22http://www.w3.org/2000/svg%22%20viewBox=%220%200%201280%20720%22%3E%3C/svg%3E "Simplify Docker, Docker Compose, and Linux Commands with Bash Aliases")

  Simplify Docker, Docker Compose, and Linux Commands…](https://www.smarthomebeginner.com/bash-aliases-for-docker-and-linux/)

- [

  ![Install Docker on Ubuntu 20.04 LTS Focal Fossa](https://www.smarthomebeginner.com/images/2022/04/install-docker-on-ubuntu-20.04-ft.jpg "Install Docker on Ubuntu 20.04 (with Compose) + 3 Easy Tips")

  ![Install Docker on Ubuntu 20.04 LTS Focal Fossa](data:image/svg+xml,%3Csvg%20xmlns=%22http://www.w3.org/2000/svg%22%20viewBox=%220%200%201024%20576%22%3E%3C/svg%3E "Install Docker on Ubuntu 20.04 (with Compose) + 3 Easy Tips")

  Install Docker on Ubuntu 20.04 (with Compose) + 3 Easy Tips](https://www.smarthomebeginner.com/install-docker-on-ubuntu-20-04/)

> **Be the 1 in 200,000. Help us sustain what we do.**
>
> 56 / 150 by Dec 31, 2024
>
> [Join Us](https://www.smarthomebeginner.com/membership-account/memberships-products-services/) (starting from just $1.67/month)
>
> [Why did we start Memberships?](https://www.smarthomebeginner.com/state-of-the-site-2023/)

Categories [Home Server](https://www.smarthomebeginner.com/home-server/) Tags [cloudflare](https://www.smarthomebeginner.com/tag/cloudflare/), [docker](https://www.smarthomebeginner.com/tag/docker/), [reverse proxy](https://www.smarthomebeginner.com/tag/reverse-proxy/), [security](https://www.smarthomebeginner.com/tag/security/), [traefik](https://www.smarthomebeginner.com/tag/traefik/)

[Authelia Tutorial – Protect your Docker Traefik stack with Private MFA](https://www.smarthomebeginner.com/docker-authelia-tutorial/)

[14 Best Private Torrent Trackers – Movies, TV, Music, more. \[Dec 2020\]](https://www.smarthomebeginner.com/best-private-torrent-trackers/)

![](https://secure.gravatar.com/avatar/5038190c1ce8da93329cc44d5b592149?s=100&d=monsterid&r=pg)

![](data:image/svg+xml,%3Csvg%20xmlns=%22http://www.w3.org/2000/svg%22%20viewBox=%220%200%20100%20100%22%3E%3C/svg%3E)

### Anand

Anand is a self-learned computer enthusiast, hopeless tinkerer (if it ain't broke, fix it), a part-time blogger, and a Scientist during the day. He has been blogging since 2010 on Linux, Ubuntu, Home/Media/File Servers, Smart Home Automation, and related HOW-TOs.

Load Comments

[Facebook](https://www.smarthomebeginner.com/#facebook)[Twitter](https://www.smarthomebeginner.com/#twitter)[Reddit](https://www.smarthomebeginner.com/#reddit)[LinkedIn](https://www.smarthomebeginner.com/#linkedin)[Share](https://www.addtoany.com/share#url=https%3A%2F%2Fwww.smarthomebeginner.com%2Ftraefik-docker-security-best-practices%2F&title=20%20Docker%20Security%20Best%20Practices%20-%20Hardening%20Traefik%20Docker%20Stack%20%7C%20SHB)

[Arabic](#) [Chinese (Simplified)](#) [Dutch](#) [English](#) [French](#) [German](#) [Italian](#) [Portuguese](#) [Russian](#) [Spanish](#)

![en](20%20Docker%20Security%20Best%20Practices%20-%20Hardening%20Traefik%20Docker%20Stack_files/en-us.svg) en

[![](https://www.smarthomebeginner.com/wp-content/plugins/wp-youtube-lyte/lyteCache.php?origThumbUrl=https%3A%2F%2Fimg.youtube.com%2Fvi%2FKMZIyoZ3jWM%2Fhqdefault.jpg)](https://youtu.be/KMZIyoZ3jWM)

Master Traefik 3 in 60 min: Best Docker Reverse Proxy

> **Be the 1 in 200,000. Help us sustain what we do.**
>
> 56 / 150 by Dec 31, 2024
>
> [Join Us](https://www.smarthomebeginner.com/membership-account/memberships-products-services/)
>
> [Why did we start Memberships?](https://www.smarthomebeginner.com/state-of-the-site-2023/)

[Twitter](https://twitter.com/anandslab) [Facebook](https://www.facebook.com/anandslab) [Instagram](https://www.instagram.com/smarthomebeginr) [LinkedIn](https://www.linkedin.com/company/anandslab) [YouTube](https://www.youtube.com/@anandslab) [GitHub](https://github.com/htpcbeginner) [Feed](https://www.smarthomebeginner.com/feed/) Subscribe

[

![SmartHomeBeginner Discord Community](https://www.smarthomebeginner.com/images/2022/05/join-discord-300x75.png "SmartHomeBeginner Discord Community")

![SmartHomeBeginner Discord Community](20%20Docker%20Security%20Best%20Practices%20-%20Hardening%20Traefik%20Docker%20Stack_files/join-discord-300x75.webp "SmartHomeBeginner Discord Community")](https://www.smarthomebeginner.com/discord/)

## Recent Posts

- [

  ![Bash Aliases For Docker](https://www.smarthomebeginner.com/images/2024/05/bash-aliases-for-Docker-150x84.webp "Simplify Docker, Docker Compose, and Linux Commands with Bash Aliases 10")

  ![Bash Aliases For Docker](20%20Docker%20Security%20Best%20Practices%20-%20Hardening%20Traefik%20Docker%20Stack_files/bash-aliases-for-Docker-150x84.webp "Simplify Docker, Docker Compose, and Linux Commands with Bash Aliases 10")](https://www.smarthomebeginner.com/bash-aliases-for-docker-and-linux/)

  [Simplify Docker, Docker Compose, and Linux Commands with Bash Aliases](https://www.smarthomebeginner.com/bash-aliases-for-docker-and-linux/)

- [

  ![Traefik V3 Docker Compose](https://www.smarthomebeginner.com/images/2024/05/Docker-Series-05-Traefik-v3-150x84.png "Ultimate Traefik v3 Docker Compose Guide [2024]: LE, SSL, Reverse Proxy 11")

  ![Traefik V3 Docker Compose](20%20Docker%20Security%20Best%20Practices%20-%20Hardening%20Traefik%20Docker%20Stack_files/Docker-Series-05-Traefik-v3-150x84.webp "Ultimate Traefik v3 Docker Compose Guide [2024]: LE, SSL, Reverse Proxy 11")](https://www.smarthomebeginner.com/traefik-v3-docker-compose-guide-2024/)

  [Ultimate Traefik v3 Docker Compose Guide \[2024\]: LE, SSL, Reverse Proxy](https://www.smarthomebeginner.com/traefik-v3-docker-compose-guide-2024/)

- [

  ![Best Mini Pc For Proxmox](https://www.smarthomebeginner.com/images/2024/04/Best-Mini-PC-for-Proxmox-150x84.png "5 Best Mini PC for Proxmox Home Server [2024] 12")

  ![Best Mini Pc For Proxmox](20%20Docker%20Security%20Best%20Practices%20-%20Hardening%20Traefik%20Docker%20Stack_files/Best-Mini-PC-for-Proxmox-150x84.webp "5 Best Mini PC for Proxmox Home Server [2024] 12")](https://www.smarthomebeginner.com/best-mini-pc-for-proxmox-2024/)

  [5 Best Mini PC for Proxmox Home Server \[2024\]](https://www.smarthomebeginner.com/best-mini-pc-for-proxmox-2024/)

- [

  ![Google Oauth](https://www.smarthomebeginner.com/images/2024/04/Docker-Series-07-Google-OAuth-150x84.png "Google OAuth Traefik Forward Auth [2024]: Most Convenient MFA 13")

  ![Google Oauth](20%20Docker%20Security%20Best%20Practices%20-%20Hardening%20Traefik%20Docker%20Stack_files/Docker-Series-07-Google-OAuth-150x84.webp "Google OAuth Traefik Forward Auth [2024]: Most Convenient MFA 13")](https://www.smarthomebeginner.com/google-oauth-traefik-forward-auth-2024/)

  [Google OAuth Traefik Forward Auth \[2024\]: Most Convenient MFA](https://www.smarthomebeginner.com/google-oauth-traefik-forward-auth-2024/)

- [

  ![Vaultwarden Docker Compose](https://www.smarthomebeginner.com/images/2023/12/vaultwarden-install-header-1-150x84.webp "Vaultwarden Docker Compose + Detailed Configuration Guide 14")

  ![Vaultwarden Docker Compose](data:image/svg+xml,%3Csvg%20xmlns=%22http://www.w3.org/2000/svg%22%20viewBox=%220%200%20150%2084%22%3E%3C/svg%3E "Vaultwarden Docker Compose + Detailed Configuration Guide 14")](https://www.smarthomebeginner.com/vaultwarden-docker-compose-guide/)

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

window.lazySizesConfig=window.lazySizesConfig||{};window.lazySizesConfig.loadMode=1;var bU="https://www.smarthomebeginner.com/wp-content/plugins/wp-youtube-lyte/lyte/";var mOs=null;style = document.createElement("style");style.type = "text/css";rules = document.createTextNode(".lyte-wrapper-audio div, .lyte-wrapper div {margin:0px; overflow:hidden;} .lyte,.lyMe{position:relative;padding-bottom:56.25%;height:0;overflow:hidden;background-color:#777;} .fourthree .lyMe, .fourthree .lyte {padding-bottom:75%;} .lidget{margin-bottom:5px;} .lidget .lyte, .widget .lyMe {padding-bottom:0!important;height:100%!important;} .lyte-wrapper-audio .lyte{height:38px!important;overflow:hidden;padding:0!important} .lyMe iframe, .lyte iframe,.lyte .pL{position:absolute !important;top:0;left:0;width:100%;height:100%!important;background:no-repeat scroll center #000;background-size:cover;cursor:pointer} .tC{left:0;position:absolute;top:0;width:100%} .tC{background-image:linear-gradient(to bottom,rgba(0,0,0,0.6),rgba(0,0,0,0))} .tT{color:#FFF;font-family:Roboto,sans-serif;font-size:16px;height:auto;text-align:left;padding:5px 10px 50px 10px} .play{background:no-repeat scroll 0 0 transparent;width:88px;height:63px;position:absolute;left:43%;left:calc(50% - 44px);left:-webkit-calc(50% - 44px);top:38%;top:calc(50% - 31px);top:-webkit-calc(50% - 31px);} .widget .play {top:30%;top:calc(45% - 31px);top:-webkit-calc(45% - 31px);transform:scale(0.6);-webkit-transform:scale(0.6);-ms-transform:scale(0.6);} .lyte:hover .play{background-position:0 -65px;} .lyte-audio .pL{max-height:38px!important} .lyte-audio iframe{height:438px!important} .lyte .ctrl{background:repeat scroll 0 -220px rgba(0,0,0,0.3);width:100%;height:40px;bottom:0px;left:0;position:absolute;} .lyte-wrapper .ctrl{display:none}.Lctrl{background:no-repeat scroll 0 -137px transparent;width:158px;height:40px;bottom:0;left:0;position:absolute} .Rctrl{background:no-repeat scroll -42px -179px transparent;width:117px;height:40px;bottom:0;right:0;position:absolute;padding-right:10px;}.lyte-audio .play{display:none}.lyte-audio .ctrl{background-color:rgba(0,0,0,1)}.lyte .hidden{display:none}");if(style.styleSheet) { style.styleSheet.cssText = rules.nodeValue;} else {style.appendChild(rules);}document.getElementsByTagName("head")\[0\].appendChild(style); (function(){ var corecss = document.createElement('link'); var themecss = document.createElement('link'); var corecssurl = "https://www.smarthomebeginner.com/wp-content/plugins/syntaxhighlighter/syntaxhighlighter3/styles/shCore.css?ver=3.0.9b"; if ( corecss.setAttribute ) { corecss.setAttribute( "rel", "stylesheet" ); corecss.setAttribute( "type", "text/css" ); corecss.setAttribute( "href", corecssurl ); } else { corecss.rel = "stylesheet"; corecss.href = corecssurl; } document.head.appendChild( corecss ); var themecssurl = "https://www.smarthomebeginner.com/wp-content/plugins/syntaxhighlighter/syntaxhighlighter3/styles/shThemeDefault.css?ver=3.0.9b"; if ( themecss.setAttribute ) { themecss.setAttribute( "rel", "stylesheet" ); themecss.setAttribute( "type", "text/css" ); themecss.setAttribute( "href", themecssurl ); } else { themecss.rel = "stylesheet"; themecss.href = themecssurl; } document.head.appendChild( themecss ); })(); SyntaxHighlighter.config.strings.expandSource = '+ expand source'; SyntaxHighlighter.config.strings.help = '?'; SyntaxHighlighter.config.strings.alert = 'SyntaxHighlighter\\n\\n'; SyntaxHighlighter.config.strings.noBrush = 'Can\\'t find brush for: '; SyntaxHighlighter.config.strings.brushNotHtmlScript = 'Brush wasn\\'t configured for html-script option: '; SyntaxHighlighter.defaults\['pad-line-numbers'\] = false; SyntaxHighlighter.defaults\['toolbar'\] = false; SyntaxHighlighter.all(); // Infinite scroll support if ( typeof( jQuery ) !== 'undefined' ) { jQuery( function( $ ) { $( document.body ).on( 'post-load', function() { SyntaxHighlighter.highlight(); } ); } ); } div#toc\_container {width: 100%;}div#toc\_container ul li {font-size: 90%;} var fpframework\_countdown\_widget = {"AND":"and"}; var countVars = {"disqusShortname":"htpcbeginner"}; var embedVars = {"disqusConfig":{"integration":"wordpress 3.0.23"},"disqusIdentifier":"41345 https:\\/\\/www.smarthomebeginner.com\\/?p=41345","disqusShortname":"htpcbeginner","disqusTitle":"20 Docker Security Best Practices \\u2013 Hardening Traefik Docker Stack","disqusUrl":"https:\\/\\/www.smarthomebeginner.com\\/traefik-docker-security-best-practices\\/","postId":"41345"}; var dclCustomVars = {"dcl\_progress\_text":"Loading..."}; var pollsL10n = {"ajax\_url":"https:\\/\\/www.smarthomebeginner.com\\/wp-admin\\/admin-ajax.php","text\_wait":"Your last request is still being processed. Please wait a while ...","text\_valid":"Please choose a valid poll answer.","text\_multiple":"Maximum number of choices allowed: ","show\_loading":"1","show\_fading":"1"}; var generatepressMenu = {"toggleOpenedSubMenus":"1","openSubMenuLabel":"Open Sub-Menu","closeSubMenuLabel":"Close Sub-Menu"}; var generatepressNavSearch = {"open":"Open Search Bar","close":"Close Search Bar"}; var BestAzon\_Configuration = {"Conf\_Subsc\_Model":"2","Amzn\_AfiliateID\_US":"shbeg-20","Amzn\_AfiliateID\_CA":"shbeg09-20","Amzn\_AfiliateID\_GB":"htpcbeg-21","Amzn\_AfiliateID\_DE":"htpcbeg08-21","Amzn\_AfiliateID\_FR":"htpcbeg02-21","Amzn\_AfiliateID\_ES":"htpcbeg0a-21","Amzn\_AfiliateID\_IT":"linuxp03-21","Amzn\_AfiliateID\_JP":"","Amzn\_AfiliateID\_IN":"htpcbeg0f-21","Amzn\_AfiliateID\_CN":"","Amzn\_AfiliateID\_MX":"","Amzn\_AfiliateID\_BR":"","Amzn\_AfiliateID\_AU":"shbeg05-22","Conf\_Custom\_Class":" BestAzon\_Amazon\_Link ","Conf\_New\_Window":"1","Conf\_Link\_Follow":"1","Conf\_Product\_Link":"1","Conf\_Tracking":"2","Conf\_Footer":"2","Conf\_Link\_Keywords":"\\/go\\/","Conf\_Hide\_Redirect\_Link":"1","Conf\_Honor\_Existing\_Tag":"1","Conf\_No\_Aff\_Country\_Redirect":"1","Conf\_GA\_Tracking":"2","Conf\_GA\_ID":"","Conf\_Source":"Wordpress-52"}; var tocplus = {"visibility\_show":"show","visibility\_hide":"hide","visibility\_hide\_by\_default":"1","width":"100%"}; window.gtranslateSettings = /\* document.write \*/ window.gtranslateSettings || {};window.gtranslateSettings\['63909422'\] = {"default\_language":"en","languages":\["ar","zh-CN","nl","en","fr","de","it","pt","ru","es"\],"url\_structure":"none","flag\_style":"2d","wrapper\_selector":"#gt-wrapper-63909422","alt\_flags":{"en":"usa"},"float\_switcher\_open\_direction":"top","switcher\_horizontal\_position":"inline","flags\_location":"\\/wp-content\\/plugins\\/gtranslate\\/flags\\/"}; if ( !!window.jQuery ) {(function($){$(document).ready(function(){if ( !!window.SLB && SLB.has\_child('View.init') ) { SLB.View.init({"ui\_autofit":true,"ui\_animate":false,"slideshow\_autostart":false,"slideshow\_duration":"6","group\_loop":true,"ui\_overlay\_opacity":"0.8","ui\_title\_default":false,"theme\_default":"slb\_black","ui\_labels":{"loading":"Loading","close":"Close","nav\_next":"Next","nav\_prev":"Previous","slideshow\_start":"Start slideshow","slideshow\_stop":"Stop slideshow","group\_status":"Item %current% of %total%"}}); } if ( !!window.SLB && SLB.has\_child('View.assets') ) { {$.extend(SLB.View.assets, {"930843966":{"id":41445,"type":"image","internal":true,"source":"https:\\/\\/www.smarthomebeginner.com\\/images\\/2020\\/09\\/ufw-ports-allowed-list.png","title":"ufw ports allowed list","caption":"UFW Allowed Ports List","description":""},"591115417":{"id":41446,"type":"image","internal":true,"source":"https:\\/\\/www.smarthomebeginner.com\\/images\\/2020\\/09\\/inbound-firewall-rules-on-digital-ocean.png","title":"inbound firewall rules on digital ocean","caption":"Inbound Firewall Rules in Digital Ocean","description":""},"1019562014":{"id":41448,"type":"image","internal":true,"source":"https:\\/\\/www.smarthomebeginner.com\\/images\\/2020\\/09\\/traefik-2-dashboard.png","title":"traefik 2 dashboard","caption":"Traefik 2 Dashboard","description":""},"1281939153":{"id":41450,"type":"image","internal":true,"source":"https:\\/\\/www.smarthomebeginner.com\\/images\\/2020\\/09\\/docker-socket-ownership.png","title":"docker socket ownership","caption":"Docker Socket Ownership","description":""},"1583492933":{"id":41451,"type":"image","internal":true,"source":"https:\\/\\/www.smarthomebeginner.com\\/images\\/2020\\/09\\/docker-hub-official-images.png","title":"docker hub official images","caption":"Official Images on Docker Hub","description":""},"425247604":{"id":41326,"type":"image","internal":true,"source":"https:\\/\\/www.smarthomebeginner.com\\/images\\/2020\\/08\\/docker-secrets-folder-permissions.png","title":"docker secrets folder permissions","caption":"Docker Secrets Folder Permissions","description":""},"935751778":{"id":41133,"type":"image","internal":true,"source":"https:\\/\\/www.smarthomebeginner.com\\/images\\/2020\\/06\\/cloudflare-dns-entries.png","title":"cloudflare dns entries","caption":"Cloudflare DNS Entries","description":""},"573978050":{"id":41144,"type":"image","internal":true,"source":"https:\\/\\/www.smarthomebeginner.com\\/images\\/2020\\/06\\/cloudflare-firewall-rules.png","title":"cloudflare firewall rules","caption":"Cloudflare Firewall Rules","description":""}});} } /\* THM \*/ if ( !!window.SLB && SLB.has_child('View.extend_theme') ) { SLB.View.extend_theme('slb_baseline',{"name":"Baseline","parent":"","styles":\[{"handle":"base","uri":"https:\\/\\/www.smarthomebeginner.com\\/wp-content\\/plugins\\/simple-lightbox\\/themes\\/baseline\\/css\\/style.css","deps":\[\]}\],"layout\_raw":"<div class=\\"slb_container\\"><div class=\\"slb_content\\">{{item.content}}<div class=\\"slb_nav\\"><span class=\\"slb_prev\\">{{ui.nav\_prev}}<\\/span><span class=\\"slb_next\\">{{ui.nav\_next}}<\\/span><\\/div><div class=\\"slb_controls\\"><span class=\\"slb_close\\">{{ui.close}}<\\/span><span class=\\"slb_slideshow\\">{{ui.slideshow\_control}}<\\/span><\\/div><div class=\\"slb_loading\\">{{ui.loading}}<\\/div><\\/div><div class=\\"slb_details\\"><div class=\\"inner\\"><div class=\\"slb_data\\"><div class=\\"slb_data_content\\"><span class=\\"slb_data_title\\">{{item.title}}<\\/span><span class=\\"slb_group_status\\">{{ui.group\_status}}<\\/span><div class=\\"slb_data_desc\\">{{item.description}}<\\/div><\\/div><\\/div><div class=\\"slb_nav\\"><span class=\\"slb_prev\\">{{ui.nav\_prev}}<\\/span><span class=\\"slb_next\\">{{ui.nav\_next}}<\\/span><\\/div><\\/div><\\/div><\\/div>"}); }if ( !!window.SLB && SLB.has_child('View.extend_theme') ) { SLB.View.extend_theme('slb_default',{"name":"Default (Light)","parent":"slb_baseline","styles":\[{"handle":"base","uri":"https:\\/\\/www.smarthomebeginner.com\\/wp-content\\/plugins\\/simple-lightbox\\/themes\\/default\\/css\\/style.css","deps":\[\]}\]}); }if ( !!window.SLB && SLB.has_child('View.extend_theme') ) { SLB.View.extend_theme('slb_black',{"name":"Default (Dark)","parent":"slb_default","styles":\[{"handle":"base","uri":"https:\\/\\/www.smarthomebeginner.com\\/wp-content\\/plugins\\/simple-lightbox\\/themes\\/black\\/css\\/style.css","deps":\[\]}\]}); }})})(jQuery);} if ( !!window.jQuery ) {(function($){$(document).ready(function(){if ( !!window.SLB ) { {$.extend(SLB, {"context":\["public","user_guest"\]});} }})})(jQuery);}

✓

Thanks for sharing!

[AddToAny](https://www.addtoany.com/ "Share Buttons")

[More…](#addtoany "Show all")

[AddToAny](https://www.addtoany.com/ "Share Buttons")

[More…](#addtoany "Show all")
