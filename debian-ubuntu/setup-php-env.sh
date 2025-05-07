#!/bin/bash

# Check for system updates
sudo apt update && sudo apt upgrade -y

# Installs the needed tools
sudo apt install -y software-properties-common apt-transport-https lsb-release ca-certificates curl

# Added the necessary PPA repositories
sudo add-apt-repository ppa:ondrej/php -y
sudo apt update

# PHP Versions
PHP_VERSIONS=("8.3", "8.2", "8.1", "8.0", "7.4")

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
