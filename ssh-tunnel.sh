#!/usr/bin/env bash

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

print_help() {
    echo -e "\n${CYAN}GUIDE:${NC}"
    echo "-----------------------------------------"
    echo -e "${YELLOW}Remote port forwarding:${NC}"
    echo "  - Use this if you have SSH access to a remote machine."
    echo "  - This allows someone else to connect to a service on YOUR machine via the remote server."
    echo ""
    echo "  Example:"
    echo "    ssh -R 9090:127.0.0.1:8080 user@remote-ip"
    echo "    This lets the remote machine (and anyone with access to it) reach your local 8080 via port 9090."
    echo ""
    echo -e "${YELLOW}Local port forwarding:${NC}"
    echo "  - Use this if a remote service is only accessible from the remote server."
    echo "  - This tunnels the remote service to your local machine."
    echo ""
    echo "  Example:"
    echo "    ssh -L 9090:127.0.0.1:8080 user@remote-ip"
    echo "    This lets YOU reach remote port 8080 by visiting 127.0.0.1:9090 on your machine."
    echo "-----------------------------------------"
}

# Validate port number (1-65535)
valid_port() {
    [[ "$1" =~ ^[0-9]+$ ]] && (( $1 >= 1 && $1 <= 65535 ))
}

read_nonempty() {
    local prompt="$1"
    local var
    while true; do
        read -rp "$prompt" var
        var="${var// /}" # remove all spaces
        if [[ -n "$var" ]]; then
            echo "$var"
            break
        else
            echo -e "${RED}Input cannot be empty. Please try again.${NC}"
        fi
    done
}

confirm() {
    read -rp "Proceed? (y/n): " yn
    case "$yn" in
        [Yy]* ) return 0 ;;
        * ) echo "Cancelled."; return 1 ;;
    esac
}

remote_forward() {
    echo ""
    local user
    user=$(read_nonempty "SSH username: ")
    local host
    host=$(read_nonempty "Remote host/IP: ")

    local local_port
    while true; do
        read -rp "Local port to expose (1-65535): " local_port
        if valid_port "$local_port"; then break; else echo -e "${RED}Invalid port. Try again.${NC}"; fi
    done

    local remote_port
    while true; do
        read -rp "Remote port to use for access (1-65535): " remote_port
        if valid_port "$remote_port"; then break; else echo -e "${RED}Invalid port. Try again.${NC}"; fi
    done

    echo -e "\n${GREEN}Running:${NC} ssh -R $remote_port:127.0.0.1:$local_port $user@$host"
    if confirm; then
        ssh -R "$remote_port":127.0.0.1:"$local_port" "$user@$host"
    fi
}

local_forward() {
    echo ""
    local user
    user=$(read_nonempty "SSH username: ")
    local host
    host=$(read_nonempty "Remote host/IP: ")

    local remote_port
    while true; do
        read -rp "Remote service port to forward (1-65535): " remote_port
        if valid_port "$remote_port"; then break; else echo -e "${RED}Invalid port. Try again.${NC}"; fi
    done

    local local_port
    while true; do
        read -rp "Local port to use on your machine (1-65535): " local_port
        if valid_port "$local_port"; then break; else echo -e "${RED}Invalid port. Try again.${NC}"; fi
    done

    echo -e "\n${GREEN}Running:${NC} ssh -L $local_port:127.0.0.1:$remote_port $user@$host"
    if confirm; then
        ssh -L "$local_port":127.0.0.1:"$remote_port" "$user@$host"
    fi
}

main() {
    while true; do
        echo ""
        echo -e "${CYAN}Remote machine or local machine? Type (help) to see a guide or (exit) to quit.${NC}"
        read -rp "> " input
        input="${input,,}"  # convert to lowercase

        case "$input" in
            help)
                print_help
                ;;
            remote)
                remote_forward
#!/usr/bin/env bash

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

