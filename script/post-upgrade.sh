#!/bin/bash

PACKAGES_TO_REMOVE=(
)

FILES_TO_REMOVE=(
   "/.viminfo"
   "/.history"
   "/.zcompdump"
   "/var/log/emerge.log"
   "/var/log/emerge-fetch.log"
)

PACKAGES_TO_ADD=(
    "app-text/pastebunz"
    "app-admin/perl-cleaner"
    "sys-apps/grep"
    "app-misc/sabayon-version"
    "app-portage/layman"
    "app-portage/eix"
    "net-misc/rsync"
    "app-crypt/gnupg"
    "sys-devel/gcc::sabayon-distro"
    "sys-devel/base-gcc::sabayon-distro"
    "dev-vcs/git"
    "app-portage/gentoolkit"
    "net-misc/openssh"
    "sys-devel/automake"
)

# Handling install/removal of packages specified in env
emerge -j 2  "${PACKAGES_TO_ADD[@]}"

# Configuring layman
mkdir /etc/portage/repos.conf/
mkdir /var/lib/layman/
layman-updater -R

# Configuring repoman
mkdir -p /usr/portage/distfiles/ && wget http://www.gentoo.org/dtd/metadata.dtd -O /usr/portage/distfiles/metadata.dtd


# Cleanup Perl cruft
perl-cleaner --ph-clean

# remove SSH keys
rm -rf /etc/ssh/*_key*

# Configuring for build
echo "*" > /etc/eix-sync.conf
echo "y" | layman -f -a sabayon
echo "y" | layman -f -a sabayon-distro

# remove LDAP keys
rm -f /etc/openldap/ssl/ldap.pem /etc/openldap/ssl/ldap.key \
/etc/openldap/ssl/ldap.csr /etc/openldap/ssl/ldap.crt

# Remove scripts
rm -rf /post-upgrade.sh

# Cleanup
rm -rf "${FILES_TO_REMOVE[@]}"
