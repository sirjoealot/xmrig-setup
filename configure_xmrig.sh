#!/bin/bash

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
    echo "Select a pool to mine Monero (XMR):"
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
        echo "Invalid pool choice. Exiting..."
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

    echo "XMRig has been configured successfully."
}

# Function to validate the custom pool URL
validate_url() {
    local url=$1
    if [[ $url != http* ]]; then
        url="http://$url"
    fi

    if curl --output /dev/null --silent --head --fail "$url"; then
        echo "Custom pool URL is valid."
    else
        echo "Invalid custom pool URL. Exiting..."
        exit 1
    fi
}

# Check if run_xmrig.sh exists
if [ -f run_xmrig.sh ]; then
    echo "XMRig is already configured."
    read -p "Do you want to reconfigure XMRig? (y/n): " reconfigure_choice
    if [ "$reconfigure_choice" == "y" ] || [ "$reconfigure_choice" == "Y" ]; then
        configure_xmrig
    else
        echo "Exiting..."
        exit 0
    fi
else
    configure_xmrig
fi

# Execute run script
./run_xmrig.sh
