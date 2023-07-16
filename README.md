# XMRIG Setup Script

This script automates the installation of Xmrig on Ubuntu and other Debian-based distributions. It helps you set up the necessary dependencies, clone the Xmrig repository, and build the software easily.

## Prerequisites

- Ubuntu or other Debian-based distributions
- `sudo` access to install packages and run commands

## Usage

1. Download the setup script to your local machine.

   ```bash
   wget https://raw.githubusercontent.com/joehighton/xmrig-setup/main/xmrig_setup.sh
   ```

2. Make the script executable.

   ```bash
   chmod +x xmrig_setup.sh
   ```

3. Run the setup script.

   ```bash
   ./xmrig_setup.sh
   ```

   The script will perform the following steps:
   - Update and upgrade the system
   - Install necessary dependencies
   - Clone the Xmrig repository
   - Build Xmrig using CMake and Make

4. Once the script completes, you can find the built Xmrig executable in the `xmrig/build` directory.

## Contributing

Contributions are welcome! If you encounter any issues or have suggestions for improvements, please feel free to open an issue or submit a pull request on GitHub.

## License

This project is licensed under the [MIT License](LICENSE).

---

For more information about Xmrig, visit the [official repository](https://github.com/xmrig/xmrig).

**Disclaimer: Use this script at your own risk. Make sure to review the code before executing it on your system.**
```
