# syslog-ng-offline-deb-installer

This tool can be used for creating an offline install bundle from the [OBS](https://build.opensuse.org/package/show/home:laszlo_budai:syslog-ng/syslog-ng-3.22.1) syslog-ng Debian/Ubuntu packages.

How to use?

When you need an offline syslog-ng installer with a set of syslog-ng modules, then the tool can create an installer with the required modules and the dependencies.

* create the install bundle for a specific Debian/Ubuntu distro:

```
./create-syslog-ng-obs-bundle.sh xUbuntu_16.04 syslog-ng-core syslog-ng-mod-pgsql
```

Result: installer.tgz

```
root@c3b45df3f821:/# tar tzvf installer.tgz
drwxr-xr-x root/root         0 2019-07-12 00:41 installer/
-rw-r--r-- root/root  15628440 2019-07-12 00:41 installer/bundle.tgz
-rwxr-xr-x root/root        55 2019-07-12 00:41 installer/install.sh

```

* copy installer.tgz into your server and install syslog-ng

```
root@a4a841ff40ae:/# tar xzf installer.tgz
root@a4a841ff40ae:/# cd installer 
root@a4a841ff40ae:/installer# ./install.sh
```

* check syslog-ng

`Available-Modules` should contain afsql module.


```
root@a4a841ff40ae:/installer# syslog-ng --version
syslog-ng 3 (3.22.1)
Config version: 3.22
Installer-Version: 3.22.1
Revision: 3.22.1-2
Compile-Date: Jun 25 2019 12:58:24
Module-Directory: /usr/lib/syslog-ng/3.22
Module-Path: /usr/lib/syslog-ng/3.22
Include-Path: /usr/share/syslog-ng/include
Available-Modules: afprog,tags-parser,syslogformat,xml,kvformat,affile,dbparser,cef,appmodel,disk-buffer,json-plugin,system-source,linux-kmsg-format,confgen,hook-commands,pseudofile,cryptofuncs,afsql,sdjournal,date,basicfuncs,afsocket,afuser,csvparser
Enable-Debug: off
Enable-GProf: off
Enable-Memtrace: off
Enable-IPv6: on
Enable-Spoof-Source: on
Enable-TCP-Wrapper: on
Enable-Linux-Caps: on
Enable-Systemd: on
root@a4a841ff40ae:/installer#

```


 ## How it works?
 
 The main script is `create-syslog-ng-obs-bundle.sh` .
 First parameter is the OBS distro name (eg.: Ubuntu 16.04 is xUbuntu_16.04 in OBS).
 The supported distros are manually listed in `check-obs-distro-arg.sh`.
 After the first parameter package names to be installed are coming.

* get the apt-key (Release.key)
 Based on the OBS distro name, the `download-syslog-ng-obs-apt-key.sh` downloads the APT key for the repository.

* map OBS distro name to a Docker distro name and start Docker image
The tool uses Docker as it needs a clean environment for downloading all the required dependencies.
example for mappings:
xUbuntu_16.04 -> ubuntu:16.04
Debian_9.0 -> debian:9.0

Docker image is started by `start-docker.sh` script which runs `create-bundle.sh`. 
`start-docker.sh` binds the working directory and saves the installer.tgz to there (so the script should be run from the project directory).

* inside Docker
  * `create-bundle.sh`: add Release.key, setup sources.list for the OBS repo, run apt-update
  * downloads the requested packages with their dependencies
  * generate the bundle

