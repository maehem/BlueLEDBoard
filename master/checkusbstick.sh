#!/bin/bash
#grab message files from usb stick and automically copy to running controllers

dbget () {
  if [ -e /tmp/blueled/$1 ]; then    ## Dont bother getting the file if port as now been set up
    SRC=/media/usb0/messages/$1.txt
    DST=/tmp/blueled/$1/message.txt

    if [ ! -e $SRC ]; then ##  If USB file (or stick) not there, then revert file.
        SRC=/etc/blueled/messages/$1.txt
    fi
    cmp $SRC $DST
    if [ $? -ne 0 ]; then  ## Files differ. Copy it only if we need to.
        cp $SRC $DST
    fi


#    TMPFILE=`mktemp`
#    wget "$1" -O $TMPFILE
#
#	cat $TMPFILE
#

#    if [ $? -eq 0 ]      ## WGET success?
#     then
#       # atomically move the new file
#       mv -f $TMPFILE /tmp/blueled/$2/message.txt

#       echo "good $2 dir /tmp/blueled/$2/message.txt"
#       cat  /tmp/blueled/$2/message.txt

#     else
#       #delete any left over output file
#       rm $TMPFILE
#     fi

  fi
}

dbget ttyUSB0
dbget ttyUSB1
dbget ttyUSB3
dbget ttyUSB4
dbget ttyUSB5
dbget ttyUSB7


#dbget "https://www.dropbox.com/s/qff4av2zhk783sw/ttyUSB0.txt?dl=0" ttyUSB0
#dbget "https://www.dropbox.com/s/qb2f4xsblxw77bi/ttyUSB1.txt?dl=0" ttyUSB1
#dbget "https://www.dropbox.com/s/yndfgmppofuqrxd/ttyUSB3.txt?dl=0" ttyUSB3
#dbget "https://www.dropbox.com/s/bqv8tlfr1oom5dy/ttyUSB4.txt?dl=0" ttyUSB4
#dbget "https://www.dropbox.com/s/xobellkt6kr8l11/ttyUSB5.txt?dl=0" ttyUSB5
#dbget "https://www.dropbox.com/s/cp93qrrtwcxchdx/ttyUSB7.txt?dl=0" ttyUSB7
