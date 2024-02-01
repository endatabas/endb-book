# Operation

The `endb` executable aims to provide self-explanatory help
for direct usage of the binary.

See [Monitoring](monitoring.md) for more information about logging,
metrics, and tracing.

```
$ endb --help
Usage: endb [OPTIONS]

Options:
  -d, --data-directory <DATA_DIRECTORY>  [env: ENDB_DATA_DIRECTORY=] [default: endb_data]
  -h, --help                             Print help
  -V, --version                          Print version

Authentication:
      --username <USERNAME>  [env: ENDB_USERNAME=]
      --password <PASSWORD>  [env: ENDB_PASSWORD=]

Network:
  -p, --port <PORT>                  [env: ENDB_PORT=] [default: 3803]
      --bind-address <BIND_ADDRESS>  [env: ENDB_BIND_ADDRESS=] [default: 0.0.0.0]
      --protocol <PROTOCOL>          [env: ENDB_PROTOCOL=] [default: http] [possible values: http, https]
      --cert-file <CERT_FILE>        [env: ENDB_CERT_FILE=]
      --key-file <KEY_FILE>          [env: ENDB_KEY_FILE=]
```

The `-d` option accepts a special value of `:memory:` to run an in-memory node,
without persisting anything to disk.

The `--cert-file` and `--key-file` options are ignored when `--protocol` is set to `http`.
When `--protocol` is set to `https`, they are both required.

## Backup and Restore

If you would like to back up your Endb data, you can use any commodity copy or sync tool
(such as `rsync`) to maintain a copy of your `--data-directory` (`ENDB_DATA_DIRECTORY`).

To restore that directory, stop Endb, replace or sync that directory where Endb is running,
and restart Endb.
