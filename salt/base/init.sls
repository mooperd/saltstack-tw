
# Install all basic packages required by all of our instances
base.installed:
  pkg.installed:
    - pkgs:
      
      - java-1.8.0-openjdk

      # Install semanage
      - policycoreutils-python

      # Enable EPEL (Extra Packages for Enterprise Linux) repository
      - epel-release

      # Install PIP (Pip Installs Python / PIP Installs Packages)
      - python-pip:
