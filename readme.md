# rsyncbox <sub><sup>v0.3.0</sup></sub>

Dead simple shell-based Dropbox replacement for OS X. It has Keychain integration, supports multiple remotes, and works with any SMB/SMB2 capable server (e.g. FreeNAS, Synology, QNap, Drobo, Linux server, Windows server). Conceptualization and command usage inspired by Git (e.g. remotes, push, pull).

## Installation

Make executable available in your `PATH`:

```bash
$ curl -o /usr/local/bin/rsyncbox https://raw.githubusercontent.com/rockymadden/rsyncbox/master/rsyncbox.sh && chmod 0755 /usr/local/bin/rsyncbox
```

Initialize:

```bash
$ rsyncbox init
```

Create your first remote:

```bash
# Prompts for information, all of which is stored in your Keychain.
$ rsyncbox remote add
```

## Usage

Create local config directory `~/.rsyncbox` and store `~/rsyncbox`:

```bash
$ rsyncbox init
```

Remove, efficiently, all `.DS_Store` files on the local store via `find`:

```bash
$ rsyncbox clean
```

Secure, efficiently, all files and folders on the local store via `find` and `chmod` (e.g. 700 for executables and 600 for others):

```bash
$ rsyncbox secure
```

Add a new remote (you can have more than one):

```bash
$ rsyncbox remote add
```

Show pull delta information from remote store via `rsync --dry-run`:

```bash
$ rsyncbox diff remotename pull
```

Show push delta information to remote store via `rsync --dry-run`:

```bash
$ rsyncbox diff remotename push
```

Pulls delta from remote store via `rsync`:

```bash
$ rsyncbox pull remotename
```

Pushes delta to remote store via `rsync`:

```bash
$ rsyncbox push remotename
```

Return the last timestamps for `clean`, `secure`, `push`, and `pull`

```bash
$ rsyncbox status
```

## TODO

* Sharing files via CloudApp/Droplr
* Optional automated push/pull via Finder hooks
* Optional excludes (e.g. `target/`, `.cabal-sandbox/`, `node_modules/`)
* AFP support
* Attached storage support

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