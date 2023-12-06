# E-Invoicing SDK
I could never get the SDK to run on my machine, so I dockerized it instead.

If you have Docker installed, you should be able to run the following command
to get a shell that's pre-installed with the SDK.

```bash
docker compose run zatca
```

The envoicing-sdk is mounted into the container, so any changes you do on the host
within that folder will appear inside the container.

NOTE: This command has one downside in that it runs `install.sh` every time so
`Configuration/config.json` will be overridden each time you run the container.