# Comprehensive Guide: Building the MSI Installer with WiX

## Table of Contents
1. [Introduction](#introduction)
2. [Prerequisites](#prerequisites)
3. [Method 1: Basic Installation](#method-1-basic-installation)
4. [Method 2: Custom Features](#method-2-custom-features)
5. [Method 3: Advanced Installations](#method-3-advanced-installations)
6. [Testing Procedures](#testing-procedures)
7. [Troubleshooting](#troubleshooting)

## Introduction
This guide provides a comprehensive step-by-step process to build the MSI installer using WiX. After following the installation of WiX, these methods will guide you through the creation of an installer.

## Prerequisites
- Ensure that you have downloaded and installed the latest version of [WiX Toolset](http://wixtoolset.org/).
- Make sure you have a basic understanding of how MSI installers work.

## Method 1: Basic Installation
1. Open the Command Prompt as an Administrator.
2. Navigate to your project directory where your `.wixproj` file is located.
    ```
    cd path\to\your\project
    ```
3. Build the project with WiX using the following command:
    ```
    candle your_file.wxs
    light your_file.wixobj -o output.msi
    ```
4. Your MSI file, `output.msi`, is now ready.

## Method 2: Custom Features
1. Modify your `.wxs` files to add custom features:
    - Define features in your `.wxs`:
    ```xml
      <Feature Id="MyFeature" Title="My Feature" Level="1">
        <ComponentRef Id="MyComponent" />
      </Feature>
    ```
2. Rebuild your project as shown in Method 1.
3. Ensure that your custom features are registered in the MSI file by inspecting it with WiX tools.

## Method 3: Advanced Installations
1. Use WiX includes and variables to create complex installations:
    - Create `.wxi` files to include headers:
    ```xml
    <?xml version="1.0" encoding="utf-8"?>
    <Wix xmlns="http://schemas.microsoft.com/wix/2006/wi">
      <Include>
         <!-- Your components here -->
      </Include>
    </Wix>
    ```
2. Build your project as in Method 1. This allows for extensive customization and modularity.

## Testing Procedures
- After creating your MSI installer:
    1. Install it on a clean virtual or physical machine to ensure that it installs correctly.
    2. Check for proper installation of files and registry entries.
    3. Run uninstallation to confirm that it removes everything cleanly.

## Troubleshooting
- If you encounter issues during the building process:
  1. Double-check the syntax in your `.wixproj` and `.wxs` files.
  2. Ensure that all paths are correctly referenced.
  3. Use the WiX logs to locate errors during the installation process. Command for logging:
    ```
    msiexec /i output.msi /L*V install.log
    ```

This log will help you identify what went wrong and where.

---

This guide should help you successfully create an MSI installer with WiX. Happy coding!