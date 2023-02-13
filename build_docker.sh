#!/bin/bash
MYHUBID=jccisneros
MYIMG=template
STATALIC="/Applications/Stata/stata.lic"

DOCKER_BUILDKIT=1 docker build  . \
  --secret id=statalic,src="$STATALIC" \
  -t $MYHUBID/${MYIMG}