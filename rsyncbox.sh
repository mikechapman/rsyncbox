#!/bin/bash

function clean() {
  touch ~/.rsyncbox/clean > /dev/null 2>&1;
  find ~/rsyncbox -type f -name '*.DS_Store' -ls -delete
}

function connect() {
  if [ -z "$RSYNCBOX_REMOTE_SMB_PATH" ]; then
    echo "Remote SMB path variable not set"
  else
    touch ~/.rsyncbox/connect > /dev/null 2>&1;
    mkdir /volumes/rsyncbox > /dev/null 2>&1;
    mount_smbfs "$RSYNCBOX_REMOTE_SMB_PATH" /volumes/rsyncbox
  fi
}

function disconnect() {
  touch ~/.rsyncbox/disconnect > /dev/null 2>&1;
  umount /volumes/rsyncbox > /dev/null 2>&1;
  rmdir /volumes/rsyncbox > /dev/null 2>&1;
}

function help() {
  echo "Example usage:"
  echo "  rsyncbox [init | status | connect | disconnect | clean | secure | pull | pulldiff | push | pushdiff]"
  echo
  echo "Example multiple subcommand usage:"
  echo "  rsyncbox clean secure push"
}

function init() {
  mkdir ~/.rsyncbox > /dev/null 2>&1;
  mkdir ~/rsyncbox > /dev/null 2>&1;

  disconnect
  connect

  mkdir /volumes/rsyncbox/rsyncbox/ > /dev/null 2>&1;
}

function pull() {
  if [ ! -d /volumes/rsyncbox ]; then
    connect
  fi

  touch ~/.rsyncbox/pull > /dev/null 2>&1;
  rsync -av --inplace --delete --ignore-errors --exclude=.DS_Store /volumes/rsyncbox/rsyncbox/ ~/rsyncbox/
}

function pulldiff() {
  if [ ! -d /volumes/rsyncbox ]; then
    connect
  fi

  rsync -av --dry-run --inplace --delete --ignore-errors --exclude=.DS_Store /volumes/rsyncbox/rsyncbox/ ~/rsyncbox/
}

function push() {
  if [ ! -d /volumes/rsyncbox ]; then
    connect
  fi

  touch ~/.rsyncbox/push > /dev/null 2>&1;
  rsync -av --inplace --delete --ignore-errors --exclude=.DS_Store ~/rsyncbox/ /volumes/rsyncbox/rsyncbox/
}

function pushdiff() {
  if [ ! -d /volumes/rsyncbox ]; then
    connect
  fi

  rsync -av --dry-run --inplace --delete --ignore-errors --exclude=.DS_Store ~/rsyncbox/ /volumes/rsyncbox/rsyncbox/
}

function secure() {
  touch ~/.rsyncbox/secure > /dev/null 2>&1;
  # TODO: More extensions.
  find ~/rsyncbox ! -perm 0700 -type d -exec chmod 0700 {} + &&
  find ~/rsyncbox ! \( -name \*.purs -o -name \*.clj -o -name \*.coffee -o -name \*.hs -o -name \*.js -o -name \*.py -o -name \*.scala -o -name \*.sh \) ! -perm 0600 -type fl -exec chmod 0600 {} + &&
  find ~/rsyncbox \( -name \*.purs -o -name \*.clj -o -name \*.coffee -o -name \*.hs -o -name \*.js -o -name \*.py -o -name \*.scala -o -name \*.sh \) ! -perm 0700 -type fl -exec chmod 0700 {} +

  if [ -d "~/rsyncbox/dotfiles" ]; then
    find ~/rsyncbox/dotfiles/**/.* ! -perm 0700 -type f -exec chmod 0700 {} +
  fi
}

function status() {
  if [ -d /volumes/rsyncbox ]; then
    echo ' remote: connected'
  else
    echo ' remote: disconnected'
  fi

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

for subcommand in "$@"
do
  case ${subcommand} in
    clean) clean ;;
    connect) connect ;;
    disconnect) disconnect ;;
    init) init ;;
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
