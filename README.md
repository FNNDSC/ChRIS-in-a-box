# Description
# ![ChRIS logo](https://raw.githubusercontent.com/FNNDSC/ChRIS_ultron_backEnd/master/docs/assets/logo_chris.png) ChRIS in a box


With a build once, run anywhere approach, ChRIS in a Box allows the ability to access and use ChRIS on Edge Computing Devices that are deployed in facilities who would like to leverage the capabilities of ChRIS. 

![image](https://github.com/FNNDSC/ChRIS-in-a-box/assets/93591339/f30eb698-8b62-415f-9a8b-02f6d55d7645)


[![MIT license](https://img.shields.io/github/license/FNNDSC/chris-in-a-box)](LICENSE)

Run [_ChRIS_](https://chrisproject.org/) using [Podman](https://podman.io).

## Technical Overview

ChRIS in a box is intended to run the components of ChRIS application as containers using Podman and Microshift depending on the choice of deployment. 

The folder _podman_ provides YAML files which can be read by `podman play kube` to run _ChRIS_.

At the moment it is insecure and not be used in production. However, we aim for make changes so that it can run in production. This is a good starting point for writing production-ready configurations of _ChRIS_.

_ChRIS in a box_ runs applications in "production mode" (where applicable)
To use a specific backend service please refer to the project source repositories instead, e.g. https://github.com/FNNDSC/ChRIS_ultron_backEnd

Image tags are pinned to stable versions, so _chris in a box_ may be out-of-date with development versions of _ChRIS_ components.


## Prerequisties

### System Requirements

_ChRIS in a box_ requires Podman version 4.3 or above.
We aim to support "out-of-the-box" setups of rootless Podman (using slirp4netns).

```
   CPU: x4 cores
   RAM: 16GB
   Storage: ~500GB
```

Supported OS: Fedora Silverblue 37, Ubuntu 22.04, Arch Linux

<details>
<summary>
(Click to expand) Notes about installing Podman on Arch Linux.
</summary>

On Arch Linux, please consult the wiki: https://wiki.archlinux.org/title/Podman

Here's what worked for me (possibly helpful, definitely outdated info)

```shell
sudo pacman -Syu podman
sudo usermod --add-subuids 100000-165535 --add-subgids 100000-165535 $USER
```

</details>

Whether you're using Podman or Kubernetes, make sure your system is mostly not
running anything which might interfere with _miniChRIS_.

- Existing container/pod names might clash with _miniChRIS_.
  Make sure the output of `podman ps -a` or `kubectl get pods` is empty-ish.
- Running servers might clash with _miniChRIS_, which wants to bind TCP ports
  5005, 5010, 8000, 8010, 8080, 8020, and 8021.

## Podman - Install ChRIS

```bash
./podman/minichris.sh up
```

## Podman - Uninstall ChRIS
```bash
./podman/minichris.sh down
```


## Podman Desktop - Install ChRIS
![Screenshot from 2023-07-30 00-07-16](https://github.com/FNNDSC/ChRIS-in-a-box/assets/93591339/b16e81eb-3bca-4528-a021-4dc749abfc50)

![Screenshot from 2023-07-30 00-09-56](https://github.com/FNNDSC/ChRIS-in-a-box/assets/93591339/13152eb7-e486-4c65-bb44-14568b79c5c8)

![Screenshot from 2023-07-30 00-10-55](https://github.com/FNNDSC/ChRIS-in-a-box/assets/93591339/612b4917-d20f-43a5-9558-22f4346ec79b)

![Screenshot from 2023-07-30 00-11-54](https://github.com/FNNDSC/ChRIS-in-a-box/assets/93591339/8585abd8-5a5a-4d51-ba0f-9862d629dd12)



## Podman Desktop - UnInstall ChRIS
This is a work in progress

## Application Startup & Performance
On a fast computer with good internet speed, running `./podman/minichris.sh up`
for the first time (pulls images) takes about 1.5 to 2 minutes.
Subsequent runs will be faster, about 40 seconds.

## MicroShift

Work in Progress

<!--
## ChRIS URLs

website        | URL
---------------|-----
ChRIS_ui       | http://localhost:8020/
ChRIS admin    | http://localhost:8000/chris-admin/
ChRIS_store_ui | http://localhost:8021/
Orthanc        | http://localhost:8042/
-->

<!--

## Note

For more information on how to run the user interface, please refer to https://github.com/FNNDSC/ChRIS_ui#readme

### Adding Plugins

[_chrisomatic_](https://github.com/FNNDSC/chrisomatic) is an easy way to
add plugins to _CUBE_. Currently, only adding plugins from https://chrisstore.co
is supported.

To add plugins, append the name of the plugin to `podman/chrisomatic.yml`
and then run

```shell
podman/minichris.sh chrisomatic
```

### Adding Plugins to CUBE

Plugins are added to _ChRIS_ via the Django admin dashboard.

https://github.com/FNNDSC/ChRIS_ultron_backEnd/wiki/%5BHOW-TO%5D-Register-a-plugin-via-Django-dashboard

Alternatively, plugins can be added declaratively.
A common use case would be to run locally built Python
[`chris_plugin`](https://github.com/FNNDSC/chris_plugin)-based
_ChRIS_ plugins. These can be added using `chrisomatic` by
listing their (docker) image tags. For example, if your local image
was built with the tag `localhost/myself/pl-workinprogress` by running

```shell
podman build -t localhost/myself/pl-workinprogress .
```

The bottom of your `podman/chrisomatic.yml` file should look like

```yaml
  plugins:
    - name: pl-dircopy
      version: 2.1.1
    - name: pl-tsdircopy
      version: 1.2.1
    - name: pl-topologicalcopy
      version: 0.2
    - name: pl-simpledsapp
      version: 2.1.0
    - localhost/myself/pl-workinprogress
```

After modifying `chrisomatic.yml`, apply the changes by running `./chrisomatic.sh`

For details, see https://github.com/FNNDSC/chrisomatic#plugins-and-pipelines
-->

### Developer's Notes: On Podman
YAML files in `podman/kube` should be interoperable between Podman and Kubernetes.
Podman supports a subset of the Kubernetes manifest spec:
Pod, Deployment, PersistentVolumeClaim, ConfigMap

## Open Issues
Ideally, to add _pfcon_ to _CUBE_ we should be using the pod name of pfcon `http://minichris-pfcon:5005/api/v1/`but it won't work.
For more information please go to https://github.com/FNNDSC/ChRIS_ultron_backEnd/issues/505

There is an undocumented behavior of Podman where the host is visible to the container
via the name `host.containers.internal`, and we're able to talk to pfcon via the bound
host port.


#### Management Cluster
https://console-openshift-console.apps.edge-mgr.nerc.mghpcc.org/


#### Recommended Reading
- https://docs.podman.io/en/stable/markdown/podman-kube-play.1.html#podman-kube-play-support
- https://github.com/containers/podman/blob/main/docs/tutorials/basic_networking.md
- https://github.com/FNNDSC/chris-in-a-box/wiki/
- https://github.com/containers/podman
- https://www.freedesktop.org/software/systemd/man/systemd.unit.html
  
## Contact
- Contributors: Raghuram.Banda , Máirín Duffy.
- Github Issues: https://github.com/FNNDSC/chris-in-a-box/issues
- Matrix: https://matrix.to/#/#chris-general:fedora.im
