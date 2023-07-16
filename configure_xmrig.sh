#!/bin/bash

# Define pool options
pool_options=(
    "pool.supportxmr.com:3333"
    "pool.minexmr.com:4444"
    "xmr-eu1.nanopool.org:14444"
    "xmr-us-west1.nanopool.org:14444"
    "xmr-asia1.nanopool.org:14444"
    "Custom Pool URL"
)

# Prompt for pool selection
echo "Select a pool to mine Monero (XMR):"
for i in "${!pool_options[@]}"; do
    echo "$i. ${pool_options[$i]}"
done

read -p "Enter the number corresponding to your choice: " pool_choice

# Validate pool choice
if [[ "$pool_choice" =~ ^[0-9]+$ ]] && [ "$pool_choice" -ge 0 ] && [ "$pool_choice" -lt "${#pool_options[@]}" ]; then
    if [ "$pool_choice" -eq $(( ${#pool_options[@]} - 1 )) ]; then
        # Custom Pool URL
        read -p "Enter the custom pool URL: " pool_url
    else
        pool_url="${pool_options[$pool_choice]}"
    fi
else
    echo "Invalid pool choice. Exiting..."
    exit 1
fi

# Prompt for wallet address
read -p "Enter your XMR wallet address: " wallet_address

# Create run script
echo -e "#!/bin/bash\n\n./xmrig --url $pool_url --user $wallet_address --pass x" > run_xmrig.sh

# Make run script executable
chmod +x run_xmrig.sh

# Execute run script
./run_xmrig.sh
