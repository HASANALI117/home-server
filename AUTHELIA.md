# Authelia Docker Compose Guide: Secure 2-Factor Authentication \[2024\]

May 30, 2024February 20, 2024 by [Anand](https://www.smarthomebeginner.com/author/anand/ "View all posts by Anand")

Don’t like to outsource your authentication to third-party services like Google OAuth? Then this Authelia Docker Compose guide is for you.

[Facebook](https://www.smarthomebeginner.com/#facebook "Facebook")[Twitter](https://www.smarthomebeginner.com/#twitter "Twitter")[Reddit](https://www.smarthomebeginner.com/#reddit "Reddit")[LinkedIn](https://www.smarthomebeginner.com/#linkedin "LinkedIn")[Share](https://www.addtoany.com/share#url=https%3A%2F%2Fwww.smarthomebeginner.com%2Fauthelia-docker-compose-guide-2024%2F&title=Authelia%20Docker%20Compose%20Guide%3A%20Secure%202-Factor%20Authentication%20%5B2024%5D)

![Authelia Docker Compose Guide](Authelia%20Docker%20Compose%20Guide%20Secure%202-Factor%20Authentication%20[2024]_files/Docker-Series-06-Authelia-740x416.webp "Authelia Docker Compose Guide: Secure 2-Factor Authentication [2024] 1")

Authelia is a self-contained and local authentication layer for Docker services. This **Authelia Docker Compose tutorial** is going to show you how to easily add a secure multi-factor authentication to your Docker stack.

**Note:** If you prefer the convenience of automating Authelia setup + more (e.g. Traefik, Backups, Portainer, Homepage, etc.), then check out [Auto-Traefik Script](https://www.smarthomebeginner.com/auto-traefik/).

As you may know, I am a big fan of Docker and Traefik. I have covered this in detail in my Ultimate Docker Server series:

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

In my Traefik guide, I left you with basic HTTP authentication. But urged you to upgrade to a more secure and modern authentication layer such as Authelia (self-hoted) or Google Oauth (if you trust Google).

I covered Authelia in my previous post in [2020](https://www.smarthomebeginner.com/docker-authelia-tutorial/). My setup has changed significantly since then and so has Authelia. Therefore, it's time for an updated _Docker Compose guide for Authelia_.

We are going to do this in sections. First, we will meet the bare minimum requirements to get Authelia running on Docker. Then, I will leave you with a few Authelia enhancement ideas. We are going to do it all using [Docker Compose](https://docs.docker.com/compose/) because it is easier.

Table of Contents \[[show](#)\]

- [What is Authelia?](#What_is_Authelia)
  - [Authelia Features](#Authelia_Features)
  - [Types of Authelia Deployment](#Types_of_Authelia_Deployment)
  - [Authelia Alternatives](#Authelia_Alternatives)
    - [Authelia vs Google Oauth](#Authelia_vs_Google_Oauth)
    - [Authelia vs Keycloak](#Authelia_vs_Keycloak)
    - [Authelia vs Authentik](#Authelia_vs_Authentik)
  - [Automated Authelia Setup](#Automated_Authelia_Setup)
  - [Authelia Docker Compose Requirements](#Authelia_Docker_Compose_Requirements)
- [Authelia Configuration](#Authelia_Configuration)
  - [1\. Authelia "Required" Configuration](#1_Authelia_Required_Configuration)
    - [Customizing Authelia Configuration](#Customizing_Authelia_Configuration)
  - [2\. Authelia Secrets](#2_Authelia_Secrets)
  - [3\. Authelia Users](#3_Authelia_Users)
    - [Adding Additional Users](#Adding_Additional_Users)
  - [4\. Authelia Traefik Configuration](#4_Authelia_Traefik_Configuration)
    - [Authelia Traefik Middleware](#Authelia_Traefik_Middleware)
    - [Authelia Middleware Chain](#Authelia_Middleware_Chain)
  - [5\. Authelia Docker Compose](#5_Authelia_Docker_Compose)
  - [6\. Starting Authelia and Registering](#6_Starting_Authelia_and_Registering)
    - [Authelia First Time Use and Registration](#Authelia_First_Time_Use_and_Registration)
- [Authentication and Conditional Bypassing](#Authentication_and_Conditional_Bypassing)
  - [Putting Docker Services behind Authelia](#Putting_Docker_Services_behind_Authelia)
  - [Putting Non-Docker Services behind Authelia](#Putting_Non-Docker_Services_behind_Authelia)
  - [Bypassing Authelia](#Bypassing_Authelia)
- [Authelia Enhancements](#Authelia_Enhancements)
  - [Redis](#Redis)
  - [MySQL Storage](#MySQL_Storage)
  - [Email Notifications](#Email_Notifications)
  - [Enabling Duo Push Notification for Authelia](#Enabling_Duo_Push_Notification_for_Authelia)
    - [1\. Create a Duo User](#1_Create_a_Duo_User)
    - [2\. Activate the User](#2_Activate_the_User)
    - [3\. Create an Application](#3_Create_an_Application)
    - [4\. Configure Duo API in Authelia Configuration](#4_Configure_Duo_API_in_Authelia_Configuration)
    - [5\. Test Authelia Duo Push Notification](#5_Test_Authelia_Duo_Push_Notification)
- [Final Thoughts on Authelia for Docker Traefik](#Final_Thoughts_on_Authelia_for_Docker_Traefik)

## What is Authelia?

[Authelia](https://github.com/authelia/authelia) is an open-source authentication and authorization server providing 2-factor authentication and single sign-on (SSO) for your applications via a web portal. It acts as a companion of reverse proxies like Nginx, Traefik, or HAProxy to let them know whether queries should pass through. Unauthenticated users are redirected to the Authelia Sign-in portal instead.

The schematic below shows how Authelia fits into the grand scheme of things.

[

![Authelia Tutorial For Docker And Traefik](https://www.smarthomebeginner.com/images/2020/06/authelia-tutorial-docker-traefik-740x412.jpg "Authelia Docker Compose Guide: Secure 2-Factor Authentication [2024] 2")

![Authelia Tutorial For Docker And Traefik](data:image/svg+xml,%3Csvg%20xmlns=%22http://www.w3.org/2000/svg%22%20viewBox=%220%200%20740%20412%22%3E%3C/svg%3E "Authelia Docker Compose Guide: Secure 2-Factor Authentication [2024] 2")](https://www.smarthomebeginner.com/images/2020/06/authelia-tutorial-docker-traefik.jpg)

Authelia Traefik Schematic

Detailed information is available on [Authelia's GitHub page](https://github.com/authelia/authelia) and its [Documentation](https://www.authelia.com/configuration/prologue/introduction/).

Authelia 4.38 is out as of March 13, 2024. It has a few breaking changes. At this point, this guide is based on version 4.37.5, which still works great.

### Authelia Features

Here are some key features of Authelia:

- Several kinds of second factor:
  1.  Security Key (U2F) with Yubikey.
  2.  Time-based One-Time password with Google Authenticator.
  3.  Mobile Push Notifications with Duo.
- Password reset with identity verification using email confirmation.
- Single-factor only authentication method available.
- Access restriction after too many authentication attempts.
- Fine-grained access control per subdomain, user, resource and network.
- Support of basic authentication for endpoints protected by single factor.
- Highly available using a remote database and Redis as a highly available KV store.

### Types of Authelia Deployment

Authelia supports three scenarios:

1.  **Local:** Meant to be used for scenarios where the server is not exposed to the internet. Domains will be defined in the local hosts file and self-signed certificates will be utilized. This is useful for testing.
2.  **Lite:** Authelia Lite is for scenarios where the server will be exposed to the internet with proper domains, DNS, and LetsEncrypt certificates. The Lite element refers to minimal external dependencies; File based user storage; SQLite based configuration storage. In this configuration, the service will not scale well.
3.  **Full:** Authelia full, is similar to Lite but with scalable setup which includes external dependencies; LDAP based user storage, Database based configuration storage (MariaDB, MySQL or Postgres).

In this Authelia Docker-Compose guide, we are going to setup the **Lite scenario**, which is sufficient for a typical homelab user. However, we are going to also make it slightly scalable with Redis and MySQL configuration. Only LDAP user storage is not covered here.

### Authelia Alternatives

Are there alternatives to Authelia? Sure, there are many replacements for Authelia: Google OAuth, Keycloak, and Authentik.

#### Authelia vs Google Oauth

We already discussed [Google OAuth](https://www.smarthomebeginner.com/google-oauth-traefik-forward-auth-2024/). I liked Google OAuth 2.0 and I rarely had to login because I am usually logged into my google account on the browser.

I never really had any issues using Google OAuth. But if the thought of using my private authentication layer that is open-source fascinates you, then Authelia is a strong candidate to consider.

#### Authelia vs [Keycloak](https://github.com/keycloak/keycloak)

I have personally not administered Keycloak but have used it and spoken to others that administer it. In my limited knowledge, my opinion is that Authelia is a lot simpler to administer and use than Keycloak for protecting Docker services. Authelia has also met all my needs so far.

Combined with [Cloudflare settings for Docker](https://www.smarthomebeginner.com/cloudflare-settings-for-traefik-docker/) and [Docker Security best practices](https://www.smarthomebeginner.com/traefik-docker-security-best-practices/), Authelia has significantly enhanced the security of my setup.

#### Authelia vs [Authentik](https://goauthentik.io/)

Authentik has been gaining a lot of traction as a replacement for Authelia. But unlike Authelia, Authentik appears to be geared towards enterprise environments. Consequently, it offers more features and integrations but is also more complex to setup. For example, Authelia requires just one docker container whereas Authentik requires multiple.

### Automated Authelia Setup

If you have not heard of [Auto-Traefik](https://www.smarthomebeginner.com/auto-traefik/), then you should consider checking out this [playlist](https://www.youtube.com/playlist?list=PL1Hno7tIbSWViTyCXl9xNdXXU-1bVxIFD).

Auto-Traefik makes it very easy to setup and activate Authelia in just under 2 minutes. Check it out:

Auto Traefik 2 (Part 6) - Authentication, Basic Auth, Authelia MFA

[![Auto Traefik 2 (Part 6) - Authentication, Basic Auth, Authelia Mfa](https://www.smarthomebeginner.com/wp-content/plugins/wp-youtube-lyte/lyteCache.php?origThumbUrl=https%3A%2F%2Fi.ytimg.com%2Fvi%2F1g9h9P3QYl8%2F0.jpg "Authelia Docker Compose Guide: Secure 2-Factor Authentication [2024] 3")](https://youtu.be/1g9h9P3QYl8)

[Watch this video on YouTube](https://youtu.be/1g9h9P3QYl8).

Of course, Auto-Traefik can do a lot more than just installing Authelia.

Auto-Traefik was launched as a perk to my supporters and to find a way to financially support what I do with this site.

Everything that the Auto-Traefik Script does should be possible by following this series without paying for Auto-Traefik. But my hope is that you continue to support my work by becoming a member.

> **Be the 1 in 200,000. Help us sustain what we do.**
>
> 56 / 150 by Dec 31, 2024
>
> You will gain benefits such as discord roles, exclusive content, ad-free browsing, raffles, and more.
>
> [Become a Sponsor](https://www.smarthomebeginner.com/membership-account/memberships-products-services/) (starting from just $1.67/month)
>
> [Why did we start Memberships?](https://www.smarthomebeginner.com/state-of-the-site-2023/)

### Authelia Docker Compose Requirements

Before we get started with Authelia docker configuration, ensure that you have read and followed my previous [Docker Traefik guide](https://www.smarthomebeginner.com/traefik-docker-compose-guide-2024/). You should have a working Traefik Docker stack with the Docker root folder defined using the environmental variable **$USERDIR**.

## Authelia Configuration

That's right. We are going to first configure Authelia before setting it up. Authelia needs some basic configuration to be done before the Authelia docker service can start properly.

In the **appdata** folder (or a known location), create a folder called **authelia**. If you have been following my 2024 Ultimate Docker Server series or used [Auto-Traefik](https://www.smarthomebeginner.com/auto-traefik/), this would be in the path **/home/anand/docker/appdata**.

With that done, let us begin configuring Authelia.

### 1\. Authelia "Required" Configuration

Authelia configurations are defined in **configuration.yml**. Some are required and some are optional.

Begin by creating an empty **configuration.yml** file in the **authelia** folder we created above and add content to it as defined below (Pay attention to indentation and spaces. YAML will throw errors if proper indentation/spacing are not followed.).

**Tip:** You may use the example [configuration.yml](https://github.com/htpcBeginner/auto-traefik/blob/main/includes/authelia/configuration.yml) from Auto-Traefik's GitHub Repo as a starting point.

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

50

51

52

53

54

55

56

57

58

59

60

61

62

63

64

65

66

67

68

69

70

71

`###############################################################`

`#                   Authelia configuration                    #`

`###############################################################`

`# [https://www.authelia.com/configuration/miscellaneous/introduction/#default_redirection_url](https://www.authelia.com/configuration/miscellaneous/introduction/#default_redirection_url)`

`default_redirection_url:` ` https``:``//authelia.simplehomelab.com `

`server:`

`host:` `0.0.0.0`

`port:` `9091`

`# [https://www.authelia.com/configuration/miscellaneous/logging/](https://www.authelia.com/configuration/miscellaneous/logging/)`

`log:`

`level:` `info`

`format:` `text`

`file_path:` `/config/authelia.log`

`keep_stdout:` `true`

`# [https://www.authelia.com/configuration/second-factor/time-based-one-time-password/](https://www.authelia.com/configuration/second-factor/time-based-one-time-password/)`

`totp:`

`issuer:` `authelia.com`

`period:` `30`

`skew:` `1`

`# [https://www.authelia.com/reference/guides/passwords/](https://www.authelia.com/reference/guides/passwords/)`

`authentication_backend:`

`file:`

`path:` `/config/users.yml`

`password:`

`algorithm:` `argon2id`

`iterations:` `1`

`salt_length:` `16`

`parallelism:` `8`

`memory:` `128` `# blocks this much of the RAM`

`# [https://www.authelia.com/overview/authorization/access-control/](https://www.authelia.com/overview/authorization/access-control/)`

`access_control:`

`default_policy:` `deny`

`rules:`

`-` ` domain``: `

`-` `"*.simplehomelab.com"`

`-` `"simplehomelab.com"`

`policy:` `two_factor`

`# [https://www.authelia.com/configuration/session/introduction/](https://www.authelia.com/configuration/session/introduction/)`

`session:`

`name:` `authelia_session`

`expiration:` `1h`

`inactivity:` `5m`

`remember_me_duration:` `1M`

`domain:` `simplehomelab.com` `# Should match whatever your root protected domain is`

`# [https://www.authelia.com/configuration/security/regulation/](https://www.authelia.com/configuration/security/regulation/)`

`regulation:`

`max_retries:` `3`

`find_time:` `300`

`ban_time:` `600`

`# [https://www.authelia.com/configuration/storage/introduction/](https://www.authelia.com/configuration/storage/introduction/)`

`storage:`

`# For local storage, uncomment lines below and comment out mysql. [https://docs.authelia.com/configuration/storage/sqlite.html](https://docs.authelia.com/configuration/storage/sqlite.html)`

`# This is good for the beginning. If you have a busy site then switch to other databases.`

`local:`

`path:` `/config/db.sqlite3`

`# [https://www.authelia.com/configuration/notifications/introduction/](https://www.authelia.com/configuration/notifications/introduction/)`

`notifier:`

`disable_startup_check:` `false`

`# For testing purposes, notifications can be sent in a file. Be sure to map the volume in docker-compose.`

`filesystem:`

`filename:` `/config/notifications.txt`

#### Customizing Authelia Configuration

At any point, you may refer to [Authelia Documentation](https://www.authelia.com/configuration/prologue/introduction/) to further customize your setup.

The defaults above should work for most Docker Authelia setups. But here are some notes:

##### Redirection URL

We are redirecting "unknown" target URLs to **https://authelia.simplehomelab.com** (simplehomelab.com is the test domain I use in my guides). You may change this to another page if you would like.

1

2

`# [https://www.authelia.com/configuration/miscellaneous/introduction/#default_redirection_url](https://www.authelia.com/configuration/miscellaneous/introduction/#default_redirection_url)`

`default_redirection_url:` ` https``:``//authelia.simplehomelab.com `

##### Server Details

This is quite straightforward. With the server directive, we are asking authelia to listen on all network interface (0.0.0.0) on port 9091.

1

2

3

`server:`

`host:` `0.0.0.0`

`port:` `9091`

##### Logging

Default is set to info. But when creating bypass rules or troubleshooting, you may change the level to **debug** or **trace**.

1

2

3

4

5

6

`# [https://www.authelia.com/configuration/miscellaneous/logging/](https://www.authelia.com/configuration/miscellaneous/logging/)`

`log:`

`level:` `info`

`format:` `text`

`file_path:` `/config/authelia.log`

`keep_stdout:` `true`

The logs will be stored in **/config/authelia.log** file inside the container. Since we will be mapping the **/config** folder to **/home/anand/docker/appdata/authelia** on the Docker host, you will find **authelia.log** inside this folder (you will have to gain root privileges to access any content inside this folder).

##### TOTP

Authelia uses time-based one-time-passwords (TOTP). By default, it is set to rotate every 30 seconds. The details for above settings are [here](https://www.authelia.com/configuration/second-factor/time-based-one-time-password/). However, it is highly recommended not to mess with these.

1

2

3

4

5

`# [https://www.authelia.com/configuration/second-factor/time-based-one-time-password/](https://www.authelia.com/configuration/second-factor/time-based-one-time-password/)`

`totp:`

`issuer:` `authelia.com`

`period:` `30`

`skew:` `1`

##### Authentication Backend

We are going to use file-based authentication (**users.yml**) with one of the strongest hashing algorithms for passwords (**argon2id**). We will create the users file in the later steps.

For passwords, argon2id is the recommended hashing algorithm. You may choose to use sha512 (recommended for low power devices). The defaults shown above for iterations, salt_length, parallelism, and memory should work for most instances. You may customize them based on [this documentation](https://www.authelia.com/docs/configuration/authentication/file.html).

Note, that customizing the values will have a huge impact on resource usage.

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

`# [https://www.authelia.com/reference/guides/passwords/](https://www.authelia.com/reference/guides/passwords/)`

`authentication_backend:`

`file:`

`path:` `/config/users.yml`

`password:`

`algorithm:` `argon2id`

`iterations:` `1`

`salt_length:` `16`

`parallelism:` `8`

`memory:` `128` `# blocks this much of the RAM`

##### Access Control

For access control, we are denying access by default. Everything will require two-factor authentication.

You have the flexibility to bypass authentication for certain situations (e.g. requests from LAN IPs). This will be discussed in the enhancements section below. Meanwhile, feel free to check [Authelia documentation](https://www.authelia.com/overview/authorization/access-control/) for other ways to customize access.

1

2

3

4

5

6

7

8

`# [https://www.authelia.com/overview/authorization/access-control/](https://www.authelia.com/overview/authorization/access-control/)`

`access_control:`

`default_policy:` `deny`

`rules:`

`-` ` domain``: `

`-` `"*.simplehomelab.com"`

`-` `"simplehomelab.com"`

`policy:` `two_factor`

##### Authelia Session

Customizing the session will determine how long authentication will be valid. Shorter intervals will result in more frequent multi-factor authentication. You can further enhance the performance of session storage by using a database backend and Redis as described later.

But this is optional and improvements are marginal in a single-user environment.

1

2

3

4

5

6

7

`# [https://www.authelia.com/configuration/session/introduction/](https://www.authelia.com/configuration/session/introduction/)`

`session:`

`name:` `authelia_session`

`expiration:` `1h`

`inactivity:` `5m`

`remember_me_duration:` `1M`

`domain:` `simplehomelab.com` `# Should match whatever your root protected domain is`

##### Regulation

Regulation provides a layer of security by banning brute-force attempts. We are banning any user that has three incorrect attempts in 5 minutes (300 seconds).

1

2

3

4

5

`# [https://www.authelia.com/configuration/security/regulation/](https://www.authelia.com/configuration/security/regulation/)`

`regulation:`

`max_retries:` `3`

`find_time:` `300`

`ban_time:` `600`

Note that the user account will be banned, not the IP. While this can slow down brute-force attack, an intrusion prevention system such as CrowdSec is strongly recommended.

> ##### **How-To Series:** Crowd Security Intrusion Prevention System
>
> 1.  [Crowdsec Docker Compose Guide Part 1: Powerful IPS with Firewall Bouncer](https://www.smarthomebeginner.com/crowdsec-docker-compose-1-fw-bouncer/)
> 2.  [CrowdSec Docker Part 2: Improved IPS with Cloudflare Bouncer](https://www.smarthomebeginner.com/crowdsec-cloudflare-bouncer/)
> 3.  [CrowdSec Docker Part 3: Traefik Bouncer for Additional Security](https://www.smarthomebeginner.com/crowdsec-traefik-bouncer/)
> 4.  [CrowdSec Multiserver Docker (Part 4): For Ultimate Protection](https://www.smarthomebeginner.com/crowdsec-multiserver-docker/)

##### Storage

Authelia has built-in [session storage](https://www.authelia.com/configuration/storage/introduction/) using SQLite. This is sufficient for a single-user environment.

1

2

3

4

5

6

`# [https://www.authelia.com/configuration/storage/introduction/](https://www.authelia.com/configuration/storage/introduction/)`

`storage:`

`# For local storage, uncomment lines below and comment out mysql. [https://docs.authelia.com/configuration/storage/sqlite.html](https://docs.authelia.com/configuration/storage/sqlite.html)`

`# This is good for the beginning. If you have a busy site then switch to other databases.`

`local:`

`path:` `/config/db.sqlite3`

Replacing SQLite with a database such as MySQL (described later) offers performance, scalability, and the ability to run multiple authelia instances.

##### Notifications

Finally, notifications can be done in two ways: file or via email. Email requires a valid SMTP server, which may or may not be available in your case.

I use the free SMTP relay service from Brevo (previously SendInBlue). There are a few more free services out there.

For now, we will send all notifications to a file called **notifications.txt** inside the authelia config folder.

1

2

3

4

5

6

`# [https://www.authelia.com/configuration/notifications/introduction/](https://www.authelia.com/configuration/notifications/introduction/)`

`notifier:`

`disable_startup_check:` `false`

`# For testing purposes, notifications can be sent in a file. Be sure to map the volume in docker-compose.`

`filesystem:`

`filename:` `/config/notifications.txt`

### 2\. Authelia Secrets

In my [2020 version](https://www.smarthomebeginner.com/docker-authelia-tutorial/) of this guide, I did not use Docker secrets. I used environment variables. With revision and as with my [Ultimate Docker Guide 2024](https://www.smarthomebeginner.com/docker-media-server-2024/), I am taking secure approach from the beginning. So, let's pass sensitive information as Docker Secrets.

At the minimum, 3 secret tokens are needed for Authelia: authelia_jwt_secret, authelia_storage_encryption_key, and authelia_session_secret. All the secrets supported by Authelia are [listed here](https://www.authelia.com/configuration/methods/secrets/).

Let's create the 3 for now. Adding secrets to Docker is essentially a multi-step process, as explained in [part 2 of this Docker series](https://www.smarthomebeginner.com/docker-media-server-2024/#creating-docker-secrets).

##### Create Secrets Folder

If you haven't already done so, create a folder called **secrets** in a known location. If you have been following my guides, this would be **/home/anand/docker/secrets**. The folder must be owned by **root:root** and have **600** permission as shown below.

[

![Docker Secrets Folder Permissions](https://www.smarthomebeginner.com/images/2020/08/docker-secrets-folder-permissions.png "Authelia Docker Compose Guide: Secure 2-Factor Authentication [2024] 4")

![Docker Secrets Folder Permissions](data:image/svg+xml,%3Csvg%20xmlns=%22http://www.w3.org/2000/svg%22%20viewBox=%220%200%20491%2020%22%3E%3C/svg%3E "Authelia Docker Compose Guide: Secure 2-Factor Authentication [2024] 4")](https://www.smarthomebeginner.com/images/2020/08/docker-secrets-folder-permissions.png)

Docker Secrets Folder Permissions

Note that you will have to gain root privileges to navigate or see contents of the secrets folder.

##### Create the Secret Files

Next, use the following commands to automatically create a random string for each secret and save them in the secrets folder (**/home/anand/docker/secrets/**).

1

`tr` ` -``cd ` `'[:alnum:]'` `<` `/dev/urandom` `|` `fold` `-w` `"64"` `|` `head` `-n 1 |` `sudo` `tee` `/home/anand/docker/secrets/authelia_jwt_secret`

1

`tr` ` -``cd ` `'[:alnum:]'` `<` `/dev/urandom` `|` `fold` `-w` `"64"` `|` `head` `-n 1 |` `sudo` `tee` `/home/anand/docker/secrets/authelia_storage_encryption_key`

1

`tr` ` -``cd ` `'[:alnum:]'` `<` `/dev/urandom` `|` `fold` `-w` `"64"` `|` `head` `-n 1 |` `sudo` `tee` `/home/anand/docker/secrets/authelia_session_secret`

##### Secret Permissions

Next, let's ensure proper permissions for those using the following command:

1

2

`sudo` `chown` `root:root` ` /home/anand/docker/secrets/authelia``* `

`sudo` `chmod` `600` ` /home/anand/docker/secrets/authelia``* `

Notice that they all have the same permissions (owner root, group root, and 600 permissions) as the **secrets** folder.

[

![Secrets For Authelia](https://www.smarthomebeginner.com/images/2020/08/authelia-secrets.png "Authelia Docker Compose Guide: Secure 2-Factor Authentication [2024] 5")

![Secrets For Authelia](data:image/svg+xml,%3Csvg%20xmlns=%22http://www.w3.org/2000/svg%22%20viewBox=%220%200%20706%2098%22%3E%3C/svg%3E "Authelia Docker Compose Guide: Secure 2-Factor Authentication [2024] 5")](https://www.smarthomebeginner.com/images/2020/08/authelia-secrets.png)

Secrets For Authelia

Don't worry about any missing or additional ones. We will add a few more later. The above is just an example to show the permissions.

##### Add Authelia Secrets to Master Docker Compose

Open your master docker compose file for editing. If you have been following the Ultimate docker server series, this might be **docker-compose-udms.yml** (or whatever you named it to be).

Under secrets section, ensure you define the three secrets we created above:

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

`########################### SECRETS`

`secrets:`

`...`

`authelia_jwt_secret:`

`file:` `$DOCKERDIR/secrets/authelia_jwt_secret`

`authelia_session_secret:`

`file:` `$DOCKERDIR/secrets/authelia_session_secret`

`authelia_storage_encryption_key:`

`file:` `$DOCKERDIR/secrets/authelia_storage_encryption_key`

`...`

Note that the **...** refer to previous lines that may already exist after having followed the previous parts of this Ultimate Docker Server series.

Note that, **$DOCKERDIR** is the environment variable defined in **.env** file to represent **/home/anand/docker**.

If you have any questions on where exactly this is added, check out the compose files in [my GitHub Repo](https://github.com/htpcbeginner/docker-traefik).

We have now completed [2 of the 4 steps in adding secrets](https://www.smarthomebeginner.com/docker-media-server-2024/#creating-docker-secrets). We will perform the remaining 2 steps when we create the **Authelia Docker Compose** file.

### 3\. Authelia Users

Next, let's create a user. In our **configuration.yml** file we said users are in the **users.yml** file, which is [described here](https://www.authelia.com/configuration/first-factor/file/).

Create a file called **users.yml** inside authelia configuration folder in **appdata**, and add the following contents to it:

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

`###############################################################`

`#                         Users Database                      #`

`###############################################################`

`# This file can be used if you do not have an LDAP set up.`

`# List of users`

`users:`

`AUTHELIA_USERNAME:`

`disabled:` `false`

`displayname:` `"AUTHELIA_USER_DISPLAY_NAME"`

`email:` `AUTHELIA_USER_EMAIL`

`password:` `AUTHELIA_HASHED_PASSWORD`

`groups:`

`-` `admins`

Replace **AUTHELIA_USERNAME** with a username for the user.

Change **AUTHELIA_USER_DISPLAY_NAME** to a name for the user. **AUTHELIA_USER_EMAIL** can be a valid email or a dummy email. Remember that we do not have an SMTP server and no emails will be sent. Instead, all notifications will be stored in the **notifications.txt** file. Therefore, the validity of the email does not matter.

**AUTHELIA_HASHED_PASSWORD** is the hashed password. NOT the plain text password. To hash the password, use the following command:

1

`sudo` ` docker run authelia``/authelia``:4.37.5 authelia ` ` hash``-password MYSTRONGPASSWORD `

Replace **MYSTRONGPASSWORD** with your strong password. Your password will be hashed using the argon2id algorithm and displayed as shown below.

[

![Authelia Hashed Password](https://www.smarthomebeginner.com/images/2024/02/authelia-user-password-hash-740x182.jpg "Authelia Docker Compose Guide: Secure 2-Factor Authentication [2024] 6")

![Authelia Hashed Password](data:image/svg+xml,%3Csvg%20xmlns=%22http://www.w3.org/2000/svg%22%20viewBox=%220%200%20740%20182%22%3E%3C/svg%3E "Authelia Docker Compose Guide: Secure 2-Factor Authentication [2024] 6")](https://www.smarthomebeginner.com/images/2024/02/authelia-user-password-hash.jpg)

Authelia Hashed Password

If Authelia Docker image does not already exist on your system, it will be downloaded during the process, as shown above.

Copy hashed password in its entirety (highlighted by red box) and replace **AUTHELIA_HASHED_PASSWORD** in the **users.yml**.

Save the file and exit.

#### Adding Additional Users

##### Restricted Content

Additional explanations and bonus content are available exclusively for the following members only:

Silver - Monthly, Silver - Yearly, Gold - Monthly, Gold - Yearly, Diamond - Monthly, Diamond - Yearly, and Platinum Lifetime (All-Inclusive)

Please support us by becoming a member to unlock the content.  
[Join Now](https://www.smarthomebeginner.com/membership-account/memberships-products-services/)

Just because a user belongs to the group **admins**, does not mean that the user is admin. Group name is just a name. Access is control using access control policies.

### 4\. Authelia Traefik Configuration

Now that Authelia configuration is done. Let us configure Traefik to use Authelia.

Building on the same framework we built using the [Docker-Traefik guide](https://www.smarthomebeginner.com/traefik-docker-compose-guide-2024/), we need to add two sections to Traefik configuration: a middleware for authelia and a middleware chain for authelia.

#### Authelia Traefik Middleware

First, let us create a Authelia Traefik middleware that will forward authentication to the Authelia container. Create a file called **middlewares-authelia.yml** in your Traefik rules folder and add the following contents to it:

If you have followed my [Traefik guide](https://www.smarthomebeginner.com/traefik-docker-compose-guide-2024/), the rules folder will be **appdata/traefik2/rules/udms**, where **udms** is the hostname. In my GitHub repo, you will find files from 5 of my docker hosts, identified by hostnames: hs, mds, ws, ds918, and dns.

1

2

3

4

5

6

7

8

9

`http:`

`middlewares:`

`middlewares-authelia:`

`forwardAuth:`

`address:` ` "[http://authelia:9091/api/verify?rd=https://authelia.](http://authelia:9091/api/verify?rd=https://authelia.){{env "``DOMAINNAME_HS``"}}" `

`trustForwardHeader:` `true`

`authResponseHeaders:`

`-` `"Remote-User"`

`-` `"Remote-Groups"`

Remember the **DOMAINNAME_HS** environmental variable we passed into Traefik container? This is where it comes in handy. **{{env "DOMAINNAME\_HS"}}** will refer to the domain name set for this variable. You may replace it and hardcode your domain name.

We are basically specifying the URL to which authentication requests must be forwarded.

Since this is a dynamic configuration using a file provider, traefik will pick it up automatically.

#### Authelia Middleware Chain

Again, building on my Traefik guide, let's build the [middleware chain](https://www.smarthomebeginner.com/traefik-docker-compose-guide-2024/#Middleware_Chains) for Authelia.

We will reuse a few of the middlewares from the Traefik guide: middlewares-rate-limit and middlewares-secure-headers.

Create a file called **chain-authelia.yml** in your Traefik rules folder and add the following contents to it:

1

2

3

4

5

6

7

8

`http:`

`middlewares:`

`chain-authelia:`

`chain:`

`middlewares:`

`-` `middlewares-rate-limit`

`-` `middlewares-secure-headers`

`-` `middlewares-authelia`

If you do not understand what this does, then I suggest reading my [Traefik guide](https://www.smarthomebeginner.com/traefik-docker-compose-guide-2024/#Middleware_Chains).

In short, we are rate limit and specifying security headers, which are both security measures. Then we are including Authelia authentication in the chain (the middleware we created in the previous step).

In [my GitHub Repo](https://github.com/htpcBeginner/docker-traefik/tree/master/appdata/traefik2/rules/) you may find more middlewares than what is described above. For Authelia purposes, the above middlewares are sufficient. As you follow more of my guides you may add additional middlewares.

That's it, we are now ready to create Authelia docker-compose file.

> **Be the 1 in 200,000. Help us sustain what we do.**
>
> 56 / 150 by Dec 31, 2024
>
> [Join Us](https://www.smarthomebeginner.com/membership-account/memberships-products-services/) (starting from just $1.67/month)
>
> [Why did we start Memberships?](https://www.smarthomebeginner.com/state-of-the-site-2023/)

### 5\. Authelia Docker Compose

Now that all the configuration part is done. Let us add the Authelia docker compose service.

Just a reminder that Traefik should be up and running at this point.

##### Create Authelia Docker Compose File

Let's create the Authelia Docker compose file. Head over to the [compose folder](https://github.com/htpcBeginner/docker-traefik/tree/master/compose) in my Github Repository, and then into any of the host folders. Find the compose file for Authelia and copy the contents.

Create a file called **authelia.yml** inside **/home/anand/docker/compose/udms**. Copy-paste the contents into **authelia.yml** compose file (pay attention to blank spaces at the beginning of each line).

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

`services:`

`# Authelia (Lite) - Self-Hosted Single Sign-On and Two-Factor Authentication`

`authelia:`

`container_name:` `authelia`

`image:` ` authelia/authelia``:``4.37.5 `

`security_opt:`

`-` ` no-new-privileges``:``true `

`restart:` `unless-stopped`

`# profiles: ["core", "all"]`

`networks:`

`-` `t2_proxy`

`-` `default`

`# ports:`

`#   - "9091:9091"`

`volumes:`

`-` ` $DOCKERDIR/appdata/authelia``:``/config `

`environment:`

`-` `TZ=$TZ`

`-` `AUTHELIA_JWT_SECRET_FILE=/run/secrets/authelia_jwt_secret`

`-` `AUTHELIA_STORAGE_ENCRYPTION_KEY_FILE=/run/secrets/authelia_storage_encryption_key`

`-` `AUTHELIA_SESSION_SECRET_FILE=/run/secrets/authelia_session_secret`

`-` `DOMAINNAME_HS`

`secrets:`

`-` `authelia_jwt_secret`

`-` `authelia_storage_encryption_key`

`-` `authelia_session_secret`

`labels:`

`-` `"traefik.enable=true"`

`## HTTP Routers`

`-` `"traefik.http.routers.authelia-rtr.entrypoints=websecure"`

`-` `` "traefik.http.routers.authelia-rtr.rule=Host(`authelia.$DOMAINNAME_HS`)" ``

`## Middlewares`

`-` `"traefik.http.routers.authelia-rtr.middlewares=chain-no-auth@file"`

`## HTTP Services`

`-` `"traefik.http.routers.authelia-rtr.service=authelia-svc"`

`-` `"traefik.http.services.authelia-svc.loadbalancer.server.port=9091"`

Here are some notes about the Authelia Docker Compose:

- We are going to fix the Authelia docker image as **4.37.5** for now. Version 4.38 will bring some breaking changes.
- Docker profiles is commented out as explained previously (see my [Docker guide](https://www.smarthomebeginner.com/docker-media-server-2024/#docker-profiles-use-case) for how I use profiles).
- **networks:** We added Authelia to **t2_proxy** and **default** networks. You could probably leave out the **default** network. I included default because my MariaDB container was on **default** network.
- **ports:** Exposing ports is typically not needed for Authelia.
- The environmental variable **$DOCKERDIR** is already defined in our **.env** file. All Authelia data is being stored in a authelia-specific folder within **appdata**.
- In the environment and secret sections, we are specifying the 3 Authelia secrets we created previously (steps [3 and 4 in adding secrets](https://www.smarthomebeginner.com/docker-media-server-2024/#creating-docker-secrets)).
- With the labels, we are specifying that Authelia will use the **websecure** entrypoint and **chain-no-auth** file provider we created previously.
- Authelia listens on port 9091. So, we point **authelia-rtr.service** to a service name **authelia-svc** and in the next line, we define where that service is listening at (**authelia-svc.loadbalancer.server.port=9091**.

##### Add Authelia to the Docker Stack

We created the **authelia.yml** file. Now we need to add it to our master **docker-compose-udms.yml** file. To do so, add the path to the **authelia.yml** (compose/udms/authelia.yml) file under the include block, as shown below:

**Update (March 21, 2024):** The version tag at the top of Docker compose file is now obsolete and throws a warning. This has been removed from my guides.

1

2

3

4

5

6

7

`...`

`...`

`include:`

`...`

`-` `compose/$HOSTNAME/authelia.yml`

`...`

Note that the **...** refer to previous lines that may already exist after having followed the previous parts of this Ultimate Docker Server series.

**$HOSTNAME** here will be replaced with **udms** automatically (as defined in the **.env** file).

Save the Master Docker Compose file.

### 6\. Starting Authelia and Registering

Recreate the stack and follow Authelia container logs using the following commands:

1

2

`sudo` `docker compose -f` ` /home/anand/docker/docker-compose-udms``.yml up -d `

`sudo` `docker compose -f` ` /home/anand/docker/docker-compose-udms``.yml logs -tf --``tail``=``"50" ` `authelia`

You should see confirmation that Authelia Docker container started successfully, as shown below. \[**Read:** [Dozzle Docker Compose: Simple Docker Logs Viewer](https://www.smarthomebeginner.com/dozzle-docker-compose-guide/)\]

[

![Authelia Docker Compose - Container Started](https://www.smarthomebeginner.com/images/2024/02/authelia-running-740x66.jpg "Authelia Docker Compose Guide: Secure 2-Factor Authentication [2024] 7")

![Authelia Docker Compose - Container Started](data:image/svg+xml,%3Csvg%20xmlns=%22http://www.w3.org/2000/svg%22%20viewBox=%220%200%20740%2066%22%3E%3C/svg%3E "Authelia Docker Compose Guide: Secure 2-Factor Authentication [2024] 7")](https://www.smarthomebeginner.com/images/2024/02/authelia-running.jpg)

Authelia Docker Compose - Container Started

Now that Authelia Docker container is up and running. Let us test it out.

#### Authelia First Time Use and Registration

Let's visit **https://authelia.simplehomelab.com** (obviously use your domain name). Now and while accessing a service protected by Authelia, you should see the following login form.

[

![Authelia First Login](https://www.smarthomebeginner.com/images/2024/02/authelia-first-login-740x358.jpg "Authelia Docker Compose Guide: Secure 2-Factor Authentication [2024] 8")

![Authelia First Login](data:image/svg+xml,%3Csvg%20xmlns=%22http://www.w3.org/2000/svg%22%20viewBox=%220%200%20740%20358%22%3E%3C/svg%3E "Authelia Docker Compose Guide: Secure 2-Factor Authentication [2024] 8")](https://www.smarthomebeginner.com/images/2024/02/authelia-first-login.jpg)

Authelia First Login

Log in using the username and password you defined in **users.yml** file.

Next, you will have to register your device. Click on **Methods**, choose **One-time Password**, and then click **Not registered yet?**, as shown below.

[

![Authelia Registration](https://www.smarthomebeginner.com/images/2024/02/authelia-register-device-740x467.jpg "Authelia Docker Compose Guide: Secure 2-Factor Authentication [2024] 9")

![Authelia Registration](data:image/svg+xml,%3Csvg%20xmlns=%22http://www.w3.org/2000/svg%22%20viewBox=%220%200%20740%20467%22%3E%3C/svg%3E "Authelia Docker Compose Guide: Secure 2-Factor Authentication [2024] 9")](https://www.smarthomebeginner.com/images/2024/02/authelia-register-device.jpg)

Authelia Registration

A registration link will be sent to the user's email ID defined in the **users.yml** file.

[

![Authelia Notification Email Sent](https://www.smarthomebeginner.com/images/2024/02/authelia-device-registration-email-sent-740x143.jpg "Authelia Docker Compose Guide: Secure 2-Factor Authentication [2024] 10")

![Authelia Notification Email Sent](data:image/svg+xml,%3Csvg%20xmlns=%22http://www.w3.org/2000/svg%22%20viewBox=%220%200%20740%20143%22%3E%3C/svg%3E "Authelia Docker Compose Guide: Secure 2-Factor Authentication [2024] 10")](https://www.smarthomebeginner.com/images/2024/02/authelia-device-registration-email-sent.jpg)

Authelia Notification Email Sent

But there is one problem. What if you did not configure SMTP server for email notifications? Well, in that case, the registration link is embedded in the notification saved to **notification.txt** file.

Open the **notifications.txt** file inside Authelia config folder in **appdata** to find the link. Use nano or vi editor on commandline with after elevating your privileges to root.

**Open the link in the same browser as the one where you are trying to access the service that is behind Authelia** (IMPORTANT).

**Note:** If you do not open the registration link on the same device initiating the authelia registration, then the registration will fail.

[

![Authelia Notification Email - Registration Link](https://www.smarthomebeginner.com/images/2024/02/authelia-device-registration-email-740x209.jpg "Authelia Docker Compose Guide: Secure 2-Factor Authentication [2024] 11")

![Authelia Notification Email - Registration Link](data:image/svg+xml,%3Csvg%20xmlns=%22http://www.w3.org/2000/svg%22%20viewBox=%220%200%20740%20209%22%3E%3C/svg%3E "Authelia Docker Compose Guide: Secure 2-Factor Authentication [2024] 11")](https://www.smarthomebeginner.com/images/2024/02/authelia-device-registration-email.jpg)

Authelia Notification Email - Registration Link

The link should open a QR Code, as shown in the screenshot below. You can use any of the authenticator apps (Duo, Authy, Google Authenticator, etc.) to scan the code. I recommend Duo because it supports push notifications, which makes authentications easier (described later).

[

![Authelia Registration Qr Code](https://www.smarthomebeginner.com/images/2024/02/authelia-device-registration-qr-code-740x435.jpg "Authelia Docker Compose Guide: Secure 2-Factor Authentication [2024] 12")

![Authelia Registration Qr Code](data:image/svg+xml,%3Csvg%20xmlns=%22http://www.w3.org/2000/svg%22%20viewBox=%220%200%20740%20435%22%3E%3C/svg%3E "Authelia Docker Compose Guide: Secure 2-Factor Authentication [2024] 12")](https://www.smarthomebeginner.com/images/2024/02/authelia-device-registration-qr-code.jpg)

Authelia Registration Qr Code

After scanning, enter the OTP code from the authenticator app into Authelia. This should complete your device registration for Authelia and you should see something like the screenshot below.

[

![Authelia Registration Complete](https://www.smarthomebeginner.com/images/2024/02/authelia-authenticated-740x340.jpg "Authelia Docker Compose Guide: Secure 2-Factor Authentication [2024] 13")

![Authelia Registration Complete](data:image/svg+xml,%3Csvg%20xmlns=%22http://www.w3.org/2000/svg%22%20viewBox=%220%200%20740%20340%22%3E%3C/svg%3E "Authelia Docker Compose Guide: Secure 2-Factor Authentication [2024] 13")](https://www.smarthomebeginner.com/images/2024/02/authelia-authenticated.jpg)

Authelia Registration Complete

That is about it. You can now start using Authelia multi-factor authentication for your Docker apps. Authelia protects some of my key administration apps such as [Guacamole](https://www.smarthomebeginner.com/install-guacamole-on-docker/).

## Authentication and Conditional Bypassing

Now that we have Authelia working, let's look at ways to protect apps and also some ways to conditionally bypass authentication.

### Putting Docker Services behind Authelia

If you created the authelia traefik middleware and middleware chain discussed above, then putting docker services behind Authelia authentication is simple. All you need to do is add the following middleware (**chain-authelia**) to docker-compose labels:

1

2

`## Middlewares`

`- "traefik.http.routers.service-rtr.middlewares=chain-authelia@file"`

**service-rtr** could be different for different services. As always, check the docker-compose files in [GitHub repo](https://github.com/htpcBeginner/docker-traefik) for working examples.

### Putting Non-Docker Services behind Authelia

Adding non-docker apps or apps from docker host or external hosts is also quite simple using file providers, as previously explained in my [Traefik guide](https://www.smarthomebeginner.com/traefik-docker-compose-guide-2024/#Adding_non-Docker_or_External_Apps_Behind_Traefik).

Auto Traefik 2 (Part 9) - Putting External Applications Behind Traefik

[![Auto Traefik 2 (Part 9) - Putting External Applications Behind Traefik](https://www.smarthomebeginner.com/wp-content/plugins/wp-youtube-lyte/lyteCache.php?origThumbUrl=https%3A%2F%2Fi.ytimg.com%2Fvi%2FkGaX1pnP_y4%2F0.jpg "Authelia Docker Compose Guide: Secure 2-Factor Authentication [2024] 14")](https://youtu.be/kGaX1pnP_y4)

[Watch this video on YouTube](https://youtu.be/kGaX1pnP_y4).

Let's take the same example of [Adguard Home running on Raspberry Pi](https://www.smarthomebeginner.com/adguard-home-raspberry-pi-2023/), as in my [Traefik guide](https://www.smarthomebeginner.com/traefik-docker-compose-guide-2024/#Adding_non-Docker_or_External_Apps_Behind_Traefik).

Previously, we had [AdGuard](https://www.smarthomebeginner.com/go/adguard "AdGuard") Home with no Traefik authentication (**chain-no-auth**). Putting it behind Authelia is as simple as changing the middleware from **chain-no-auth** to **chain-authelia**, as shown below:

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

`http:`

`routers:`

`adguard-rtr:`

`rule:` `` "Host(`ag.{{env "```DOMAINNAME_HS```"}}`)" ``

`entryPoints:`

`-` `websecure`

`middlewares:`

`-` `chain-no-auth`

`service:` `adguard-svc`

`tls:`

`certResolver:` `dns-cloudflare`

`options:` `tls-opts@file`

`services:`

`adguard-svc:`

`loadBalancer:`

`servers:`

`-` ` url``: ` `"[http://192.168.1.225:80](http://192.168.1.225/)"`

Note that [AdGuard](https://www.smarthomebeginner.com/go/adguard "AdGuard") Home is listening on a non-SSL port. Some services (e.g. NextCloud, UniFi controller, Proxmox etc.) tend to be available via HTTPS protocol with a self-signed certificate. For these, be sure to refer to my guide on putting [HTTPS apps behind Traefik](https://www.smarthomebeginner.com/proxmox-web-interface-behind-traefik/).

Since the rules directory is dynamic, simply by adding this file to that directory we have created the route. You should be able to connect to AdGuard Home behind Authelia, without restarting Traefik!

### Bypassing Authelia

This is my preferred method for bypassing.

Although you can use Authelia's built-in [access control](#access-control) methods, I do not use it. I leverage custom headers to let Traefik handle the bypassing instead of the authentication service.

Traefik has built-in mechanisms for conditional bypassing. Depending on certain conditions, I can specify a different middleware or a middleware chain. This is explained in detail in my separate guide on [Traefik Auth bypass](https://www.smarthomebeginner.com/traefik-auth-bypass/).

Several apps in my [GitHub repo](https://github.com/htpcBeginner/docker-traefik) have auth bypasses set based on certain conditions.

## Authelia Enhancements

At this point, you should already have a fully functional Authelia Docker authentication system. But depending on your situation, you could benefit from some optional enhancements. Let's look at some of those now.

### Redis

In simple terms, Redis is a key-value caching mechanism that can enhance the performance of applications that access databases frequently. If you do not have Redis, it is quite easy to have it up and running with Docker. \[**Read:** [Redis Docker Compose Install: With 2 SAVVY Use Cases](https://www.smarthomebeginner.com/redis-docker-compose-example/)\]

If you have a Redis instance available add the following block under **session:** in **configuration.yml** file to activate the usage of Redis (pay attention to indentation).

1

2

3

4

5

6

`session:`

`# [https://www.authelia.com/configuration/session/redis/](https://www.authelia.com/configuration/session/redis/)`

`redis:`

`host: redis`

`port: 6379`

`# password: REDISPASSWORD`

Note that you may also define and host, port, and even password using [environment variables](https://www.authelia.com/configuration/methods/environment/) (check for variable names to use). If you decide to do so, the only line in **configuration.yml** will be **redis:** under **session:** to enable it.

Customize the host with the host running Redis. If Redis and Authelia are on the same Docker network, you can use the hostname (**redis**; if that is how your Redis service is called). The port is typically 6379.

If you use a password for Redis, you may specify the password directly in **configuration.yml** file or use the environment variable. But as mentioned before, we are going to use Secrets.

##### Adding Secrets for Redis

1.  You will have to create a secret file: /home/anand/docker/secrets/authelia_session_redis_password.
2.  Define the secret globally in the master docker compose file.

    1

    2

    3

    4

    `...`

    `authelia_session_redis_password:`

    `file:` `$DOCKERDIR/secrets/authelia_session_redis_password`

    `...`

3.  Define the **AUTHELIA_SESSION_REDIS_PASSWORD_FILE** environment variable and point it to the secret file.

    1

    2

    3

    4

    `...`

    `environment:`

    `-` `AUTHELIA_SESSION_REDIS_PASSWORD_FILE=/run/secrets/authelia_session_redis_password`

    `...`

4.  Enable the secret in Authelia docker compose.

    1

    2

    3

    4

    `...`

    `secrets:`

    `-` `authelia_session_redis_password`

    `...`

Reminder that in a non-busy system, using Redis will have minimal impact. Recreate Authelia for the changes to take effect.

Implementing TLS can secure the connection between [Authelia and Redis](https://www.authelia.com/configuration/session/redis/#tls). This is not discussed in this guide, but is highly recommended for a multiuser/business environment.

### MySQL Storage

Authelia offers [several storage backends](https://www.authelia.com/configuration/storage/). In this example, let us use MySQL. Add the following block under **storage:** in **configuration.yml** file, paying attention to the indendation.

The assumption at this point is that you already have MySQL/MariaDB running and have created a database and database-specific user for Authelia.

1

2

3

4

5

6

7

8

`storage:`

`# [https://www.authelia.com/configuration/storage/mysql/](https://www.authelia.com/configuration/storage/mysql/)`

`mysql:`

`host:` `mariadb`

`port:` `3306`

`database:` `authelia`

`username:` `DBUSERNAME`

`# password: DBPASSWORD`

Once again, if MariaDB and Authelia are on the same network, you can use **mariadb** for hostname (if that is how your MariaDB service is called). 3306 is the default MariaDB port. Customize the database name and username based on your situation.

Note that you may also define and host, port, database, username, and even password using [environment variables](https://www.authelia.com/configuration/methods/environment/) (check for variable names to use). If you decide to do so, the only line in **configuration.yml** will be **mysql:** under **storage:** to enable it.

Only the [password can be specified as a secret](https://www.authelia.com/configuration/methods/secrets/) (check for supported secrets). The [four steps are exactly the same as described for Redis](#adding-secrets-for-redis), with minor changes. Use **AUTHELIA_STORAGE_MYSQL_PASSWORD_FILE** for environment variable name and **authelia_storage_mysql_password** for secret name.

If you use MySQL, be sure to comment out or remove the SQLite storage backend in the **configuration.yml** file.

Recreate Authelia for the changes to take effect.

Implementing TLS can secure the connection between [Authelia and MySQL](https://www.authelia.com/configuration/storage/mysql/#tls). This is not discussed in this guide, but is highly recommended for a multiuser/business environment.

### Email Notifications

Storing notifications in a text file is not ideal. If you have an email server (I use and recommend Brevo (there are others too), which is free), you can enable email notification by adding the following block under **notifier:**:

1

2

3

4

5

6

7

`notifier:`

`smtp:`

`username:` `SMTP_USERNAME`

`# password: SMTP_PASSWORD`

`host:` `SMTP_HOST`

`port:` `587` `# Or 465`

`sender:` `SENDER_EMAIL`

Once again, you can specify the above details in 2 ways: directly in **configuration.yml** and as [environment variables](https://www.authelia.com/configuration/methods/environment/) (check for variable names to use).

If you decide to go with environment variables and secrets, then the only line in **configuration.yml** will be **smtp:** under **notifier:** to enable it.

Only the [SMTP_PASSWORD can be specified as a secret](https://www.authelia.com/configuration/methods/secrets/) (check for supported secrets). The [four steps are exactly the same as described for Redis](#adding-secrets-for-redis), with minor changes. Use **AUTHELIA_NOTIFIER_SMTP_PASSWORD_FILE** for environment variable name and **authelia_notifier_smtp_password** for secret name.

After enabling email notifications, you may choose to disable writing notifications to the **notifications.txt** file (comment out or remove those lines).

Recreate Authelia for the changes to take effect.

When configured correctly, here is an example of an email you may receive during account registration (of course, a valid email is now necessary).

[

![Opening Authelia Registration Link](https://www.smarthomebeginner.com/images/2020/07/04b-authelia-registration-email-740x299.png "Authelia Docker Compose Guide: Secure 2-Factor Authentication [2024] 15")

![Opening Authelia Registration Link](data:image/svg+xml,%3Csvg%20xmlns=%22http://www.w3.org/2000/svg%22%20viewBox=%220%200%20740%20299%22%3E%3C/svg%3E "Authelia Docker Compose Guide: Secure 2-Factor Authentication [2024] 15")](https://www.smarthomebeginner.com/images/2020/07/04b-authelia-registration-email.png)

Opening Authelia Registration Link

### Enabling Duo Push Notification for Authelia

As I hinted before, I like Duo because it supports [push notifications](https://www.authelia.com/overview/authentication/push-notification/) that allow one-click easy login approvals compared to entering the OTP. Enabling this is a little bit of work and unintuitive.

But don't worry, I will walk you through it and it's FREE.

First, head over to [Duo's website](https://duo.com/) and register an account.

#### 1\. Create a Duo User

From the **Users** menu, click on **Add User** as shown below and create a new user.

[

![Add Duo User For Authelia Push Authentication](https://www.smarthomebeginner.com/images/2020/07/09-add-duo-user-for-authelia-740x266.png "Authelia Docker Compose Guide: Secure 2-Factor Authentication [2024] 16")

![Add Duo User For Authelia Push Authentication](data:image/svg+xml,%3Csvg%20xmlns=%22http://www.w3.org/2000/svg%22%20viewBox=%220%200%20740%20266%22%3E%3C/svg%3E "Authelia Docker Compose Guide: Secure 2-Factor Authentication [2024] 16")](https://www.smarthomebeginner.com/images/2020/07/09-add-duo-user-for-authelia.png)

Add Duo User For Authelia Push Authentication

Fill in the user details.

**Note:** The **username must be the same as what you used for Authelia** in **users.yml**.

Scroll down and add a phone number.

#### 2\. Activate the User

You should see a warning message (shown below) on the Duo admin page that says that the user is not activated.

[

![Activate New Duo User](https://www.smarthomebeginner.com/images/2020/07/10-authelia-activate-duo-user-740x105.png "Authelia Docker Compose Guide: Secure 2-Factor Authentication [2024] 17")

![Activate New Duo User](data:image/svg+xml,%3Csvg%20xmlns=%22http://www.w3.org/2000/svg%22%20viewBox=%220%200%20740%20105%22%3E%3C/svg%3E "Authelia Docker Compose Guide: Secure 2-Factor Authentication [2024] 17")](https://www.smarthomebeginner.com/images/2020/07/10-authelia-activate-duo-user.png)

Activate New Duo User

Send the activation link to the user's/your phone and click the received link to activate the user.

#### 3\. Create an Application

Under **Applications**, select **Protect an Application**, search for _Partner Auth API_ and click **Protect**, as shown below.

[

![Add New Application For Duo Push Authentication](https://www.smarthomebeginner.com/images/2020/07/11-authelia-add-applications-to-protect-740x185.png "Authelia Docker Compose Guide: Secure 2-Factor Authentication [2024] 18")

![Add New Application For Duo Push Authentication](data:image/svg+xml,%3Csvg%20xmlns=%22http://www.w3.org/2000/svg%22%20viewBox=%220%200%20740%20185%22%3E%3C/svg%3E "Authelia Docker Compose Guide: Secure 2-Factor Authentication [2024] 18")](https://www.smarthomebeginner.com/images/2020/07/11-authelia-add-applications-to-protect.png)

Add New Application For Duo Push Authentication

Once created, copy the **Integration key**, **Secret key**, and **API hostname**.

#### 4\. Configure Duo API in Authelia Configuration

Open up Authelia's **configuration.yml** and add the following code block to it.

1

2

3

4

5

`# [https://www.authelia.com/configuration/second-factor/duo/](https://www.authelia.com/configuration/second-factor/duo/)`

`duo_api:`

`hostname: API_HOSTNAME`

`# integration_key: INTEGRATION_KEY`

`# secret_key: SECRET_KEY`

Once again, you can specify the above details in 2 days: directly in **configuration.yml** and as [environment variables](https://www.authelia.com/configuration/methods/environment/) (check for variable names to use).

If you decide to go with environment variables and secrets, then the only line in **configuration.yml** will be **duo_api:** to enable it.

Only the [INTEGRATION_KEY and SECRET_KEY can be specified as a secrets](https://www.authelia.com/configuration/methods/secrets/) (check for supported secrets). The [four steps are exactly the same as described for Redis](#adding-secrets-for-redis), with minor changes. Use **AUTHELIA_DUO_API_INTEGRATION_KEY_FILE** and **AUTHELIA_DUO_API_SECRET_KEY_FILE** for environment variable names and **authelia_duo_api_integration_key** and **authelia_duo_api_secret_key** for secret names, respectively.

Recreate Authelia for the changes to take effect.

#### 5\. Test Authelia Duo Push Notification

##### Restricted Content

Additional explanations and bonus content are available exclusively for the following members only:

Silver - Monthly, Silver - Yearly, Gold - Monthly, Gold - Yearly, Diamond - Monthly, Diamond - Yearly, and Platinum Lifetime (All-Inclusive)

Please support us by becoming a member to unlock the content.  
[Join Now](https://www.smarthomebeginner.com/membership-account/memberships-products-services/)

## Final Thoughts on Authelia for Docker Traefik

It seemed like a lengthy process but in reality, implementing this **Authelia Docker Compose tutorial** shouldn't take more than an hour. I was very satisfied with [Google OAuth](https://www.smarthomebeginner.com/google-oauth-traefik-forward-auth-2024/). And Authelia is equally awesome or better depending on what is important to you.

I am not sure if Authelia offers more protection than Google OAuth but I feel like I have more control and obviously more privacy. And the duo push authorization made it simpler to use.

Authelia does offer support for [hardware security keys](https://www.authelia.com/overview/authentication/security-key/). I have not explored those yet but if you do, then you are covered there as well.

If you have any piece of information that is missing in this Authelia Docker guide, please feel free to add in the comments to help others. Otherwise, I hope this Docker Compose for Authelia was useful in making your stack more secure.

[Facebook](https://www.smarthomebeginner.com/#facebook "Facebook")[Twitter](https://www.smarthomebeginner.com/#twitter "Twitter")[Reddit](https://www.smarthomebeginner.com/#reddit "Reddit")[LinkedIn](https://www.smarthomebeginner.com/#linkedin "LinkedIn")[Share](https://www.addtoany.com/share#url=https%3A%2F%2Fwww.smarthomebeginner.com%2Fauthelia-docker-compose-guide-2024%2F&title=Authelia%20Docker%20Compose%20Guide%3A%20Secure%202-Factor%20Authentication%20%5B2024%5D)

### Related Posts:

- [

  ![auto traefik 2 ft](https://www.smarthomebeginner.com/images/2023/11/auto-traefik-2-ft.jpg "Auto-Traefik Version 2.0 - Free Options, UI, Authelia, Portainer, and more")

  ![auto traefik 2 ft](data:image/svg+xml,%3Csvg%20xmlns=%22http://www.w3.org/2000/svg%22%20viewBox=%220%200%20784%20441%22%3E%3C/svg%3E "Auto-Traefik Version 2.0 - Free Options, UI, Authelia, Portainer, and more")

  Auto-Traefik Version 2.0 - Free Options, UI,…](https://www.smarthomebeginner.com/auto-traefik-version-2-0/)

- [

  ![Traefik Dashboard](https://www.smarthomebeginner.com/images/2023/10/traefik-dashboard.jpg "Traefik Auth Bypass: Conditionally Bypassing Forward Authentication")

  ![Traefik Dashboard](data:image/svg+xml,%3Csvg%20xmlns=%22http://www.w3.org/2000/svg%22%20viewBox=%220%200%202184%201247%22%3E%3C/svg%3E "Traefik Auth Bypass: Conditionally Bypassing Forward Authentication")

  Traefik Auth Bypass: Conditionally Bypassing Forward…](https://www.smarthomebeginner.com/traefik-auth-bypass/)

- [

  ![Redis Docker Compose](https://www.smarthomebeginner.com/images/2022/05/redis-docker-compose-ft-1.jpg "Redis Docker Compose Install: With 2 SAVVY Use Cases")

  ![Redis Docker Compose](data:image/svg+xml,%3Csvg%20xmlns=%22http://www.w3.org/2000/svg%22%20viewBox=%220%200%201100%20628%22%3E%3C/svg%3E "Redis Docker Compose Install: With 2 SAVVY Use Cases")

  Redis Docker Compose Install: With 2 SAVVY Use Cases](https://www.smarthomebeginner.com/redis-docker-compose-example/)

- [

  ![Auto-Traefik 3.0](https://www.smarthomebeginner.com/images/2024/03/Auto-Traefik-3.png "Auto-Traefik Version 3.0 - Backups, Guacamole, More Free Options, etc.")

  ![Auto-Traefik 3.0](data:image/svg+xml,%3Csvg%20xmlns=%22http://www.w3.org/2000/svg%22%20viewBox=%220%200%201280%20720%22%3E%3C/svg%3E "Auto-Traefik Version 3.0 - Backups, Guacamole, More Free Options, etc.")

  Auto-Traefik Version 3.0 - Backups, Guacamole, More…](https://www.smarthomebeginner.com/auto-traefik-version-3-0/)

- [

  ![Auto Traefik](https://www.smarthomebeginner.com/images/2023/09/auto-traefik-by-smarthomebeginner.jpg "Auto-Traefik: Dead Simple Traefik Reverse Proxy Automator for Docker")

  ![Auto Traefik](data:image/svg+xml,%3Csvg%20xmlns=%22http://www.w3.org/2000/svg%22%20viewBox=%220%200%201271%20715%22%3E%3C/svg%3E "Auto-Traefik: Dead Simple Traefik Reverse Proxy Automator for Docker")

  Auto-Traefik: Dead Simple Traefik Reverse Proxy…](https://www.smarthomebeginner.com/auto-traefik/)

- [

  ![Portainer Container Manager](https://www.smarthomebeginner.com/images/2023/03/portainer-container-manager.jpg "Portainer Docker Compose: FREE & MUST-HAVE Container Manager")

  ![Portainer Container Manager](data:image/svg+xml,%3Csvg%20xmlns=%22http://www.w3.org/2000/svg%22%20viewBox=%220%200%202162%201184%22%3E%3C/svg%3E "Portainer Docker Compose: FREE & MUST-HAVE Container Manager")

  Portainer Docker Compose: FREE & MUST-HAVE Container Manager](https://www.smarthomebeginner.com/portainer-docker-compose-guide/)

> **Be the 1 in 200,000. Help us sustain what we do.**
>
> 56 / 150 by Dec 31, 2024
>
> [Join Us](https://www.smarthomebeginner.com/membership-account/memberships-products-services/) (starting from just $1.67/month)
>
> [Why did we start Memberships?](https://www.smarthomebeginner.com/state-of-the-site-2023/)

Categories [Home Server](https://www.smarthomebeginner.com/home-server/) Tags [authentication](https://www.smarthomebeginner.com/tag/authentication/), [docker](https://www.smarthomebeginner.com/tag/docker/), [security](https://www.smarthomebeginner.com/tag/security/), [traefik](https://www.smarthomebeginner.com/tag/traefik/)

[Ultimate Traefik Docker Compose Guide \[2024\]: LE, SSL, Reverse Proxy](https://www.smarthomebeginner.com/traefik-docker-compose-guide-2024/)

[Watchtower Docker Compose with Cool Notifications \[2024\]](https://www.smarthomebeginner.com/watchtower-docker-compose-2024/)

![](https://secure.gravatar.com/avatar/5038190c1ce8da93329cc44d5b592149?s=100&d=monsterid&r=pg)

![](data:image/svg+xml,%3Csvg%20xmlns=%22http://www.w3.org/2000/svg%22%20viewBox=%220%200%20100%20100%22%3E%3C/svg%3E)

### Anand

Anand is a self-learned computer enthusiast, hopeless tinkerer (if it ain't broke, fix it), a part-time blogger, and a Scientist during the day. He has been blogging since 2010 on Linux, Ubuntu, Home/Media/File Servers, Smart Home Automation, and related HOW-TOs.

Load Comments

[Facebook](https://www.smarthomebeginner.com/#facebook)[Twitter](https://www.smarthomebeginner.com/#twitter)[Reddit](https://www.smarthomebeginner.com/#reddit)[LinkedIn](https://www.smarthomebeginner.com/#linkedin)[Share](https://www.addtoany.com/share#url=https%3A%2F%2Fwww.smarthomebeginner.com%2Fauthelia-docker-compose-guide-2024%2F&title=Authelia%20Docker%20Compose%20Guide%3A%20Secure%202-Factor%20Authentication%20%5B2024%5D%20%7C%20SHB)

[Arabic](#) [Chinese (Simplified)](#) [Dutch](#) [English](#) [French](#) [German](#) [Italian](#) [Portuguese](#) [Russian](#) [Spanish](#)

![en](Authelia%20Docker%20Compose%20Guide%20Secure%202-Factor%20Authentication%20[2024]_files/en-us.svg) en

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

![SmartHomeBeginner Discord Community](Authelia%20Docker%20Compose%20Guide%20Secure%202-Factor%20Authentication%20[2024]_files/join-discord-300x75.webp "SmartHomeBeginner Discord Community")](https://www.smarthomebeginner.com/discord/)

## Recent Posts

- [

  ![Bash Aliases For Docker](https://www.smarthomebeginner.com/images/2024/05/bash-aliases-for-Docker-150x84.webp "Simplify Docker, Docker Compose, and Linux Commands with Bash Aliases 19")

  ![Bash Aliases For Docker](Authelia%20Docker%20Compose%20Guide%20Secure%202-Factor%20Authentication%20[2024]_files/bash-aliases-for-Docker-150x84.webp "Simplify Docker, Docker Compose, and Linux Commands with Bash Aliases 19")](https://www.smarthomebeginner.com/bash-aliases-for-docker-and-linux/)

  [Simplify Docker, Docker Compose, and Linux Commands with Bash Aliases](https://www.smarthomebeginner.com/bash-aliases-for-docker-and-linux/)

- [

  ![Traefik V3 Docker Compose](https://www.smarthomebeginner.com/images/2024/05/Docker-Series-05-Traefik-v3-150x84.png "Ultimate Traefik v3 Docker Compose Guide [2024]: LE, SSL, Reverse Proxy 20")

  ![Traefik V3 Docker Compose](Authelia%20Docker%20Compose%20Guide%20Secure%202-Factor%20Authentication%20[2024]_files/Docker-Series-05-Traefik-v3-150x84.webp "Ultimate Traefik v3 Docker Compose Guide [2024]: LE, SSL, Reverse Proxy 20")](https://www.smarthomebeginner.com/traefik-v3-docker-compose-guide-2024/)

  [Ultimate Traefik v3 Docker Compose Guide \[2024\]: LE, SSL, Reverse Proxy](https://www.smarthomebeginner.com/traefik-v3-docker-compose-guide-2024/)

- [

  ![Best Mini Pc For Proxmox](https://www.smarthomebeginner.com/images/2024/04/Best-Mini-PC-for-Proxmox-150x84.png "5 Best Mini PC for Proxmox Home Server [2024] 21")

  ![Best Mini Pc For Proxmox](Authelia%20Docker%20Compose%20Guide%20Secure%202-Factor%20Authentication%20[2024]_files/Best-Mini-PC-for-Proxmox-150x84.webp "5 Best Mini PC for Proxmox Home Server [2024] 21")](https://www.smarthomebeginner.com/best-mini-pc-for-proxmox-2024/)

  [5 Best Mini PC for Proxmox Home Server \[2024\]](https://www.smarthomebeginner.com/best-mini-pc-for-proxmox-2024/)

- [

  ![Google Oauth](https://www.smarthomebeginner.com/images/2024/04/Docker-Series-07-Google-OAuth-150x84.png "Google OAuth Traefik Forward Auth [2024]: Most Convenient MFA 22")

  ![Google Oauth](Authelia%20Docker%20Compose%20Guide%20Secure%202-Factor%20Authentication%20[2024]_files/Docker-Series-07-Google-OAuth-150x84.webp "Google OAuth Traefik Forward Auth [2024]: Most Convenient MFA 22")](https://www.smarthomebeginner.com/google-oauth-traefik-forward-auth-2024/)

  [Google OAuth Traefik Forward Auth \[2024\]: Most Convenient MFA](https://www.smarthomebeginner.com/google-oauth-traefik-forward-auth-2024/)

- [

  ![Vaultwarden Docker Compose](https://www.smarthomebeginner.com/images/2023/12/vaultwarden-install-header-1-150x84.webp "Vaultwarden Docker Compose + Detailed Configuration Guide 23")

  ![Vaultwarden Docker Compose](Authelia%20Docker%20Compose%20Guide%20Secure%202-Factor%20Authentication%20[2024]_files/vaultwarden-install-header-1-150x84.webp "Vaultwarden Docker Compose + Detailed Configuration Guide 23")](https://www.smarthomebeginner.com/vaultwarden-docker-compose-guide/)

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

window.lazySizesConfig=window.lazySizesConfig||{};window.lazySizesConfig.loadMode=1;var bU="https://www.smarthomebeginner.com/wp-content/plugins/wp-youtube-lyte/lyte/";var mOs=null;style = document.createElement("style");style.type = "text/css";rules = document.createTextNode(".lyte-wrapper-audio div, .lyte-wrapper div {margin:0px; overflow:hidden;} .lyte,.lyMe{position:relative;padding-bottom:56.25%;height:0;overflow:hidden;background-color:#777;} .fourthree .lyMe, .fourthree .lyte {padding-bottom:75%;} .lidget{margin-bottom:5px;} .lidget .lyte, .widget .lyMe {padding-bottom:0!important;height:100%!important;} .lyte-wrapper-audio .lyte{height:38px!important;overflow:hidden;padding:0!important} .lyMe iframe, .lyte iframe,.lyte .pL{position:absolute !important;top:0;left:0;width:100%;height:100%!important;background:no-repeat scroll center #000;background-size:cover;cursor:pointer} .tC{left:0;position:absolute;top:0;width:100%} .tC{background-image:linear-gradient(to bottom,rgba(0,0,0,0.6),rgba(0,0,0,0))} .tT{color:#FFF;font-family:Roboto,sans-serif;font-size:16px;height:auto;text-align:left;padding:5px 10px 50px 10px} .play{background:no-repeat scroll 0 0 transparent;width:88px;height:63px;position:absolute;left:43%;left:calc(50% - 44px);left:-webkit-calc(50% - 44px);top:38%;top:calc(50% - 31px);top:-webkit-calc(50% - 31px);} .widget .play {top:30%;top:calc(45% - 31px);top:-webkit-calc(45% - 31px);transform:scale(0.6);-webkit-transform:scale(0.6);-ms-transform:scale(0.6);} .lyte:hover .play{background-position:0 -65px;} .lyte-audio .pL{max-height:38px!important} .lyte-audio iframe{height:438px!important} .lyte .ctrl{background:repeat scroll 0 -220px rgba(0,0,0,0.3);width:100%;height:40px;bottom:0px;left:0;position:absolute;} .lyte-wrapper .ctrl{display:none}.Lctrl{background:no-repeat scroll 0 -137px transparent;width:158px;height:40px;bottom:0;left:0;position:absolute} .Rctrl{background:no-repeat scroll -42px -179px transparent;width:117px;height:40px;bottom:0;right:0;position:absolute;padding-right:10px;}.lyte-audio .play{display:none}.lyte-audio .ctrl{background-color:rgba(0,0,0,1)}.lyte .hidden{display:none}");if(style.styleSheet) { style.styleSheet.cssText = rules.nodeValue;} else {style.appendChild(rules);}document.getElementsByTagName("head")\[0\].appendChild(style); (function(){ var corecss = document.createElement('link'); var themecss = document.createElement('link'); var corecssurl = "https://www.smarthomebeginner.com/wp-content/plugins/syntaxhighlighter/syntaxhighlighter3/styles/shCore.css?ver=3.0.9b"; if ( corecss.setAttribute ) { corecss.setAttribute( "rel", "stylesheet" ); corecss.setAttribute( "type", "text/css" ); corecss.setAttribute( "href", corecssurl ); } else { corecss.rel = "stylesheet"; corecss.href = corecssurl; } document.head.appendChild( corecss ); var themecssurl = "https://www.smarthomebeginner.com/wp-content/plugins/syntaxhighlighter/syntaxhighlighter3/styles/shThemeDefault.css?ver=3.0.9b"; if ( themecss.setAttribute ) { themecss.setAttribute( "rel", "stylesheet" ); themecss.setAttribute( "type", "text/css" ); themecss.setAttribute( "href", themecssurl ); } else { themecss.rel = "stylesheet"; themecss.href = themecssurl; } document.head.appendChild( themecss ); })(); SyntaxHighlighter.config.strings.expandSource = '+ expand source'; SyntaxHighlighter.config.strings.help = '?'; SyntaxHighlighter.config.strings.alert = 'SyntaxHighlighter\\n\\n'; SyntaxHighlighter.config.strings.noBrush = 'Can\\'t find brush for: '; SyntaxHighlighter.config.strings.brushNotHtmlScript = 'Brush wasn\\'t configured for html-script option: '; SyntaxHighlighter.defaults\['pad-line-numbers'\] = false; SyntaxHighlighter.defaults\['toolbar'\] = false; SyntaxHighlighter.all(); // Infinite scroll support if ( typeof( jQuery ) !== 'undefined' ) { jQuery( function( $ ) { $( document.body ).on( 'post-load', function() { SyntaxHighlighter.highlight(); } ); } ); } div#toc_container {width: 100%;}div#toc_container ul li {font-size: 90%;} var fpframework_countdown_widget = {"AND":"and"};

✓

Thanks for sharing!

[AddToAny](https://www.addtoany.com/ "Share Buttons")

[More…](#addtoany "Show all")

[AddToAny](https://www.addtoany.com/ "Share Buttons")

[More…](#addtoany "Show all")

var countVars = {"disqusShortname":"htpcbeginner"}; var embedVars = {"disqusConfig":{"integration":"wordpress 3.0.23"},"disqusIdentifier":"50643 https:\\/\\/www.smarthomebeginner.com\\/?p=50643","disqusShortname":"htpcbeginner","disqusTitle":"Authelia Docker Compose Guide: Secure 2-Factor Authentication \[2024\]","disqusUrl":"https:\\/\\/www.smarthomebeginner.com\\/authelia-docker-compose-guide-2024\\/","postId":"50643"}; var dclCustomVars = {"dcl_progress_text":"Loading..."}; var pollsL10n = {"ajax_url":"https:\\/\\/www.smarthomebeginner.com\\/wp-admin\\/admin-ajax.php","text\_wait":"Your last request is still being processed. Please wait a while ...","text_valid":"Please choose a valid poll answer.","text_multiple":"Maximum number of choices allowed: ","show_loading":"1","show_fading":"1"}; var generatepressMenu = {"toggleOpenedSubMenus":"1","openSubMenuLabel":"Open Sub-Menu","closeSubMenuLabel":"Close Sub-Menu"}; var generatepressNavSearch = {"open":"Open Search Bar","close":"Close Search Bar"}; var BestAzon_Configuration = {"Conf_Subsc_Model":"2","Amzn_AfiliateID_US":"shbeg-20","Amzn_AfiliateID_CA":"shbeg09-20","Amzn_AfiliateID_GB":"htpcbeg-21","Amzn_AfiliateID_DE":"htpcbeg08-21","Amzn_AfiliateID_FR":"htpcbeg02-21","Amzn_AfiliateID_ES":"htpcbeg0a-21","Amzn_AfiliateID_IT":"linuxp03-21","Amzn_AfiliateID_JP":"","Amzn_AfiliateID_IN":"htpcbeg0f-21","Amzn_AfiliateID_CN":"","Amzn_AfiliateID_MX":"","Amzn_AfiliateID_BR":"","Amzn_AfiliateID_AU":"shbeg05-22","Conf_Custom_Class":" BestAzon_Amazon_Link ","Conf_New_Window":"1","Conf_Link_Follow":"1","Conf_Product_Link":"1","Conf_Tracking":"2","Conf_Footer":"2","Conf_Link_Keywords":"\\/go\\/","Conf_Hide_Redirect_Link":"1","Conf_Honor_Existing_Tag":"1","Conf_No_Aff_Country_Redirect":"1","Conf_GA_Tracking":"2","Conf_GA_ID":"","Conf_Source":"Wordpress-52"}; var tocplus = {"visibility_show":"show","visibility_hide":"hide","visibility_hide_by_default":"1","width":"100%"}; window.gtranslateSettings = /\* document.write \*/ window.gtranslateSettings || {};window.gtranslateSettings\['78970730'\] = {"default_language":"en","languages":\["ar","zh-CN","nl","en","fr","de","it","pt","ru","es"\],"url_structure":"none","flag_style":"2d","wrapper_selector":"#gt-wrapper-78970730","alt_flags":{"en":"usa"},"float_switcher_open_direction":"top","switcher_horizontal_position":"inline","flags_location":"\\/wp-content\\/plugins\\/gtranslate\\/flags\\/"}; if ( !!window.jQuery ) {(function($){$(document).ready(function(){if ( !!window.SLB && SLB.has_child('View.init') ) { SLB.View.init({"ui_autofit":true,"ui_animate":false,"slideshow_autostart":false,"slideshow_duration":"6","group_loop":true,"ui_overlay_opacity":"0.8","ui_title_default":false,"theme_default":"slb_black","ui_labels":{"loading":"Loading","close":"Close","nav_next":"Next","nav_prev":"Previous","slideshow_start":"Start slideshow","slideshow_stop":"Stop slideshow","group_status":"Item %current% of %total%"}}); } if ( !!window.SLB && SLB.has_child('View.assets') ) { {$.extend(SLB.View.assets, {"357690579":{"id":41129,"type":"image","internal":true,"source":"https:\\/\\/www.smarthomebeginner.com\\/images\\/2020\\/06\\/authelia-tutorial-docker-traefik.jpg","title":"authelia tutorial docker traefik","caption":"Authelia Tutorial for Docker and Traefik","description":""},"1526968854":{"id":41326,"type":"image","internal":true,"source":"https:\\/\\/www.smarthomebeginner.com\\/images\\/2020\\/08\\/docker-secrets-folder-permissions.png","title":"docker secrets folder permissions","caption":"Docker Secrets Folder Permissions","description":""},"496392505":{"id":41327,"type":"image","internal":true,"source":"https:\\/\\/www.smarthomebeginner.com\\/images\\/2020\\/08\\/authelia-secrets.png","title":"authelia secrets","caption":"Secrets for Authelia","description":""},"1239580093":{"id":50660,"type":"image","internal":true,"source":"https:\\/\\/www.smarthomebeginner.com\\/images\\/2024\\/02\\/authelia-user-password-hash.jpg","title":"authelia user password hash","caption":"Authelia Hashed Password","description":""},"1249273197":{"id":50659,"type":"image","internal":true,"source":"https:\\/\\/www.smarthomebeginner.com\\/images\\/2024\\/02\\/authelia-running.jpg","title":"authelia running","caption":"Authelia Docker Compose - Container Started","description":""},"55349735":{"id":50656,"type":"image","internal":true,"source":"https:\\/\\/www.smarthomebeginner.com\\/images\\/2024\\/02\\/authelia-first-login.jpg","title":"authelia first login","caption":"Authelia First Login","description":""},"1439911068":{"id":50658,"type":"image","internal":true,"source":"https:\\/\\/www.smarthomebeginner.com\\/images\\/2024\\/02\\/authelia-register-device.jpg","title":"authelia register device","caption":"Authelia Registration","description":""},"1960423871":{"id":50655,"type":"image","internal":true,"source":"https:\\/\\/www.smarthomebeginner.com\\/images\\/2024\\/02\\/authelia-device-registration-email-sent.jpg","title":"authelia device registration email sent","caption":"Authelia Notification Email Sent","description":""},"1490813079":{"id":50663,"type":"image","internal":true,"source":"https:\\/\\/www.smarthomebeginner.com\\/images\\/2024\\/02\\/authelia-device-registration-email.jpg","title":"authelia device registration email","caption":"Authelia Notification Email - Registration Link","description":""},"1212771030":{"id":50664,"type":"image","internal":true,"source":"https:\\/\\/www.smarthomebeginner.com\\/images\\/2024\\/02\\/authelia-device-registration-qr-code.jpg","title":"authelia device registration qr code","caption":"Authelia Registration QR Code","description":""},"1032266799":{"id":50662,"type":"image","internal":true,"source":"https:\\/\\/www.smarthomebeginner.com\\/images\\/2024\\/02\\/authelia-authenticated.jpg","title":"authelia authenticated","caption":"Authelia Registration Complete","description":""},"392394403":{"id":41303,"type":"image","internal":true,"source":"https:\\/\\/www.smarthomebeginner.com\\/images\\/2020\\/07\\/04b-authelia-registration-email.png","title":"04b authelia registration email","caption":"Opening Authelia Registration Link","description":""},"138058200":{"id":41307,"type":"image","internal":true,"source":"https:\\/\\/www.smarthomebeginner.com\\/images\\/2020\\/07\\/09-add-duo-user-for-authelia.png","title":"09 add duo user for authelia","caption":"Add Duo User for Authelia Push Authentication","description":""},"2043384545":{"id":41308,"type":"image","internal":true,"source":"https:\\/\\/www.smarthomebeginner.com\\/images\\/2020\\/07\\/10-authelia-activate-duo-user.png","title":"10 authelia activate duo user","caption":"Activate New Duo User","description":""},"376739251":{"id":41309,"type":"image","internal":true,"source":"https:\\/\\/www.smarthomebeginner.com\\/images\\/2020\\/07\\/11-authelia-add-applications-to-protect.png","title":"11 authelia add applications to protect","caption":"Add New Application for Duo Push Authentication","description":""}});} } /\* THM \*/ if ( !!window.SLB && SLB.has\_child('View.extend\_theme') ) { SLB.View.extend\_theme('slb\_baseline',{"name":"Baseline","parent":"","styles":\[{"handle":"base","uri":"https:\\/\\/www.smarthomebeginner.com\\/wp-content\\/plugins\\/simple-lightbox\\/themes\\/baseline\\/css\\/style.css","deps":\[\]}\],"layout\_raw":"<div class=\\"slb\_container\\"><div class=\\"slb\_content\\">{{item.content}}<div class=\\"slb\_nav\\"><span class=\\"slb\_prev\\">{{ui.nav\_prev}}<\\/span><span class=\\"slb\_next\\">{{ui.nav\_next}}<\\/span><\\/div><div class=\\"slb\_controls\\"><span class=\\"slb\_close\\">{{ui.close}}<\\/span><span class=\\"slb\_slideshow\\">{{ui.slideshow\_control}}<\\/span><\\/div><div class=\\"slb\_loading\\">{{ui.loading}}<\\/div><\\/div><div class=\\"slb\_details\\"><div class=\\"inner\\"><div class=\\"slb\_data\\"><div class=\\"slb\_data\_content\\"><span class=\\"slb\_data\_title\\">{{item.title}}<\\/span><span class=\\"slb\_group\_status\\">{{ui.group\_status}}<\\/span><div class=\\"slb\_data\_desc\\">{{item.description}}<\\/div><\\/div><\\/div><div class=\\"slb\_nav\\"><span class=\\"slb\_prev\\">{{ui.nav\_prev}}<\\/span><span class=\\"slb\_next\\">{{ui.nav\_next}}<\\/span><\\/div><\\/div><\\/div><\\/div>"}); }if ( !!window.SLB && SLB.has\_child('View.extend\_theme') ) { SLB.View.extend\_theme('slb\_default',{"name":"Default (Light)","parent":"slb\_baseline","styles":\[{"handle":"base","uri":"https:\\/\\/www.smarthomebeginner.com\\/wp-content\\/plugins\\/simple-lightbox\\/themes\\/default\\/css\\/style.css","deps":\[\]}\]}); }if ( !!window.SLB && SLB.has\_child('View.extend\_theme') ) { SLB.View.extend\_theme('slb\_black',{"name":"Default (Dark)","parent":"slb\_default","styles":\[{"handle":"base","uri":"https:\\/\\/www.smarthomebeginner.com\\/wp-content\\/plugins\\/simple-lightbox\\/themes\\/black\\/css\\/style.css","deps":\[\]}\]}); }})})(jQuery);} if ( !!window.jQuery ) {(function($){$(document).ready(function(){if ( !!window.SLB ) { {$.extend(SLB, {"context":\["public","user_guest"\]});} }})})(jQuery);}
