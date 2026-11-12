# Environment Setup

Before diving into either track, get familiar with the two tools you'll use
to write and apply your YAML throughout the lab: VS Code as your editor, and
WSL as the Linux shell that runs Terraform.

## Accessing your lab machine

This lab runs on a shared Windows jump machine with VS Code, WSL, and
Terraform already installed - connect to it through WebRDP.

!!! note "WebRDP connection steps coming soon"
    Instructions for connecting to your jump machine over WebRDP will be
    added here shortly.

!!! tip "Working from your own computer instead"
    If you'd rather use your own laptop instead of RDP-ing into the jump
    machine, that's fine - use whatever editor and terminal you're
    comfortable with. Just make sure you have, before the lab starts:

    - **Terraform** installed
    - **[uv](https://docs.astral.sh/uv/)** installed - this lab's Python
      tooling (`nac-validate`, `nac-test`) is installed and run through it
    - An active connection to the **lab VPN** - the GitLab instance and the
      virtualized IOS-XE devices (CML) only live inside the lab network, not
      on the public internet

## What is VS Code?

Visual Studio Code (VS Code) is a free, lightweight, yet powerful source
code editor developed by Microsoft. It runs on Windows, macOS, and Linux and
has become one of the most popular code editors among developers and IT
professionals.

Key features that make VS Code ideal for Network as Code:

- **Syntax highlighting** - colors and formats YAML files for easy
  readability
- **IntelliSense** - provides intelligent code completion and suggestions
- **Integrated terminal** - run commands directly within the editor
- **Extensions** - add functionality like YAML validators and schema
  support
- **Git integration** - built-in version control for tracking changes
- **Multi-file editing** - work with multiple configuration files
  simultaneously
- **File explorer** - easy navigation through project folders and files

## YAML linting with the Red Hat extension

Since Network as Code configurations are written in YAML, having proper
syntax validation is essential. VS Code supports YAML linting through the
[YAML extension by Red Hat](https://marketplace.visualstudio.com/items?itemName=redhat.vscode-yaml),
which helps catch syntax errors and enforce best practices as you write your
configuration files.

<figure markdown="span">
  ![Red Hat YAML extension in VS Code](assets/rh.png){ width="70%" }<figcaption>The Red Hat
  YAML extension, pre-installed in your lab environment.</figcaption>
</figure>

This extension provides:

- **Real-time syntax validation** - highlights errors as you type
- **Auto-completion** - suggests valid YAML structures
- **Formatting** - automatically formats your YAML files
- **Schema validation** - can validate against predefined schemas

The YAML extension is already pre-installed in your lab - you'll see syntax
highlighting and error detection automatically as you edit YAML files.

!!! note "File extension matters"
    The YAML extension only recognizes files ending with **`.nac.yaml`** as
    Network as Code YAML files. To benefit from its validation and
    auto-completion, make sure every configuration file you create ends in
    `.nac.yaml`.

## What is WSL?

Windows Subsystem for Linux (WSL) lets you run a Linux environment directly
on Windows without a virtual machine. WSL is pre-installed in this lab, and
you'll use it to run Terraform commands - most DevOps tools, including
Terraform, are designed for Linux.

## Setting up your project

With the tools introduced, the next few steps get your actual lab files in
place: clone the repository, open it in VS Code, and confirm Autosave is on
before you start editing.

### Clone the lab repository

From a WSL terminal, clone the lab repository into a dedicated project
directory on your desktop: `/Desktop/network-as-code`. This is your
workspace for both tracks - it already contains a `meraki/` and an `ios-xe/`
folder, each with its own `main.tf`, `data/`, and `data-lab-task/`.

```sh
git clone <lab-repo-url> /Desktop/network-as-code
```

### Open VS Code

To begin working with your project in a development-friendly environment,
open your project folder in VS Code:

1. Double-click the **Visual Studio Code** icon on the Windows desktop.
2. Click **File → Open Folder**.
3. In the address bar, type or paste: `/Desktop/network-as-code`.
4. Click **OK**.

### Check Autosave is on

Throughout this lab you'll switch frequently between editing YAML in VS Code
and running Terraform in the WSL terminal. Autosave means every edit is
written to disk immediately, so the terminal always sees your latest changes
without you having to remember to save manually. It should already be enabled
on your lab machine - just confirm it before you start editing:

1. Click **File** in the VS Code menu bar.
2. Check that **Auto Save** already has a checkmark next to it. If not,
   click it to turn it on.

!!! tip "Verify it's on"
    With Auto Save enabled, the dot on a file's editor tab (shown for
    unsaved changes) disappears a moment after you stop typing, instead of
    staying until you press ++cmd+s++ / ++ctrl+s++.

### Project structure

Before touching Terraform or `.env`, take a quick look at what's actually
inside `/Desktop/network-as-code` - knowing where things live now saves
confusion later:

```text
network-as-code/
├── .env.example          # template for your pod's secrets/variables
├── meraki/               # Part 1 - Meraki track
│   ├── main.tf           # the Terraform module block for this track
│   ├── data/             # what Terraform actually reads - starts nearly empty
│   ├── data-lab-task/    # staged files you move into data/ one step at a time
│   ├── rules/            # nac-validate semantic rules
│   └── tests/            # nac-test Robot Framework suite
└── ios-xe/               # Part 2 - IOS-XE track
    ├── main.tf
    ├── data/
    ├── data-lab-task/
    ├── rules/
    └── tests/
```

Both tracks follow the same shape: a `main.tf` driving an nac module, the
`data/` folder that module actually reads, a `data-lab-task/` folder of files
you move into `data/` one at a time as the lab progresses, `rules/` for
validation, and `tests/` for post-deploy checks. You'll only ever work inside
one track's folder at a time - commands like `terraform plan` always run
from inside `meraki/` or `ios-xe/`, never from the repo root.

### Terraform: the `main.tf` file

Each track's folder in the repo you just cloned already has its own
`main.tf` - you won't write one from scratch. It's worth understanding what's
in it before you start running Terraform against it. Here's `meraki/main.tf`:

```hcl title="meraki/main.tf"
module "meraki" {
  source           = "github.com/netascode/terraform-meraki-nac-meraki"
  yaml_directories = ["data"]
  write_model_file = "meraki_merged_configuration.nac.yaml"
}
```

!!! note "Formatting matters"
    Terraform (`.tf`) files use braces `{}` and proper indentation for
    structure. While Terraform is more forgiving than YAML, consistent
    formatting makes your code readable and maintainable - keep that in mind
    if you ever edit this file by hand.

Understanding the configuration:

- **`module "meraki"`** - declares a Terraform module named `meraki`. Modules
  are reusable Terraform configurations that encapsulate infrastructure
  logic.
- **`source`** - tells Terraform where to find the module. This points to
  the Network as Code for Meraki module on GitHub, published by Cisco under
  the `netascode` organization. The module handles all the complexity of
  translating YAML configurations into the Terraform HashiCorp Configuration
  Language (HCL) code needed by the Meraki Terraform provider. As written
  here, `source` has no version pinned, so Terraform tracks the latest
  commit on the module's default branch - you could instead append a
  `?ref=` to pin it:
    - `?ref=v1.4.0` to pin a specific, tested release tag.
    - `?ref=a1b2c3d4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b0` to pin an exact commit,
      when you need more granularity than a tag provides.
- **`yaml_directories = ["data"]`** - specifies which directories contain
  your YAML configuration files. Terraform automatically discovers and
  processes every YAML file within the `data/` folder - more flexible than
  listing individual files, since you can add multiple YAML files to
  `data/` and they'll all be processed automatically.
- **`write_model_file = "meraki_merged_configuration.nac.yaml"`** - outputs
  the merged YAML data model to a file. Useful for debugging and for running
  Robot Framework tests against the combined configuration - you'll
  generate and examine this file later in the lab.

### Copy `.env.example` to `.env`

Both tracks read pod-specific values (API keys, credentials, your unique
branch name) from shell environment variables rather than hardcoding them in
YAML. The repo ships a template for these at the root, `.env.example`. Copy
it to `.env` and fill in your own values:

```sh
cp .env.example .env
```

Then edit `.env` and `source` it before running Terraform in `meraki/` or
`ios-xe/`:

```sh
source .env
terraform plan
```

!!! note "`.env` stays local - never committed"
    `.env` is for **your machine only**. The root `.gitignore` explicitly
    excludes it:

    ```
    .env
    *.env
    !.env.example
    ```

    Only the sanitized `.env.example` template is tracked in Git - the real
    `.env` file with your personal values never leaves your machine and is
    never committed. The GitLab CI/CD pipeline doesn't read `.env` either;
    it takes the same values from GitLab CI/CD Variables instead (see the
    Cheat Sheet).

---

**← Previous:** [Overview](Intro01_overview.md) · **Next:** [Part 1 - Meraki: log in](Meraki00_login.md)
