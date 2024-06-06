# Google OAuth Traefik Forward Auth \[2024\]: Most Convenient MFA

May 1, 2024April 17, 2024 by [Anand](https://www.smarthomebeginner.com/author/anand/ "View all posts by Anand")

Traefik forward authentication with Google OAuth 2 provides a convenient yet strong multi-factor authentication for your Docker or non-Docker apps. This is a step-by-step guide to accomplish that.

[Facebook](https://www.smarthomebeginner.com/#facebook "Facebook")[Twitter](https://www.smarthomebeginner.com/#twitter "Twitter")[Reddit](https://www.smarthomebeginner.com/#reddit "Reddit")[LinkedIn](https://www.smarthomebeginner.com/#linkedin "LinkedIn")[Share](https://www.addtoany.com/share#url=https%3A%2F%2Fwww.smarthomebeginner.com%2Fgoogle-oauth-traefik-forward-auth-2024%2F&title=Google%20OAuth%20Traefik%20Forward%20Auth%20%5B2024%5D%3A%20Most%20Convenient%20MFA)

![Google Oauth](Google%20OAuth%20Traefik%20Forward%20Auth%20[2024]%20Most%20Convenient%20MFA_files/Docker-Series-07-Google-OAuth-740x416.webp "Google OAuth Traefik Forward Auth [2024]: Most Convenient MFA 1")

Tired of all your docker services having their authentication system? For those that don't, do you hate Traefik's basic auth? Then, read on to setup up Google OAuth2 with **Traefik Forward Auth**. Enjoy the convenience of a secure single-sign-on for your Docker services.

In fact, on all my services, I prefer Google OAuth over Authelia just because I am usually signed into the Google ecosystem for various things. This means significantly fewer login prompts for me. This guide is an updated version of my previous Traefik OAuth guides published in [2019](https://www.smarthomebeginner.com/google-oauth-with-traefik-docker/), [2020](https://www.smarthomebeginner.com/google-oauth-with-traefik-2-docker/), and [2022](https://www.smarthomebeginner.com/traefik-forward-auth-google-oauth-2022/).

**Note:** If you prefer the convenience of automating Homelab setup (e.g. Traefik, Backups, Portainer, Homepage, Authelia, etc.), then check out [Auto-Traefik Script](https://www.smarthomebeginner.com/auto-traefik/).

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

If you're already running Docker-based Media Server behind a Traefik reverse proxy, then this is a logical next step. \[**Read:** [Podman vs Docker: 6 Reasons why I am HAPPY I switched](https://www.smarthomebeginner.com/podman-vs-docker/)\]

Table of Contents \[[show](#)\]

- [What is OAuth?](#What_is_OAuth)
  - [Why Traefik Google OAuth2 for Docker Services?](#Why_Traefik_Google_OAuth2_for_Docker_Services)
  - [Traefik Forward Auth Alternatives](#Traefik_Forward_Auth_Alternatives)
  - [How does Google OAuth2 with Traefik work?](#How_does_Google_OAuth2_with_Traefik_work)
- [Setting Up Google OAuth with Traefik Forward Authentication](#Setting_Up_Google_OAuth_with_Traefik_Forward_Authentication)
  - [Step 1: Create DNS Records](#Step_1_Create_DNS_Records)
  - [Step 2: Configure Google OAuth2 Service](#Step_2_Configure_Google_OAuth2_Service)
    - [Step 2a: Create a Google Project](#Step_2a_Create_a_Google_Project)
    - [Step 2b: Configure the Consent Screen](#Step_2b_Configure_the_Consent_Screen)
    - [Step 2c: Create OAuth Credentials](#Step_2c_Create_OAuth_Credentials)
    - [Step 2d: Create the OAuth client ID](#Step_2d_Create_the_OAuth_client_ID)
  - [Step 3: Setup Traefik Forward Authentication with OAuth2](#Step_3_Setup_Traefik_Forward_Authentication_with_OAuth2)
    - [Step 3a: Create Traefik Auth Middleware](#Step_3a_Create_Traefik_Auth_Middleware)
    - [Step 3b: Create Traefik OAuth Middleware Chain](#Step_3b_Create_Traefik_OAuth_Middleware_Chain)
    - [Step 3b: Add Traefik Forward Auth Secrets](#Step_3b_Add_Traefik_Forward_Auth_Secrets)
  - [Step 4. OAuth Docker Compose](#Step_4_OAuth_Docker_Compose)
  - [Step 5: Starting OAuth Container](#Step_5_Starting_OAuth_Container)
- [Authentication and Conditional Bypassing](#Authentication_and_Conditional_Bypassing)
  - [Putting Docker Services behind OAuth](#Putting_Docker_Services_behind_OAuth)
  - [Putting Non-Docker Services behind OAuth](#Putting_Non-Docker_Services_behind_OAuth)
  - [Bypassing OAuth / Selective Authentication](#Bypassing_OAuth_Selective_Authentication)
  - [Alternative Bypass Methods](#Alternative_Bypass_Methods)
- [OAuth and Security Headers](#OAuth_and_Security_Headers)
- [FAQs](#FAQs)
  - [What is traefik-forward-auth-provider?](#What_is_traefik-forward-auth-provider)
  - [Is traefik-forward-auth-provider popular?](#Is_traefik-forward-auth-provider_popular)
  - [What is the difference between OIDC and OAuth?](#What_is_the_difference_between_OIDC_and_OAuth)
  - [Are there other (more private) alternatives to Google OAuth?](#Are_there_other_more_private_alternatives_to_Google_OAuth)
  - [How do I sign out of my services that use Google OAuth2?](#How_do_I_sign_out_of_my_services_that_use_Google_OAuth2)
- [Final Thoughts Traefik Forward Authentication](#Final_Thoughts_Traefik_Forward_Authentication)

## What is OAuth?

OAuth is an open standard for access delegation, commonly used as a way for Internet users to grant websites or applications access to their information on other websites but without giving them the passwords. This mechanism is used by companies such as Amazon, Google, Facebook, Microsoft, and Twitter to permit users to share information about their accounts with third-party applications or websites.” [\- Wikipedia](https://en.wikipedia.org/wiki/OAuth)

### Why Traefik Google OAuth2 for Docker Services?

Adding the [basic authentication that Traefik provides](https://doc.traefik.io/traefik/middlewares/http/basicauth/) is the simplest way to protect your docker and non-docker services.

For a single service, this can be useful, but I found it quickly became inconvenient and tedious once I had to sign-in to multiple services and for every browser session.

Google OAuth2 enables you to use your Google account to sign in to your services. Using **Google OAuth with Traefik** will allow you to whitelist accounts, implement Google’s 2FA, as well as provide a Single Sign-On (SSO) to your services. This not only offers the convenience of not having to sign in frequently but also improves security.

### Traefik Forward Auth Alternatives

If you prefer a private self-hosted (rather than relying on Google) multi-factor authentication system, then look into Authelia. I use [Authelia](https://www.smarthomebeginner.com/authelia-docker-compose-guide-2024/) for certain services.

The **thomseddon/traefik-forward-auth** image provides Google OAuth authentication. If you prefer other generic OIDC providers, then a good options is the **mesosphere/traefik-forward-auth** Docker image.

In addition, there are more alternatives such as Keycloak and Authentik.

**Which authentication system do you prefer or use for your Docker stack?**

- Only each service's native authentication
- Traefik's Basic HTTP Authentication
- Google OAuth
- Authelia
- Authentik
- Keycloak
- Others

[View Results](#ViewPollResults "View Results Of This Poll")

![Loading ...](https://www.smarthomebeginner.com/wp-content/plugins/wp-polls/images/loading.gif "Loading ...")

![Loading ...](data:image/svg+xml,%3Csvg%20xmlns=%22http://www.w3.org/2000/svg%22%20viewBox=%220%200%2016%2016%22%3E%3C/svg%3E "Loading ...") Loading ...

### How does Google OAuth2 with Traefik work?

Before configuring Traefik Forward Auth with Google OAuth2, let us see how it all fits together.

Google OAuth login and authentication for Traefik acts like a gatekeeper for your services, allowing or denying access after checking for an authorized cookie in your browser. To sum it up, the process goes something like this:

1.  A request is made for our **Host** ( e.g.: https://traefik.simplehomelab.com)
2.  The request is routed by our DNS provider to our WAN IP, where ports 80 and 443 are forwarded to the Traefik container.
3.  Traefik sees the incoming request and recognizes that **Forward Auth** is defined in the **labels** for that **Host**, therefore the request is forwarded to the **Traefik Forward Auth** container.
4.  The container then checks to see if the browser already has an authorized cookie. If there's no cookie, the request is sent to **Google's OAuth2 Authorization Server**.
5.  After successfully logging in to Google, the request is sent to the **redirect URI** identified for the **Web Application** (_https://oauth.simplehomelab.com/\_oauth_).
6.  An authorized cookie is then saved in the browser, and the user is sent to the backend service.

The next time that this browser tries to access a service protected by OAuth-based login and authentication, the cookie will be recognized and the user will be taken to their service, without being prompted to sign in!

[

![Traefik Forward Auth With Google Oauth - Process Flow](https://www.smarthomebeginner.com/images/2019/10/traefik-forward-authentication-with-google-oauth-740x353.png "Google OAuth Traefik Forward Auth [2024]: Most Convenient MFA 2")

![Traefik Forward Auth With Google Oauth - Process Flow](data:image/svg+xml,%3Csvg%20xmlns=%22http://www.w3.org/2000/svg%22%20viewBox=%220%200%20740%20353%22%3E%3C/svg%3E "Google OAuth Traefik Forward Auth [2024]: Most Convenient MFA 2")](https://www.smarthomebeginner.com/images/2019/10/traefik-forward-authentication-with-google-oauth.png)

Traefik Forward Auth With Google Oauth - Process Flow

This process happens very quickly, and once your browser receives the cookie, you'll forget you've even enabled Google OAuth with Traefik!

**Note:** The Traefik Forward Auth image uses [**OpenID** **Connect**](https://en.wikipedia.org/wiki/OpenID_Connect) (**OIDC**), which is an authentication layer on top of the [OAuth 2.0](https://en.wikipedia.org/wiki/OAuth#OAuth_2.0 "OAuth") protocol. The docker image presented in this guide supports Google and also [other OIDC providers](https://github.com/thomseddon/traefik-forward-auth/wiki/Provider-Setup).

With the basics taken care of let's move on to setting Google OAuth _Traefik forward authentication_ for our Docker services.

## Setting Up Google OAuth with Traefik Forward Authentication

Setting up Google OAuth for Docker using Traefik, involves 3 steps: 1) creating DNS records, 2) configuring Google OAuth2 Service, and 2) modifying Docker compose files and adding the Traefik labels to activate forward authentication.

Let's set up all of the prerequisites now:

### Step 1: Create DNS Records

Start by [creating a new CNAME DNS record](https://www.smarthomebeginner.com/traefik-docker-compose-guide-2024/#Requirements_for_Docker_Traefik_Setup) for our OAuth service (Google will redirect to this address after authentication).

If you have a wildcard CNAME (\*) set then you do not have to create one specific for OAuth. You may then skip this step.

For clarity, throughout this guide we'll use the domain name **simplehomelab.com**.

Set the DNS record as **oauth.simplehomelab.com**. The pictures below show a screenshot from Cloudflare. Depending on your DNS provider, things may look different for you but essentially have the same content.

[

![Create Dns Records For Google Oauth2](https://www.smarthomebeginner.com/images/2019/10/01-clouldflare-dns-records-for-traefik-google-oauth-740x265.png "Google OAuth Traefik Forward Auth [2024]: Most Convenient MFA 3")

![Create Dns Records For Google Oauth2](data:image/svg+xml,%3Csvg%20xmlns=%22http://www.w3.org/2000/svg%22%20viewBox=%220%200%20740%20265%22%3E%3C/svg%3E "Google OAuth Traefik Forward Auth [2024]: Most Convenient MFA 3")](https://www.smarthomebeginner.com/images/2019/10/01-clouldflare-dns-records-for-traefik-google-oauth.png)

Create Dns Records For Google Oauth2

Note that DNS records can take several hours to propagate and become active.

### Step 2: Configure Google OAuth2 Service

With the DNS records created, let us move on the configuring Google OAuth.

#### Step 2a: Create a Google Project

We need to create a **Google Project** that will contain our **Web App**, **Consent Screen**, and **Credentials**. This process is very similar to what is described in our guide on [setting up Google Assistant for Home Assistant](https://www.smarthomebeginner.com/configure-google-assistant-for-home-assistant/).

Navigate to the [Google Cloud Developers Console](https://console.developers.google.com/) and make sure that you are signed into the correct Google account that you want to use (This will normally be your e-mail address).

**Note:** Sign out of other active Google accounts to make sure that the correct account is used at each step.

If prompted, you'll need to agree to the **Google Cloud Platform Terms of Service** to use their API:

[

![Google Terms Of Service](https://www.smarthomebeginner.com/images/2019/10/Google-ToS.jpg "Google OAuth Traefik Forward Auth [2024]: Most Convenient MFA 4")

![Google Terms Of Service](data:image/svg+xml,%3Csvg%20xmlns=%22http://www.w3.org/2000/svg%22%20viewBox=%220%200%20558%20448%22%3E%3C/svg%3E "Google OAuth Traefik Forward Auth [2024]: Most Convenient MFA 4")](https://www.smarthomebeginner.com/images/2019/10/Google-ToS.jpg)

Google Terms Of Service

It's free to use Google's OAuth service, so we can **Dismiss** the free trial for now. Click on **Select a project** and **New project**.

[

![Create A New Project For Oauth](https://www.smarthomebeginner.com/images/2019/10/02-google-oauth-create-new-project-740x358.png "Google OAuth Traefik Forward Auth [2024]: Most Convenient MFA 5")

![Create A New Project For Oauth](data:image/svg+xml,%3Csvg%20xmlns=%22http://www.w3.org/2000/svg%22%20viewBox=%220%200%20740%20358%22%3E%3C/svg%3E "Google OAuth Traefik Forward Auth [2024]: Most Convenient MFA 5")](https://www.smarthomebeginner.com/images/2019/10/02-google-oauth-create-new-project.png)

Create A New Project For Oauth

Enter a unique name to identify the project, such as **Traefik Forward Auth**. Click **Create**.

[

![Google Console - Create A New Project](https://www.smarthomebeginner.com/images/2024/04/01-Create-a-New-Projects-740x520.png "Google OAuth Traefik Forward Auth [2024]: Most Convenient MFA 6")

![Google Console - Create A New Project](data:image/svg+xml,%3Csvg%20xmlns=%22http://www.w3.org/2000/svg%22%20viewBox=%220%200%20740%20520%22%3E%3C/svg%3E "Google OAuth Traefik Forward Auth [2024]: Most Convenient MFA 6")](https://www.smarthomebeginner.com/images/2024/04/01-Create-a-New-Projects.png)

Google Console - Create A New Project

#### Step 2b: Configure the Consent Screen

Once you click **OAuth Client ID**, you will see the note to configure the consent screen as shown below. A configuring a consent screen is required before proceeding.

If you're not automatically prompted, select the **OAuth consent screen** from the left panel.

Choose **External** for **User Type** and click **Create**.

[

![Oauth Consent Screen - External App](https://www.smarthomebeginner.com/images/2024/04/02-OAuth-Concent-Screen-External-740x469.png "Google OAuth Traefik Forward Auth [2024]: Most Convenient MFA 7")

![Oauth Consent Screen - External App](data:image/svg+xml,%3Csvg%20xmlns=%22http://www.w3.org/2000/svg%22%20viewBox=%220%200%20740%20469%22%3E%3C/svg%3E "Google OAuth Traefik Forward Auth [2024]: Most Convenient MFA 7")](https://www.smarthomebeginner.com/images/2024/04/02-OAuth-Concent-Screen-External.png)

Oauth Consent Screen - External App

Choose a name for your app, such as **Traefik Auth**.

[

![Oauth Consent Screen - App Information](https://www.smarthomebeginner.com/images/2024/04/03-1-OAuth-Consent-Screen-App-Name-1-740x393.png "Google OAuth Traefik Forward Auth [2024]: Most Convenient MFA 8")

![Oauth Consent Screen - App Information](data:image/svg+xml,%3Csvg%20xmlns=%22http://www.w3.org/2000/svg%22%20viewBox=%220%200%20740%20393%22%3E%3C/svg%3E "Google OAuth Traefik Forward Auth [2024]: Most Convenient MFA 8")](https://www.smarthomebeginner.com/images/2024/04/03-1-OAuth-Consent-Screen-App-Name-1.png)

Oauth Consent Screen - App Information

Then, under the **Authorized domains** section enter your domain, for instance, **simplehomelab.com**. You may even add multiple domains if you plan to use the same for authentication on multiple domains.

[

![Oauth Consent Screen - Authorized Domains](https://www.smarthomebeginner.com/images/2024/04/03-2-Oauth-Consent-Screen-Domains-1-740x692.png "Google OAuth Traefik Forward Auth [2024]: Most Convenient MFA 9")

![Oauth Consent Screen - Authorized Domains](data:image/svg+xml,%3Csvg%20xmlns=%22http://www.w3.org/2000/svg%22%20viewBox=%220%200%20740%20692%22%3E%3C/svg%3E "Google OAuth Traefik Forward Auth [2024]: Most Convenient MFA 9")](https://www.smarthomebeginner.com/images/2024/04/03-2-Oauth-Consent-Screen-Domains-1.png)

Oauth Consent Screen - Authorized Domains

Make sure that you press **Enter** to add it, and then click **Save**.

Nothing to add or change under **Scopes**. So **Save and Continue**.

[

![Oauth Consent Screen - Scope](https://www.smarthomebeginner.com/images/2024/04/04-Scopes-Save-and-Continue-740x273.png "Google OAuth Traefik Forward Auth [2024]: Most Convenient MFA 10")

![Oauth Consent Screen - Scope](data:image/svg+xml,%3Csvg%20xmlns=%22http://www.w3.org/2000/svg%22%20viewBox=%220%200%20740%20273%22%3E%3C/svg%3E "Google OAuth Traefik Forward Auth [2024]: Most Convenient MFA 10")](https://www.smarthomebeginner.com/images/2024/04/04-Scopes-Save-and-Continue.png)

Oauth Consent Screen - Scope

Again, nothing to add or change for **Test Users**. So **Save and Continue**.

[

![Oauth Consent Screen - Test Users](https://www.smarthomebeginner.com/images/2024/04/05-Test-Users-Nothing-to-Add-740x472.png "Google OAuth Traefik Forward Auth [2024]: Most Convenient MFA 11")

![Oauth Consent Screen - Test Users](data:image/svg+xml,%3Csvg%20xmlns=%22http://www.w3.org/2000/svg%22%20viewBox=%220%200%20740%20472%22%3E%3C/svg%3E "Google OAuth Traefik Forward Auth [2024]: Most Convenient MFA 11")](https://www.smarthomebeginner.com/images/2024/04/05-Test-Users-Nothing-to-Add.png)

Oauth Consent Screen - Test Users

Finally for the OAuth Consent Screen, check the app registration details and hit **Back to Dashboard** at the end.

[

![Oauth Consent Screen - App Registration](https://www.smarthomebeginner.com/images/2024/04/06-App-Registration-Back-to-Dashboard-740x395.png "Google OAuth Traefik Forward Auth [2024]: Most Convenient MFA 12")

![Oauth Consent Screen - App Registration](data:image/svg+xml,%3Csvg%20xmlns=%22http://www.w3.org/2000/svg%22%20viewBox=%220%200%20740%20395%22%3E%3C/svg%3E "Google OAuth Traefik Forward Auth [2024]: Most Convenient MFA 12")](https://www.smarthomebeginner.com/images/2024/04/06-App-Registration-Back-to-Dashboard.png)

Oauth Consent Screen - App Registration

On the OAuth Consent Screen Dashboard, **Publish** the app and confirm Push to production.

[

![Oauth Consent Screen - Publish App To Production](https://www.smarthomebeginner.com/images/2024/04/07-Publish-App-and-Confirm-to-Production-740x351.png "Google OAuth Traefik Forward Auth [2024]: Most Convenient MFA 13")

![Oauth Consent Screen - Publish App To Production](data:image/svg+xml,%3Csvg%20xmlns=%22http://www.w3.org/2000/svg%22%20viewBox=%220%200%20740%20351%22%3E%3C/svg%3E "Google OAuth Traefik Forward Auth [2024]: Most Convenient MFA 13")](https://www.smarthomebeginner.com/images/2024/04/07-Publish-App-and-Confirm-to-Production.png)

Oauth Consent Screen - Publish App To Production

#### Step 2c: Create OAuth Credentials

Next, we need to create a **client ID** and **client secret** to authenticate with Google. Choose our **Traefik Forward Auth** project, and under the Navigation menu select **APIs & Services > Credentials**. Click on **Create Credentials > OAuth client ID**.

[

![Create Oauth Client Id](https://www.smarthomebeginner.com/images/2024/04/08-Create-OAuth-Client-ID-740x308.png "Google OAuth Traefik Forward Auth [2024]: Most Convenient MFA 14")

![Create Oauth Client Id](data:image/svg+xml,%3Csvg%20xmlns=%22http://www.w3.org/2000/svg%22%20viewBox=%220%200%20740%20308%22%3E%3C/svg%3E "Google OAuth Traefik Forward Auth [2024]: Most Convenient MFA 14")](https://www.smarthomebeginner.com/images/2024/04/08-Create-OAuth-Client-ID.png)

Create Oauth Client Id

#### Step 2d: Create the OAuth client ID

Now select the **Web Application** type and enter a name for your web application, such as **Traefik OAuth**.

[

![Oauth Client Id - Application Type (Web)](https://www.smarthomebeginner.com/images/2024/04/09-1-Application-Type-Web-740x340.png "Google OAuth Traefik Forward Auth [2024]: Most Convenient MFA 15")

![Oauth Client Id - Application Type (Web)](data:image/svg+xml,%3Csvg%20xmlns=%22http://www.w3.org/2000/svg%22%20viewBox=%220%200%20740%20340%22%3E%3C/svg%3E "Google OAuth Traefik Forward Auth [2024]: Most Convenient MFA 15")](https://www.smarthomebeginner.com/images/2024/04/09-1-Application-Type-Web.png)

Oauth Client Id - Application Type (Web)

In addition, you'll need to enter your Authorized redirect URI as **https://oauth.simplehomelab.com/\_oauth** (or multiple redirect URIs as shown below).

**Note:** You are only allowed to add **redirect URIs** that direct to your **Authorized Domains** (described above). Return to the OAuth consent screen if you need to edit them.

[

![Client Id Web Application Redirect Uris](https://www.smarthomebeginner.com/images/2024/04/09-2-Client-ID-Web-Application-740x786.png "Google OAuth Traefik Forward Auth [2024]: Most Convenient MFA 16")

![Client Id Web Application Redirect Uris](data:image/svg+xml,%3Csvg%20xmlns=%22http://www.w3.org/2000/svg%22%20viewBox=%220%200%20740%20786%22%3E%3C/svg%3E "Google OAuth Traefik Forward Auth [2024]: Most Convenient MFA 16")](https://www.smarthomebeginner.com/images/2024/04/09-2-Client-ID-Web-Application.png)

Client Id Web Application Redirect Uris

Make sure that you press **Enter** to add it, and then click **Save**.

The credentials for our Single Sign-on for Docker have been created! Copy and save the **client ID** and **client secret**; we'll need to use them in the next step.

[

![Google Oauth Client Credentials (Keep It Safe!!!)](https://www.smarthomebeginner.com/images/2024/04/10-OAuth-Client-Credentials-740x808.png "Google OAuth Traefik Forward Auth [2024]: Most Convenient MFA 17")

![Google Oauth Client Credentials (Keep It Safe!!!)](data:image/svg+xml,%3Csvg%20xmlns=%22http://www.w3.org/2000/svg%22%20viewBox=%220%200%20740%20808%22%3E%3C/svg%3E "Google OAuth Traefik Forward Auth [2024]: Most Convenient MFA 17")](https://www.smarthomebeginner.com/images/2024/04/10-OAuth-Client-Credentials.png)

Google Oauth Client Credentials (Keep It Safe!!!)

### Step 3: Setup Traefik Forward Authentication with OAuth2

Now that the OAuth credentials have been configured, the last thing to do is set up the OAuth container. Sign-in to your local machine, or use one of the several [awesome SSH clients](https://www.smarthomebeginner.com/best-ssh-clients-windows-putty-alternatives/) to sign in remotely.

> **Be the 1 in 200,000. Help us sustain what we do.**
>
> 56 / 150 by Dec 31, 2024
>
> [Join Us](https://www.smarthomebeginner.com/membership-account/memberships-products-services/) (starting from just $1.67/month)
>
> [Why did we start Memberships?](https://www.smarthomebeginner.com/state-of-the-site-2023/)

The assumption is that you have already read and followed most of my [Traefik 2 guide](https://www.smarthomebeginner.com/traefik-docker-compose-guide-2024/) and are reading this post just to implement Google OAuth.

Alternatively, you have a setup based on the [Auto-Traefik](https://www.smarthomebeginner.com/auto-traefik/) script, which automates many parts of setting up a homelab, including Traefik, Authelia, and more than 15 other apps.

#### Step 3a: Create Traefik Auth Middleware

Let us now specify a Traefik auth middleware for OAuth2. All authentication will be forwarded to this middleware. Create a file called **middlewares-oauth.yml** in your Traefik rules folder and add the following contents to it:

If you have followed my [Traefik guide](https://www.smarthomebeginner.com/traefik-docker-compose-guide-2024/), the rules folder will be **appdata/traefik2/rules/udms**, where **udms** is the hostname. In my GitHub repo, you will find files from 5 of my docker hosts, identified by hostnames: hs, mds, ws, ds918, and dns.

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

`middlewares-oauth:`

`forwardAuth:`

`address:` `"[http://oauth:4181](http://oauth:4181/)"` `# Make sure you have the OAuth service in docker-compose.yml`

`trustForwardHeader:` `true`

`authResponseHeaders:`

`-` `"X-Forwarded-User"`

Nothing to customize in the YML above.

#### Step 3b: Create Traefik OAuth Middleware Chain

Again, building on my Traefik guide, let's build the [middleware chain](https://www.smarthomebeginner.com/traefik-docker-compose-guide-2024/#Middleware_Chains) for OAuth.

We will reuse a few of the middlewares from the Traefik guide: middlewares-rate-limit and middlewares-secure-headers.

Create a file called **chain-oauth.yml** in your Traefik rules folder and add the following contents to it:

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

`chain-oauth:`

`chain:`

`middlewares:`

`-` `middlewares-rate-limit`

`-` `middlewares-secure-headers`

`-` `middlewares-oauth`

If you do not understand what this does, then I suggest reading my [Traefik guide](https://www.smarthomebeginner.com/traefik-docker-compose-guide-2024/#Middleware_Chains).

In short, we are rate limit and specifying security headers, which are both security measures. Then we are including OAuth2 authentication in the chain (the middleware we created in the previous step).

In [my GitHub Repo](https://github.com/htpcBeginner/docker-traefik/tree/master/appdata/traefik2/rules/) you may find more middlewares than what is described above. For OAuth2 purposes, the above middlewares are sufficient. As you follow more of my guides you may add additional middlewares.

Save the files and exit editing.

#### Step 3b: Add Traefik Forward Auth Secrets

With revision and as with my [Ultimate Docker Guide 2024](https://www.smarthomebeginner.com/docker-media-server-2024/), I am taking secure approach from the beginning. So, let's pass sensitive information as Docker Secrets.

But, instead of creating multiple secrets, we are going to create one single secret file for _Traefik forward auth_ that contains all the credentials.

##### Create Secrets Folder

If you haven't already done so, create a folder called **secrets** in a known location. If you have been following my guides, this would be **/home/anand/docker/secrets**. The folder must be owned by **root:root** and have **600** permission as shown below.

[

![Docker Secrets Folder Permissions](https://www.smarthomebeginner.com/images/2020/08/docker-secrets-folder-permissions.png "Google OAuth Traefik Forward Auth [2024]: Most Convenient MFA 18")

![Docker Secrets Folder Permissions](data:image/svg+xml,%3Csvg%20xmlns=%22http://www.w3.org/2000/svg%22%20viewBox=%220%200%20491%2020%22%3E%3C/svg%3E "Google OAuth Traefik Forward Auth [2024]: Most Convenient MFA 18")](https://www.smarthomebeginner.com/images/2020/08/docker-secrets-folder-permissions.png)

Docker Secrets Folder Permissions

Note that you will have to gain root privileges to navigate or see contents of the secrets folder.

##### Create Forward auth Secrets

Create a file called **oauth_secrets** inside the **secrets** folder and add the following content to it:

1

2

3

4

5

` providers.google.client-``id``=yourGOOGLEclientID `

`providers.google.client-secret=yourCLIENTsecret`

`secret=yourOAUTHsecret`

`whitelist=yourEMAILaddress1`

`whitelist=yourEMAILaddress2`

Customize the above using the information below:

- **yourGOOGLEclientID** and **yourCLIENTsecret**: Obtained previously in this Traefik Oauth2 guide.
- **yourOAUTHsecret**: This is used to sign the cookie and should be random. Generate a random secret with:

  1

  `openssl rand -hex 16`

  Alternatively, you may use an [online service like this one](https://www.browserling.com/tools/random-string), to generate your random secret.

  [

  ![08 Random Oauth Secret | Smarthomebeginner](https://www.smarthomebeginner.com/images/2019/10/08-random-oauth-secret.png "Google OAuth Traefik Forward Auth [2024]: Most Convenient MFA 19")

  ![08 Random Oauth Secret | Smarthomebeginner](data:image/svg+xml,%3Csvg%20xmlns=%22http://www.w3.org/2000/svg%22%20viewBox=%220%200%20487%20278%22%3E%3C/svg%3E "Google OAuth Traefik Forward Auth [2024]: Most Convenient MFA 19")](https://www.smarthomebeginner.com/images/2019/10/08-random-oauth-secret.png)

  Random Oauth Secret

- **yourEMAILaddress1**: Google email ID which will be used to authenticate. Optionally, you may add additional email addresses that are allowed to authenticate (e.g. **yourEMAILaddress2**; remove this line if you only want to allow one email ID).

Save and exit.

##### Secret Permissions

Next, let's ensure proper permissions for those using the following command:

1

2

`sudo` `chown` `root:root` `/home/anand/docker/secrets/oauth_secrets`

`sudo` `chmod` `600` `/home/anand/docker/secrets/oauth_secrets`

Next, let us setup the OAuth Forwarder container.

##### Add OAuth Secrets to Master Docker Compose

Open your master docker compose file for editing. If you have been following the Ultimate docker server series, this might be **docker-compose-udms.yml** (or whatever you named it to be).

Under secrets section, ensure you define the three secrets we created above:

1

2

3

4

5

6

`########################### SECRETS`

`secrets:`

`...`

`oauth_secrets:`

`file:` `$DOCKERDIR/secrets/oauth_secrets`

`...`

Note that the **...** refer to previous lines that may already exist after having followed the previous parts of this Ultimate Docker Server series.

Note that, **$DOCKERDIR** is the environment variable defined in **.env** file to represent **/home/anand/docker**.

If you have any questions on where exactly this is added, check out the compose files in [my GitHub Repo](https://github.com/htpcbeginner/docker-traefik).

We have now completed [2 of the 4 steps in adding secrets](https://www.smarthomebeginner.com/docker-media-server-2024/#creating-docker-secrets). We will perform the remaining 2 steps when we create the **OAuth Docker Compose** file.

### Step 4. OAuth Docker Compose

Now that all the configuration part is done. Let us add the Traefik Forward Auth docker compose service.

Just a reminder that Traefik should be up and running at this point.

##### Create OAuth Docker Compose File

Let's create the OAuth Docker compose file. Head over to the [compose folder](https://github.com/htpcBeginner/docker-traefik/tree/master/compose) in my Github Repository, and then into any of the host folders. Find the compose file for OAuth and copy the contents.

Create a file called **oauth.yml** inside **/home/anand/docker/compose/udms**. Copy-paste the contents into **oauth.yml** compose file (pay attention to blank spaces at the beginning of each line).

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

`# Google OAuth - Single Sign On using OAuth 2.0`

`# [https://www.smarthomebeginner.com/google-oauth-with-traefik-docker/](https://www.smarthomebeginner.com/google-oauth-with-traefik-docker/)`

`oauth:`

`container_name:` `oauth`

`image:` ` thomseddon/traefik-forward-auth``:``latest `

`# image: thomseddon/traefik-forward-auth:2.1-arm # Use this image with Raspberry Pi`

`security_opt:`

`-` ` no-new-privileges``:``true `

`restart:` `unless-stopped`

`# profiles: ["core", "all"]`

`networks:`

`-` `t2_proxy`

`environment:`

`-` `CONFIG=/config`

`-` `COOKIE_DOMAIN=$DOMAINNAME_HS`

`-` ` INSECURE_COOKIE=``false `

`-` `AUTH_HOST=oauth.$DOMAINNAME_HS`

`-` `URL_PATH=/_oauth`

`-` `LOG_LEVEL=warn` `# set to trace while testing bypass rules`

`-` `LOG_FORMAT=text`

`-` `LIFETIME=86400` `# 1 day`

`-` `DEFAULT_ACTION=auth`

`-` `DEFAULT_PROVIDER=google`

`secrets:`

`-` ` source``: ` `oauth_secrets`

`target:` `/config`

`labels:`

`-` `"traefik.enable=true"`

`# HTTP Routers`

`-` `"traefik.http.routers.oauth-rtr.tls=true"`

`-` `"traefik.http.routers.oauth-rtr.entrypoints=websecure"`

`-` `` "traefik.http.routers.oauth-rtr.rule=Host(`oauth.$DOMAINNAME_HS`)" ``

`# Middlewares`

`-` `"traefik.http.routers.oauth-rtr.middlewares=chain-oauth@file"`

`# HTTP Services`

`-` `"traefik.http.routers.oauth-rtr.service=oauth-svc"`

`-` `"traefik.http.services.oauth-svc.loadbalancer.server.port=4181"`

Here are some notes about the Traefik OAuth Docker Compose:

- We are using the **thomseddon/traefik-forward-auth:latest**. Use the correct image for your system's architecture. For example, Raspberry Pi has a different image tag.

  **Note:** This image has not been updated in about 3 years, at the time of writing this guide. It still works. But other developers have forked this image and incorporated some improvements via pull requests. One recently updated image tag appears to be this one: **ghcr.io/jordemort/traefik-forward-auth**. Feel free to try this one in place of **thomseddon/traefik-forward-auth**

  .

- Docker profiles is commented out as explained previously (see my [Docker guide](https://www.smarthomebeginner.com/docker-media-server-2024/#docker-profiles-use-case) for how I use profiles).
- **networks:** We added OAuth to **t2_proxy** network.
- You may also change the duration (**LIFETIME**) for which the authentication is valid from 1 day specified in seconds to another duration.
- Initially, set the **LOG_LEVEL** to **trace** or **debug**. Once everything works, you may change it to **warn**.
- Optionally, the rest of the environment variables defined for the **oauth** can be configured to your liking (if you know what you are doing).
- With the labels, we are specifying that OAuth will use the **websecure** entrypoint and **chain-oauth** file provider we created previously.
- Traefik forward auth listens on port 4181. So, we point **oauth-rtr.service** to a service name **oauth-svc** and in the next line, we define where that service is listening at (**oauth-svc.loadbalancer.server.port=4181**.

##### Add OAuth to the Docker Stack

We created the **oauth.yml** file. Now we need to add it to our master **docker-compose-udms.yml** file. To do so, add the path to the **oauth.yml** (compose/udms/oauth.yml) file under the include block, as shown below:

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

`-` `compose/$HOSTNAME/oauth.yml`

`...`

Note that the **...** refer to previous lines that may already exist after having followed the previous parts of this Ultimate Docker Server series.

**$HOSTNAME** here will be replaced with **udms** automatically (as defined in the **.env** file).

Save the Master Docker Compose file.

### Step 5: Starting OAuth Container

Recreate the stack and follow OAuth container logs using the following commands:

1

2

`sudo` `docker compose -f` ` /home/anand/docker/docker-compose-udms``.yml up -d `

`sudo` `docker compose -f` ` /home/anand/docker/docker-compose-udms``.yml logs -tf --``tail``=``"50" ` `oauth`

You should see confirmation that OAuth Docker container started successfully. \[**Read:** [Dozzle Docker Compose: Simple Docker Logs Viewer](https://www.smarthomebeginner.com/dozzle-docker-compose-guide/)\]

Now that OAuth Docker container is up and running. Let us test it out by visiting **https://oauth.simplehomelab.com**. You should now be redirected to Google's login and authentication page before reaching the service.

[

![Google Oauth Login For Docker Services](https://www.smarthomebeginner.com/images/2020/04/google-oauth-login-500x600.png "Google OAuth Traefik Forward Auth [2024]: Most Convenient MFA 20")

![Google Oauth Login For Docker Services](data:image/svg+xml,%3Csvg%20xmlns=%22http://www.w3.org/2000/svg%22%20viewBox=%220%200%20500%20600%22%3E%3C/svg%3E "Google OAuth Traefik Forward Auth [2024]: Most Convenient MFA 20")](https://www.smarthomebeginner.com/images/2020/04/google-oauth-login.png)

Google Oauth Login For Docker Services

This is confirmation that everything works they should!

## Authentication and Conditional Bypassing

Now that we have Google OAuth working with Traefik Forward Auth, let's look at ways to protect apps and also some ways to conditionally bypass authentication.

### Putting Docker Services behind OAuth

If you created the OAuth Traefik middleware and middleware chain discussed above, then putting docker services behind Google OAuth 2 authentication is simple. All you need to do is add the following middleware (**chain-oauth**) to docker-compose labels:

1

2

`## Middlewares`

`- "traefik.http.routers.service-rtr.middlewares=chain-oauth@file"`

**service-rtr** could be different for different services. As always, check the docker-compose files in [GitHub repo](https://github.com/htpcBeginner/docker-traefik) for working examples.

### Putting Non-Docker Services behind OAuth

Adding non-docker apps or apps from docker host or external hosts is also quite simple using file providers, as previously explained in my [Traefik guide](https://www.smarthomebeginner.com/traefik-docker-compose-guide-2024/#Adding_non-Docker_or_External_Apps_Behind_Traefik).

Auto Traefik 2 (Part 9) - Putting External Applications Behind Traefik

[![Auto Traefik 2 (Part 9) - Putting External Applications Behind Traefik](https://www.smarthomebeginner.com/wp-content/plugins/wp-youtube-lyte/lyteCache.php?origThumbUrl=https%3A%2F%2Fi.ytimg.com%2Fvi%2FkGaX1pnP_y4%2F0.jpg "Google OAuth Traefik Forward Auth [2024]: Most Convenient MFA 21")](https://youtu.be/kGaX1pnP_y4)

[Watch this video on YouTube](https://youtu.be/kGaX1pnP_y4).

Let's take the same example of [Adguard Home running on Raspberry Pi](https://www.smarthomebeginner.com/adguard-home-raspberry-pi-2023/), as in my [Traefik guide](https://www.smarthomebeginner.com/traefik-docker-compose-guide-2024/#Adding_non-Docker_or_External_Apps_Behind_Traefik).

Previously, we had [AdGuard](https://www.smarthomebeginner.com/go/adguard "AdGuard") Home with no Traefik authentication (**chain-no-auth**). Putting it behind OAuth is as simple as changing the middleware from **chain-no-auth** to **chain-oauth**, as shown below:

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

`-` `chain-oauth`

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

Since the rules directory is dynamic, simply by adding this file to that directory we have created the route. You should be able to connect to AdGuard Home behind OAuth, without restarting Traefik!

### Bypassing OAuth / Selective Authentication

I use the NZB360 app on Android and LunaSea on iOS for remotely managing SABnzbd, Sonarr, Radarr, etc. When these apps are behind OAuth, I could not use these apps remotely using a fully qualified domain name (e.g. https://sonarr.simplehomelab.com). These apps have no way to authenticate themselves and pass through OAuth.

But, you can bypass authentication based on specific keys in the request Headers, regular expressions, host, path, query, and more.

**Note:** By using an incorrectly specified rule, you can easily disable authentication when you do not intend to. Therefore, I strongly recommend specific and narrow rules for bypassing authentication.

##### Identifying Bypass Rule

How can we figure out what specific rules to use?

This can be quite tricky. As discussed in the link below, a generic way to bypass authentication would be using the path. For example, NZB360 app requests have **/api** in the path. You may disable authentication for all those requests.

**Resource:**: Check this [GitHub thread](https://github.com/htpcBeginner/docker-traefik/issues/27) for additional information selective authentication.

But this can loosen the security and I recommend setting specific rules. For example, if the request header contains the SABnzbd API key then bypass authentication.

Then the next question, how did I know to look for SABnzbd API key? This requires some trial and error.

First, ensure SABNzbd is behind OAuth. Then set the OAuth container's log level to **trace** in the environmental variable:

1

`LOG_LEVEL: trace`

Then check the docker logs for the OAuth container ([Basic Docker Commands](https://www.smarthomebeginner.com/traefik-2-docker-tutorial/#Basic_Docker_Commands_to_Know)). This will spit out pretty much everything going on in that container, which can be overwhelming. You can trim this down to your app of interest by piping in the **grep sabnzbd** command.

1

`sudo` ` docker-compose -f ~``/docker/docker-compose-t2``.yml logs sabnzbd logs -tf --``tail``=``"50" `

Now when I try to open SABnzbd through the app of interest, in my case NZB360, it creates an OAuth log entry like the one below.

[

![Oauth Log Entry For Sabnzbd Access Via Nzb360 App](https://www.smarthomebeginner.com/images/2020/06/sabnzbd-oauth-api-key-740x186.png "Google OAuth Traefik Forward Auth [2024]: Most Convenient MFA 22")

![Oauth Log Entry For Sabnzbd Access Via Nzb360 App](data:image/svg+xml,%3Csvg%20xmlns=%22http://www.w3.org/2000/svg%22%20viewBox=%220%200%20740%20186%22%3E%3C/svg%3E "Google OAuth Traefik Forward Auth [2024]: Most Convenient MFA 22")](https://www.smarthomebeginner.com/images/2020/06/sabnzbd-oauth-api-key.png)

Oauth Log Entry For Sabnzbd Access Via Nzb360 App

##### Specifying OAuth Bypass Rule

Notice the **uri** in the above log screenshot contains the SABnzbd API key. So you can set the bypass use based on this, as follows:

This guide has been updated to the new Traefik v3 syntax. To understand more about how has changed from Traefik v2, check my [Traefik v3 guide](https://www.smarthomebeginner.com/traefik-v3-docker-compose-guide-2024/#Migrating_from_Traefik_v2_to_v3).

1

`command:` ` --rule.sabnzbd.action=allow --rule.sabnzbd.rule=```"HeaderRegexp( `X-Forwarded-Uri`, `$SABNZBD_API_KEY`)"``

[

![Oauth Log For Radarr Access Via Nzb360 App](https://www.smarthomebeginner.com/images/2020/06/radarr_from_nzb360_oauth_log-740x35.png "Google OAuth Traefik Forward Auth [2024]: Most Convenient MFA 23")

![Oauth Log For Radarr Access Via Nzb360 App](data:image/svg+xml,%3Csvg%20xmlns=%22http://www.w3.org/2000/svg%22%20viewBox=%220%200%20740%2035%22%3E%3C/svg%3E "Google OAuth Traefik Forward Auth [2024]: Most Convenient MFA 23")](https://www.smarthomebeginner.com/images/2020/06/radarr_from_nzb360_oauth_log.png)

Oauth Log For Radarr Access Via Nzb360 App

For Radarr, Sonarr, Lidarr, etc, you may use the following rule (should work for NZB360 or similar apps):

This guide has been updated to the new Traefik v3 syntax. To understand more about how has changed from Traefik v2, check my [Traefik v3 guide](https://www.smarthomebeginner.com/traefik-v3-docker-compose-guide-2024/#Migrating_from_Traefik_v2_to_v3).

1

`command:` ` --rule.radarr.action=allow --rule.radarr.rule=```"Header( `X-Api-Key`, `$RADARR_API_KEY`)"``

For the full docker-compose, check my [GitHub Repo](https://github.com/htpcBeginner/docker-traefik). All the above codes assume that you followed my previous Traefik guide and that the API keys are defined correctly in your **.env** file. Otherwise, the above rules won't work.

Restart the OAuth container and try to access SABnzbd now via the app and browser. The browser should present the OAuth login and the App should take you to the service directly.

There are several more ways to specify rules. Check out [OAuth Forwarders to GitHub page](https://github.com/thomseddon/traefik-forward-auth) for all available options.

### Alternative Bypass Methods

This is my preferred method for bypassing.

Although OAuth Forwarder allows bypassing, I do not use the above method (hence why all the OAuth bypass rules are commented out in the compose files in my GitHub repo). I leverage custom headers to let Traefik handle the bypassing instead of the authentication service.

Traefik has built-in mechanisms for conditional bypassing. Depending on certain conditions, I can specify a different middleware or a middleware chain. This is explained in detail in my separate guide on [Traefik Auth bypass](https://www.smarthomebeginner.com/traefik-auth-bypass/).

Several apps in my [GitHub repo](https://github.com/htpcBeginner/docker-traefik) have auth bypasses set based on certain conditions.

## OAuth and Security Headers

One thing to note about using the Traefik OAuth2 service is your security headers. If the service is behind OAuth and you’re trying to [check whether your security headers](https://securityheaders.com/) are applied, you will probably receive a lower rating.

##### Restricted Content

Additional explanations and bonus content are available exclusively for the following members only:

Silver - Monthly, Silver - Yearly, Gold - Monthly, Gold - Yearly, Diamond - Monthly, Diamond - Yearly, and Platinum Lifetime (All-Inclusive)

Please support us by becoming a member to unlock the content.  
[Join Now](https://www.smarthomebeginner.com/membership-account/memberships-products-services/)

## FAQs

### What is traefik-forward-auth-provider?

Traefik forward auth is as service that integrates with a third-party authentication provider (e.g. Google, Microsoft, Authelia, etc.) to secure your services and web applications.

### Is traefik-forward-auth-provider popular?

Yes, Traefik forward auth provider is popular among Traefik and Docker enthusiasts. It makes securing applications with strong authentication system, very easy.

### What is the difference between OIDC and OAuth?

OIDC or OpenID Connect (OIDC) is a protocol for authentication. It is a set of specifications based on OAuth 2.0, which adds extra features. In essence, OIDC is the authentical protocol while OAuth is the set of specifications for resource access and sharing.

### Are there other (more private) alternatives to Google OAuth?

Yes. [Authelia](https://github.com/authelia/authelia) and [Keycloak](https://github.com/keycloak/keycloak) are two I can think of. IMHO, Authelia was much simpler to setup, cmopared to Keycloak. There is also [Authentik](https://goauthentik.io/).

### How do I sign out of my services that use Google OAuth2?

If you need to logout, sign out from your google services in any other tab/window and your OAuth for services will be invalidated.

## Final Thoughts Traefik Forward Authentication

Implementing Google OAuth2 with Traefik forward authentication has been one of the easiest and most secure ways for me to protect my docker services. By whitelisting accounts and implementing Google’s 2FA, I have confidence that I will be the only one that's able to access those services.

In addition, I now have an authentication service that allows me to access many of my services with just one login.

As said previously, if you prefer a self-hosted alternative that is more private then [Authelia](https://www.smarthomebeginner.com/authelia-docker-compose-guide-2024/) is a great option. In fact, in a multi-user environment, it might be easier and more secure to use Authelia. Unlike **Traefik Forward Auth with Google OAuth2**, Authelia is email-agnostic (not everyone has a Google account).

I hope you enjoyed learning about Google OAuth with Traefik for Docker services! If you have any questions feel free to leave a comment below.

[Facebook](https://www.smarthomebeginner.com/#facebook "Facebook")[Twitter](https://www.smarthomebeginner.com/#twitter "Twitter")[Reddit](https://www.smarthomebeginner.com/#reddit "Reddit")[LinkedIn](https://www.smarthomebeginner.com/#linkedin "LinkedIn")[Share](https://www.addtoany.com/share#url=https%3A%2F%2Fwww.smarthomebeginner.com%2Fgoogle-oauth-traefik-forward-auth-2024%2F&title=Google%20OAuth%20Traefik%20Forward%20Auth%20%5B2024%5D%3A%20Most%20Convenient%20MFA)

### Related Posts:

- [

  ![Traefik Dashboard](https://www.smarthomebeginner.com/images/2023/10/traefik-dashboard.jpg "Traefik Auth Bypass: Conditionally Bypassing Forward Authentication")

  ![Traefik Dashboard](data:image/svg+xml,%3Csvg%20xmlns=%22http://www.w3.org/2000/svg%22%20viewBox=%220%200%202184%201247%22%3E%3C/svg%3E "Traefik Auth Bypass: Conditionally Bypassing Forward Authentication")

  Traefik Auth Bypass: Conditionally Bypassing Forward…](https://www.smarthomebeginner.com/traefik-auth-bypass/)

- [

  ![OAuth Featured Image_final](https://www.smarthomebeginner.com/images/2019/10/OAuth-Featured-Image_final.jpg "Traefik Forward Auth Guide - Simple, Secure Google SSO [2022]")

  ![OAuth Featured Image_final](data:image/svg+xml,%3Csvg%20xmlns=%22http://www.w3.org/2000/svg%22%20viewBox=%220%200%20800%20450%22%3E%3C/svg%3E "Traefik Forward Auth Guide - Simple, Secure Google SSO [2022]")

  Traefik Forward Auth Guide - Simple, Secure Google…](https://www.smarthomebeginner.com/traefik-forward-auth-google-oauth-2022/)

- [

  ![Proxmox Web Interface Traefik](https://www.smarthomebeginner.com/images/2023/12/proxmox-web-interface-traefik.jpg "How to put Proxmox Web Interface Behind Traefik?")

  ![Proxmox Web Interface Traefik](data:image/svg+xml,%3Csvg%20xmlns=%22http://www.w3.org/2000/svg%22%20viewBox=%220%200%201373%20752%22%3E%3C/svg%3E "How to put Proxmox Web Interface Behind Traefik?")

  How to put Proxmox Web Interface Behind Traefik?](https://www.smarthomebeginner.com/proxmox-web-interface-behind-traefik/)

- [

  ![Traefik Multiple Hosts on Single Gateway Router](https://www.smarthomebeginner.com/images/2023/07/Traefik-Multiple-Hosts-but-Single-Gateway-Router.png "Multiple Traefik Instances on Different Domains/Hosts and One External IP")

  ![Traefik Multiple Hosts on Single Gateway Router](data:image/svg+xml,%3Csvg%20xmlns=%22http://www.w3.org/2000/svg%22%20viewBox=%220%200%201280%20720%22%3E%3C/svg%3E "Multiple Traefik Instances on Different Domains/Hosts and One External IP")

  Multiple Traefik Instances on Different…](https://www.smarthomebeginner.com/multiple-traefik-instances/)

- [

  ![CrowdSec Traefik Bouncer](https://www.smarthomebeginner.com/images/2022/11/crowdsec-traefik-bouncer.jpg "CrowdSec Docker Part 3: Traefik Bouncer for Additional Security")

  ![CrowdSec Traefik Bouncer](data:image/svg+xml,%3Csvg%20xmlns=%22http://www.w3.org/2000/svg%22%20viewBox=%220%200%20862%20513%22%3E%3C/svg%3E "CrowdSec Docker Part 3: Traefik Bouncer for Additional Security")

  CrowdSec Docker Part 3: Traefik Bouncer for…](https://www.smarthomebeginner.com/crowdsec-traefik-bouncer/)

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

Categories [Home Server](https://www.smarthomebeginner.com/home-server/) Tags [authentication](https://www.smarthomebeginner.com/tag/authentication/), [docker](https://www.smarthomebeginner.com/tag/docker/), [reverse proxy](https://www.smarthomebeginner.com/tag/reverse-proxy/), [traefik](https://www.smarthomebeginner.com/tag/traefik/)

[Vaultwarden Docker Compose + Detailed Configuration Guide](https://www.smarthomebeginner.com/vaultwarden-docker-compose-guide/)

[5 Best Mini PC for Proxmox Home Server \[2024\]](https://www.smarthomebeginner.com/best-mini-pc-for-proxmox-2024/)

![](https://secure.gravatar.com/avatar/5038190c1ce8da93329cc44d5b592149?s=100&d=monsterid&r=pg)

![](data:image/svg+xml,%3Csvg%20xmlns=%22http://www.w3.org/2000/svg%22%20viewBox=%220%200%20100%20100%22%3E%3C/svg%3E)

### Anand

Anand is a self-learned computer enthusiast, hopeless tinkerer (if it ain't broke, fix it), a part-time blogger, and a Scientist during the day. He has been blogging since 2010 on Linux, Ubuntu, Home/Media/File Servers, Smart Home Automation, and related HOW-TOs.

Load Comments

[Facebook](https://www.smarthomebeginner.com/#facebook)[Twitter](https://www.smarthomebeginner.com/#twitter)[Reddit](https://www.smarthomebeginner.com/#reddit)[LinkedIn](https://www.smarthomebeginner.com/#linkedin)[Share](https://www.addtoany.com/share#url=https%3A%2F%2Fwww.smarthomebeginner.com%2Fgoogle-oauth-traefik-forward-auth-2024%2F&title=Google%20OAuth%20Traefik%20Forward%20Auth%20%5B2024%5D%3A%20Most%20Convenient%20MFA%20%7C%20SHB)

[Arabic](#) [Chinese (Simplified)](#) [Dutch](#) [English](#) [French](#) [German](#) [Italian](#) [Portuguese](#) [Russian](#) [Spanish](#)

![en](Google%20OAuth%20Traefik%20Forward%20Auth%20[2024]%20Most%20Convenient%20MFA_files/en-us.svg) en

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

![SmartHomeBeginner Discord Community](Google%20OAuth%20Traefik%20Forward%20Auth%20[2024]%20Most%20Convenient%20MFA_files/join-discord-300x75.webp "SmartHomeBeginner Discord Community")](https://www.smarthomebeginner.com/discord/)

## Recent Posts

- [

  ![Bash Aliases For Docker](https://www.smarthomebeginner.com/images/2024/05/bash-aliases-for-Docker-150x84.webp "Simplify Docker, Docker Compose, and Linux Commands with Bash Aliases 24")

  ![Bash Aliases For Docker](Google%20OAuth%20Traefik%20Forward%20Auth%20[2024]%20Most%20Convenient%20MFA_files/bash-aliases-for-Docker-150x84.webp "Simplify Docker, Docker Compose, and Linux Commands with Bash Aliases 24")](https://www.smarthomebeginner.com/bash-aliases-for-docker-and-linux/)

  [Simplify Docker, Docker Compose, and Linux Commands with Bash Aliases](https://www.smarthomebeginner.com/bash-aliases-for-docker-and-linux/)

- [

  ![Traefik V3 Docker Compose](https://www.smarthomebeginner.com/images/2024/05/Docker-Series-05-Traefik-v3-150x84.png "Ultimate Traefik v3 Docker Compose Guide [2024]: LE, SSL, Reverse Proxy 25")

  ![Traefik V3 Docker Compose](Google%20OAuth%20Traefik%20Forward%20Auth%20[2024]%20Most%20Convenient%20MFA_files/Docker-Series-05-Traefik-v3-150x84.webp "Ultimate Traefik v3 Docker Compose Guide [2024]: LE, SSL, Reverse Proxy 25")](https://www.smarthomebeginner.com/traefik-v3-docker-compose-guide-2024/)

  [Ultimate Traefik v3 Docker Compose Guide \[2024\]: LE, SSL, Reverse Proxy](https://www.smarthomebeginner.com/traefik-v3-docker-compose-guide-2024/)

- [

  ![Best Mini Pc For Proxmox](https://www.smarthomebeginner.com/images/2024/04/Best-Mini-PC-for-Proxmox-150x84.png "5 Best Mini PC for Proxmox Home Server [2024] 26")

  ![Best Mini Pc For Proxmox](Google%20OAuth%20Traefik%20Forward%20Auth%20[2024]%20Most%20Convenient%20MFA_files/Best-Mini-PC-for-Proxmox-150x84.webp "5 Best Mini PC for Proxmox Home Server [2024] 26")](https://www.smarthomebeginner.com/best-mini-pc-for-proxmox-2024/)

  [5 Best Mini PC for Proxmox Home Server \[2024\]](https://www.smarthomebeginner.com/best-mini-pc-for-proxmox-2024/)

- [

  ![Google Oauth](https://www.smarthomebeginner.com/images/2024/04/Docker-Series-07-Google-OAuth-150x84.png "Google OAuth Traefik Forward Auth [2024]: Most Convenient MFA 27")

  ![Google Oauth](Google%20OAuth%20Traefik%20Forward%20Auth%20[2024]%20Most%20Convenient%20MFA_files/Docker-Series-07-Google-OAuth-150x84.webp "Google OAuth Traefik Forward Auth [2024]: Most Convenient MFA 27")](https://www.smarthomebeginner.com/google-oauth-traefik-forward-auth-2024/)

  [Google OAuth Traefik Forward Auth \[2024\]: Most Convenient MFA](https://www.smarthomebeginner.com/google-oauth-traefik-forward-auth-2024/)

- [

  ![Vaultwarden Docker Compose](https://www.smarthomebeginner.com/images/2023/12/vaultwarden-install-header-1-150x84.webp "Vaultwarden Docker Compose + Detailed Configuration Guide 28")

  ![Vaultwarden Docker Compose](data:image/svg+xml,%3Csvg%20xmlns=%22http://www.w3.org/2000/svg%22%20viewBox=%220%200%20150%2084%22%3E%3C/svg%3E "Vaultwarden Docker Compose + Detailed Configuration Guide 28")](https://www.smarthomebeginner.com/vaultwarden-docker-compose-guide/)

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

window.lazySizesConfig=window.lazySizesConfig||{};window.lazySizesConfig.loadMode=1;var bU="https://www.smarthomebeginner.com/wp-content/plugins/wp-youtube-lyte/lyte/";var mOs=null;style = document.createElement("style");style.type = "text/css";rules = document.createTextNode(".lyte-wrapper-audio div, .lyte-wrapper div {margin:0px; overflow:hidden;} .lyte,.lyMe{position:relative;padding-bottom:56.25%;height:0;overflow:hidden;background-color:#777;} .fourthree .lyMe, .fourthree .lyte {padding-bottom:75%;} .lidget{margin-bottom:5px;} .lidget .lyte, .widget .lyMe {padding-bottom:0!important;height:100%!important;} .lyte-wrapper-audio .lyte{height:38px!important;overflow:hidden;padding:0!important} .lyMe iframe, .lyte iframe,.lyte .pL{position:absolute !important;top:0;left:0;width:100%;height:100%!important;background:no-repeat scroll center #000;background-size:cover;cursor:pointer} .tC{left:0;position:absolute;top:0;width:100%} .tC{background-image:linear-gradient(to bottom,rgba(0,0,0,0.6),rgba(0,0,0,0))} .tT{color:#FFF;font-family:Roboto,sans-serif;font-size:16px;height:auto;text-align:left;padding:5px 10px 50px 10px} .play{background:no-repeat scroll 0 0 transparent;width:88px;height:63px;position:absolute;left:43%;left:calc(50% - 44px);left:-webkit-calc(50% - 44px);top:38%;top:calc(50% - 31px);top:-webkit-calc(50% - 31px);} .widget .play {top:30%;top:calc(45% - 31px);top:-webkit-calc(45% - 31px);transform:scale(0.6);-webkit-transform:scale(0.6);-ms-transform:scale(0.6);} .lyte:hover .play{background-position:0 -65px;} .lyte-audio .pL{max-height:38px!important} .lyte-audio iframe{height:438px!important} .lyte .ctrl{background:repeat scroll 0 -220px rgba(0,0,0,0.3);width:100%;height:40px;bottom:0px;left:0;position:absolute;} .lyte-wrapper .ctrl{display:none}.Lctrl{background:no-repeat scroll 0 -137px transparent;width:158px;height:40px;bottom:0;left:0;position:absolute} .Rctrl{background:no-repeat scroll -42px -179px transparent;width:117px;height:40px;bottom:0;right:0;position:absolute;padding-right:10px;}.lyte-audio .play{display:none}.lyte-audio .ctrl{background-color:rgba(0,0,0,1)}.lyte .hidden{display:none}");if(style.styleSheet) { style.styleSheet.cssText = rules.nodeValue;} else {style.appendChild(rules);}document.getElementsByTagName("head")\[0\].appendChild(style); (function(){ var corecss = document.createElement('link'); var themecss = document.createElement('link'); var corecssurl = "https://www.smarthomebeginner.com/wp-content/plugins/syntaxhighlighter/syntaxhighlighter3/styles/shCore.css?ver=3.0.9b"; if ( corecss.setAttribute ) { corecss.setAttribute( "rel", "stylesheet" ); corecss.setAttribute( "type", "text/css" ); corecss.setAttribute( "href", corecssurl ); } else { corecss.rel = "stylesheet"; corecss.href = corecssurl; } document.head.appendChild( corecss ); var themecssurl = "https://www.smarthomebeginner.com/wp-content/plugins/syntaxhighlighter/syntaxhighlighter3/styles/shThemeDefault.css?ver=3.0.9b"; if ( themecss.setAttribute ) { themecss.setAttribute( "rel", "stylesheet" ); themecss.setAttribute( "type", "text/css" ); themecss.setAttribute( "href", themecssurl ); } else { themecss.rel = "stylesheet"; themecss.href = themecssurl; } document.head.appendChild( themecss ); })(); SyntaxHighlighter.config.strings.expandSource = '+ expand source'; SyntaxHighlighter.config.strings.help = '?'; SyntaxHighlighter.config.strings.alert = 'SyntaxHighlighter\\n\\n'; SyntaxHighlighter.config.strings.noBrush = 'Can\\'t find brush for: '; SyntaxHighlighter.config.strings.brushNotHtmlScript = 'Brush wasn\\'t configured for html-script option: '; SyntaxHighlighter.defaults\['pad-line-numbers'\] = false; SyntaxHighlighter.defaults\['toolbar'\] = false; SyntaxHighlighter.all(); // Infinite scroll support if ( typeof( jQuery ) !== 'undefined' ) { jQuery( function( $ ) { $( document.body ).on( 'post-load', function() { SyntaxHighlighter.highlight(); } ); } ); } div#toc\_container {width: 100%;}div#toc\_container ul li {font-size: 90%;} var fpframework\_countdown\_widget = {"AND":"and"}; var countVars = {"disqusShortname":"htpcbeginner"}; var embedVars = {"disqusConfig":{"integration":"wordpress 3.0.23"},"disqusIdentifier":"50868 https:\\/\\/www.smarthomebeginner.com\\/?p=50868","disqusShortname":"htpcbeginner","disqusTitle":"Google OAuth Traefik Forward Auth \[2024\]: Most Convenient MFA","disqusUrl":"https:\\/\\/www.smarthomebeginner.com\\/google-oauth-traefik-forward-auth-2024\\/","postId":"50868"}; var dclCustomVars = {"dcl\_progress\_text":"Loading..."}; var pollsL10n = {"ajax\_url":"https:\\/\\/www.smarthomebeginner.com\\/wp-admin\\/admin-ajax.php","text\_wait":"Your last request is still being processed. Please wait a while ...","text\_valid":"Please choose a valid poll answer.","text\_multiple":"Maximum number of choices allowed: ","show\_loading":"1","show\_fading":"1"}; var generatepressMenu = {"toggleOpenedSubMenus":"1","openSubMenuLabel":"Open Sub-Menu","closeSubMenuLabel":"Close Sub-Menu"}; var generatepressNavSearch = {"open":"Open Search Bar","close":"Close Search Bar"}; var BestAzon\_Configuration = {"Conf\_Subsc\_Model":"2","Amzn\_AfiliateID\_US":"shbeg-20","Amzn\_AfiliateID\_CA":"shbeg09-20","Amzn\_AfiliateID\_GB":"htpcbeg-21","Amzn\_AfiliateID\_DE":"htpcbeg08-21","Amzn\_AfiliateID\_FR":"htpcbeg02-21","Amzn\_AfiliateID\_ES":"htpcbeg0a-21","Amzn\_AfiliateID\_IT":"linuxp03-21","Amzn\_AfiliateID\_JP":"","Amzn\_AfiliateID\_IN":"htpcbeg0f-21","Amzn\_AfiliateID\_CN":"","Amzn\_AfiliateID\_MX":"","Amzn\_AfiliateID\_BR":"","Amzn\_AfiliateID\_AU":"shbeg05-22","Conf\_Custom\_Class":" BestAzon\_Amazon\_Link ","Conf\_New\_Window":"1","Conf\_Link\_Follow":"1","Conf\_Product\_Link":"1","Conf\_Tracking":"2","Conf\_Footer":"2","Conf\_Link\_Keywords":"\\/go\\/","Conf\_Hide\_Redirect\_Link":"1","Conf\_Honor\_Existing\_Tag":"1","Conf\_No\_Aff\_Country\_Redirect":"1","Conf\_GA\_Tracking":"2","Conf\_GA\_ID":"","Conf\_Source":"Wordpress-52"}; var tocplus = {"visibility\_show":"show","visibility\_hide":"hide","visibility\_hide\_by\_default":"1","width":"100%"}; window.gtranslateSettings = /\* document.write \*/ window.gtranslateSettings || {};window.gtranslateSettings\['33375625'\] = {"default\_language":"en","languages":\["ar","zh-CN","nl","en","fr","de","it","pt","ru","es"\],"url\_structure":"none","flag\_style":"2d","wrapper\_selector":"#gt-wrapper-33375625","alt\_flags":{"en":"usa"},"float\_switcher\_open\_direction":"top","switcher\_horizontal\_position":"inline","flags\_location":"\\/wp-content\\/plugins\\/gtranslate\\/flags\\/"}; if ( !!window.jQuery ) {(function($){$(document).ready(function(){if ( !!window.SLB && SLB.has\_child('View.init') ) { SLB.View.init({"ui\_autofit":true,"ui\_animate":false,"slideshow\_autostart":false,"slideshow\_duration":"6","group\_loop":true,"ui\_overlay\_opacity":"0.8","ui\_title\_default":false,"theme\_default":"slb\_black","ui\_labels":{"loading":"Loading","close":"Close","nav\_next":"Next","nav\_prev":"Previous","slideshow\_start":"Start slideshow","slideshow\_stop":"Stop slideshow","group\_status":"Item %current% of %total%"}}); } if ( !!window.SLB && SLB.has\_child('View.assets') ) { {$.extend(SLB.View.assets, {"743340558":{"id":40420,"type":"image","internal":true,"source":"https:\\/\\/www.smarthomebeginner.com\\/images\\/2019\\/10\\/traefik-forward-authentication-with-google-oauth.png","title":"traefik forward authentication with google oauth","caption":"Traefik Forward Auth with Google OAuth - Process Flow","description":""},"1143580575":{"id":40408,"type":"image","internal":true,"source":"https:\\/\\/www.smarthomebeginner.com\\/images\\/2019\\/10\\/01-clouldflare-dns-records-for-traefik-google-oauth.png","title":"01 clouldflare dns records for traefik google oauth","caption":"Create DNS Records for Google OAuth2","description":""},"2139835099":{"id":40418,"type":"image","internal":true,"source":"https:\\/\\/www.smarthomebeginner.com\\/images\\/2019\\/10\\/Google-ToS.jpg","title":"Google ToS","caption":"Google Terms of Service","description":""},"1157068408":{"id":40410,"type":"image","internal":true,"source":"https:\\/\\/www.smarthomebeginner.com\\/images\\/2019\\/10\\/02-google-oauth-create-new-project.png","title":"02 google oauth create new project","caption":"Create a new Project for OAuth","description":""},"566902481":{"id":50903,"type":"image","internal":true,"source":"https:\\/\\/www.smarthomebeginner.com\\/images\\/2024\\/04\\/01-Create-a-New-Projects.png","title":"01 Create a New Projects","caption":"Google Console - Create a New Project","description":""},"712122899":{"id":50902,"type":"image","internal":true,"source":"https:\\/\\/www.smarthomebeginner.com\\/images\\/2024\\/04\\/02-OAuth-Concent-Screen-External.png","title":"02 OAuth Concent Screen External","caption":"OAuth Consent Screen - External App","description":""},"237954270":{"id":50906,"type":"image","internal":true,"source":"https:\\/\\/www.smarthomebeginner.com\\/images\\/2024\\/04\\/03-1-OAuth-Consent-Screen-App-Name-1.png","title":"03-1 OAuth Consent Screen App Name (1)","caption":"OAuth Consent Screen - App Information","description":""},"2069264558":{"id":50904,"type":"image","internal":true,"source":"https:\\/\\/www.smarthomebeginner.com\\/images\\/2024\\/04\\/03-2-Oauth-Consent-Screen-Domains-1.png","title":"03-2 Oauth Consent Screen Domains (1)","caption":"OAuth Consent Screen - Authorized Domains","description":""},"1227023285":{"id":50899,"type":"image","internal":true,"source":"https:\\/\\/www.smarthomebeginner.com\\/images\\/2024\\/04\\/04-Scopes-Save-and-Continue.png","title":"04 Scopes - Save and Continue","caption":"OAuth Consent Screen - Scope","description":""},"1423643537":{"id":50898,"type":"image","internal":true,"source":"https:\\/\\/www.smarthomebeginner.com\\/images\\/2024\\/04\\/05-Test-Users-Nothing-to-Add.png","title":"05 Test Users - Nothing to Add","caption":"OAuth Consent Screen - Test Users","description":""},"1838926739":{"id":50897,"type":"image","internal":true,"source":"https:\\/\\/www.smarthomebeginner.com\\/images\\/2024\\/04\\/06-App-Registration-Back-to-Dashboard.png","title":"06 App Registration - Back to Dashboard","caption":"OAuth Consent Screen - App Registration","description":""},"1355466506":{"id":50896,"type":"image","internal":true,"source":"https:\\/\\/www.smarthomebeginner.com\\/images\\/2024\\/04\\/07-Publish-App-and-Confirm-to-Production.png","title":"07 Publish App and Confirm to Production","caption":"OAuth Consent Screen - Publish App to Production","description":""},"1137522546":{"id":50895,"type":"image","internal":true,"source":"https:\\/\\/www.smarthomebeginner.com\\/images\\/2024\\/04\\/08-Create-OAuth-Client-ID.png","title":"08 Create OAuth Client ID","caption":"Create OAuth Client ID","description":""},"418562052":{"id":50894,"type":"image","internal":true,"source":"https:\\/\\/www.smarthomebeginner.com\\/images\\/2024\\/04\\/09-1-Application-Type-Web.png","title":"09-1 Application Type Web","caption":"OAuth Client ID - Application Type (Web)","description":""},"698706694":{"id":50893,"type":"image","internal":true,"source":"https:\\/\\/www.smarthomebeginner.com\\/images\\/2024\\/04\\/09-2-Client-ID-Web-Application.png","title":"09-2 Client ID Web Application","caption":"Client ID Web Application Redirect URIs","description":""},"1922454995":{"id":50892,"type":"image","internal":true,"source":"https:\\/\\/www.smarthomebeginner.com\\/images\\/2024\\/04\\/10-OAuth-Client-Credentials.png","title":"10 OAuth Client Credentials","caption":"Google OAuth Client Credentials (keep it safe!!!)","description":""},"24764486":{"id":41326,"type":"image","internal":true,"source":"https:\\/\\/www.smarthomebeginner.com\\/images\\/2020\\/08\\/docker-secrets-folder-permissions.png","title":"docker secrets folder permissions","caption":"Docker Secrets Folder Permissions","description":""},"877207999":{"id":40426,"type":"image","internal":true,"source":"https:\\/\\/www.smarthomebeginner.com\\/images\\/2019\\/10\\/08-random-oauth-secret.png","title":"08 random oauth secret","caption":"Random OAuth Secret","description":"Random OAuth Secret"},"1887149766":{"id":40915,"type":"image","internal":true,"source":"https:\\/\\/www.smarthomebeginner.com\\/images\\/2020\\/04\\/google-oauth-login.png","title":"google oauth login","caption":"Google OAuth Login for Docker Services","description":""},"1144250525":{"id":41105,"type":"image","internal":true,"source":"https:\\/\\/www.smarthomebeginner.com\\/images\\/2020\\/06\\/sabnzbd-oauth-api-key.png","title":"sabnzbd oauth api key","caption":"OAuth Log entry for SABnzbd access via NZB360 app","description":""},"1373125479":{"id":41111,"type":"image","internal":true,"source":"https:\\/\\/www.smarthomebeginner.com\\/images\\/2020\\/06\\/radarr\_from\_nzb360\_oauth\_log.png","title":"radarr\_from\_nzb360\_oauth\_log","caption":"OAuth Log for Radarr access via NZB360 App","description":""}});} } /\* THM \*/ if ( !!window.SLB && SLB.has_child('View.extend_theme') ) { SLB.View.extend_theme('slb_baseline',{"name":"Baseline","parent":"","styles":\[{"handle":"base","uri":"https:\\/\\/www.smarthomebeginner.com\\/wp-content\\/plugins\\/simple-lightbox\\/themes\\/baseline\\/css\\/style.css","deps":\[\]}\],"layout\_raw":"<div class=\\"slb_container\\"><div class=\\"slb_content\\">{{item.content}}<div class=\\"slb_nav\\"><span class=\\"slb_prev\\">{{ui.nav\_prev}}<\\/span><span class=\\"slb_next\\">{{ui.nav\_next}}<\\/span><\\/div><div class=\\"slb_controls\\"><span class=\\"slb_close\\">{{ui.close}}<\\/span><span class=\\"slb_slideshow\\">{{ui.slideshow\_control}}<\\/span><\\/div><div class=\\"slb_loading\\">{{ui.loading}}<\\/div><\\/div><div class=\\"slb_details\\"><div class=\\"inner\\"><div class=\\"slb_data\\"><div class=\\"slb_data_content\\"><span class=\\"slb_data_title\\">{{item.title}}<\\/span><span class=\\"slb_group_status\\">{{ui.group\_status}}<\\/span><div class=\\"slb_data_desc\\">{{item.description}}<\\/div><\\/div><\\/div><div class=\\"slb_nav\\"><span class=\\"slb_prev\\">{{ui.nav\_prev}}<\\/span><span class=\\"slb_next\\">{{ui.nav\_next}}<\\/span><\\/div><\\/div><\\/div><\\/div>"}); }if ( !!window.SLB && SLB.has_child('View.extend_theme') ) { SLB.View.extend_theme('slb_default',{"name":"Default (Light)","parent":"slb_baseline","styles":\[{"handle":"base","uri":"https:\\/\\/www.smarthomebeginner.com\\/wp-content\\/plugins\\/simple-lightbox\\/themes\\/default\\/css\\/style.css","deps":\[\]}\]}); }if ( !!window.SLB && SLB.has_child('View.extend_theme') ) { SLB.View.extend_theme('slb_black',{"name":"Default (Dark)","parent":"slb_default","styles":\[{"handle":"base","uri":"https:\\/\\/www.smarthomebeginner.com\\/wp-content\\/plugins\\/simple-lightbox\\/themes\\/black\\/css\\/style.css","deps":\[\]}\]}); }})})(jQuery);} if ( !!window.jQuery ) {(function($){$(document).ready(function(){if ( !!window.SLB ) { {$.extend(SLB, {"context":\["public","user_guest"\]});} }})})(jQuery);}

✓

Thanks for sharing!

[AddToAny](https://www.addtoany.com/ "Share Buttons")

[More…](#addtoany "Show all")

[AddToAny](https://www.addtoany.com/ "Share Buttons")

[More…](#addtoany "Show all")
