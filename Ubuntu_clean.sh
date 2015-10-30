#!/bin/sh
sudo apt-get clean
sudo apt-get autoclean
sudo apt-get autoremove -y
sudo rm -rf /var/log/*
sudo rm -rf /var/cache/apt/archives/*
