# Part 1 - Meraki

<figure markdown="span">
  ![Part 1 - Meraki lab overview](assets/meraki-lab-overview.svg)
</figure>

## Step 1 - Log In and Identify Your Lab Organization

Open [https://dashboard.meraki.com](https://dashboard.meraki.com) and sign in
with the email address from your lab reservation.

If your account has access to multiple organizations, click the organization
name in the top-left corner and select the lab organization - it follows the
naming pattern `Org-[org_id]` (for example, `Org-3665367146726167151` - the
brackets are not literal, and the ID is an opaque number of 6-19 digits).

## Step 2 - Generate Your Meraki API Key

We will be authenticating to Meraki using a personal API key tied to your dashboard account. Follow these steps to generate one. **If you already have an API key for your lab account, skip this step.**

1. In the Meraki Dashboard, click your **profile icon** in the top-right corner and select **My profile**.

    ![Meraki Dashboard profile menu](assets/image11.png){ width="60%" }

2. Scroll down to the **API access** section and click **Generate new API key**. 

3. Copy the key immediately and save it somewhere safe, we will be using it in the next step. **It will only be displayed once** - if you navigate away without copying it, you will need to revoke it and generate a new one.

    ![Meraki Dashboard profile menu](assets/image12.png){ width="60%" }

    !!! warning "Keep your API key private"
        Your API key has the same access level as your dashboard login. Never share it, commit it to a repository, or paste it into chat. You will store it securely in the next step. We also advise you to revoke this API key after finishing the lab as a precaution.

    !!! note "Your key inherits your admin role"
        A personal API key doesn't carry its own permissions - it acts with
        whatever role your account holds in the organization, the same way
        your dashboard login does. This lab's first steps configure
        org-level settings (login security, SNMP, VPN firewall rules), so
        your lab account needs **full organization** admin access, not just
        network-level access, for Terraform to apply them - your lab
        account is already provisioned with full organization admin access
        in this lab's organization, so no action is needed from you here.
        See the
        [Meraki Developer Hub authorization docs](https://developer.cisco.com/meraki/api-v1/authorization/)
        for how API key permissions map to admin roles.

---

**← Previous:** [Environment Setup](Intro02_environment.md) · **Next:** [Org and global settings](Meraki01_org_global.md)
