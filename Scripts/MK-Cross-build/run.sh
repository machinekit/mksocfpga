#!/bin/bash

#set -x

SCRIPT_ROOT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
CURRENT_DIR=`pwd`
#WORK_DIR=$1
WORK_DIR=$CURRENT_DIR

REL_CURRENT_DATE=`date -I`
#REL_CURRENT_DATE="2016-03-07"

#ROOTFS_DIR=${WORK_DIR}/rootfs
#IMG_FILE=${CURRENT_DIR}/mksoc_sdcard-beta2.img
#IMG_FILE=${CURRENT_DIR}/mksoc_sdcard.img
IMG_FILE=${CURRENT_DIR}/mksocfpga_jessie_linux-3.10-${REL_CURRENT_DATE}_sdcard.img
IMG_ROOT_PART=p3
ROOTFS_MNT=/mnt/rootfs
DRIVE=/dev/mapper/loop0

MK_SOURCEFILE_NAME=machinekit-src.tar.bz2
MK_BUILDTFILE_NAME=machinekit-built.tar.bz2

MK_RIPROOTFS_NAME=mksocfpga_jessie_linux-3.10-${REL_CURRENT_DATE}_mk-rip-rootfs-final.tar.bz2

# this is where the test build will go. 
#MK_BUILDDIR=${ROOTFS_DIR}/machinekit/machinekit

# git repository to pull from
REPO=git://github.com/machinekit/machinekit.git

# the origin to use
ORIGIN=github-machinekit

# the branch to build
BRANCH=master

# this is where the clone will be. 
MK_CLONEDIR=${WORK_DIR}/machinekit

install_clone_deps(){
# prerequisits for cloning Machinekit
# git
echo machinekit | sudo -S apt-get -y install git-core git-gui dpkg-dev
}

mk_clone() {
# refuse to clone into an existing directory.
if [ -d "${MK_CLONEDIR}" ]; then
    echo the target directory ${MK_CLONEDIR} already exists.
    echo cleaning repo
    cd ${MK_CLONEDIR} 
    git clean -d -f -x
    cd ..    
#    echo please remove or rename this directory and run again.
#    exit 1
else
# $MK_BUILDDIR does not exist. Make a shallow git clone into it.
# make sure you have around 200MB free space.

    git clone -b "${BRANCH}" -o "${ORIGIN}" --depth 1 "${REPO}" "${MK_CLONEDIR}"
fi 
}

compress_clone(){
    echo "compressing machinekit folder"
    cd ${WORK_DIR}
    tar -jcf "${MK_SOURCEFILE_NAME}" ./machinekit
}

compress_mkrip_rootfs(){
    echo "compressing final mk-rip-rootfs"
    
    sudo kpartx -a -s -v ${IMG_FILE}

    sudo mkdir -p ${ROOTFS_MNT}
    sudo mount ${DRIVE}${IMG_ROOT_PART} ${ROOTFS_MNT}

    
    cd ${ROOTFS_MNT}
    sudo tar -cjSf ${CURRENT_DIR}/${MK_RIPROOTFS_NAME} *
    cd ${WORK_DIR}
    sudo umount -R ${ROOTFS_MNT}
    sudo kpartx -d -s -v ${IMG_FILE}
}

# compress_mk_build(){
# cd ${HOME}
# if [ -d machinekit ]; then
#     echo "the target directory machinekit exists ... compressing"
#     tar -jcf "${MK_BUILDTFILE_NAME}" ./machinekit
# fi
# }

copy_files(){
echo "copying build-script and machinekit tar.bz2"
sudo cp -f ${SCRIPT_ROOT_DIR}/mk-rip-build.sh ${ROOTFS_MNT}/home/
sudo cp -f ${WORK_DIR}/${MK_SOURCEFILE_NAME} $ROOTFS_MNT/home/machinekit/
}

gen_policy-rc.d() {
sudo sh -c 'cat <<EOT > '${ROOTFS_MNT}'/usr/sbin/policy-rc.d
echo "************************************" >&2
echo "All rc.d operations denied by policy" >&2
echo "************************************" >&2
exit 101
EOT'
}

POLICY_FILE=/usr/sbin/policy-rc.d

