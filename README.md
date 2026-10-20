# polaris

The command line for ItsMyCargo: ask your forwarder for quotes, compare them,
book one and track the shipment, from a terminal, a script, a CI job or an AI
agent.

This repository holds the releases. Download the latest from
[Releases](https://github.com/itsmycargo/polaris-cli-releases/releases/latest).

## Install

macOS or Linux, with Homebrew:

```sh
brew install itsmycargo/tap/polaris
```

macOS or Linux, without it (installs to `/usr/local/bin`, or `~/.local/bin`,
after checking the download's checksum):

```sh
curl -fsSL https://github.com/itsmycargo/polaris-cli-releases/releases/latest/download/install.sh | sh
```

Windows: download `polaris_<version>_windows_amd64.zip` from the
[latest release](https://github.com/itsmycargo/polaris-cli-releases/releases/latest),
unzip it and put `polaris.exe` on your PATH.

In CI, pin a version: `POLARIS_VERSION=v0.1.0 sh install.sh`.

Check it works with `polaris version`.

## Sign in

```sh
polaris login --org <your forwarder's slug>
```

polaris shows a code and opens your forwarder's web app. Sign in there as usual
(password, two-factor or single sign-on), check what polaris asks for, and
approve it. polaris never sees your password. You find the exact command,
with your forwarder's slug, in the web app under **Settings → Command line**.

For scripts, CI jobs and agents, create a personal access token in the web app
under **Settings → API tokens**, and set it as `POLARIS_TOKEN` instead.

## Use it

```sh
polaris locations search hamburg
polaris quotes create --from DEHAM --to CNSHA --container 2xfcl_40@18000 --wait
polaris quotes charges <result id>
polaris shipments create <result id> --notes "Pick up after 2pm"
polaris shipments updates <shipment request id>
```

Every command takes `--json`, and `polaris <command> --help` explains it.
`polaris api` calls any other operation of the API you have access to.

AI agents: read
[AGENTS.md](https://github.com/itsmycargo/polaris-cli-releases/releases/latest/download/AGENTS.md).

## Verifying a download

Each release has a `checksums.txt` with the SHA-256 of every archive:

```sh
shasum -a 256 -c checksums.txt --ignore-missing
```

## Help

For questions about your quotes, bookings or account, contact your forwarder.
To report a problem with polaris itself, contact ItsMyCargo support, and
include the `request id` polaris prints with any error.

## License

polaris is proprietary software of ItsMyCargo GmbH; see [LICENSE](LICENSE).
It includes open-source components under their own licenses, listed in
`THIRD_PARTY_NOTICES` in each release archive.
