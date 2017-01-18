#!/bin/sh

while true; do ping -c1 www.google.com > /dev/null && break; done
