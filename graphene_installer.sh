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

clear
logo
    echo "Which Pixel are you flashing? "
    echo "1. Pixel 3        5. Pixel 4       9. Pixel 5" 
    echo "2. Pixel 3 XL     6. Pixel 4 XL    10. Pixel 5a" 
    echo "3. Pixel 3a       7. Pixel 4a                  " 
    echo "4. Pixel 3a XL    8. Pixel 4a 5G               "
    echo ""
    read -p "Select Model > " pixel_model
    read -p "Select Firmware Version (ex. 2021.06.09.13 > " date_picked
    read -p "Enter Install Directory > " global_dir
    clear

    echo -e "\033[0;31m'Please ensure that 'OEM unlocking' and 'USB Debugging' are enabled"
    sleep 3s


      echo "Downloading GrapheneOS. . ."
    sleep 2s
    cd $global_dir


    case $pixel_model in
        
        1)
            # Pixel 3
            curl -O https://releases.grapheneos.org/blueline-factory-$date_picked.zip
            curl -O https://releases.grapheneos.org/blueline-factory-$date_picked.zip.sig
        ;;
       
        2)
            # Pixel 3 XL
            curl -O https://releases.grapheneos.org/crosshatch-factory-$date_picked.zip
            curl -O https://releases.grapheneos.org/crosshatch-factory-$date_picked.zip.sig
        ;;

        3) 
            # Pixel 3a
            curl -O https://releases.grapheneos.org/sargo-factory-$date_picked.zip
            curl -O https://releases.grapheneos.org/sargo-factory-$date_picked.zip.sig
        ;;

        4) 
            #Pixel 3a XL
            curl -O https://releases.grapheneos.org/bonito-factory-$date_picked.zip
            curl -O https://releases.grapheneos.org/bonito-factory-$date_picked.zip.sig
        ;;
        5)
            # Pixel 4
            curl -O https://releases.grapheneos.org/flame-factory-$date_picked.zip
            curl -O https://releases.grapheneos.org/flame-factory-$date_picked.zip.sig
        ;;

        6)
            # Pixel 4 XL
            curl -O https://releases.grapheneos.org/coral-factory-$date_picked.zip
            curl -O https://releases.grapheneos.org/coral-factory-$date_picked.zip.sig
        ;;

        7)
            # Pixel 4a
            curl -O https://releases.grapheneos.org/sunfish-factory-$date_picked.zip
            curl -O https://releases.grapheneos.org/sunfish-factory-$date_picked.zip.sig
        ;;

        8)
            # Pixel 4a 5G
            curl -O https://releases.grapheneos.org/bramble-factory-$date_picked.zip
            curl -O https://releases.grapheneos.org/bramble-factory-$date_picked.zip.sig
        ;;
        
        9)
            # Pixel 5
            curl -O https://releases.grapheneos.org/redfin-factory-$date_picked.zip
            curl -O https://releases.grapheneos.org/redfin-factory-$date_picked.zip.sig
        ;;

        10)
            # Pixel 5a
            curl -O https://releases.grapheneos.org/barbet-factory-$date_picked.zip
            curl -O https://releases.grapheneos.org/barbet-factory-$date_picked.zip.sig
        ;;

        

    esac



    echo "Checking for platform-tools. . ."

    if [ -d "$global_dir/platform-tools" ]
then
    echo "Tools exist"
    sleep 3s

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
    read -n 1 -s -r -p "Press any key when your phone is connected"
    clear
    echo "Unlocking Bootloader. . ."
    fastboot flashing unlock

    echo "Downloading verification key. . ."
    curl -O https://releases.grapheneos.org/factory.pub

    read -p "Drag Firmware here > " frmware_path
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
fi

echo "Script complete! For issues or to attempt manual CLI install,"
echo "visit https://grapheneos.org/install/cli"

}
