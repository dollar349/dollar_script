#!/bin/sh

bitbake obmc-phosphor-image && rm -rf /tftpboot/${USER}/image-* && cp tmp/deploy/images/*/image-* /tftpboot/${USER}/.
