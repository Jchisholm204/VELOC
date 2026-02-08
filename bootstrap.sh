#!/usr/bin/env bash

# Get the local repo dir
REPO_DIR=$(git rev-parse --show-toplevel)

PRJ_DEPS_DIR="$REPO_DIR/deps"

# Bootstrap Python
if [ -z "$PYTHONUSERBASE" ]; then
    export PYTHONUSERBASE=$HOME/.local
fi

# Ensure Python Dependencies are met
if  python3 -c "import wget, bs4" 2>/dev/null ; then
    echo "Python Dependencies met, skipping install..."
else
    wget https://bootstrap.pypa.io/get-pip.py && python3 get-pip.py --user
    $PYTHONUSERBASE/bin/pip3 install wget --user
    $PYTHONUSERBASE/bin/pip3 install bs4 --user
    rm -rf get-pip.py
fi

# $1 - Git Repo
# $2 - Version
function check_clone_dep(){
    if [ "$#" != 2 ]; then
        printf "Clone Dependencies expected 2 arguments, got $#\n"
    fi
    local filename="${1##*/}"
    local name="${filename%%.*}"
    # Check if dep already exists
    if [ -d "$PRJ_DEPS_DIR/$name" ]; then
        printf "Found $name in $PRJ_DEPS_DIR, skipping...\n"
    else
        git clone -b $2 --depth 1 $1 "$PRJ_DEPS_DIR/$name" > /dev/null 2>&1
        printf "Cloned $name in $PRJ_DEPS_DIR\n"
    fi
}

if [ ! -d "$PRJ_DEPS_DIR" ]; then
    echo "Project dependencies folder not found..\n Creating $PRJ_DEPS_DIR now."
    mkdir "$PRJ_DEPS_DIR"
fi

# Check and clone all project dependencies seperately
check_clone_dep 'https://github.com/ECP-VeloC/KVTree.git' 'v1.4.0'
check_clone_dep 'https://github.com/ECP-VeloC/AXL.git' 'v0.8.0'
check_clone_dep 'https://github.com/ECP-VeloC/rankstr.git' 'v0.3.0'
check_clone_dep 'https://github.com/ECP-VeloC/shuffile.git' 'v0.3.0'
check_clone_dep 'https://github.com/ECP-VeloC/redset.git' 'v0.3.0'
check_clone_dep 'https://github.com/ECP-VeloC/er.git' 'v0.4.0'
