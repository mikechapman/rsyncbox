# rsyncbox <sub><sup>v0.1.0</sup></sub>

Shell based Dropbox replacement for OS X. It has Keychain integration and works with any SMB/SMB2 capable remote (e.g. FreeNAS, Synology, QNap, Drobo, Linux server, Windows server). Conceptualization and command usage inspired by Git (e.g. remotes, push, pull).

## Installation

Make executable available in your `PATH`:

```bash
$ curl -o /usr/local/bin/rsyncbox https://raw.githubusercontent.com/rockymadden/rsyncbox/master/rsyncbox.sh && chmod 0755 /usr/local/bin/rsyncbox
```

Initialize:

```bash
# Prompts for remote info, which is stored in your keychain.
$ rsyncbox init
```

## Usage

```bash
$ rsyncbox [status | clean | secure | pull | pulldiff | push | pushdiff]
```

Issue multiple commands in a single statement:

```bash
$ rsyncbox clean secure push
```

## Commands

* __init:__ Creates local directories, remote directories, and Keychain entry
* __status:__ Returns the last timestamps for `clean`, `secure`, `push`, and `pull`
* __clean:__ Removes, efficiently, all `.DS_Store` files on the local store via `find`
* __secure:__ Secures, efficiently, all files and folders on the local store via `find` and `chmod` (e.g. 700 for executables and 600 for others)
* __pull:__ Pulls delta from remote store via `rsync`
* __pulldiff:__ Shows pull delta to remote store via `rsync --dry-run`
* __push:__ Pushes delta to remote store via `rsync`
* __pushdiff:__ Shows push delta to remote store via `rsync --dry-run`

## TODO

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