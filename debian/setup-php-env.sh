#!/bin/bash

# Set home folder and username
USERNAME="nicholaslleite"
HOME_FOLDER="/home/${USERNAME}"

# Check for system updates
sudo apt update && sudo apt upgrade -y

# Installs the needed tools
sudo apt install -y lsb-release ca-certificates apt-transport-https software-properties-common gnupg curl

# Add repo's GPG key
curl -fsSL https://packages.sury.org/php/apt.gpg | sudo gpg --dearmor -o /usr/share/keyrings/php.gpg

# Added the repository to the APT
echo "deb [signed-by=/usr/share/keyrings/php.gpg] https://packages.sury.org/php/ $(lsb_release -sc) main" | sudo tee /etc/apt/sources.list.d/php.list

# Current PHP Version
CURRENT_PHP_VERSION=8.4

# Installing PHP (current version) with https://php.new
echo
echo "Installing PHP with https://php.new"
/bin/bash -c "$(curl -fsSL https://php.new/install/linux/${CURRENT_PHP_VERSION})"

# PHP Versions (from 7.4)
PHP_VERSIONS=("8.3" "8.2" "8.1" "8.0" "7.4")

# Common PHP extensions for general development
COMMON_EXTENSIONS=(
    bcmath bz2 curl intl mbstring mysql
    readline soap xml zip cli common opcache
)

# Laravel-specific extensions
LARAVEL_EXTENSIONS=(
    gd imagick fileinfo
)

# Install each PHP version with extensions
for version in "${PHP_VERSIONS[@]}"; do
    echo "Installing PHP $version..."

    sudo apt install -y php$version php$version-fpm

    # Install common extensions
    for ext in "${COMMON_EXTENSIONS[@]}"; do
        sudo apt install -y php$version-$ext
    done

    # Install Laravel-specific extensions
    for ext in "${LARAVEL_EXTENSIONS[@]}"; do
        sudo apt install -y php$version-$ext
    done

    # Register with update-alternatives
    sudo update-alternatives --install /usr/bin/php php /usr/bin/php$version 100
done

echo
echo "All PHP versions and extensions have been installed."
echo "You can switch between versions using:"
echo "  sudo update-alternatives --config php"
