# rsyncbox <sub><sup>v0.1.0</sup></sub>

Git-inspired Dropbox replacement with any SMB capable remote (e.g. FreeNAS, Synology, QNap, Drobo, Linux server, Windows server). Currently only for OS X.

## Installation
Make executable available in your `PATH`:

```bash
$ curl -o /usr/local/bin/rsyncbox https://raw.githubusercontent.com/rockymadden/rsyncbox/master/rsyncbox.sh && chmod 0755 /usr/local/bin/rsyncbox
```

Export global variable in your `~/.bash_profile`:

```bash
$ export RSYNCBOX_REMOTE_SMB_PATH=//username@ip/share
```

Initialize:

```bash
$ rsyncbox init
```

## Usage

```bash
$ rsyncbox [status | connect | disconnect | clean | secure | pull | pulldiff | push | pushdiff]
```

You can issue mutiple subcommands at once:

```bash
$ rsyncbox connect clean secure push
```

## Subcommands
* __init:__ Creates local and remote directories, if they do not exist
  * `~/rsyncbox` is the local store
  * `~/.rsyncbox` is the local configuration
  * `${RSYNCBOX_REMOTE_SMB_PATH}/rsyncbox` is the remote store
* __status:__ Returns the remote status and the last timestamps for `clean`, `secure`, `push`, and `pull`
* __connect:__ Connects to the remote store via `mount_smbfs`
* __disconnect:__ Disconnects from the remote store via `unmount`
* __clean:__ Removes, efficiently, all `.DS_Store` files from the local store
* __secure:__ Secures, efficiently, the local store via `find` and `chmod`
  * Non-executables: 600
  * Executables: 700
* __pull:__ Pulls delta from remote store via `rsync`
* __pulldiff:__ Shows pull delta to remote store via `rsync --dry-run`
* __push:__ Pushes delta to remote store via `rsync`
* __pushdiff:__ Shows push delta to remote store via `rsync --dry-run`

# TODO
* Sharing files via CloudApp/Droplr
* Optional automated push/pull via Finder hooks
* Optional excludes (e.g. `target/`, `.cabal-sandbox/`, `node_modules/`)

## License

```
The MIT License (MIT)

Copyright (c) 2015 Rocky Madden (http://rockymadden.com/)

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
```