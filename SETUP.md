# Setup Instructions for COI Mod Agent

## Prerequisites

1. Ensure that you have .NET Framework 4.8 installed on your system.
   - You can download it from the official Microsoft website: [Download .NET Framework 4.8](https://dotnet.microsoft.com/download/dotnet-framework/net48)

## Installing .NET Framework 4.8

To install the .NET Framework 4.8:

1. Download the installer from the link provided above.
2. Run the installer and follow the prompts to complete the installation.
3. After installation, restart your machine if prompted.

## Setting the COI_ROOT Environment Variable

The `COI_ROOT` environment variable must be set to point to the root directory of your COI Mod Agent installation.

### On Windows:

1. Press `Win + R` to open the Run dialog.
2. Type `sysdm.cpl` and press Enter.
3. Go to the “Advanced” tab.
4. Click on "Environment Variables".
5. Under the "System variables" section, click "New" and enter the following:
   - Variable name: `COI_ROOT`
   - Variable value: Path to your COI Mod Agent root directory
6. Click OK to close all dialogs.

## Build and Deploy Workflow

Once you have set up the environment variables and installed the .NET Framework, you can build and deploy the project.

### Building the Project

1. Open a command prompt.
2. Navigate to the directory of your COI Mod Agent.
3. Run the following command to build the solution:

   ```bash
   dotnet build
   ```

### Deploying the Project

1. After a successful build, you can deploy the application using the following command:

   ```bash
   dotnet publish
   ```

2. Follow any additional deployment instructions specific to your application.

## Conclusion

You are now set up to work with the COI Mod Agent. If you encounter any issues, please check the documentation or contact support.
