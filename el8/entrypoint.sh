#!/usr/bin/env bash

set -x

# Set our base kernel version from the full version
IFS='.' read -r -a VERSION_ARRAY <<< $KERNEL_FULL_VERSION
KERNEL_BASE_VERSION="${VERSION_ARRAY[0]}.${VERSION_ARRAY[1]}"

# Make sure we have the latest code
cd /opt/kernel-rc-aufs
git pull

cd /opt/kernel-rc-aufs/specs-el8/

dnf builddep -y --nobest kernel-rc-aufs-$KERNEL_BASE_VERSION.spec

cd /opt/kernel-rc-aufs/
mkdir -p /root/rpmbuild/SOURCES
mkdir /root/rpmbuild/SPECS
mkdir /root/rpmbuild/RPMS
mkdir /root/rpmbuild/SRPMS

cp configs-el8/config-$KERNEL_FULL_VERSION* /root/rpmbuild/SOURCES/
cp configs-el8/cpupower.* /root/rpmbuild/SOURCES/
cp configs-el8/mod-extra.list /root/rpmbuild/SOURCES/
cp scripts-el8/* /root/rpmbuild/SOURCES/
cp specs-el8/kernel-rc-aufs-$KERNEL_BASE_VERSION.spec /root/rpmbuild/SPECS/

cd /root/rpmbuild/SOURCES/
git clone git://github.com/sfjro/aufs5-standalone.git -b aufs$KERNEL_BASE_VERSION aufs-standalone
if [[ $? != 0 ]]; then
    git clone git://github.com/sfjro/aufs5-standalone.git -b aufs5.x-rcN aufs-standalone
fi

cd /root/rpmbuild/SOURCES/aufs-standalone
export HEAD_COMMIT=$(git rev-parse --short HEAD); git archive $HEAD_COMMIT > ../aufs-standalone.tar

cd /root/rpmbuild/SOURCES/
rm -rf aufs-standalone

cd /root/rpmbuild/SPECS/
spectool -g -C /root/rpmbuild/SOURCES/ kernel-rc-aufs-$KERNEL_BASE_VERSION.spec
rpmbuild -bs kernel-rc-aufs-$KERNEL_BASE_VERSION.spec

cd /root/rpmbuild/SRPMS/
rpmbuild --rebuild kernel-rc-aufs-$KERNEL_FULL_VERSION-$RELEASE_VERSION.el8.src.rpm

mkdir -p /root/ml

mkdir -p /root/ml/SRPMS
cp -av /root/rpmbuild/SRPMS/* /root/ml/SRPMS/
cp -av /root/rpmbuild/RPMS/* /root/ml/
