#!/bin/bash
set -e


git init
touch README.md
echo "Cisco CT" >> README.md
mkdir -p topology-1/diagrams\
    topology-1/switch\
    topology-1/multiplayer-switch\
    topology-1/routers/router-ent\
    topology-1/routers/router-internet\
    topology-1/hosts
touch topology-1/switch/vlan.config\
    topology-1/switch/interfaces.config\
    topology-1/routers/router-ent/global.config\
    topology-1/routers/router-ent/subinterfaces.config