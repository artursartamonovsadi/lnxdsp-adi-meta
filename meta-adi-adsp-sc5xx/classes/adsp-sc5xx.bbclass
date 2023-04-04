inherit core-image extrausers adsp-sc5xx-compatible adsp-fit-generation

SUMMARY = "Minimal image for Analog Devices ADSP-SC5xx boards"
LICENSE = "MIT"

INITRD_NAME = "adsp-sc5xx-ramdisk-${MACHINE}.cpio.gz"

ICC = " \
	rpmsg-utils \
"

CRYPTO = " \
    openssl \
    openssl-bin \
    cryptodev-linux \
    cryptodev-module \
    crypto-tests \
    crc-tests \
"

IMAGE_INSTALL = " \
    packagegroup-core-boot \
    packagegroup-base \
    ${CORE_IMAGE_EXTRA_INSTALL} \
    alsa-utils \
    openssh \
    openssl \
    iproute2 \
    iproute2-tc \
    ncurses \
    busybox-watchdog-init \
    util-linux \
    rng-tools \
    spidev-test \
    spitools \
    ${ICC} \
    ${CRYPTO} \
    libgpiod libgpiod-tools \
"

# printf "%q" $(mkpasswd -m sha256crypt adi)
PASSWD_ROOT = "\$5\$j9T8zDE13LXUGyc6\$utDvGwFWR.kt/AKwwbHnXC14HJBqbcWwvLoDDLMQrc8"
EXTRA_USERS_PARAMS = "usermod -p '${PASSWD_ROOT}' root;"

TOOLCHAIN_HOST_TASK:append = " nativesdk-openocd-adi"

IMAGE_FSTYPES:append = " tar.xz jffs2 "

#For some reason on poky-tiny, INIT_MANAGER="systemd" does not appear to work
#For now, let's relink directly to systemd
fakeroot do_set_init(){
    rm -rf ${IMAGE_ROOTFS}/sbin/init
    ln -s /lib/systemd/systemd ${IMAGE_ROOTFS}/sbin/init
}

addtask do_set_init after do_rootfs before do_image
