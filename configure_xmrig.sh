#!/bin/bash

# Define color variables
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Define pool options
pool_options=(
    "pool.hashvault.pro:80"
    "pool.hashvault.pro:443"
    "pool.hashvault.pro:3333"
    "Custom Pool URL"
)

# Function to configure XMRig
configure_xmrig() {
    # Prompt for pool selection
    echo -e "${YELLOW}Select a pool to mine Monero (XMR):${NC}"
    for i in "${!pool_options[@]}"; do
        echo "[$i] - ${pool_options[$i]}"
    done

    read -p "Enter the number corresponding to your choice: " pool_choice
    
    # Validate pool choice
    if [[ "$pool_choice" =~ ^[0-9]+$ ]] && [ "$pool_choice" -ge 0 ] && [ "$pool_choice" -lt "${#pool_options[@]}" ]; then
        if [ "$pool_choice" -eq $(( ${#pool_options[@]} - 1 )) ]; then
            # Custom Pool URL
            read -p "Enter the custom pool URL (leave blank for default): " pool_url
            if [ -z "$pool_url" ]; then
                pool_url="${pool_options[$(( ${#pool_options[@]} - 1 ))]}"
            else
                validate_url "$pool_url"
            fi
        else
            pool_url="${pool_options[$pool_choice]}"
        fi
    else
        echo -e "${RED}Invalid pool choice. Exiting...${NC}"
        exit 1
    fi

    # Prompt for wallet address
    read -p "Enter your XMR wallet address: " wallet_address

    # Remove old run_xmrig.sh if exists
    if [ -f run_xmrig.sh ]; then
        rm run_xmrig.sh
    fi

    # Create run script
    echo -e "#!/bin/bash\n\n./xmrig --url $pool_url --user $wallet_address --pass x" > run_xmrig.sh

    # Make run script executable
    chmod +x run_xmrig.sh

    echo -e "${GREEN}XMRig has been configured successfully.${NC}"
    
    read -p "Do you want to run XMRig now? (y/n): " run_choice
    if [ "$run_choice" == "y" ] || [ "$run_choice" == "Y" ]; then
        echo -e "${GREEN}Running XMRig...${NC}"
        ./run_xmrig.sh
    else
        echo -e "To run XMRig later, execute the following command: ${YELLOW}./run_xmrig.sh${NC}"
        exit 0
    fi
}

# Function to validate the custom pool URL
validate_url() {
    local url=$1
    if [[ $url != http* ]]; then
        url="http://$url"
    fi

    if curl --output /dev/null --silent --head --fail "$url"; then
        echo -e "${GREEN}Custom pool URL is valid.${NC}"
    else
        echo -e "${RED}Invalid custom pool URL. Exiting...${NC}"
        exit 1
    fi
}

# Check if run_xmrig.sh exists
if [ -f run_xmrig.sh ]; then
    echo -e "${YELLOW}XMRig is already configured.${NC}"
    read -p "Do you want to reconfigure XMRig? (y/n): " reconfigure_choice
    if [ "$reconfigure_choice" == "y" ] || [ "$reconfigure_choice" == "Y" ]; then
        configure_xmrig
    else
        echo -e "${GREEN}Exiting...${NC}"
        exit 0
    fi
else
    configure_xmrig
fi
