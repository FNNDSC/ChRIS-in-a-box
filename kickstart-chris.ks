# set locale defaults for the Install
lang en_US.UTF-8
keyboard us
timezone UTC

# initialize any invalid partition tables and destroy all of their contents
zerombr

# erase all disk partitions and create a default label
clearpart --all --initlabel

# automatically create xfs partitions with no LVM and no /home partition
autopart --type=plain --fstype=xfs --nohome

# reboot after installation is successfully completed
reboot

# installation will run in text mode
text

# activate network devices and configure with DHCP
network --bootproto=dhcp

# create default user with sudo privileges
user --name={{ rfe_user | default('core') }} --groups=wheel --password={{ rfe_password | default('edge') }}

# set up the OSTree-based install with disabled GPG key verification, the base
# URL to pull the installation content, 'rhel' as the management root in the
# repo, and 'rhel/8/x86_64/edge' as the branch for the installation
ostreesetup --nogpg --url={{ rfe_tarball_url }}/repo/ --osname=rhel --remote=edge --ref=rhel/8/x86_64/edge

%post

# Set the update policy to automatically download and stage updates to be
# applied at the next reboot
#stage updates as they become available. This is highly recommended
echo AutomaticUpdatePolicy=stage >> /etc/rpm-ostreed.conf


cat > /etc/greenboot/check/required.d/startchris.sh << PODMANSCRIPT
#!/bin/bash
echo "This next few steps of ths script will clone the git repo for chris in a box and set few environment variables"

# Git repository for Chris
GIT_REPO_URL="https://github.com/FNNDSC/ChRIS-in-a-box.git"

# Replace with the desired directory where the repository will be cloned
CLONE_DIR="/opt"

# Replace with the name of the shell script to execute
SCRIPT_NAME="minichris.sh"

# Clone the Git repository
git clone "$GIT_REPO_URL" "$CLONE_DIR"

# Navigate to the cloned repository directory
cd "$CLONE_DIR"

#commands to start your podman pods in the order

echo "We will be running script to create the pods for Chris in a box using Podman using the script below "

# Execute the shell script that will bring chris up
./podman/"$SCRIPT_NAME" up

PODMANSCRIPT

chmod 755 /etc/greenboot/check/required.d/startchris.sh

cat > /etc/systemd/system/chris.service << 'EOF'

[Unit]
Description=Deploy Chris in a box using Podman
After=network.target

[Service]
Type=simple
User=admin    # Replace with the desired user who should run the service

ExecStart=/bin/bash /usr/local/bin/startchris.sh

[Install]
WantedBy=multi-user.target

systemctl enable chris.service

%end
