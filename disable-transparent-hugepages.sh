#!/bin/bash

case $1 in
  start)
    if [ -d /sys/kernel/mm/transparent_hugepage ]; then
      thp_path=/sys/kernel/mm/transparent_hugepage
    elif [ -d /sys/kernel/mm/redhat_transparent_hugepage ]; then
      thp_path=/sys/kernel/mm/redhat_transparent_hugepage
    else
      return 0
    fi

    echo 'never' > ${thp_path}/enabled
    echo 'never' > ${thp_path}/defrag

    re='^[0-1]+$'
    if [[ `cat ${thp_path}/khugepaged/defrag` =~ $re ]]
    then
        # RHEL 7
        echo 0  > ${thp_path}/khugepaged/defrag
    else
        # RHEL 6
        echo 'no' > ${thp_path}/khugepaged/defrag
    fi

    unset thp_path
    ;;
esac
