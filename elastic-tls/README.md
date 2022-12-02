Tooling: elastic-tls
===================

Script shell used to help you generate SSL/TLS config for Elasticsearch

`$ ./generate-tls.sh -v 7.17.0 -t cluster`

```
Usage: ./generate-tls.sh [-V <string>] [-t <single|cluster>]

options:

-V     Set Elaticsearch version, exp 7.17.0.
-t     single or cluster type.
-h     Print Help.
```

In order to use the script you *must* create a file `certutil-input.yaml` that describe your instance name and ip.

```yaml
instances:
  - name: "es_0"
    ip:
      - "x.x.x.x"
  - name: "es_1"
    ip:
      - "x.x.x.x"
  - name: "es_2"
    ip:
      - "x.x.x.x"
```
