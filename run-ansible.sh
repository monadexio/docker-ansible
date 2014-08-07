#!/bin/bash

usage(){
cat <<EOF
usage: $0 options

OPTIONS:
    -h       Hostname
    -i       Path to the inventory file
    -p       Path to the playbook to be executed
    -r       Path to the docker ansible directory

If -i and -p is not specified, they will be dirived from the path to the docker
ansible directory. If -r is not specified, it will be set to the current directory.

Default value for -h is localhost

example:
$0 -i /path/to/inventory_file -p /path/to/playbook -h hostname

EOF
}

print_info(){
cat <<EOF
Current setup:
- Seal docker ansible root directory: $SEAL_ANSIBLE_DOCKER_ROOT
- Seal docker ansible inventory file: $SEAL_ANSIBLE_DOCKER_INVENTORY_FILE
- Seal docker ansible hostname: $SEAL_ANSIBLE_DOCKER_HOSTNAME
- Seal docker ansible playbook: $SEAL_ANSIBLE_DOCKER_PLAYBOOK
EOF
}

while getopts "h:i:p:r:v" OPTION
do
    case $OPTION in
        h)
            SEAL_ANSIBLE_DOCKER_HOSTNAME="$OPTARG"
            ;;
        i)
            SEAL_ANSIBLE_DOCKER_INVENTORY_FILE="$OPTARG"
            ;;
        p)
            SEAL_ANSIBLE_DOCKER_PLAYBOOK="$OPTARG"
            ;;
        r)
            SEAL_ANSIBLE_DOCKER_ROOT="$OPTARG"
            ;;
        v)
            SEAL_ANSIBLE_DOCKER_VERBOSE="TRUE"
            ;;
        ?)
            usage
            exit 1
            ;;
    esac
done

if [ -z "$SEAL_ANSIBLE_DOCKER_ROOT" ]; then
    SEAL_ANSIBLE_DOCKER_ROOT="$(pwd)"
fi

if [ -z "$SEAL_ANSIBLE_DOCKER_HOSTNAME" ]; then
    SEAL_ANSIBLE_DOCKER_HOSTNAME="localhost"
fi

if [ -z "$SEAL_ANSIBLE_DOCKER_PLAYBOOK" ]; then
    SEAL_ANSIBLE_DOCKER_PLAYBOOK="$SEAL_ANSIBLE_DOCKER_ROOT/playbooks/main.yml"
fi

if [ -z "$SEAL_ANSIBLE_DOCKER_INVENTORY_FILE" ]; then
    SEAL_ANSIBLE_DOCKER_INVENTORY_FILE="$SEAL_ANSIBLE_DOCKER_ROOT/target"
fi

if [ "$SEAL_ANSIBLE_DOCKER_VERBOSE" == "TRUE" ]; then
    print_info
fi

ansible-playbook -i "$SEAL_ANSIBLE_DOCKER_INVENTORY_FILE" --extra-vars="hosts=$SEAL_ANSIBLE_DOCKER_HOSTNAME" "$SEAL_ANSIBLE_DOCKER_PLAYBOOK"
