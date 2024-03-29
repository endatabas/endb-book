# Monitoring

Endb exposes plaintext logs, Prometheus metrics,
and optional OpenTelemetry tracing.
Any one, or a combination, of these can be used to monitor an Endb instance.

Some monitoring options are offered as flags.
Set flags by setting the environment variable to `0` or `1`
(ex. `ENDB_LOG_ANSI=0`).

## Logging

By default, `endb` logs to STDOUT with a log level of `endb=INFO`.

Adjust the log level with the `ENDB_LOG_LEVEL` environment variable.
Endb uses [Rust Logging](https://docs.rs/env_logger/latest/env_logger/#enabling-logging)
and more details about log levels are available in that document.

Other flags include:

* `ENDB_LOG_ANSI` - turns ANSI terminal colour output on or off (on by default)
* `ENDB_LOG_THREAD_IDS` - set to enable or disable logging of thread ids (enabled by default)

Example:

```sh
docker run --rm -e ENDB_LOG_LEVEL=endb=DEBUG -e ENDB_LOG_ANSI=0 -e ENDB_LOG_THREAD_IDS=1 -p 3803:3803 -v demo_data:/app/endb_data docker.io/endatabas/endb:latest
```

## Prometheus

A Prometheus endpoint is available at `/metrics`.
This endpoint is enabled by default.
If your Endb instance is running locally, you can view metrics in a browser at
http://localhost:3803/metrics

The Prometheus tracing level defaults to `endb=DEBUG`.
Set the tracing level with `ENDB_TRACING_LEVEL`.

## OpenTelemetry

To enable OpenTelemetry, set `ENDB_TRACING_OTEL=1` and
`OTEL_EXPORTER_OTLP_ENDPOINT=http://localhost:4317/`
[Configuration options for the OTLP exporter](https://opentelemetry.io/docs/specs/otel/protocol/exporter/) and
[additional OTLP environment variables](https://opentelemetry.io/docs/concepts/sdk-configuration/otlp-exporter-configuration/)
may also prove useful for configuration.

The OpenTelemetry tracing level defaults to `endb=DEBUG`.
Set the tracing level with `ENDB_TRACING_LEVEL`.

At the moment, only gRPC metrics are exposed, not HTTP.

## Metrics

Endb exposes a number of metrics to the Prometheus endpoint and OpenTelemetry.
These can be useful in debugging performance of applications connected to Endb.

### Histograms

* `query_real_time_duration_seconds`
* `query_gc_run_time_duration_seconds`
* `query_consed_bytes`
* `http_request_duration_seconds`

### Counters

* `queries_active`
* `interactive_transactions_active`
* `buffer_pool_usage_bytes`
* `dynamic_space_usage_bytes`

### Monotonic Counters

* `websocket_message_internal_errors_total`
* `object_store_read_bytes_total`
* `object_store_written_bytes_total`
* `queries_total`
* `transactions_conflicted_total`
* `transactions_committed_total`
* `transactions_prepared_total`
* `transactions_retried_total`
* `wal_read_bytes_total`
* `wal_written_bytes_total`
* `http_requests_total`

## Tracing

Endb exposes a variety of tracing spans to OpenTelemetry.
Tracing data is mostly useful if your Endb instance is not performing in the way you expect.

* `buffer_pool_eviction`
* `build_info`
* `commit`
* `compaction`
* `constraints`
* `gc`
* `index`
* `log_replay`
* `log_rotation`
* `object_store_delete`
* `object_store_get`
* `object_store_list`
* `object_store_put`
* `query`
* `shutdown`
* `snapshot`
* `startup`
* `wal_append_entry`
* `wal_read_next_entry`
* `wal_fsync`
* `websocket_connections_active`
* `websocket_message_duration_seconds`
* `websocket_messages_total`
