You should probably make a backup of your keyboard before installing, just in case :

    <from your computer>
    $ ssh nemo@<device ip address>
    <type password (configured in settings/developper mode)>
    $ devel-su
    <type password (configured in settings/developper mode)>
    # cp -R /usr/share/maliit/plugins/com/jolla /usr/share/maliit/plugins/com/jolla_BACK

To install the keyboard on your device :

    <from your computer>
    $ ssh nemo@<device ip address>
    $ devel-su
    # cp -RT /path/to/keyboard/ /usr/share/maliit/plugins/com/jolla/
    # systemctl --user restart maliit-server
    
    * Then from the device, go to settings, Text Input, Keyboard, select Ease
    * From your keyboard, long press on the spacebar, select Ease layout
    
    