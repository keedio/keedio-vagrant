pvdisplay /dev/sdb  
if [ -b /dev/sdb ] && [ $? == 0 ];
then
pvcreate /dev/sdb
vgextend VolGroup /dev/sdb
lvextend /dev/VolGroup/lv_root /dev/sdb
resize2fs /dev/VolGroup/lv_root
fi
