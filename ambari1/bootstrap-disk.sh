pvcreate /dev/sdb
vgextend VolGroup /dev/sdb
lvextend /dev/VolGroup/lv_root /dev/sdb
resize2fs /dev/VolGroup/lv_root
