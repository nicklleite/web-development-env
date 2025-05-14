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

# PHP Versions
PHP_VERSIONS=("8.4" "8.3" "8.2" "8.1" "8.0" "7.4")

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

# Install Composer
IS_COMPOSER_INSTALLING=true

while $IS_COMPOSER_INSTALLING; do
    echo "Downloading Composer..."
    
    cd $HOME_FOLDER
    php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
    php -r "if (hash_file('sha384', 'composer-setup.php') === 'dac665fdc30fdd8ec78b38b9800061b4150413ff2e3b6f88543c636f7cd84f6db9189d43a81e5503cda447da73c7e5b6') { echo 'Installer verified'.PHP_EOL; } else { echo 'Installer corrupt'.PHP_EOL; unlink('composer-setup.php'); exit(1); }"
    php composer-setup.php
    php -r "unlink('composer-setup.php');"
    
    echo
    echo "Creating global executable for Composer..."
    sudo ln -s $HOME_FOLDER/composer.phar /usr/local/bin/composer
    
    IS_COMPOSER_INSTALLING=false
done

# Install Laravel installer
IS_LARAVEL_INSTALLING=true

while $IS_LARAVEL_INSTALLING; do
    echo "Installing Laravel Installer..."

    composer global require laravel/installer

    echo
    echo "Creating global executable for Laravel Installer..."
    sudo ln -s $HOME_FOLDER/.config/composer/vendor/bin/laravel /usr/local/bin/laravel

    IS_LARAVEL_INSTALLING=false
done

echo
echo "All PHP versions and extensions have been installed."
echo "You can switch between versions using:"
echo "  sudo update-alternatives --config php"
