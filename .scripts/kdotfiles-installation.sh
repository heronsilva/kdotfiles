#!/bin/bash

REPO_URL=https://github.com/heronsilva/kdotfiles.git
DEST_PATH=$HOME/.kdotfiles
BACKUP_PATH=$HOME/.kdotfiles-backup

rm -rf ~/.kdotfiles
rm -rf ~/.kdotfiles-backup

git clone --bare $REPO_URL $DEST_PATH

function kconfig {
  /usr/bin/git --git-dir=$HOME/.kdotfiles --work-tree=$HOME $@
}

kconfig checkout

if [ $? = 0 ]; then
  echo "Checked out .kdotfiles";
else
  echo "Backing up pre-existing K dot files";
  mkdir -p BACKUP_PATH

  files=`kconfig checkout 2>&1 | egrep "\s+\." | awk {'print $1'}`

  for file in $files
  do
    directory=`dirname $BACKUP_PATH/$file`
    echo 'Creating directory' $directory
    mkdir --parents $directory

    echo 'Moving file ' $file
    mv $file $BACKUP_PATH
  done
fi;

kconfig checkout
kconfig config status.showUntrackedFiles no

