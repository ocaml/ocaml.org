---
title: "OCaml Infrastructure: Promote watch.ocaml.org to Non-Beta Status"
tags: [infrastructure]
---

[watch.ocaml.org](https://watch.ocaml.org) has been updated to run as a Docker service stack rather than via docker-compose.  This change allowed an [OCurrent](https://github.com/ocurrent/ocurrent) pipeline to monitor the Docker repository and update the image via `docker service update` when a new version is available.

We have several other services updated via OCurrent: [deploy.ci.ocaml.org](https://deploy.ci.ocaml.org)

In OCurrent, we can create a schedule node that triggers every seven days and invokes a `docker pull`, yielding the current image SHA.  If this has changed, run `docker service update` with the new image. 

```
  let peertube =
     let weekly = Current_cache.Schedule.v ~valid_for:(Duration.of_day 7) () in
     let image = Cluster.Watch_docker.pull ~schedule:weekly "chocobozzz/peertube:production-bullseye" in
     Cluster.Watch_docker.service ~name:"infra_peertube" ~image ()
```

The deployment is achieved through an Ansible Playbook.  Further details are available [here](/watch-ocaml-org).

The second part of the update was to improve the visibility of the backups for watch.ocaml.org.  As noted [previously](/2022/11/08/tarsnap-backups.html), these use [Tarsnap](https://www.tarsnap.com) running monthly via `CRON`.
              
For this, a new plugin was added to OCurrent called [ocurrent_ssh](https://github.com/ocurrent/ocurrent/tree/master/plugins/ssh).  This plugin allows arbitrary SSH commands to be executed as part of an OCurrent pipeline.

Again using a schedule node, the `Current_ssh.run` node will be triggered on a 30-day schedule, and the logs for each run will be available on [deploy.ci.ocaml.org](https://deploy.ci.ocaml.org).

```
  let monthly = Current_cache.Schedule.v ~valid_for:(Duration.of_day 30) () in
   let tarsnap = Current_ssh.run ~schedule:monthly "watch.ocaml.org" ~key:"tarsnap" (Current.return ["./tarsnap-backup.sh"])
```

