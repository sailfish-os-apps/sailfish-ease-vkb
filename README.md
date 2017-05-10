# Sailfish Ease virtual Keyboard

![Preview](http://i.imgur.com/mekiJ4X.png "Sailfish Ease keyboard Preview")
![Preview](http://i.imgur.com/LheLfqC.png "Sailfish Ease keyboard Preview")

# Sailfish Loopen virtual Keyboard

[![Preview](https://img.youtube.com/vi/ABPYkV7qKq0/0.jpg)](https://www.youtube.com/watch?v=ABPYkV7qKq0)


# Installation

You should probably make a backup of your keyboard before installing, just in case :

```
<from your computer>
$ ssh nemo@<device ip address>
<type password (configured in settings/developper mode)>
$ devel-su
<type password (configured in settings/developper mode)>
# cp -R /usr/share/maliit/plugins/com/jolla /usr/share/maliit/plugins/com/jolla_BACK
```

To install the keyboard on your device :

```
<from your computer>
$ ssh nemo@<device ip address>
$ devel-su
# cp -RT /path/to/keyboard/ /usr/share/maliit/plugins/com/jolla/
# systemctl --user restart maliit-server

* Then from the device, go to settings, Text Input, Keyboard, select Ease
* From your keyboard, long press on the spacebar, select Ease layout
```
    
# How to use it

The 9 most used letter are in a 3x3 grid, just tap the letter to input any of the 9
```
to input "a", just tap on "a"
```
the remaining of the alphabet is showed around each of the 9 letters : you swipe from that letter to the direction of the letter you want, the letter selected is shown instead of the main letter, inside the circle
```
to input "k", press "h" then swipe to the right
```
Special characters are available but not shown by default, you can tap the bottom left key "*.$" to make them appear.
At any time (whether they are visible or not) you can input a special character the same way you input other letter
```
to input ".", press "e" then swipe down
```
Numbers are available by pressing the "?123" key on the right

You can input accentuated characters by entering the diacritics you want to use after the character
```
to input "é", input "e" then input "´" ("n" then swipe up-right)
```
if you wanted to input two characters but they got automatically merge, you can press the erase key on the top right (the arrow with a X)
```
if you wanted to input "e´" but you got "é", just press erase
```
