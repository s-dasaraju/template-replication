#!/bin/bash
MYHUBID=jccisneros
USER=$(whoami)
MYIMG=template
STATALIC="/Applications/Stata/stata.lic"
GITHUB_KEY="/Users/${USER}/.ssh" # Default SSH file name if following Github tutorial
DROPBOX="/Users/${USER}/Dropbox (GSLab)" # Change to Dropbox folder name

docker run -it --rm \
  -v "${STATALIC}":/usr/local/stata/stata.lic:ro \
  -v "${DROPBOX}":/home/statauser/dropbox:ro \
  -v "${GITHUB_KEY}":/home/statauser/.ssh:ro \
  -v "$(pwd)":/home/statauser/template \
  -w /home/statauser/template \
  $MYHUBID/${MYIMG} -; echo "Container removed"