print_help() {
    echo -e "\n${CYAN}GUIDE:${NC}"
    echo "-----------------------------------------"
    echo -e "${YELLOW}Remote port forwarding:${NC}"
    echo "  - Use this if you have SSH access to a remote machine."
    echo "  - This allows someone else to connect to a service on YOUR machine via the remote server."
    echo ""
    echo "  Example:"
    echo "    ssh -R 9090:127.0.0.1:8080 user@remote-ip"
    echo "    This lets the remote machine (and anyone with access to it) reach your local 8080 via port 9090."
    echo ""
    echo -e "${YELLOW}Local port forwarding:${NC}"
    echo "  - Use this if a remote service is only accessible from the remote server."
    echo "  - This tunnels the remote service to your local machine."
    echo ""
    echo "  Example:"
    echo "    ssh -L 9090:127.0.0.1:8080 user@remote-ip"
    echo "    This lets YOU reach remote port 8080 by visiting 127.0.0.1:9090 on your machine."
    echo "-----------------------------------------"
}

# Validate port number (1-65535)
valid_port() {
    [[ "$1" =~ ^[0-9]+$ ]] && (( $1 >= 1 && $1 <= 65535 ))
}

read_nonempty() {
    local prompt="$1"
    local var
    while true; do
        read -rp "$prompt" var
        # Trim leading/trailing spaces instead of removing all
        var="$(echo "$var" | xargs)"
        if [[ -n "$var" ]]; then
            echo "$var"
            break
        else
            echo -e "${RED}Input cannot be empty. Please try again.${NC}"
        fi
    done
}

confirm() {
    read -rp "Proceed? (y/n): " yn
    case "${yn,,}" in
        y|yes) return 0 ;;
        *) echo "Cancelled."; return 1 ;;
    esac
}

remote_forward() {
    echo ""
    local user
    user=$(read_nonempty "SSH username: ")
    local host
    host=$(read_nonempty "Remote host/IP: ")

    local local_port
    while true; do
        read -rp "Local port to expose (1-65535): " local_port
        if valid_port "$local_port"; then break; else echo -e "${RED}Invalid port. Try again.${NC}"; fi
    done

    local remote_port
    while true; do
        read -rp "Remote port to use for access (1-65535): " remote_port
        if valid_port "$remote_port"; then break; else echo -e "${RED}Invalid port. Try again.${NC}"; fi
    done

    echo -e "\n${GREEN}Running:${NC} ssh -R $remote_port:127.0.0.1:$local_port $user@$host"
    if confirm; then
        if ! ssh -R "$remote_port":127.0.0.1:"$local_port" "$user@$host"; then
            echo -e "${RED}SSH connection failed.${NC}"
        fi
    fi
}

local_forward() {
    echo ""
    local user
    user=$(read_nonempty "SSH username: ")
    local host
    host=$(read_nonempty "Remote host/IP: ")

    local remote_port
    while true; do
        read -rp "Remote service port to forward (1-65535): " remote_port
        if valid_port "$remote_port"; then break; else echo -e "${RED}Invalid port. Try again.${NC}"; fi
    done

    local local_port
    while true; do
        read -rp "Local port to use on your machine (1-65535): " local_port
        if valid_port "$local_port"; then break; else echo -e "${RED}Invalid port. Try again.${NC}"; fi
    done

    echo -e "\n${GREEN}Running:${NC} ssh -L $local_port:127.0.0.1:$remote_port $user@$host"
    if confirm; then
        if ! ssh -L "$local_port":127.0.0.1:"$remote_port" "$user@$host"; then
            echo -e "${RED}SSH connection failed.${NC}"
        fi
    fi
}

main() {
    while true; do
        echo ""
        echo -e "${CYAN}Remote machine or local machine? Type (help) to see a guide or (exit) to quit.${NC}"
        read -rp "> " input
        # Portable lowercase conversion
        input="$(echo "$input" | tr '[:upper:]' '[:lower:]')"

        case "$input" in
            help)
                print_help
                ;;
            remote)
                remote_forward
                ;;
            local)
                local_forward
                ;;
            exit|quit)
                echo "Bye!"
                exit 0
                ;;
            *)
                echo -e "${RED}Not a valid option.${NC} Please type either (remote), (local), (help), or (exit)."
                ;;
        esac
    done
}

main
                ;;
            local)
                local_forward
                ;;
            exit|quit)
                echo "Bye!"
                exit 0
                ;;
            *)
                echo -e "${RED}Not a valid option.${NC} Please type either (remote), (local), (help), or (exit)."
                ;;
        esac
    done
}

main
