 
# BetterGallery

BetterGallery is a Qt5-based application for SteamDeck that lets you traverse through all of the screenshots of your games - unlike the stock SteamDeck Media gallery.

![BetterGallery](https://github.com/mozcelikors/BetterGallery/blob/main/preview_imgs/preview.png?raw=true)

![BetterGallery](https://github.com/mozcelikors/BetterGallery/blob/main/preview_imgs/preview2.png?raw=true)

![BetterGallery](https://github.com/mozcelikors/BetterGallery/blob/main/preview_imgs/preview3.png?raw=true)

## Features

* BetterGallery lets you quickly traverse through all your screenshots with ease.
* Downloads game header images automatically on first launch (might take a while).
* Full screen in handheld mode is supported (1280x800).
* Ability to select and remove screenshots.

## Installation Intstructions

### Mandatory Steps

To proceed with the installation, go to SteamDeck desktop mode, plug in keyboard, mouse, and monitor to your device.
We advise you to install this application on your SD card instead of the SteamDeck storage. Do the following at your own risk.

Before we begin, make sure to create a sudo password:

```
passwd
```

Clone the repository with following:

```
cd /run/media/mmcblk0p1
git clone https://github.com/mozcelikors/BetterGallery
cd BetterGallery
```

Now, Qt5 along with some build tools need to be installed on the SteamDeck with the following command. You will be prompted to enter your password. For about 4-5 times package manager will ask you to enter packages to install. You just need to press "Enter" each time this is asked to install all packages.

```
./prepare_environment.sh
```

You should have a desktop icon for BetterGallery by now. Change it if you used different installation directory. Replace the "Exec" and "Icon" paths with the correct ones.

```
#!/usr/bin/env xdg-open
[Desktop Entry]
Name=BetterGallery
Comment=BetterGallery
Exec=/run/media/mmcblk0p1/BetterGallery/run_better_gallery.sh
Icon=/run/media/mmcblk0p1/BetterGallery/qtapplogo.png
Type=Application

```

Right click onto it and select "Add to Steam".

Now we are ready to copy our logo to the Steam app:

```
./add-steamgrid-image.sh
```

### Do this only if you logged in with more than one Steam account in your SteamDeck
After this step, all that's left is to change some variables specific to your Steam account. Go inside `run_better_gallery.sh and edit following line with your steam User ID.

```
export STEAMUSERID=$(ls /home/deck/.local/share/Steam/userdata/)
```

You can obtain your STEAMUSERID as follows:

```
ls /home/deck/.local/share/Steam/userdata/
```

### Troubleshooting

You might also need to adjust location of the screenshots from `init-prepare-game-lists.sh` script if you are running to issues. Default value is as follows:

```
SCREENSHOTSDIR=/home/deck/.local/share/Steam/userdata/$STEAMUSERID/760/remote
```

## Controller Configuration

`BetterGallery` application is optimized for keyboard inputs. However, SteamDeck allows us to customize layouts.

For this application, we propose you use `Web Browser` layout but map following additional keys:

```
A button => Keyboard Return/Enter
B button => Keyboard Backspace
```

With these keys traversal of screenshots will be seamless.
We will hopefully automize this controller set-up procedure once we find it out!

## Running

If installation is correct, you should be able to run it from your Steam library both in desktop and gaming modes. Furthermore, you can double click to the shortcut at the desktop. Enjoy!
