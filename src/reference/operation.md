# Operation

The `endb` executable aims to provide self-explanatory help
for direct usage of the binary.

By default, `endb` logs to STDOUT.

```
$ endb --help
NAME:
  endb - Endatabas is a SQL document database with full history.

USAGE:
  endb [OPTION]...

OPTIONS:
      --help                    display usage information and exit
      --password <VALUE>        password [env: $ENDB_PASSWORD]
      --username <VALUE>        username [env: $ENDB_USERNAME]
      --version                 display version and exit
  -d, --data-directory <VALUE>  data directory [default: endb_data] [env: $ENDB_DATA_DIRECTORY]
  -l, --log-level <CHOICE>      log level [default: info] [env: $ENDB_LOG_LEVEL] [choices: info, warn,
                                error, debug]
  -p, --http-port <INT>         HTTP port [default: 3803] [env: $ENDB_HTTP_PORT]

LICENSE:
  AGPL-3.0-only
```
