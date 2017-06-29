# copy/paste version of setup


```
mkdir -p /usr/lib/tuned/mongodb-tuned
cat >> /usr/lib/tuned/mongodb-tuned disable-transparent-hugepages.sh << EOF
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
EOF

chmod +x /usr/lib/tuned/mongodb-tuned disable-transparent-hugepages.sh

cat >> /usr/lib/tuned/mongodb-tuned disable-transparent-hugepages.sh << EOF
[vm]
transparent_hugepages=never

[script]
script=disable-transparent-hugepages.sh

[sysctl]
net.ipv4.tcp_keepalive_time = 120
fs.file-max = 98000
kernel.pid_max = 64000
kernel.threads-max = 64000
vm.swappiness=1
vm.zone_reclaim_mode=0

[disk]
alpm=max_performance
devices=xvdb,dm-0
elevator=deadline
readahead=0
EOF

tuned-adm profile mongodb-tuned
blockdev --report
cat /sys/kernel/mm/transparent_hugepage/defrag
cat /sys/kernel/mm/transparent_hugepage/enabled
```


