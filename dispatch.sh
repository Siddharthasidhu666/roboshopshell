command=$(df -hT)
xfs=$command|grep -i xfs
echo "$xfs"