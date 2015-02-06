#!/bin/bash
# Note: Works with bash 4.x and above only #
_getdomainnameonly(){
        local h="$1"
        local f="$(echo "$h" | tr '[A-Z]' '[a-z]')"
        # remove protocol part of hostname
        f="${f#http://}"
        f="${f#https://}"
        f="${f#ftp://}"
        f="${f#scp://}"
        f="${f#scp://}"
        f="${f#sftp://}"
        # remove username and/or username:password part of hostname
        f="${f#*:*@}"
        f="${f#*@}"
        # remove all /foo/xyz.html*
        f=${f%%/*}
        # show domain name only
        echo "$f"
}


ping(){
        local array=( $@ )              # get all args in an array
        local len=${#array[@]}          # find the length of an array
        local host=${array[$len-1]}     # get the last arg
        local args=${array[@]:0:$len-1} # get all args before the last arg in $@ in an array
        local _ping="/sbin/ping"
        local c=$(_getdomainnameonly "$host")
        [ "$t" != "$c" ] && echo "Sending ICMP ECHO_REQUEST to \"$c\"..."
        # pass args and host
        $_ping $args $c
}

host(){
        local array=( $@ )
        local len=${#array[@]}
        local host=${array[$len-1]}
        local args=${array[@]:0:$len-1}
        local _host="/usr/bin/host"
        local c=$(_getdomainnameonly "$host")
        [ "$t" != "$c" ] && echo "Performing DNS lookups for \"$c\"..."
        $_host $args $c
}
