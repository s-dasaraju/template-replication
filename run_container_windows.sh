#!/bin/bash
MYHUBID=jccisneros
WINDOWS_USER=$(/mnt/c/Windows/System32/cmd.exe /c 'echo %USERNAME%' | sed -e 's/\r//g')
MYIMG=template
STATALIC="/mnt/c/Program Files/Stata17/stata.lic"
DROPBOX="/mnt/c/Users/$WINDOWS_USER/Dropbox (GSLab)"
GITHUB="/mnt/c/Users/$WINDOWS_USER/.ssh"

docker run -it --rm \
  -v "${STATALIC}":/usr/local/stata/stata.lic:ro \
  -v "${DROPBOX}":/home/statauser/dropbox:ro \
  -v "${GITHUB_KEY}":/home/statauser/.ssh:ro \
  -v "$(pwd)":/home/statauser/template \
  -w /home/statauser/template \
  $MYHUBID/${MYIMG} -; echo "Container removed"