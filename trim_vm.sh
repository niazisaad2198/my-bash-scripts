#!/bin/bash

# A bash script that trims VM images.
# All the operations done in this script require root permissions. So make sure to run this script as root or with sudo.
# It is assumed that the VMs are located in the default directory defined by virt-manager i.e. /var/lib/libvirt/images.
# The only required input is the correct filename(without extension i.e. ".qcow2") of the vm located in default directory.

# Get username
username="$(whoami)"

# Check for root privilege
if [ $username != "root" ];then
	echo "Root permission is required to execute this script."
	exit
fi


# Ask the user the name of the VM without extension.
echo "Enter VM file name (without extension)."
read file_name

# Determine the paths to the files used in the script.
original_path="/var/lib/libvirt/images/${file_name}.qcow2"
new_path="/vm_trim_tmp/${file_name}_small.qcow2"


# Get the original file's size.
original_filesize=$(ls -lh $original_path | awk '{print  $5}')


# Trim the files using the spicified paths.
echo "Started trimming."
qemu-img convert -O qcow2 $original_path $new_path
echo "Trimming complete."


# Get the new file's size.
new_filesize=$(ls -lh $new_path | awk '{print  $5}')

# Show difference in sizes.
echo "Old size = ${original_filesize}"
echo "New size = ${new_filesize}"

# Replace the original file.
echo "Replacing the old file."
mv $new_path $original_path
echo "Replacement complete."

exit
