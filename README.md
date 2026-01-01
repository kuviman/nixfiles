```sh
nixos-anywhere --flake .#parix root@${REMOTE} --no-disko-deps --phases disko
```

Need to setup swap after partitioning and formatting since 512mb ram is not enough

```sh
fallocate --length 1G /tmp/swapfile
chmod 600 /tmp/swapfile
mkswap /tmp/swapfile
swapon /tmp/swapfile
```

```sh
nixos-anywhere --flake .#parix root@${REMOTE} --no-disko-deps --phases install
```

```sh
nixos-rebuild --flake .#parix --target-host ${REMOTE} switch --ask-sudo-password
```
