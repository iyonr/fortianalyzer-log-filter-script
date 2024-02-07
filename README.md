Certainly! Below is the updated `README.md` for your script `log-filter.sh`, including the change to specify that the script is under the MIT License.

---

# README for log-filter.sh

## Introduction

`log-filter.sh` is a powerful shell script designed to filter logs from FortiAnalyzer, specifically optimized for logs downloaded via the LogView >> Log Browser function. Compatible with FortiAnalyzer version 7.4.2 build 2397, it allows users to specify date and time ranges, VDOM (Virtual Domain), and policy ID for targeted log analysis. This tool is invaluable for system administrators and cybersecurity professionals needing to efficiently sift through extensive log data.

## Features

- **Date and Time Filtering:** Enables filtering logs within a specific date and time range for focused analysis.
- **VDOM and Policy ID Filtering:** Provides the ability to filter logs based on Virtual Domain and policy ID, offering a granular log analysis approach.
- **Output Customization:** Displays filtered logs on the terminal and saves the output to a timestamped file for documentation and further analysis.

## Requirements

- Bash shell (available on most Unix/Linux systems)
- FortiAnalyzer logs in the specified format
- `date` command support for timestamp operations (included in GNU coreutils)

## Installation

1. **Download the Script:**
   - Clone the repository or directly download `log-filter.sh` from the provided link.

2. **Make the Script Executable:**
   - Navigate to the directory containing `log-filter.sh`.
   - Make the script executable with the following command:
     ```bash
     chmod +x log-filter.sh
     ```

## Usage

### Basic Command Structure

```bash
./log-filter.sh -f <log_file> -s <start_date_time> -e <end_date_time> [-v <vd>] [-p <policyid>]
```

### Parameters

- `-f` **Log file path** (mandatory): Path to the log file for filtering.
- `-s` **Start date and time** (mandatory): Start of the date and time range for filtering (format: YYYY-MM-DD HH:MM:SS).
- `-e` **End date and time** (mandatory): End of the date and time range for filtering (format: YYYY-MM-DD HH:MM:SS).
- `-v` **Virtual Domain** (optional): VDOM for filtering logs.
- `-p` **Policy ID** (optional): Policy ID for filtering logs.

### Examples

- **Filtering by Date and Time Range:**
  ```bash
  ./log-filter.sh -f tlog.log -s "2024-01-31 22:42:00" -e "2024-01-31 22:43:16"
  ```
- **Filtering with VDOM and Policy ID:**
  ```bash
  ./log-filter.sh -f tlog.log -s "2024-01-31 22:42:00" -e "2024-01-31 22:43:16" -v IT -p 6
  ```

## Contributing

Contributions to `log-filter.sh` are welcome! Please submit pull requests or open issues on the project's GitHub page to suggest improvements or report bugs.

## Contact

For questions or feedback regarding `log-filter.sh`, please contact:

- Marion Renaldo Rotensulu (@iyonr)
- Email: mrr@isecuritylab.com

## License

This script is licensed under the MIT License. See the LICENSE file in the project repository for full license text.

---

To fully align with the MIT License, you should include the actual license text in a file named `LICENSE` in the same directory as your script. Here is the MIT License text you can use:

```
MIT License

Copyright (c) 2024 Marion Renaldo Rotensulu

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```