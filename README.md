mackerel-plugin-oracle
======================

Oracle custom metrics plugin for mackerel.io agent.

## Synopsis

```shell
mackerel-plugin-oracle -sid=<SID> -username=<username> -password=<password> -service=<service> -host=<host> -event=<event> -event<event> ...
```

`-sid` is Oracle Database SID.
`-event` is Oracle WaitEvent name.

## Example of mackerel-agent.conf

```
[plugin.metrics.oracle]
command = [
	"/path/to/mackerel-plugin-oracle",
	"-event=Disk file operations I/O",
	"-event=control file sequential read",
	"-event=OS Thread Startup",
	"-user=sys",
	"-password=password",
	"-sid=FREE"
]
```

This is an example of the case using Oracle Database 23ai Free.

## Reference

You can find event name 

```
SELECT name, wait_class FROM V$EVENT_NAME ORDER BY name;
```

See also: <https://docs.oracle.com/database/122/REFRN/descriptions-of-wait-events.htm#REFRN-GUID-2FDDFAA4-24D0-4B80-A157-A907AF5C68E2>

Or

```
mackerel-plugin-oracle -sid <SID> -username <username> -password <password> -service <service> -host <host> -show-event
```
