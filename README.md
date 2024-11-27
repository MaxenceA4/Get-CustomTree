# Get-CustomTree PowerShell Function

`Get-CustomTree` is a PowerShell function to display a tree-like structure of directories and files in your filesystem. It supports optional inclusion of files, filtering of directories or files, and works recursively to provide a visual representation of your folder hierarchy.

---

## Features

- Recursively list folders and files in a tree structure.
- Exclude specified files or folders from the output.
- Optionally include or omit files in the listing.
- Unicode-friendly output with tree characters (`├─`, `└─`, etc.).

---

## Installation

To install and use the `Get-CustomTree` function on your computer, follow these steps:

### **1. Clone the Repository**
First, clone this repository to your local computer:

```bash
git clone https://github.com/MaxenceA4/TreeButBetter
```
---

### **2. Add the Function to Your PowerShell Profile**

To make the `Get-CustomTree` function available in all PowerShell sessions:

0. Make sure you have PowerShell 7 at least :
   ```powershell
   $PSVersionTable
   ```

1. Open your PowerShell profile for editing:

   ```powershell
   notepad $PROFILE
   ```

   If the file does not exist, PowerShell will create a new one.

2. Copy the content of the `Get-CustomTree.ps1` file from the repository into your profile file.

3. Save and close the file.

4. Close and reopen your PowerShell profile to apply the changes:

   ```powershell
   . $PROFILE
   ```

The `Get-CustomTree` function will now be available in all your PowerShell sessions.

---

### **3. Alternatively, Import the Script Manually**

If you prefer not to modify your PowerShell profile, you can import the script manually in each session:

1. Navigate to the directory where the repository was cloned:

   ```powershell
   cd <path-to-repo>
   ```

2. Import the script:

   ```powershell
   . .\Get-CustomTree.ps1
   ```

This will load the function into your current session. Note that you’ll need to re-import it for each new session.

---

## Usage

### **Syntax**

```powershell
Get-CustomTree -Path <string> [-IncludeFiles] [-Exclude <string[]>]
```

### **Parameters**

| Parameter       | Type       | Description                                                                 |
|-----------------|------------|-----------------------------------------------------------------------------|
| `-Path`         | `string`   | The path of the directory to display in the tree structure. **Required.**   |
| `-IncludeFiles` | `switch`   | If specified, files will be included in the output.                         |
| `-Exclude`      | `string[]` | An array of file or folder names to exclude from the output.                |

### **Examples**

1. **Basic Usage**:
   ```powershell
   Get-CustomTree -Path "C:\Projects"
   ```
   Output the tree structure of the `C:\Projects` directory, showing only folders.

2. **Include Files**:
   ```powershell
   Get-CustomTree -Path "C:\Projects" -IncludeFiles
   ```
   Output the tree structure of the `C:\Projects` directory, including files.

3. **Exclude Specific Folders**:
   ```powershell
   Get-CustomTree -Path "C:\Projects" -Exclude @("node_modules", ".git")
   ```
   Exclude the `node_modules` and `.git` folders from the tree structure.

4. **Combine Parameters**:
   ```powershell
   Get-CustomTree -Path "C:\Projects" -IncludeFiles -Exclude @("node_modules", ".git")
   ```
   Include files but exclude `node_modules` and `.git` folders.

---

## Notes

- This script has been tested on **PowerShell 7+** and should work on most modern systems.
- Ensure that the PowerShell script file is saved with UTF-8 encoding to preserve the Unicode characters used for the tree structure.
- I don't think I'll update this any further (unless someone open a PR or an error). This repo is more to keep this script somewhere between my computer. Why not share it at the same time ?

---

## License

There is no licence for this, everyone can take it :)
---
