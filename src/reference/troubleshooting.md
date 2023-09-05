# Troubleshooting

## Mysterious "Corrupt archive", HTTP format, and Arrow Errors

Occasionally, Docker images can become corrupted.
This tends to happen if you are both building Docker images yourself
and downloading them from Docker Hub.
Indications that you may be experiencing this include the following
nonsensical _server-side_ errors:

```
<ERROR> [00:19:35] endb/http http.lisp (make-api-handler fun9) -
  unknown format: "+m"
```

```
Invalid argument types: ARROW-GET(0, 0)
```

You can remove images, containers, and/or volumes manually.
If you are certain you don't need any of your other Docker/Podman data,
you can try the "nuke it from space" approach:

* `podman system reset` (Podman)

* `docker system prune --all --volumes` (Docker)

WARNING: These two commands will destroy _all your data_.
