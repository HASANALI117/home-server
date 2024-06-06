# Cloudflare Settings for Traefik Docker: DDNS, CNAMEs, & Tweaks

February 29, 2024June 21, 2020 by [Anand](https://www.smarthomebeginner.com/author/anand/ "View all posts by Anand")

![Cloudflare Settings For Traefik Docker](Cloudflare%20Settings%20for%20Traefik%20Docker%20DDNS,%20CNAMEs,%20&%20Tweaks_files/cloudflare-settings-for-traefik-docker-740x407.webp "Cloudflare Settings for Traefik Docker: DDNS, CNAMEs, & Tweaks 1")

**Cloudflare offers free security and performance improvements for your Traefik 2 Docker setup. In this post, let us look at some Cloudflare settings for Traefik Docker setup to get the best out of your server.**

Our [Traefik Docker guide](https://www.smarthomebeginner.com/traefik-2-docker-tutorial/) is written around Cloudflare. In that guide, I recommended using a wildcard CNAME record to forward all subdomains for apps to your home server. However, proxying wildcard CNAMEs is not allowed in the Cloudflare free plan ([Proxying wildcard CNAMEs is now allowed in the free plan](https://blog.cloudflare.com/wildcard-proxy-for-everyone/)).

Because of this, all services were "gray-clouded" in Cloudflare DNS. This means they were not proxied by Cloudflare and were not benefitting from the security and performance improvements offered by Cloudflare. In addition, these DNS records would also expose the WAN IP of your home server.

The alternative was to, manually create CNAMEs for all the apps in your Docker Traefik stack, which is laborious. Recently, I enabled Cloudflare proxy for all my services (orange-cloud) to take advantage of Cloudflare's enhancements.

In this guide, I will show you the Cloudflare settings to use to get the best out of your Docker and Traefik based home server. \[**Read:** [My Smart Home setup – All gadgets and apps I use in my automated home](https://www.smarthomebeginner.com/my-smart-home-setup-2019/)\]

In addition, I will also show you some of the Docker Cloudflare tweaks to simplify or automate the Cloudflare account management, including automatic DNS updates and CNAME creation.

Table of Contents \[[show](#)\]

- [Traefik Configuration for Cloudflare](#Traefik_Configuration_for_Cloudflare)
- [Cloudflare Settings for Traefik and Docker](#Cloudflare_Settings_for_Traefik_and_Docker)
  - [1\. Development and Maintenance](#1_Development_and_Maintenance)
    - [Pausing Cloudflare during Initial Setup](#Pausing_Cloudflare_during_Initial_Setup)
  - [2\. DNS Entries](#2_DNS_Entries)
  - [3\. SSL/TLS Options](#3_SSLTLS_Options)
    - [Edge Certificates](#Edge_Certificates)
    - [Origin Server](#Origin_Server)
  - [4\. Firewall](#4_Firewall)
    - [Firewall Rules](#Firewall_Rules)
    - [Firewall Tools](#Firewall_Tools)
    - [Firewall Settings](#Firewall_Settings)
  - [5\. Speed](#5_Speed)
    - [Optimization](#Optimization)
  - [6\. Caching](#6_Caching)
    - [Configuration](#Configuration)
  - [7\. Page Rules](#7_Page_Rules)
  - [8\. Network](#8_Network)
- [Docker Images for Cloudflare](#Docker_Images_for_Cloudflare)
  - [1\. Cloudflare DNS Updater](#1_Cloudflare_DNS_Updater)
  - [2\. Cloudflare Companion](#2_Cloudflare_Companion)
- [Cloudflare Tweaks for Traefik and Docker - Final Thoughts](#Cloudflare_Tweaks_for_Traefik_and_Docker_-_Final_Thoughts)

## Traefik Configuration for Cloudflare

This has already been covered in detail in my [Traefik Docker guide](https://www.smarthomebeginner.com/traefik-2-docker-tutorial/). Please follow the linked guide for the initial setup.

One specific CLI argument that I recommend enabling is forwarding headers for trusted IPs.

1

`- --entrypoints.https.forwardedHeaders.trustedIPs=173.245.48.0/20,103.21.244.0/22,103.22.200.0/22,103.31.4.0/22,141.101.64.0/18,108.162.192.0/18,190.93.240.0/20,188.114.96.0/20,197.234.240.0/22,198.41.128.0/17,162.158.0.0/15,104.16.0.0/12,172.64.0.0/13,131.0.72.0/22`

Check the docker-compose file on my [GitHub Repo](https://github.com/htpcBeginner/docker-traefik) to see how exactly this is added to your docker compose.

This CLI argument ensures that the IP addresses of the clients are forwarded to your server. When you check the logs, you will see the client's IP. Without this setting, all requests will appear as if they are originating from Cloudflare's servers.

## Cloudflare Settings for Traefik and Docker

Assuming that your [Docker Traefik setup](https://www.smarthomebeginner.com/traefik-2-docker-tutorial/) follows my guide, let us look at the Cloudflare settings to use.

Note that available Cloudflare features vary based on your plan. For typical home use, I do not see a need for a paid plan and so this article focusses on the free features only.

Cloudflare keeps changing its dashboard/interface periodically. Although the images below may look different at some point in the future, the Cloudflare settings for Docker and Traefik described below should still be valid.

Any setting that is not listed below means either use the Cloudflare-offered default or ignore the Cloudflare setting for Traefik/Docker setup.

### 1\. Development and Maintenance

Two of the main things to know when using Cloudflare proxy are **Development Mode** and **Pausing**.

Development Mode, as the name suggests is for use during development. It disables Cloudflare caching for 3 hours and turns it back on. During this time all requests are directly sent your server.

[

![Cloudflare Settings For Traefik- Development Mode](https://www.smarthomebeginner.com/images/2020/06/cloudflare_development_mode-740x183.png "Cloudflare Settings for Traefik Docker: DDNS, CNAMEs, & Tweaks 2")

![Cloudflare Settings For Traefik- Development Mode](data:image/svg+xml,%3Csvg%20xmlns=%22http://www.w3.org/2000/svg%22%20viewBox=%220%200%20740%20183%22%3E%3C/svg%3E "Cloudflare Settings for Traefik Docker: DDNS, CNAMEs, & Tweaks 2")](https://www.smarthomebeginner.com/images/2020/06/cloudflare_development_mode.png)

Cloudflare Development Mode

The result is that you see the changes immediately, instead of the cached version from Cloudflare servers.

The second option is, pausing Cloudflare. This completely bypasses all Cloudflare features, including security, and uses Cloudflare for only DNS. This is equivalent to "gray-clouding" the DNS records.

[

![Cloudflare Settings - Pause](https://www.smarthomebeginner.com/images/2020/06/pause-cloudflare.png "Cloudflare Settings for Traefik Docker: DDNS, CNAMEs, & Tweaks 3")

![Cloudflare Settings - Pause](data:image/svg+xml,%3Csvg%20xmlns=%22http://www.w3.org/2000/svg%22%20viewBox=%220%200%20590%20198%22%3E%3C/svg%3E "Cloudflare Settings for Traefik Docker: DDNS, CNAMEs, & Tweaks 3")](https://www.smarthomebeginner.com/images/2020/06/pause-cloudflare.png)

Pause Cloudflare

Pausing Cloudflare is rarely needed, except one main instance.

#### Pausing Cloudflare during Initial Setup

When Cloudflare is enabled, it serves its own free SSL certificate to the client, which is great.

However, if you are just setting up Traefik and pulling your certificates from LetsEncrypt, then you want to be able to see the LetsEncrypt Certificate and verify that everything works as it should.

[

![Cloudflare Issues Ssl (Origin Letsencrypt Certificate Not Visible)](https://www.smarthomebeginner.com/images/2020/06/cloudflare-ssl-on-radarr-740x392.png "Cloudflare Settings for Traefik Docker: DDNS, CNAMEs, & Tweaks 4")

![Cloudflare Issues Ssl (Origin Letsencrypt Certificate Not Visible)](data:image/svg+xml,%3Csvg%20xmlns=%22http://www.w3.org/2000/svg%22%20viewBox=%220%200%20740%20392%22%3E%3C/svg%3E "Cloudflare Settings for Traefik Docker: DDNS, CNAMEs, & Tweaks 4")](https://www.smarthomebeginner.com/images/2020/06/cloudflare-ssl-on-radarr.png)

Cloudflare Issues Ssl (Origin Letsencrypt Certificate Not Visible)

During my initial Traefik setup and LetsEncrypt certificate pull, I typically pause Cloudflare. This also removes most of the Cloudflare related entries in the Traefik logs, so I can see what is going without Cloudflare's influence.

Once Traefik and its dashboard are working and I am ready to add more services behind Traefik, I re-enable Cloudflare Proxy (orange-cloud).

### 2\. DNS Entries

Next, the DNS entries/records. In my [Docker Traefik 2 guide](https://www.smarthomebeginner.com/traefik-2-docker-tutorial/), I recommended adding he following two DNS entries.

[

![Cloudflare Dns Entries For Traefik 2 Dns Challenge](https://www.smarthomebeginner.com/images/2018/05/cloudflare-dns-records-for-traefik-2-740x290.png "Cloudflare Settings for Traefik Docker: DDNS, CNAMEs, & Tweaks 5")

![Cloudflare Dns Entries For Traefik 2 Dns Challenge](data:image/svg+xml,%3Csvg%20xmlns=%22http://www.w3.org/2000/svg%22%20viewBox=%220%200%20740%20290%22%3E%3C/svg%3E "Cloudflare Settings for Traefik Docker: DDNS, CNAMEs, & Tweaks 5")](https://www.smarthomebeginner.com/images/2018/05/cloudflare-dns-records-for-traefik-2.png)

Cloudflare Dns Entries For Traefik 2 Dns Challenge

Notice that both entries are "gray-clouded", meaning we are using Cloudflare for DNS only and not for security and performance. In addition, gray-clouding also exposes your server's IP address.

So for security and performance, it makes sense to proxy your services ("orange-cloud") behind Cloudflare. Unfortunately, Cloudflare does not allow proxying wildcard (\*) CNAMEs.

Therefore, you will have to manually add CNAMEs for all of your services and orange-cloud (proxy) them as shown in the screenshot below.

[

![Cloudflare Dns Entries](https://www.smarthomebeginner.com/images/2020/06/cloudflare-dns-entries-740x226.png "Cloudflare Settings for Traefik Docker: DDNS, CNAMEs, & Tweaks 6")

![Cloudflare Dns Entries](data:image/svg+xml,%3Csvg%20xmlns=%22http://www.w3.org/2000/svg%22%20viewBox=%220%200%20740%20226%22%3E%3C/svg%3E "Cloudflare Settings for Traefik Docker: DDNS, CNAMEs, & Tweaks 6")](https://www.smarthomebeginner.com/images/2020/06/cloudflare-dns-entries.png)

Cloudflare Dns Entries

If you have been following my [GitHub repo](https://github.com/htpcBeginner/docker-traefik), I run over 60 services on docker. Imagine manually adding a CNAME for each service? What about when I create and destroy services at will during testing? Managing CNAMEs manually could easily become a pain.

Fear not, there is an easier way. But for now, let us continue to configure Cloudflare for Traefik and come back to this topic later in this guide.

### 3\. SSL/TLS Options

The next Cloudflare option for Traefik reverse proxy is SSL/TLS. Cloudflare offers [4 different modes for SSL](https://developers.cloudflare.com/ssl/origin-configuration/ssl-modes).

Flexible, Full, and Strict, all three models offer pretty much the same level of security. The difference is the trust level.

For home applications (and even beyond). You should be fine with Full or even Flexible SSL mode. Here is a quick summary of how to pick the right mode (Origin Server = Your Home Server):

1.  **No SSL Certificate on Origin server:** All your services are available on HTTP and not HTTPS. Use **Flexible SSL mode**. The connection from your server to Cloudflare can be insecure but the connection between the client and Cloudflare will be secure.
2.  **Self-Signed Certificate on Origin Server:** This is when browsers display a "Your connection is not secure/private" warning (when not using Cloudflare proxy). Use **Full SSL mode**. The connection from your server to Cloudflare is secured using your self-signed certificate and the connection from Cloudflare to your client uses trusted Cloudflare's certificate.
3.  **Certificate Authority Issued Certificate on Origin Server:** This is the situation that will apply if your server uses a) LetsEncrypt certificate that Traefik pulls automatically, b) Cloudflare's free origin certificates or c) your own certificate purchased from a CA. Use **Strict SSL mode**. The connection from your server to Cloudflare is secured using LetsEncrypt certificate and the connection from Cloudflare to your client uses trusted Cloudflare's certificate.

If you have been following my Traefik Docker guides then, you can use **Strict** or **Full**) SSL mode. Using Full SSL mode will ensure that your services are still accessible in case LetsEncrypt renewal fails. The downside is you will not know that a failure happened.

[

![Cloudflare Ssl Encryption Mode For Traefik](https://www.smarthomebeginner.com/images/2020/06/cloudflare-ssl-encryption-mode-740x417.png "Cloudflare Settings for Traefik Docker: DDNS, CNAMEs, & Tweaks 7")

![Cloudflare Ssl Encryption Mode For Traefik](data:image/svg+xml,%3Csvg%20xmlns=%22http://www.w3.org/2000/svg%22%20viewBox=%220%200%20740%20417%22%3E%3C/svg%3E "Cloudflare Settings for Traefik Docker: DDNS, CNAMEs, & Tweaks 7")](https://www.smarthomebeginner.com/images/2020/06/cloudflare-ssl-encryption-mode.png)

Cloudflare Ssl Encryption Mode

I use Strict mode and conditionally downgrade it to Full mode for certain situations as explained later.

Notice that if you choose to use Cloudflare, you do not need LetsEncrypt certificates for your Docker Traefik stack. Traefik's own self-signed certificate would suffice. You won't be able to use Strict SSL mode but all your services would still be available through the trusted Cloudflare's SSL certificate and Full SSL mode.

#### Edge Certificates

Next, configure the **Edge Certificates** section as described below.

- **Always Use HTTPS: ON**. Automatically redirects all requests with scheme “http” to “https”.
- **HTTP Strict Transport Security (HSTS): Enable** (Be Cautious). HSTS improves the security/trust level. However, enable this option with caution. Any certificate issues/change (eg. pausing Cloudflare) can lock you out of accessing your services (you can still access them locally with IP:port). So I recommend enabling this only after everything is working as expected.
- **Minimum TLS Version: 1.2**. Only connections from visitors with TLS versions 1.2 or newer will be allowed for improved security.
- **Opportunistic Encryption: ON**. Opportunistic Encryption allows browsers to benefit from the improved performance of HTTP/2 by letting them know that your site is available over an encrypted connection.
- **TLS 1.3: ON**. TLS 1.3 is the newest, fastest, and most secure version of the TLS protocol. Enable it.
- **Automatic HTTPS Rewrites: ON**. This option fixes the **mixed content** warning from browsers by automatically rewriting HTTP requests to HTTPS.
- **Certificate Transparency Monitoring: ON**. Cloudflare sends an email when a Certificate Authority issues a certificate for your domain. So when your LetsEncrypt certificate is renewed, you will receive an email.

  [

  ![Cloudlfare Certificate Transparency Notification](https://www.smarthomebeginner.com/images/2020/06/cloudflare-certificate-transparency-notification-740x369.png "Cloudflare Settings for Traefik Docker: DDNS, CNAMEs, & Tweaks 8")

  ![Cloudlfare Certificate Transparency Notification](data:image/svg+xml,%3Csvg%20xmlns=%22http://www.w3.org/2000/svg%22%20viewBox=%220%200%20740%20369%22%3E%3C/svg%3E "Cloudflare Settings for Traefik Docker: DDNS, CNAMEs, & Tweaks 8")](https://www.smarthomebeginner.com/images/2020/06/cloudflare-certificate-transparency-notification.png)

  Cloudlfare Certificate Transparency Notification Shows Letsencrypt Renewal

#### Origin Server

You can safely ignore the Origin Server section unless you want to install Cloudflare's free origin certificate (instead of LetsEncrypt) that will allow you to use Strict SSL mode.

### 4\. Firewall

Ignore the **Overview** and **Managed Rules** sections.

#### Firewall Rules

Under **Firewall Rules**, the free plan allows you to create up to 5 rules.

Using this feature, you may block certain kinds of traffic. For example, I am blocking all requests coming from China. Alternatively, you may choose to allow access only from countries that you know you will access your apps from and block the rest.

[

![Cloudflare Firewall Rules For Docker](https://www.smarthomebeginner.com/images/2020/06/cloudflare-firewall-rules.png "Cloudflare Settings for Traefik Docker: DDNS, CNAMEs, & Tweaks 9")

![Cloudflare Firewall Rules For Docker](data:image/svg+xml,%3Csvg%20xmlns=%22http://www.w3.org/2000/svg%22%20viewBox=%220%200%20740%20335%22%3E%3C/svg%3E "Cloudflare Settings for Traefik Docker: DDNS, CNAMEs, & Tweaks 9")](https://www.smarthomebeginner.com/images/2020/06/cloudflare-firewall-rules.png)

Cloudflare Firewall Rules

In addition, this is a personal/private site. So there is no need for any bots (eg. search engine bots) to crawl my site. So, as shown above, I am blocking those as well. Here is a firewall report screenshot showing, Yandex bot was blocked.

[

![Yandex Blocked By Cloudflare Firewall Rules](https://www.smarthomebeginner.com/images/2020/06/yandex-blocked-by-cloudflare-740x378.png "Cloudflare Settings for Traefik Docker: DDNS, CNAMEs, & Tweaks 10")

![Yandex Blocked By Cloudflare Firewall Rules](data:image/svg+xml,%3Csvg%20xmlns=%22http://www.w3.org/2000/svg%22%20viewBox=%220%200%20740%20378%22%3E%3C/svg%3E "Cloudflare Settings for Traefik Docker: DDNS, CNAMEs, & Tweaks 10")](https://www.smarthomebeginner.com/images/2020/06/yandex-blocked-by-cloudflare.png)

Yandex Blocked By Cloudflare Firewall Rules

Firewall rules have been very beneficial to this site, which runs on [WordPress on Docker](https://www.smarthomebeginner.com/wordpress-on-docker-traefik/).

#### Firewall Tools

You can also use the Tools section to put certain blocks or allows in place. You can even present a challenge to the incoming traffic.

In the example below, I am whitelisting traffic from my home's WAN IP so all requests coming from my home IP are allowed and not blocked or challenged.

[

![Whitelisting Known Ips](https://www.smarthomebeginner.com/images/2020/06/cloudflare_ip_whitelist-740x309.png "Cloudflare Settings for Traefik Docker: DDNS, CNAMEs, & Tweaks 11")

![Whitelisting Known Ips](data:image/svg+xml,%3Csvg%20xmlns=%22http://www.w3.org/2000/svg%22%20viewBox=%220%200%20740%20309%22%3E%3C/svg%3E "Cloudflare Settings for Traefik Docker: DDNS, CNAMEs, & Tweaks 11")](https://www.smarthomebeginner.com/images/2020/06/cloudflare_ip_whitelist.png)

Whitelisting Known Ips

#### Firewall Settings

Next, under the Firewall **Settings** section (easy to miss - see on the right side), set the following options.

- **Security Level: High**. Challenges all visitors that have exhibited threatening behavior within the last 14 days.
- **Bot Fight Mode: ON**. Challenge requests matching patterns of known bots before they can access your site.
- **Challenge Passage: 30 Minutes**. Specify the length of time that a visitor, who has successfully completed a Captcha or JavaScript Challenge, can access your website.
- **Browser Integrity Check: ON**. Evaluate HTTP headers from your visitor's browser for threats. If a threat is found a block page will be delivered.

Combined with a good multifactor authentication system ([Google OAuth](https://www.smarthomebeginner.com/google-oauth-with-traefik-2-docker/) or [Authelia](https://www.smarthomebeginner.com/docker-authelia-tutorial/)), **High** security level offers a great level of protection.

- [Google OAuth Tutorial for Docker and Traefik – Authentication for Services](https://www.smarthomebeginner.com/google-oauth-with-traefik-2-docker/)

I use [Guacamole](https://www.smarthomebeginner.com/install-guacamole-on-docker/) and [VNC](https://www.smarthomebeginner.com/setup-vnc-server-on-ubuntu-linux/) to remotely connect to my apps. In the wrong hands, these apps can enable complete take over of your system and data. Knowing that certain traffic, known bots, and threats are mitigated with Cloudflare, gives me a certain level of peace.

> **Be the 1 in 200,000. Help us sustain what we do.**
>
> 56 / 150 by Dec 31, 2024
>
> [Join Us](https://www.smarthomebeginner.com/membership-account/memberships-products-services/) (starting from just $1.67/month)
>
> [Why did we start Memberships?](https://www.smarthomebeginner.com/state-of-the-site-2023/)

### 5\. Speed

The next section in configuring Cloudflare for Traefik and Docker is Speed. This is beneficial for high traffic websites and has minimal impact on a private server.

#### Optimization

Under optimization, choose the following settings:

- **Auto Minify: OFF**. Reduce the file size of the source code on your website. But if not done properly, it can mess up Javascript and CSS, causing unexpected behavior.
- **Brotli: ON**. Speeds up page load times for HTTPS traffic by applying Brotli compression.
- **Rocket Loader: OFF**. Rocket Loader improves paint times by asynchronously loading your Javascripts, including third-party scripts so that they do not block rendering the content of your pages. But again, this is one of the main culprits that can cause your home server apps to behave unexpectedly. \[**Read:** [9 Best Home Server Apps to Automate Media Management](https://www.smarthomebeginner.com/best-home-server-apps/)\].

[

![Rocket Loader Will Most Likely Interfere With The Functioning Of Home Server Apps](https://www.smarthomebeginner.com/images/2020/06/cloudflare-rocket-loader-740x157.png "Cloudflare Settings for Traefik Docker: DDNS, CNAMEs, & Tweaks 12")

![Rocket Loader Will Most Likely Interfere With The Functioning Of Home Server Apps](data:image/svg+xml,%3Csvg%20xmlns=%22http://www.w3.org/2000/svg%22%20viewBox=%220%200%20740%20157%22%3E%3C/svg%3E "Cloudflare Settings for Traefik Docker: DDNS, CNAMEs, & Tweaks 12")](https://www.smarthomebeginner.com/images/2020/06/cloudflare-rocket-loader.png)

Rocket Loader Will Most Likely Interfere With The Functioning Of Home Server Apps

You can ignore the remaining settings (most of them are paid features anyways).

### 6\. Caching

Caching stores copies of your web app resources on Cloudflare's servers and present the cached version when requested. This increases speed, especially when you are accessing your Docker apps from outside your home.

If you made significant changes to your app's UI and you do not see it in your browser, then the cache purge buttons on this page are worth trying.

#### Configuration

Under Cache configuration, choose the following settings:

- **Caching Level: Standard**. Determine how much of your website’s static content you want Cloudflare to cache.
- **Browser Cache TTL: 1 hour**. During this period, the browser loads the files from its local cache, speeding up page loads. Keeping it too long can force you to clear your browser cache to see the changes.
- **Always Online: OFF**. If your server goes down, Cloudflare will serve your web app's "static" pages from the cache. Most of the docker apps from my previous guides are dynamic.

Caching requests and content from your media servers (eg. videos form Plex, Emby, Jellyfin, etc.) could use a significant amount of Cloudflare's resources. Doing so is against the terms of use and could get your account suspended. Use **Page Rules** to not cache these requests.

### 7\. Page Rules

Next, we move to one of the more important Cloudflare settings for Docker and Traefik. This is critical, especially, if you run media servers (eg. Plex, Emby, Jellyfin, etc.).

Page Rules give finer, URL-based control of Cloudflare's settings. There are certain pages in our setup that need to bypass Cloudflare's resources. In my case, I wanted to bypass the following apps from using Cloudflare cache:

- **Plex** - available at https://nucplex.example.com
- **Emby** - available at https://nucemby.example.com
- **Jellyfin** - available at https://nucjelly.example.com
- **Airsonic** - available at https://nucair.example.com

Notice, that all of the above subdomains start with _nuc_. This makes it easy to define Cloudflare rules and helps us be within the limit of 3 rules for the free account. My Cloudflare rule is defined as shown below to bypass Cloudflare's cache for these media server apps.

[

![Cloudflare Page Rules For Letsencrypt And Media Servers (Plex, Emby, Jellyfin, Etc.)](https://www.smarthomebeginner.com/images/2020/06/cloudflare-page-rules-free-740x403.png "Cloudflare Settings for Traefik Docker: DDNS, CNAMEs, & Tweaks 13")

![Cloudflare Page Rules For Letsencrypt And Media Servers (Plex, Emby, Jellyfin, Etc.)](data:image/svg+xml,%3Csvg%20xmlns=%22http://www.w3.org/2000/svg%22%20viewBox=%220%200%20740%20403%22%3E%3C/svg%3E "Cloudflare Settings for Traefik Docker: DDNS, CNAMEs, & Tweaks 13")](https://www.smarthomebeginner.com/images/2020/06/cloudflare-page-rules-free.png)

Cloudflare Page Rules For Letsencrypt And Media Servers (Plex, Emby, Jellyfin, Etc.)

Any page that starts with "nuc" ([NUC for my Intel NUC home server](https://www.smarthomebeginner.com/my-smart-home-setup-2019/#Home_Server_Media_Server)), bypasses the Cloudflare cache. Doing so is important to comply with Cloudflare's terms of rule for the free plan.

In addition, I also have two other rules (#1 and #3 in the screenshot above):

**#1**. Switch SSL Mode from **Strict** to **Full** when accessing Unifi Controller. Unifi controller has had issues while accessing it via Traefik 2 because it uses a self-signed certificate. There are other workarounds for this. But using Cloudflare proxy in Full SSL mode also solved the problem for me.

**#3**. Turn Cloudflare's SSL off when Traefik tries to fetch LetsEncrypt SSL certificates. If this rule is not presented, then Cloudflare's free SSL certificate with interfere with LetsEncrypt. In other words, the LetsEncrypt server must be able to see your origin server and the private key directly without any intermediate (Cloudflare proxy).

### 8\. Network

There is nothing much to customize or configure in **Network** section. HTTP/2 is enabled by default. The rest of the settings can be left as-is.

## Docker Images for Cloudflare

Now that all the Cloudflare settings for Traefik have been set, let us look at a couple of Cloudflare specific docker images that can enhance our Docker server. As always check my [GitHub Repo](https://github.com/htpcBeginner/docker-traefik) for current versions.

**Note:** In my GitHub repo (which should be your main source of reference for docker-compose examples as it has the most up-to-date information), I use several domain names: DOMAINNAME_HOME_SERVER (for my Docker Home Server on Synology), DOMAINNAME_CLOUD_SERVER (for my Dedicated Server in a Datacenter, with Proxmox), DOMAINNAME_SHB (domain name for this website), and DOMAINNAME_KHUB (domain name of another non-WordPress website I host). You may find any of these domain variables in my examples. Make sure to substitute this variable with your own.

### 1\. Cloudflare DNS Updater

The first docker image is for Cloudflare DNS updater. This is useful if you are using a dynamic WAN IP issued by your ISP (typically the case for most home users). Any time your WAN IP changes, you will need to update IP address on your DNS records.

This dynamic DNS updater image will make sure that the host IP address for your root domain set in your DNS records is always current. When your WAN IP changes, it will automatically update your DNS records.

Here is the docker-componse snippet to your Docker stack:

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

`# Cloudflare DDNS - Dynamic DNS Updater`

`cf-ddns:`

`container_name: cf-ddns`

`image: oznu/cloudflare-ddns:latest`

`restart: always`

`environment:`

`- API_KEY=$CLOUDFLARE_API_TOKEN`

`- ZONE=$DOMAINNAME_HOME_SERVER`

`- PROXIED=true`

`- RRTYPE=A`

`- DELETE_ON_STOP=false`

`- DNS_SERVER=1.1.1.1`

**Change/Configure:**

- **$CLOUDFLARE_API_TOKEN:** This is a scoped API token created on your Cloudflare profile. Here is a screenshot of mine:

  [

  ![Scoped Api Token For Cloudflare Management](https://www.smarthomebeginner.com/images/2020/06/cloudflare-scoped-API-token-740x295.png "Cloudflare Settings for Traefik Docker: DDNS, CNAMEs, & Tweaks 14")

  ![Scoped Api Token For Cloudflare Management](data:image/svg+xml,%3Csvg%20xmlns=%22http://www.w3.org/2000/svg%22%20viewBox=%220%200%20740%20295%22%3E%3C/svg%3E "Cloudflare Settings for Traefik Docker: DDNS, CNAMEs, & Tweaks 14")](https://www.smarthomebeginner.com/images/2020/06/cloudflare-scoped-API-token.png)

  Scoped Api Token For Cloudflare Management

  Once created, add it to **CLOUDFLARE_API_TOKEN** environmental variable defined in your **.env** file.

- **$DOMAINNAME_HOME_SERVER** - Your root domain name as defined in **.env** file. If you followed my [Docker Traefik guide](https://www.smarthomebeginner.com/traefik-2-docker-tutorial/), you should already have this.
- **PROXIED** - Set this to true if you want your domain proxied (orange-cloud) via Cloudflare.
- **RRTYPE** - A, for A record.
- **DELETE_ON_STOP** - Set this to false as we do not want the record deleted when the container is stopped.
- **DNS_SERVER** - Leave this as 1.1.1.1, which is Cloudflare's DNS resolver.

Save your docker-compose, start the container, and check the logs for **cf-ddns** container. You should see something like this:

[

![Cloudflare Ddns Monitors Your Wan Ip And Updates Dns Records If Necessary](https://www.smarthomebeginner.com/images/2020/06/cf-ddns-update-740x58.png "Cloudflare Settings for Traefik Docker: DDNS, CNAMEs, & Tweaks 15")

![Cloudflare Ddns Monitors Your Wan Ip And Updates Dns Records If Necessary](data:image/svg+xml,%3Csvg%20xmlns=%22http://www.w3.org/2000/svg%22%20viewBox=%220%200%20740%2058%22%3E%3C/svg%3E "Cloudflare Settings for Traefik Docker: DDNS, CNAMEs, & Tweaks 15")](https://www.smarthomebeginner.com/images/2020/06/cf-ddns-update.png)

Cloudflare Ddns Monitors Your Wan Ip And Updates Dns Records If Necessary

In the above case, no IP change was needed in the DNS records.

### 2\. Cloudflare Companion

The second container that I recently discovered automatically creates CNAME records for your services. Manually adding CNAMEs for all your services can be cumbersome. This was stopping me from enabling proxy (orange-cloud) and using all the awesome security and performance features that Cloudflare offers.

This image was the main reason I decided to turn on Cloudflare proxy for my services.

To add Cloudflare Companion, add the following snippet to your docker-compose.

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

`# Cloudflare-Companion - Automatic CNAME DNS Creation`

`cf-companion:`

`container_name: cf-companion`

`image: tiredofit/traefik-cloudflare-companion:latest`

`restart: always`

`volumes:`

`- /var/run/docker.sock:/var/run/docker.sock:ro`

`environment:`

`- TIMEZONE=$TZ`

`- TRAEFIK_VERSION=2`

`- CF_EMAIL=$CLOUDFLARE_EMAIL # Same as traefik`

`# - CF_TOKEN=$CLOUDFLARE_API_TOKEN # Scoped api token not working. Error 10000.`

`- CF_TOKEN=$CLOUDFLARE_API_KEY # Same as traefik`

`- TARGET_DOMAIN=$DOMAINNAME_HOME_SERVER`

`- DOMAIN1=$DOMAINNAME_HOME_SERVER`

`- DOMAIN1_ZONE_ID=$CLOUDFLARE_ZONEID # Copy from Cloudflare Overview page`

`- DOMAIN1_PROXIED=TRUE`

`labels:`

`# Add hosts specified in rules here to force cf-companion to create the CNAMEs`

`# Since cf-companion creates CNAMEs based on host rules, this a workaround for non-docker/external apps`

`` - "traefik.http.routers.cf-companion-rtr.rule=HostHeader(`pihole.$DOMAINNAME_HOME_SERVER`) || HostHeader(`hassio.$DOMAINNAME_HOME_SERVER`)" ``

**Change/Configure:**

- **TRAEFIK_VERSION**: Set this to 2 for Traefik v2. Cloudflare Companion also works with Traefik version 1.
- **$CLOUDFLARE_EMAIL**: Your Cloudflare account email. This must already be in your **.env** file if you followed my previous guides.
- **$CLOUDFLARE_API_TOKEN**: Scoped API Token as described for the Cloudflare DDNS service described above. Unfortunately this did not work for me. A solution was to use $CLOUDFLARE_API_KEY instead.
- **$CLOUDFLARE_API_KEY**: This is the Cloudflare global API key. It should already be in your **.env** file if you followed my previous guides.
- **$DOMAINNAME_HOME_SERVER**: Your root domain name as defined in **.env** file.
- **$CLOUDFLARE_ZONEID**: This is the Zone ID for the domain from your Cloudflare account and defined in the **.env** file.
- **DOMAIN1_PROXIED**: Set this to true to enable Cloudflare proxy for the CNAME record.

This container will automatically pick up the CNAMEs to create for your services from the **Host** rule defined for each service.

But what about the external services that are behind Traefik using the **rules** folder? You can add these using labels. Examples for PiHole and Home Assistant (hass) are shown in the compose snippet above. \[**Read:** [Complete Pi Hole setup guide: Ad-free better internet in 15 minutes](https://www.smarthomebeginner.com/pi-hole-setup-guide/)\]

Once added and configured, save your docker-compose file, start the container, and check the logs for **cf-companion** container. You should see something like what is shown in the screenshot below.

[

![Cloudflare Tweaks - Cloudflare Companion Auto Creates Cnames For Services](https://www.smarthomebeginner.com/images/2020/06/cloudflare-companion-to-autocreate-CNAMEs-740x172.png "Cloudflare Settings for Traefik Docker: DDNS, CNAMEs, & Tweaks 16")

![Cloudflare Tweaks - Cloudflare Companion Auto Creates Cnames For Services](data:image/svg+xml,%3Csvg%20xmlns=%22http://www.w3.org/2000/svg%22%20viewBox=%220%200%20740%20172%22%3E%3C/svg%3E "Cloudflare Settings for Traefik Docker: DDNS, CNAMEs, & Tweaks 16")](https://www.smarthomebeginner.com/images/2020/06/cloudflare-companion-to-autocreate-CNAMEs.png)

Cloudflare Companion Auto Creates Cnames For Services

The example screenshot shows CF companion checking CNAMEs for Bazarr (bazarr) and Airsonic (nucair). The CNAMEs for these services already exist and so no DNS record update was needed.

## Cloudflare Tweaks for Traefik and Docker - Final Thoughts

I have been using Cloudflare for nearly 10 years. I started out with the free plan and now use their paid plans to enhance this website. So the Cloudflare free plan to my private/home domain was a no brainer.

When Cloudflare came up with their own privacy focussed DNS servers (1.1.1.1 and 1.0.0.1) I switched to them immediately. When they opened up domain registrations, I moved mine to Cloudflare (~$7.25 for private domain registration is one of the best). So you can say, I am a Cloudflare fanboy.

For my Docker Traefik setup, I use Cloudflare mainly for its security features. In addition, I have implemented several [best practices for Docker security](https://www.smarthomebeginner.com/traefik-docker-security-best-practices/). I highly recommend that you review those.

Performance effects are quite minimal as most times I access my docker services from my home environment. I had issues with Traefik 2 working properly with Unifi Controller (which uses a self-signed certificate). With Cloudflare's Full SSL, this problem went away.

For anybody that uses a Docker Traefik setup with their own domain name, I strongly recommend using Cloudflare. Configuring Cloudflare to work properly could be a bit overwhelming for beginners. I hope that this post helps you set the optimal Cloudflare settings for Traefik Docker setup. If you have any thoughts or different ideas, please feel free to comment below.

[Facebook](https://www.smarthomebeginner.com/#facebook "Facebook")[Twitter](https://www.smarthomebeginner.com/#twitter "Twitter")[Reddit](https://www.smarthomebeginner.com/#reddit "Reddit")[LinkedIn](https://www.smarthomebeginner.com/#linkedin "LinkedIn")[Share](https://www.addtoany.com/share#url=https%3A%2F%2Fwww.smarthomebeginner.com%2Fcloudflare-settings-for-traefik-docker%2F&title=Cloudflare%20Settings%20for%20Traefik%20Docker%3A%20DDNS%2C%20CNAMEs%2C%20%26%20Tweaks)

### Related Posts:

- [

  ![CrowdSec Traefik Bouncer](https://www.smarthomebeginner.com/images/2022/11/crowdsec-traefik-bouncer.jpg "CrowdSec Docker Part 3: Traefik Bouncer for Additional Security")

  ![CrowdSec Traefik Bouncer](data:image/svg+xml,%3Csvg%20xmlns=%22http://www.w3.org/2000/svg%22%20viewBox=%220%200%20862%20513%22%3E%3C/svg%3E "CrowdSec Docker Part 3: Traefik Bouncer for Additional Security")

  CrowdSec Docker Part 3: Traefik Bouncer for…](https://www.smarthomebeginner.com/crowdsec-traefik-bouncer/)

- [

  ![Proxmox Web Interface Traefik](https://www.smarthomebeginner.com/images/2023/12/proxmox-web-interface-traefik.jpg "How to put Proxmox Web Interface Behind Traefik?")

  ![Proxmox Web Interface Traefik](data:image/svg+xml,%3Csvg%20xmlns=%22http://www.w3.org/2000/svg%22%20viewBox=%220%200%201373%20752%22%3E%3C/svg%3E "How to put Proxmox Web Interface Behind Traefik?")

  How to put Proxmox Web Interface Behind Traefik?](https://www.smarthomebeginner.com/proxmox-web-interface-behind-traefik/)

- [

  ![Auto-Traefik 3.0](https://www.smarthomebeginner.com/images/2024/03/Auto-Traefik-3.png "Auto-Traefik Version 3.0 - Backups, Guacamole, More Free Options, etc.")

  ![Auto-Traefik 3.0](data:image/svg+xml,%3Csvg%20xmlns=%22http://www.w3.org/2000/svg%22%20viewBox=%220%200%201280%20720%22%3E%3C/svg%3E "Auto-Traefik Version 3.0 - Backups, Guacamole, More Free Options, etc.")

  Auto-Traefik Version 3.0 - Backups, Guacamole, More…](https://www.smarthomebeginner.com/auto-traefik-version-3-0/)

- [

  ![CrowdSec Cloudflare Bouncer](https://www.smarthomebeginner.com/images/2022/11/crowdsec-cloudflare-bouncer.jpg "CrowdSec Docker Part 2: Improved IPS with Cloudflare Bouncer")

  ![CrowdSec Cloudflare Bouncer](data:image/svg+xml,%3Csvg%20xmlns=%22http://www.w3.org/2000/svg%22%20viewBox=%220%200%20862%20513%22%3E%3C/svg%3E "CrowdSec Docker Part 2: Improved IPS with Cloudflare Bouncer")

  CrowdSec Docker Part 2: Improved IPS with Cloudflare Bouncer](https://www.smarthomebeginner.com/crowdsec-cloudflare-bouncer/)

- [

  ![Proxmox SSL Certificate with LetsEncrypt](https://www.smarthomebeginner.com/images/2022/03/proxmox-ssl-certificate-letsencrypt-ft-1.jpg "Dead Simple Proxmox SSL Certificate with LetsEncrypt in <10 MIN")

  ![Proxmox SSL Certificate with LetsEncrypt](data:image/svg+xml,%3Csvg%20xmlns=%22http://www.w3.org/2000/svg%22%20viewBox=%220%200%201647%20888%22%3E%3C/svg%3E "Dead Simple Proxmox SSL Certificate with LetsEncrypt in <10 MIN")

  Dead Simple Proxmox SSL Certificate with LetsEncrypt in](https://www.smarthomebeginner.com/proxmox-ssl-certificate-with-letsencrypt/)

- [

  ![Traefik Multiple Hosts on Single Gateway Router](https://www.smarthomebeginner.com/images/2023/07/Traefik-Multiple-Hosts-but-Single-Gateway-Router.png "Multiple Traefik Instances on Different Domains/Hosts and One External IP")

  ![Traefik Multiple Hosts on Single Gateway Router](data:image/svg+xml,%3Csvg%20xmlns=%22http://www.w3.org/2000/svg%22%20viewBox=%220%200%201280%20720%22%3E%3C/svg%3E "Multiple Traefik Instances on Different Domains/Hosts and One External IP")

  Multiple Traefik Instances on Different…](https://www.smarthomebeginner.com/multiple-traefik-instances/)

> **Be the 1 in 200,000. Help us sustain what we do.**
>
> 56 / 150 by Dec 31, 2024
>
> [Join Us](https://www.smarthomebeginner.com/membership-account/memberships-products-services/) (starting from just $1.67/month)
>
> [Why did we start Memberships?](https://www.smarthomebeginner.com/state-of-the-site-2023/)

Categories [Home Server](https://www.smarthomebeginner.com/home-server/) Tags [docker](https://www.smarthomebeginner.com/tag/docker/), [reverse proxy](https://www.smarthomebeginner.com/tag/reverse-proxy/), [traefik](https://www.smarthomebeginner.com/tag/traefik/)

[Google OAuth Tutorial for Docker and Traefik – Authentication for Services](https://www.smarthomebeginner.com/google-oauth-with-traefik-2-docker/)

[Synology Docker Media Server with Traefik, Docker Compose, and Cloudflare](https://www.smarthomebeginner.com/synology-docker-media-server/)

![](https://secure.gravatar.com/avatar/5038190c1ce8da93329cc44d5b592149?s=100&d=monsterid&r=pg)

![](data:image/svg+xml,%3Csvg%20xmlns=%22http://www.w3.org/2000/svg%22%20viewBox=%220%200%20100%20100%22%3E%3C/svg%3E)

### Anand

Anand is a self-learned computer enthusiast, hopeless tinkerer (if it ain't broke, fix it), a part-time blogger, and a Scientist during the day. He has been blogging since 2010 on Linux, Ubuntu, Home/Media/File Servers, Smart Home Automation, and related HOW-TOs.

Load Comments

[Facebook](https://www.smarthomebeginner.com/#facebook)[Twitter](https://www.smarthomebeginner.com/#twitter)[Reddit](https://www.smarthomebeginner.com/#reddit)[LinkedIn](https://www.smarthomebeginner.com/#linkedin)[Share](https://www.addtoany.com/share#url=https%3A%2F%2Fwww.smarthomebeginner.com%2Fcloudflare-settings-for-traefik-docker%2F&title=Cloudflare%20Settings%20for%20Traefik%20Docker%3A%20DDNS%2C%20CNAMEs%2C%20%26%20Tweaks%20%7C%20SHB)

[Arabic](#) [Chinese (Simplified)](#) [Dutch](#) [English](#) [French](#) [German](#) [Italian](#) [Portuguese](#) [Russian](#) [Spanish](#)

![en](Cloudflare%20Settings%20for%20Traefik%20Docker%20DDNS,%20CNAMEs,%20&%20Tweaks_files/en-us.svg) en

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

![SmartHomeBeginner Discord Community](Cloudflare%20Settings%20for%20Traefik%20Docker%20DDNS,%20CNAMEs,%20&%20Tweaks_files/join-discord-300x75.webp "SmartHomeBeginner Discord Community")](https://www.smarthomebeginner.com/discord/)

## Recent Posts

- [

  ![Bash Aliases For Docker](https://www.smarthomebeginner.com/images/2024/05/bash-aliases-for-Docker-150x84.webp "Simplify Docker, Docker Compose, and Linux Commands with Bash Aliases 17")

  ![Bash Aliases For Docker](Cloudflare%20Settings%20for%20Traefik%20Docker%20DDNS,%20CNAMEs,%20&%20Tweaks_files/bash-aliases-for-Docker-150x84.webp "Simplify Docker, Docker Compose, and Linux Commands with Bash Aliases 17")](https://www.smarthomebeginner.com/bash-aliases-for-docker-and-linux/)

  [Simplify Docker, Docker Compose, and Linux Commands with Bash Aliases](https://www.smarthomebeginner.com/bash-aliases-for-docker-and-linux/)

- [

  ![Traefik V3 Docker Compose](https://www.smarthomebeginner.com/images/2024/05/Docker-Series-05-Traefik-v3-150x84.png "Ultimate Traefik v3 Docker Compose Guide [2024]: LE, SSL, Reverse Proxy 18")

  ![Traefik V3 Docker Compose](Cloudflare%20Settings%20for%20Traefik%20Docker%20DDNS,%20CNAMEs,%20&%20Tweaks_files/Docker-Series-05-Traefik-v3-150x84.webp "Ultimate Traefik v3 Docker Compose Guide [2024]: LE, SSL, Reverse Proxy 18")](https://www.smarthomebeginner.com/traefik-v3-docker-compose-guide-2024/)

  [Ultimate Traefik v3 Docker Compose Guide \[2024\]: LE, SSL, Reverse Proxy](https://www.smarthomebeginner.com/traefik-v3-docker-compose-guide-2024/)

- [

  ![Best Mini Pc For Proxmox](https://www.smarthomebeginner.com/images/2024/04/Best-Mini-PC-for-Proxmox-150x84.png "5 Best Mini PC for Proxmox Home Server [2024] 19")

  ![Best Mini Pc For Proxmox](Cloudflare%20Settings%20for%20Traefik%20Docker%20DDNS,%20CNAMEs,%20&%20Tweaks_files/Best-Mini-PC-for-Proxmox-150x84.webp "5 Best Mini PC for Proxmox Home Server [2024] 19")](https://www.smarthomebeginner.com/best-mini-pc-for-proxmox-2024/)

  [5 Best Mini PC for Proxmox Home Server \[2024\]](https://www.smarthomebeginner.com/best-mini-pc-for-proxmox-2024/)

- [

  ![Google Oauth](https://www.smarthomebeginner.com/images/2024/04/Docker-Series-07-Google-OAuth-150x84.png "Google OAuth Traefik Forward Auth [2024]: Most Convenient MFA 20")

  ![Google Oauth](Cloudflare%20Settings%20for%20Traefik%20Docker%20DDNS,%20CNAMEs,%20&%20Tweaks_files/Docker-Series-07-Google-OAuth-150x84.webp "Google OAuth Traefik Forward Auth [2024]: Most Convenient MFA 20")](https://www.smarthomebeginner.com/google-oauth-traefik-forward-auth-2024/)

  [Google OAuth Traefik Forward Auth \[2024\]: Most Convenient MFA](https://www.smarthomebeginner.com/google-oauth-traefik-forward-auth-2024/)

- [

  ![Vaultwarden Docker Compose](https://www.smarthomebeginner.com/images/2023/12/vaultwarden-install-header-1-150x84.webp "Vaultwarden Docker Compose + Detailed Configuration Guide 21")

  ![Vaultwarden Docker Compose](data:image/svg+xml,%3Csvg%20xmlns=%22http://www.w3.org/2000/svg%22%20viewBox=%220%200%20150%2084%22%3E%3C/svg%3E "Vaultwarden Docker Compose + Detailed Configuration Guide 21")](https://www.smarthomebeginner.com/vaultwarden-docker-compose-guide/)

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

window.lazySizesConfig=window.lazySizesConfig||{};window.lazySizesConfig.loadMode=1;var bU="https://www.smarthomebeginner.com/wp-content/plugins/wp-youtube-lyte/lyte/";var mOs=null;style = document.createElement("style");style.type = "text/css";rules = document.createTextNode(".lyte-wrapper-audio div, .lyte-wrapper div {margin:0px; overflow:hidden;} .lyte,.lyMe{position:relative;padding-bottom:56.25%;height:0;overflow:hidden;background-color:#777;} .fourthree .lyMe, .fourthree .lyte {padding-bottom:75%;} .lidget{margin-bottom:5px;} .lidget .lyte, .widget .lyMe {padding-bottom:0!important;height:100%!important;} .lyte-wrapper-audio .lyte{height:38px!important;overflow:hidden;padding:0!important} .lyMe iframe, .lyte iframe,.lyte .pL{position:absolute !important;top:0;left:0;width:100%;height:100%!important;background:no-repeat scroll center #000;background-size:cover;cursor:pointer} .tC{left:0;position:absolute;top:0;width:100%} .tC{background-image:linear-gradient(to bottom,rgba(0,0,0,0.6),rgba(0,0,0,0))} .tT{color:#FFF;font-family:Roboto,sans-serif;font-size:16px;height:auto;text-align:left;padding:5px 10px 50px 10px} .play{background:no-repeat scroll 0 0 transparent;width:88px;height:63px;position:absolute;left:43%;left:calc(50% - 44px);left:-webkit-calc(50% - 44px);top:38%;top:calc(50% - 31px);top:-webkit-calc(50% - 31px);} .widget .play {top:30%;top:calc(45% - 31px);top:-webkit-calc(45% - 31px);transform:scale(0.6);-webkit-transform:scale(0.6);-ms-transform:scale(0.6);} .lyte:hover .play{background-position:0 -65px;} .lyte-audio .pL{max-height:38px!important} .lyte-audio iframe{height:438px!important} .lyte .ctrl{background:repeat scroll 0 -220px rgba(0,0,0,0.3);width:100%;height:40px;bottom:0px;left:0;position:absolute;} .lyte-wrapper .ctrl{display:none}.Lctrl{background:no-repeat scroll 0 -137px transparent;width:158px;height:40px;bottom:0;left:0;position:absolute} .Rctrl{background:no-repeat scroll -42px -179px transparent;width:117px;height:40px;bottom:0;right:0;position:absolute;padding-right:10px;}.lyte-audio .play{display:none}.lyte-audio .ctrl{background-color:rgba(0,0,0,1)}.lyte .hidden{display:none}");if(style.styleSheet) { style.styleSheet.cssText = rules.nodeValue;} else {style.appendChild(rules);}document.getElementsByTagName("head")\[0\].appendChild(style); (function(){ var corecss = document.createElement('link'); var themecss = document.createElement('link'); var corecssurl = "https://www.smarthomebeginner.com/wp-content/plugins/syntaxhighlighter/syntaxhighlighter3/styles/shCore.css?ver=3.0.9b"; if ( corecss.setAttribute ) { corecss.setAttribute( "rel", "stylesheet" ); corecss.setAttribute( "type", "text/css" ); corecss.setAttribute( "href", corecssurl ); } else { corecss.rel = "stylesheet"; corecss.href = corecssurl; } document.head.appendChild( corecss ); var themecssurl = "https://www.smarthomebeginner.com/wp-content/plugins/syntaxhighlighter/syntaxhighlighter3/styles/shThemeDefault.css?ver=3.0.9b"; if ( themecss.setAttribute ) { themecss.setAttribute( "rel", "stylesheet" ); themecss.setAttribute( "type", "text/css" ); themecss.setAttribute( "href", themecssurl ); } else { themecss.rel = "stylesheet"; themecss.href = themecssurl; } document.head.appendChild( themecss ); })(); SyntaxHighlighter.config.strings.expandSource = '+ expand source'; SyntaxHighlighter.config.strings.help = '?'; SyntaxHighlighter.config.strings.alert = 'SyntaxHighlighter\\n\\n'; SyntaxHighlighter.config.strings.noBrush = 'Can\\'t find brush for: '; SyntaxHighlighter.config.strings.brushNotHtmlScript = 'Brush wasn\\'t configured for html-script option: '; SyntaxHighlighter.defaults\['pad-line-numbers'\] = false; SyntaxHighlighter.defaults\['toolbar'\] = false; SyntaxHighlighter.all(); // Infinite scroll support if ( typeof( jQuery ) !== 'undefined' ) { jQuery( function( $ ) { $( document.body ).on( 'post-load', function() { SyntaxHighlighter.highlight(); } ); } ); } div#toc\_container {width: 100%;}div#toc\_container ul li {font-size: 90%;} var fpframework\_countdown\_widget = {"AND":"and"}; var countVars = {"disqusShortname":"htpcbeginner"}; var embedVars = {"disqusConfig":{"integration":"wordpress 3.0.23"},"disqusIdentifier":"41097 https:\\/\\/www.smarthomebeginner.com\\/?p=41097","disqusShortname":"htpcbeginner","disqusTitle":"Cloudflare Settings for Traefik Docker: DDNS, CNAMEs, & Tweaks","disqusUrl":"https:\\/\\/www.smarthomebeginner.com\\/cloudflare-settings-for-traefik-docker\\/","postId":"41097"}; var dclCustomVars = {"dcl\_progress\_text":"Loading..."}; var pollsL10n = {"ajax\_url":"https:\\/\\/www.smarthomebeginner.com\\/wp-admin\\/admin-ajax.php","text\_wait":"Your last request is still being processed. Please wait a while ...","text\_valid":"Please choose a valid poll answer.","text\_multiple":"Maximum number of choices allowed: ","show\_loading":"1","show\_fading":"1"}; var generatepressMenu = {"toggleOpenedSubMenus":"1","openSubMenuLabel":"Open Sub-Menu","closeSubMenuLabel":"Close Sub-Menu"}; var generatepressNavSearch = {"open":"Open Search Bar","close":"Close Search Bar"}; var BestAzon\_Configuration = {"Conf\_Subsc\_Model":"2","Amzn\_AfiliateID\_US":"shbeg-20","Amzn\_AfiliateID\_CA":"shbeg09-20","Amzn\_AfiliateID\_GB":"htpcbeg-21","Amzn\_AfiliateID\_DE":"htpcbeg08-21","Amzn\_AfiliateID\_FR":"htpcbeg02-21","Amzn\_AfiliateID\_ES":"htpcbeg0a-21","Amzn\_AfiliateID\_IT":"linuxp03-21","Amzn\_AfiliateID\_JP":"","Amzn\_AfiliateID\_IN":"htpcbeg0f-21","Amzn\_AfiliateID\_CN":"","Amzn\_AfiliateID\_MX":"","Amzn\_AfiliateID\_BR":"","Amzn\_AfiliateID\_AU":"shbeg05-22","Conf\_Custom\_Class":" BestAzon\_Amazon\_Link ","Conf\_New\_Window":"1","Conf\_Link\_Follow":"1","Conf\_Product\_Link":"1","Conf\_Tracking":"2","Conf\_Footer":"2","Conf\_Link\_Keywords":"\\/go\\/","Conf\_Hide\_Redirect\_Link":"1","Conf\_Honor\_Existing\_Tag":"1","Conf\_No\_Aff\_Country\_Redirect":"1","Conf\_GA\_Tracking":"2","Conf\_GA\_ID":"","Conf\_Source":"Wordpress-52"}; var tocplus = {"visibility\_show":"show","visibility\_hide":"hide","visibility\_hide\_by\_default":"1","width":"100%"}; window.gtranslateSettings = /\* document.write \*/ window.gtranslateSettings || {};window.gtranslateSettings\['60028224'\] = {"default\_language":"en","languages":\["ar","zh-CN","nl","en","fr","de","it","pt","ru","es"\],"url\_structure":"none","flag\_style":"2d","wrapper\_selector":"#gt-wrapper-60028224","alt\_flags":{"en":"usa"},"float\_switcher\_open\_direction":"top","switcher\_horizontal\_position":"inline","flags\_location":"\\/wp-content\\/plugins\\/gtranslate\\/flags\\/"}; if ( !!window.jQuery ) {(function($){$(document).ready(function(){if ( !!window.SLB && SLB.has\_child('View.init') ) { SLB.View.init({"ui\_autofit":true,"ui\_animate":false,"slideshow\_autostart":false,"slideshow\_duration":"6","group\_loop":true,"ui\_overlay\_opacity":"0.8","ui\_title\_default":false,"theme\_default":"slb\_black","ui\_labels":{"loading":"Loading","close":"Close","nav\_next":"Next","nav\_prev":"Previous","slideshow\_start":"Start slideshow","slideshow\_stop":"Stop slideshow","group\_status":"Item %current% of %total%"}}); } if ( !!window.SLB && SLB.has\_child('View.assets') ) { {$.extend(SLB.View.assets, {"676218445":{"id":41139,"type":"image","internal":true,"source":"https:\\/\\/www.smarthomebeginner.com\\/images\\/2020\\/06\\/cloudflare\_development\_mode.png","title":"cloudflare\_development\_mode","caption":"Cloudflare Development Mode","description":""},"1636710989":{"id":41140,"type":"image","internal":true,"source":"https:\\/\\/www.smarthomebeginner.com\\/images\\/2020\\/06\\/pause-cloudflare.png","title":"pause cloudflare","caption":"Pause Cloudflare","description":""},"613174528":{"id":41149,"type":"image","internal":true,"source":"https:\\/\\/www.smarthomebeginner.com\\/images\\/2020\\/06\\/cloudflare-ssl-on-radarr.png","title":"cloudflare ssl on radarr","caption":"Cloudflare issues SSL (Origin LetsEncrypt Certificate not visible)","description":""},"2078708622":{"id":40833,"type":"image","internal":true,"source":"https:\\/\\/www.smarthomebeginner.com\\/images\\/2018\\/05\\/cloudflare-dns-records-for-traefik-2.png","title":"cloudflare dns records for traefik 2","caption":"Cloudflare DNS Entries for Traefik 2 DNS Challenge","description":""},"1274934094":{"id":41133,"type":"image","internal":true,"source":"https:\\/\\/www.smarthomebeginner.com\\/images\\/2020\\/06\\/cloudflare-dns-entries.png","title":"cloudflare dns entries","caption":"Cloudflare DNS Entries","description":""},"2114932269":{"id":41136,"type":"image","internal":true,"source":"https:\\/\\/www.smarthomebeginner.com\\/images\\/2020\\/06\\/cloudflare-ssl-encryption-mode.png","title":"cloudflare ssl encryption mode","caption":"Cloudflare SSL Encryption Mode","description":""},"115206409":{"id":41154,"type":"image","internal":true,"source":"https:\\/\\/www.smarthomebeginner.com\\/images\\/2020\\/06\\/cloudflare-certificate-transparency-notification.png","title":"cloudflare certificate transparency notification","caption":"Cloudlfare Certificate Transparency Notification","description":""},"2110774940":{"id":41144,"type":"image","internal":true,"source":"https:\\/\\/www.smarthomebeginner.com\\/images\\/2020\\/06\\/cloudflare-firewall-rules.png","title":"cloudflare firewall rules","caption":"Cloudflare Firewall Rules","description":""},"1101016777":{"id":41160,"type":"image","internal":true,"source":"https:\\/\\/www.smarthomebeginner.com\\/images\\/2020\\/06\\/yandex-blocked-by-cloudflare.png","title":"yandex blocked by cloudflare","caption":"Yandex Blocked by Cloudflare Firewall Rules","description":""},"332272825":{"id":41134,"type":"image","internal":true,"source":"https:\\/\\/www.smarthomebeginner.com\\/images\\/2020\\/06\\/cloudflare\_ip\_whitelist.png","title":"cloudflare\_ip\_whitelist","caption":"Whitelisting Known IPs","description":""},"666970799":{"id":41173,"type":"image","internal":true,"source":"https:\\/\\/www.smarthomebeginner.com\\/images\\/2020\\/06\\/cloudflare-rocket-loader.png","title":"cloudflare rocket loader","caption":"Rocket Loader will most likely interfere with the functioning of home server apps","description":""},"1953840927":{"id":41167,"type":"image","internal":true,"source":"https:\\/\\/www.smarthomebeginner.com\\/images\\/2020\\/06\\/cloudflare-page-rules-free.png","title":"cloudflare page rules free","caption":"Cloudflare Page Rules for LetsEncrypt and Media Servers (Plex, Emby, Jellyfin, etc.)","description":""},"613535475":{"id":41163,"type":"image","internal":true,"source":"https:\\/\\/www.smarthomebeginner.com\\/images\\/2020\\/06\\/cloudflare-scoped-API-token.png","title":"cloudflare scoped API token","caption":"Scoped API Token for Cloudflare Management","description":""},"398121651":{"id":41162,"type":"image","internal":true,"source":"https:\\/\\/www.smarthomebeginner.com\\/images\\/2020\\/06\\/cf-ddns-update.png","title":"cf ddns update","caption":"Cloudflare DDNS Monitors your WAN IP and Updates DNS Records if Necessary","description":""},"631364514":{"id":41164,"type":"image","internal":true,"source":"https:\\/\\/www.smarthomebeginner.com\\/images\\/2020\\/06\\/cloudflare-companion-to-autocreate-CNAMEs.png","title":"cloudflare companion to autocreate CNAMEs","caption":"Cloudflare Companion Auto Creates CNAMEs for Services ","description":""}});} } /\* THM \*/ if ( !!window.SLB && SLB.has_child('View.extend_theme') ) { SLB.View.extend_theme('slb_baseline',{"name":"Baseline","parent":"","styles":\[{"handle":"base","uri":"https:\\/\\/www.smarthomebeginner.com\\/wp-content\\/plugins\\/simple-lightbox\\/themes\\/baseline\\/css\\/style.css","deps":\[\]}\],"layout\_raw":"<div class=\\"slb_container\\"><div class=\\"slb_content\\">{{item.content}}<div class=\\"slb_nav\\"><span class=\\"slb_prev\\">{{ui.nav\_prev}}<\\/span><span class=\\"slb_next\\">{{ui.nav\_next}}<\\/span><\\/div><div class=\\"slb_controls\\"><span class=\\"slb_close\\">{{ui.close}}<\\/span><span class=\\"slb_slideshow\\">{{ui.slideshow\_control}}<\\/span><\\/div><div class=\\"slb_loading\\">{{ui.loading}}<\\/div><\\/div><div class=\\"slb_details\\"><div class=\\"inner\\"><div class=\\"slb_data\\"><div class=\\"slb_data_content\\"><span class=\\"slb_data_title\\">{{item.title}}<\\/span><span class=\\"slb_group_status\\">{{ui.group\_status}}<\\/span><div class=\\"slb_data_desc\\">{{item.description}}<\\/div><\\/div><\\/div><div class=\\"slb_nav\\"><span class=\\"slb_prev\\">{{ui.nav\_prev}}<\\/span><span class=\\"slb_next\\">{{ui.nav\_next}}<\\/span><\\/div><\\/div><\\/div><\\/div>"}); }if ( !!window.SLB && SLB.has_child('View.extend_theme') ) { SLB.View.extend_theme('slb_default',{"name":"Default (Light)","parent":"slb_baseline","styles":\[{"handle":"base","uri":"https:\\/\\/www.smarthomebeginner.com\\/wp-content\\/plugins\\/simple-lightbox\\/themes\\/default\\/css\\/style.css","deps":\[\]}\]}); }if ( !!window.SLB && SLB.has_child('View.extend_theme') ) { SLB.View.extend_theme('slb_black',{"name":"Default (Dark)","parent":"slb_default","styles":\[{"handle":"base","uri":"https:\\/\\/www.smarthomebeginner.com\\/wp-content\\/plugins\\/simple-lightbox\\/themes\\/black\\/css\\/style.css","deps":\[\]}\]}); }})})(jQuery);} if ( !!window.jQuery ) {(function($){$(document).ready(function(){if ( !!window.SLB ) { {$.extend(SLB, {"context":\["public","user_guest"\]});} }})})(jQuery);}

✓

Thanks for sharing!

[AddToAny](https://www.addtoany.com/ "Share Buttons")

[More…](#addtoany "Show all")

[AddToAny](https://www.addtoany.com/ "Share Buttons")

[More…](#addtoany "Show all")
