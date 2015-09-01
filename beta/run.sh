#!/bin/bash

DATADIR="/data"
DEST="/var/www/html"
CHECKDIR="$DEST/data"

# look for empty dir 
[[ "$(ls -A $CHECKDIR)" ]] || {
  mv $DATADIR $DEST
  chown -R :www-data $CHECKDIR
  chmod -R g+w $CHECKDIR
}

#run apache
apache2-foreground
