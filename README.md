# README for log-filter.sh

Enhance your security log analysis workflow with `log-filter.sh`, a script tailored for filtering FortiAnalyzer logs based on precise criteria such as date, time, VDOM, and policy ID, now featuring a debug mode for detailed processing insights.

## Introduction

`log-filter.sh` is a versatile shell script designed to sift through logs from FortiAnalyzer, specially optimized for logs downloaded via the LogView >> Log Browser function. It is compatible with FortiAnalyzer version 7.4.2 build 2397. This tool is invaluable for system administrators and cybersecurity professionals who need to efficiently process extensive log data by specifying date and time ranges, VDOM (Virtual Domain), and policy ID. The newly introduced debug mode allows for an in-depth analysis process, providing verbose output for troubleshooting and ensuring the accuracy of the filtering criteria.

## Features

- **Date and Time Filtering:** Filter logs within a specified date and time range for focused analysis.
- **VDOM and Policy ID Filtering:** Filter logs based on Virtual Domain and policy ID for granular analysis.
- **Debug Mode:** Activate debug mode for verbose output during log processing, aiding in troubleshooting and criteria verification.
- **Output Customization:** View filtered logs on the terminal and save the output to a timestamped file for documentation and further analysis.

## Requirements

- Bash shell (available on most Unix/Linux systems)
- FortiAnalyzer logs in the specified format
- `date` command support for timestamp operations (included in GNU coreutils)
- GNU `awk` (`gawk`) for advanced string manipulation

## Installation

1. **Installing GAWK:**
   `log-filter.sh` utilizes GNU `awk` (`gawk`), which may not be the default on all systems. Follow these steps to install it:

   - **Debian/Ubuntu:**
     ```sh
     sudo apt update
     sudo apt install gawk
     ```
   
   - **Fedora:**
     ```sh
     sudo dnf install gawk
     ```
   
   - **CentOS/RHEL:**
     ```sh
     sudo yum install gawk
     ```
   
   - **macOS:**
     First, install Homebrew if it's not already installed:
     ```sh
     /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
     ```
     Then, install `gawk` using Homebrew:
     ```sh
     brew install gawk
     ```

2. **Download the Script:**
   Clone the repository or directly download `log-filter.sh` from the provided link.

3. **Make the Script Executable:**
   Navigate to the directory containing `log-filter.sh` and make it executable:
   ```bash
   chmod +x log-filter.sh
   ```

## Usage

### Basic Command Structure

```bash
./log-filter.sh -f <log_file> -s <start_date_time> -e <end_date_time> [-v <vd>] [-p <policyid>] [--debug]
```

### Parameters

- `-f` **Log file path** (mandatory): Path to the log file for filtering.
- `-s` **Start date and time** (mandatory): Start of the date and time range for filtering (format: YYYY-MM-DD HH:MM:SS).
- `-e` **End date and time** (mandatory): End of the date and time range for filtering (format: YYYY-MM-DD HH:MM:SS).
- `-v` **Virtual Domain** (optional): Specify the VDOM for filtering logs.
- `-p` **Policy ID** (optional): Specify the policy ID for filtering logs.
- `--debug` **Activate debug mode** (optional): Activate debug mode for verbose output during log processing.

### Examples

- **Filtering by Date and Time Range:**
  ```bash
  ./log-filter.sh -f tlog.log -s "2024-01-31 22:42:00" -e "2024-01-31 22:43:16"
  ```

- **Filtering with VDOM and Policy ID:**
  ```bash
  ./log-filter.sh -f tlog.log -s "2024-01-31 22:42:00" -e "2024-01-31 22:43:16" -v IT -p 6
  ```

- **Using Debug Mode for Detailed Output:**
  ```bash
  ./log-filter.sh -f tlog.log -s "2024-01-31 22:42:00" -e "2024-01-31 22:43:16" --debug
  ```

## Contributing

Contributions
