# PorkbunDNSUpdate

Use [Porkbun's API](https://porkbun.com/api/json/v3/documentation) <sup><sub>(as of 04/10/2022: Version 3 - Beta)</sub></sup> to update the DNS A record in Porkbun's DNS Server.

## Simple Updater
- Pick the `simpleUpdater.sh` file to run
- Update these variables in the updater.config file in the section Simple Updater Configs

## Slightly More Complicated Updater
- Pick the `slightlyMoreComplicatedUpdater.sh` file to run
- Update the configs in the `updater.config.sample` file and rename it to `updater.config`
- Make sure the below dependencies are installed
- Update these variables in the updater.config file in the section Simple Updater Configs <strong>AND</strong> in the section Slightly More Complicated Updater Configs


## Dependencies
These are for the <em>Slightly More Complicated Updater</em>
- [ ] dos2unix
    - May or may not be required depending on how linux reads these files as it was written on a windows machine
    - Installation
        ```bash
        $ sudo apt install jq
        ```
- [ ] jq
    - Installation
        ```bash
        $ sudo apt install jq
        ```

## Logs
These are for the <em>Slightly More Complicated Updater</em>
A logs folder created if it doesn't exist.

<strong>Remember to check the log folder periodically and clean it up.</strong>


