#!/bin/sh
MACHTTPSERVER="/media/psf/Home/httpserver"
UBUNTUHTTPSERVER="/var/www/dollar"
sudo mount --bind ${MACHTTPSERVER} ${UBUNTUHTTPSERVER}
