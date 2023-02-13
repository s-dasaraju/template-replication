#!/bin/bash
MYHUBID=jccisneros
MYIMG=template

docker image rm $MYHUBID/${MYIMG}:$TAG

docker container prune -f
