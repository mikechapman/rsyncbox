#!/bin/bash

function clean() {
  touch ~/.rsyncbox/clean
  find ~/rsyncbox -type f -name '*.DS_Store' -ls -delete
}

function connect() {
  if [ ! -d /volumes/rsyncbox ]; then
    mkdir /volumes/rsyncbox > /dev/null 2>&1;
    mount_smbfs "$(<~/.rsyncbox/remote)" /volumes/rsyncbox > /dev/null 2>&1;
  fi
}

function disconnect() {
  if [ -d /volumes/rsyncbox ]; then
    umount /volumes/rsyncbox > /dev/null 2>&1;
    rmdir /volumes/rsyncbox > /dev/null 2>&1;
  fi
}

function help() {
  echo "Example usage:"
  echo "  rsyncbox init PATH"
  echo "  rsyncbox [status | clean | secure | pull | pulldiff | push | pushdiff]"
  echo
  echo "Example multiple command usage:"
  echo "  rsyncbox clean secure push"
}

function init() {
  mkdir ~/rsyncbox > /dev/null 2>&1;
  mkdir ~/.rsyncbox > /dev/null 2>&1;
  echo "$1" > ~/.rsyncbox/remote
  disconnect
  connect
  mkdir /volumes/rsyncbox/rsyncbox > /dev/null 2>&1;
}

function pull() {
  connect
  touch ~/.rsyncbox/pull
  rsync -av --inplace --delete --ignore-errors --exclude=.DS_Store /volumes/rsyncbox/rsyncbox/ ~/rsyncbox/
  disconnect
}

function pulldiff() {
  connect
  rsync -av --dry-run --inplace --delete --ignore-errors --exclude=.DS_Store /volumes/rsyncbox/rsyncbox/ ~/rsyncbox/
  disconnect
}

function push() {
  connect
  touch ~/.rsyncbox/push
  rsync -av --inplace --delete --ignore-errors --exclude=.DS_Store ~/rsyncbox/ /volumes/rsyncbox/rsyncbox/
  disconnect
}

function pushdiff() {
  connect
  rsync -av --dry-run --inplace --delete --ignore-errors --exclude=.DS_Store ~/rsyncbox/ /volumes/rsyncbox/rsyncbox/
  disconnect
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

function version() {
  echo "v0.1.0"
}

case ${1} in
  init) init "$2" ;;
  *)
    for command in "$@"
    do
      case ${command} in
        clean) clean ;;
        pull) pull ;;
        pulldiff) pulldiff ;;
        push) push ;;
        pushdiff) pushdiff ;;
        secure) secure ;;
        status) status ;;
        --help) help ;;
        --version) version ;;
      esac
    done
    ;;
esac
