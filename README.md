# CitrixPrinterAvailabilityChecker
CitrixGPOPrinterDiagnosticTool.ps1 is a PowerShell script designed to assist administrators in Citrix environments. It validates the availability of network printers that are assigned to users through Group Policy Objects (GPOs) based on Active Directory (AD) group memberships. This tool is particularly useful for identifying and addressing issues related to printers that are reported as unavailable in Windows event logs.

## Overview
In complex Citrix environments, printers are often deployed to users dynamically based on their group memberships. While this system offers flexibility and control, it can sometimes lead to issues where users are assigned printers that are, for various reasons, not available on the network. This script automates the process of checking these printer assignments against actual printer availability on specified print servers, providing a quick and efficient way to diagnose and resolve such issues.

## Features
- **Event Log Integration**: Parses Windows Event Logs to identify printers reported as unavailable during user logon processes.
- **Multi-Server Support**: Checks printer availability across multiple specified print servers.
- **AD Group-Based Assignment Validation**: Verifies printer assignments based on AD group memberships and GPO configurations.
- **Network Availability Checks**: Uses WMI to check the existence and network availability of printers on print servers.
- **Report Generation**: Outputs a detailed report of printer availability, including any discrepancies found during the validation process.

## Prerequisites
Before running CitrixGPOPrinterDiagnosticTool.ps1, ensure that:
- PowerShell 5.1 or higher is installed.
- The user executing the script has administrative privileges on the local machine, as well as on the target print servers.
- Necessary network permissions and firewall settings are configured to allow WMI queries and remote PowerShell execution.

## Usage
To use CitrixGPOPrinterDiagnosticTool.ps1, follow these steps:
1. Open PowerShell with administrative privileges.
2. Navigate to the directory containing the script.
3. Execute the script with appropriate parameters. Example:

powershell
.\CitrixGPOPrinterDiagnosticTool.ps1

## Configuration
Modify the `$servers` and `$printServers` variables within the script to match your environment's Citrix servers and print servers, respectively.

## Contributing
Contributions to CitrixGPOPrinterDiagnosticTool.ps1 are welcome. Please feel free to fork the repository, make your changes, and submit a pull request.

## License
This script is provided "AS IS" with no warranties, and confers no rights. Use it at your own risk.

## Support
If you encounter any issues or have suggestions for improvements, please submit an issue on GitHub.
