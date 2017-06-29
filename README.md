# mongodb-tuned

tuned profile for MongoDB recommended settings

To configure:

```
cd /usr/lib/tuned/
git clone https://github.com/mhelmstetter/mongodb-tuned.git
```

Edit:
```
cd /usr/lib/tuned/mongodb-tuned
chmod +x *.sh
vi tuned.conf
```
Change the devices settings to reflect the MongoDB data device(s):

```
devices=xvdb,dm-0
```

Activate the profile:
```
tuned-adm profile mongodb-tuned
```

To verify:
```
blockdev --report
cat /sys/kernel/mm/transparent_hugepage/defrag
cat /sys/kernel/mm/transparent_hugepage/enabled
```
Readahead should be 0 for the MongoDB data volume, [never] for both THP settings
