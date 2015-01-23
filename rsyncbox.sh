#!/bin/bash

function clean() {
  touch ~/.rsyncbox/clean
  find ~/rsyncbox -type f -name '*.DS_Store' -ls -delete
}

function connect() {
  if [ ! -d /volumes/rsyncbox ]; then
    keychain=`security find-internet-password -l "rsyncbox-$1"`
    pass=`security find-internet-password -w -l "rsyncbox-$1"`
    user=`echo "$keychain" | grep 'acct' | sed 's/^.*="\(.*\)".*$/\1/'`
    share=`echo "$keychain" | grep 'path' | sed 's/^.*="\(.*\)".*$/\1/'`
    ip=`echo "$keychain" | grep 'srvr' | sed 's/^.*="\(.*\)".*$/\1/'`
    urlpass=`urlencode "$pass"`
    urluser=`urlencode "$user"`

    mkdir /volumes/rsyncbox > /dev/null 2>&1;
    mount_smbfs "//$urluser:$urlpass@$ip$share" /volumes/rsyncbox > /dev/null 2>&1;
  fi
}

function diff() {
  case "$2" in
    pull)
      connect "$1"
      rsync -av --dry-run --inplace --delete --ignore-errors --exclude=.DS_Store /volumes/rsyncbox/rsyncbox/ ~/rsyncbox/
      disconnect
    ;;
    push)
      connect "$1"
      rsync -av --dry-run --inplace --delete --ignore-errors --exclude=.DS_Store ~/rsyncbox/ /volumes/rsyncbox/rsyncbox/
      disconnect
    ;;
    *) echo 'Unknown diff type' ;;
  esac
}

function disconnect() {
  if [ -d /volumes/rsyncbox ]; then
    umount /volumes/rsyncbox > /dev/null 2>&1;
    rmdir /volumes/rsyncbox > /dev/null 2>&1;
  fi
}

function help() {
  echo "Example usage:"
  echo "  rsyncbox [init | status | clean | secure]"
  echo "  rsyncbox diff REMOTE [push | pull]"
  echo "  rsyncbox pull REMOTE"
  echo "  rsyncbox push REMOTE"
}

function init() {
  mkdir ~/rsyncbox > /dev/null 2>&1;
  mkdir ~/.rsyncbox > /dev/null 2>&1;
}

function pull() {
  connect "$1"
  touch ~/.rsyncbox/pull
  rsync -av --inplace --delete --ignore-errors --exclude=.DS_Store /volumes/rsyncbox/rsyncbox/ ~/rsyncbox/
  disconnect
}

function push() {
  connect "$1"
  touch ~/.rsyncbox/push
  rsync -av --inplace --delete --ignore-errors --exclude=.DS_Store ~/rsyncbox/ /volumes/rsyncbox/rsyncbox/
  disconnect
}

function remote() {
  case "$1" in
    add)
      read -p "Enter remote name: " name
      read -p "Enter remote ip/domain: " ip
      read -p "Enter remote share: " share
      read -p "Enter remote username: " user
      read -s -p "Enter remote password: " pass
      echo

      security add-internet-password -U -l "rsyncbox-$name" -a "$user" -s "$ip" -p "/$share" -r "smb " -w "$pass"

      connect "$name"
      mkdir /volumes/rsyncbox/rsyncbox > /dev/null 2>&1;
    ;;
  esac
}

function secure() {
  touch ~/.rsyncbox/secure
  find ~/rsyncbox ! -perm 0700 -type d -exec chmod 0700 {} + &&
  find ~/rsyncbox ! \( -name \*.purs -o -name \*.clj -o -name \*.coffee -o -name \*.hs -o -name \*.js -o -name \*.py -o -name \*.scala -o -name \*.sh \) ! -perm 0600 -type fl -exec chmod 0600 {} + &&
  find ~/rsyncbox \( -name \*.purs -o -name \*.clj -o -name \*.coffee -o -name \*.hs -o -name \*.js -o -name \*.py -o -name \*.scala -o -name \*.sh \) ! -perm 0700 -type fl -exec chmod 0700 {} +

  if [ -d "~/rsyncbox/dotfiles" ]; then
    find ~/rsyncbox/dotfiles/**/.* ! -perm 0700 -type f -exec chmod 0700 {} +
  fi
}

function status() {
  if [ -e ~/.rsyncbox/clean ]; then
    echo 'cleaned:' `stat -f "%Sm" -t "%Y-%m-%dT%H:%M:%S%z" ~/.rsyncbox/clean`
  else
    echo 'cleaned: never'
  fi

  if [ -e ~/.rsyncbox/secure ]; then
    echo 'secured:' `stat -f "%Sm" -t "%Y-%m-%dT%H:%M:%S%z" ~/.rsyncbox/secure`
  else
    echo 'secured: never'
  fi

  if [ -e ~/.rsyncbox/push ]; then
    echo ' pushed:' `stat -f "%Sm" -t "%Y-%m-%dT%H:%M:%S%z" ~/.rsyncbox/push`
  else
    echo ' pushed: never'
  fi

  if [ -e ~/.rsyncbox/pull ]; then
    echo ' pulled:' `stat -f "%Sm" -t "%Y-%m-%dT%H:%M:%S%z" ~/.rsyncbox/pull`
  else
    echo ' pulled: never'
  fi
}

function urlencode() {
  echo -ne "$1" | hexdump -v -e '/1 "%02x"' | sed 's/\(..\)/%\1/g'
}

function version() {
  echo "v0.3.0"
}

# Route.
case "$1" in
  clean) clean ;;
  diff)
    if [ ! "$#" -eq 3 ]; then
      echo 'Remote name and diff type arguments required'
    else

      diff "$2" "$3"
    fi
  ;;
  init) init ;;
  pull)
    if [ ! "$#" -eq 2 ]; then
      echo 'Remote name argument required'
    else
      pull "$2"
    fi
  ;;
  push)
    if [ ! "$#" -eq 2 ]; then
      echo 'Remote name argument required'
    else
      push "$2"
    fi
  ;;
  remote)
    if [ ! "$#" -eq 2 ]; then
      echo 'Action and remote name arguments required'
    else
      remote "$2"
    fi
  ;;
  secure) secure ;;
  status) status ;;
  --help) help ;;
  --version) version ;;
esac
