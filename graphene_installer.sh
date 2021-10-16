#!/bin/bash

function logo() {
echo -e "\033[0;34m          |             "
echo "          |             "
echo "          O             "
echo "   \    /   \   /      "
echo "    \  /     \ /       "
echo "      O       O         "
echo -e " \033[0;34m     |       |    \033[0;32mGrapheneOS Security    "
echo -e "  \033[0;34m    |       |          "
echo -e "  \033[0;34m    O       O         "
echo -e "     /  \    / \         \033[0;32mFree your Pixel >>    "
echo -e " \033[0;34m   /    \  /   \      "
echo "          O             "
echo "          |             "
echo -e "          |       \033[1;31m                    Coded by ~flyaway~      "
echo -e "\033[1;37m---------------------------------------------------------"
}

function flash_process() {
    echo "Please boot phone into recovery"
    echo "**Reboot and then hold volume down until you're in recovery"
    read -n 1 -s -r -p "Press any key when your phone is connected and in recovery"
    clear
    echo "Unlocking Bootloader. . ."
    fastboot flashing unlock

    echo "Downloading verification key. . ."
    curl -O https://releases.grapheneos.org/factory.pub

    read -p "Drag .zip firmware package here > " frmware_path
    signify -Cqp factory.pub -x  $frmware_path && echo verified
    sleep 3s
    echo "Make sure it says 'verified'"

    echo "Extracting Image. . ."
    bsdtar xvf $frmware_path
    read -p "Drag extracted firmware folder here > " extracted_frmware

    echo "Flashing. . ."
    cd $extracted_frmware
    ./flash-all.sh
    read -n 1 -s -r -p "Press any key when your phone is back in recovery/bootloader"

    echo "Complete. Re-Locking Bootloader. . ."
    fastboot flashing lock
    sleep 5s

    clear
    logo
    echo "Congradulations! Enjoy GrapheneOS"
}

function menu() {
    clear
logo
    echo "Which Pixel are you flashing? "
    echo "|Pixel 3 (blueline)        | Pixel 4 (flame)         | 9. Pixel 5 (redfin)" 
    echo "|Pixel 3 XL (crosshatch)   | Pixel 4 XL (coral)      | 10.Pixel 5a (barbet)" 
    echo "|Pixel 3a (sargo)          | Pixel 4a (sunfish)                  " 
    echo "|Pixel 3a XL (bonito)      | Pixel 4a 5G (bramble)               "
    echo "                                                     |Manual Unlock Bootloader: 'unlock'"
    echo "                                                     |Manual Lock Bootloader: 'lock'"
    echo ""
}

function options() {
     read -p "Codename or option > " pixel_model
    case $pixel_model in

    unlock)
        fastboot flashing unlock; menu; options ;;
    lock)
        fastboot flashing lock; menu; options ;;
    esac
    read -p "Select Firmware Version (ex. 2021.06.09.13) > " date_picked
    read -p "Enter Install Directory > " global_dir
    clear

    echo -e "\033[0;31m'Please ensure that 'OEM unlocking' and 'USB Debugging' are enabled"
    sleep 5s


      echo "Downloading GrapheneOS. . ."
    sleep 2s

    curl -O https://releases.grapheneos.org/$mpixel_model-factory-$date_picked.zip
    curl -O https://releases.grapheneos.org/$pixel_model-factory-$date_picked.zip.sig

    echo "Checking for platform-tools. . ."

    if [ -d "$global_dir/platform-tools" ]
then
    echo "Tools exist"
    sleep 3s

    flash_process
else
    echo "Tools don't exist"
    sleep 2s
    echo "Installing . . ."
    cd $global_dir
    sudo apt install libarchive-tools
    curl -O https://dl.google.com/android/repository/platform-tools_r31.0.3-linux.zip
    echo 'e6cb61b92b5669ed6fd9645fad836d8f888321cd3098b75588a54679c204b7dc  platform-tools_r31.0.3-linux.zip' | sha256sum -c
    bsdtar xvf platform-tools_r31.0.3-linux.zip

    echo "Adding to PATH. . ."
    export PATH="$PWD/platform-tools:$PATH"

    echo "Installing signify. . ."
    sudo apt install signify-openbsd
    alias signify=signify-openbsd

    echo "Script can continue"
    sleep 2s
    flash_process
fi
}

menu
options


echo "Script complete! For issues or to attempt manual CLI install,"
echo "visit https://grapheneos.org/install/cli"

}