gen_build_sh() {
echo "------------------------------------------"
echo "generating run.sh chroot config script"
echo "------------------------------------------"
sudo sh -c 'cat <<EOT > '${ROOTFS_MNT}'/home/build.sh
#!/bin/bash

set -x


compress_mk_build(){
cd /home/machinekit
if [ -d machinekit ]; then
    echo "the target directory machinekit exists ... compressing"
    tar -jcf "'${MK_BUILDTFILE_NAME}'" ./machinekit
fi
}


/home/mk-rip-build.sh

if [ -f '${POLICY_FILE}' ]; then
    echo "removing '${POLICY_FILE}'"
    sudo rm -f '${POLICY_FILE}'
fi

compress_mk_build

exit
EOT'

sudo chmod +x ${ROOTFS_MNT}/home/build.sh
}

kill_ch_proc(){
FOUND=0

for ROOT in /proc/*/root; do
    LINK=$(sudo readlink ${ROOT})
    if [ "x${LINK}" != "x" ]; then
        if [ "x${LINK:0:${#PREFIX}}" = "x${PREFIX}" ]; then
            # this process is in the chroot...
            PID=$(basename $(dirname "${ROOT}"))
            sudo kill -9 "${PID}"
            FOUND=1
        fi
    fi
done
}

umount_ch_proc(){
COUNT=0

while sudo grep -q "${PREFIX}" /proc/mounts; do
    COUNT=$((${COUNT}+1))
    if [ ${COUNT} -ge 20 ]; then
        echo "failed to umount ${PREFIX}"
        if [ -x /usr/bin/lsof ]; then
            /usr/bin/lsof "${PREFIX}"
        fi
        exit 1
    fi
    grep "${PREFIX}" /proc/mounts | \
        cut -d\  -f2 | LANG=C sort -r | xargs -r -n 1 sudo umount || sleep 1
done
}

run_build_sh() {
echo "mounting SD-Image"

sudo kpartx -a -s -v ${IMG_FILE}

sync
sudo mkdir -p ${ROOTFS_MNT}
sudo mount ${DRIVE}${IMG_ROOT_PART} ${ROOTFS_MNT}

echo "------------------------------------------"
echo "   copying files to root mount            "
echo "------------------------------------------"
#cd $ROOTFS_DIR
#sudo tar cf - . | (sudo tar xf - -C $ROOTFS_MNT)

copy_files
gen_build_sh
gen_policy-rc.d

echo "------------------------------------------"
echo "running build.sh config script in chroot"
echo "------------------------------------------"
cd ${ROOTFS_MNT} # or where you are preparing the chroot dir
sudo mount -t proc proc proc/
sudo mount -t sysfs sys sys/
sudo mount -o bind /dev dev/

#echo "will now exit in mount"
#exit 1
# fix dns:
RESOLVCONF_FILE=${ROOTFS_MNT}/etc/resolv.conf


if [ -f ${RESOLVCONF_FILE} ]; then
    sudo rm ${RESOLVCONF_FILE}
fi

sudo cp -f /etc/resolv.conf ${RESOLVCONF_FILE}

HOSTS_FILE=${ROOTFS_MNT}/etc/hosts

if [ -f ${HOSTS_FILE} ]; then
    echo "renaming ${HOSTS_FILE}"
    sudo mv ${HOSTS_FILE} ${HOSTS_FILE}.bak
    echo "replacing ${HOSTS_FILE} with one from host"
    sudo cp /etc/hosts ${HOSTS_FILE}    
else
    sudo cp /etc/hosts ${HOSTS_FILE}    
fi

cd ${ROOTFS_MNT}

sudo chroot ./ /bin/su - machinekit /bin/bash -c /home/build.sh

if [ -f ${HOSTS_FILE}.bak ]; then
    echo "restoring ${HOSTS_FILE}"
    sudo rm -f ${HOSTS_FILE}
    sudo mv ${HOSTS_FILE}.bak ${HOSTS_FILE}
fi

sudo rm ${ROOTFS_MNT}/etc/resolv.conf

cd ${CURRENT_DIR}


sudo cp -f $ROOTFS_MNT/home/machinekit/${MK_BUILDTFILE_NAME}  ${WORK_DIR}

PREFIX=${ROOTFS_MNT}
kill_ch_proc

PREFIX=${ROOTFS_MNT}
umount_ch_proc

echo "killed processes in mount now syncing..."
sync

sudo umount -R ${ROOTFS_MNT}

sync
sudo kpartx -d -v ${IMG_FILE}
sync

compress_mkrip_rootfs

}

#---------------------------------------------------------------------------#
#----------- run functions -------------------------------------------------#
#---------------------------------------------------------------------------#

install_clone_deps

###mk_clone

compress_clone

run_build_sh

##run_re_build_sh
echo "#+++   run.sh completed     ++++++++++++++++++#"
echo "#------ Machinekit Rip build completed -------#"
