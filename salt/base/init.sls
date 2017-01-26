# The Continuous Release (CR) Repository
# https://wiki.centos.org/AdditionalResources/Repositories/CR
yum.cr:
  cmd.run:
    - name: yum-config-manager --enable cr

# Install all basic packages required by all of our instances
base.installed:
  pkg.installed:
    - pkgs:

      # Install semanage
      # (Should be installed by default on minimal Linux but it's not present on the bento/centos-7.1 image)
      - policycoreutils-python

      # Enable EPEL (Extra Packages for Enterprise Linux) repository
      - epel-release

      # Install PIP (Pip Installs Python / PIP Installs Packages)
      - python-pip:
