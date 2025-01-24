# Azure DevOps Pipeline for PowerShell Code Testing

![PowerShell](https://img.shields.io/badge/PowerShell-5.0%2B-blue.svg)
![Azure DevOps](https://img.shields.io/badge/Azure%20DevOps-Compatible-green.svg)

## Introduction

Welcome! This Azure DevOps pipeline is designed to help you automate the testing of your PowerShell scripts. By integrating this pipeline into your repository, you can automatically perform syntax analysis, linting, unit tests, and more whenever you make changes to your code. This ensures your scripts maintain high quality and helps catch issues early in the development process.

This guide will walk you through setting up and using the pipeline with your own repositories.

## Flowchart Digrams

| Diagram                                     | Description                                               | Link                                                 |
|---------------------------------------------|-----------------------------------------------------------|------------------------------------------------------|
| **Process Flowchart Diagram**               | A flowchart of the Azure Pipeline logic process.          | [View Diagram](./ProcessFlowchatDiagram.md)          |

### How to View the Diagrams

1. **Open the Diagram**: Click on the "View Diagram" link for the diagram you wish to see.
2. **Switch to Preview Mode**: In the markdown file, click the "Preview" button to render the Mermaid diagram.

## Pipeline Features

- **Automated Testing**: Runs syntax checks, linting, and unit tests on your PowerShell scripts.
- **Code Coverage Reports**: Generates and publishes code coverage reports.
- **Artifact Publishing**: Collects logs and test results, making them available for review.
- **Flexible Triggers**: Configurable to run on specific branches or pull requests.
- **Gradual Error Enforcement**: Initially configured to bypass errors to ease the transition, with guidance on enabling stricter error handling when you're ready.

## Getting Started

### Prerequisites

Before you begin, make sure you have the following:

1. **Azure DevOps Project**: An existing Azure DevOps project where you can create pipelines.
2. **Your PowerShell Repository**: The repository containing the PowerShell scripts you want to test.
3. **Utility Repositories**: Access to the following repositories (or equivalent scripts):
   - `IaC-PowerShell-SyntaxAnalyzer`
   - `IaC-PowerShell-PSScriptAnalyzerWrapper`
   - `IaC-Pester-AssertionAudit`
   - `IaC-PowerShell-PesterWrapper`
   - `IaC-PowerShell-ReadMeAnalyzer`
4. **Service Connection**: A service connection in Azure DevOps named `NameGoesHere` with access to the necessary repositories.

### Step 1: Add the Pipeline to Your Repository

1. **Create the Pipeline File**:

   - In your repository, create a new file named `azure-pipelines.yml` at the root level.

2. **Copy the Pipeline Configuration**:

   - Copy the pipeline YAML content provided below into your `azure-pipelines.yml` file.

### Step 2: Configure Branch Triggers (Optional)

The pipeline is set up to trigger on changes to the following branches:

- `main`
- `develop`
- Any branch starting with `feature/`, `bugfix/`, `hotfix/`, or `release/`

If you want to customize the branches that trigger the pipeline, modify the `trigger` section in the YAML file:

```yaml
trigger:
  branches:
    include:
      - main
      - develop
      - feature/*
      - bugfix/*
      - hotfix/*
      - release/*
```

### Step 3: Understand Error Handling Configuration

By default, the pipeline scripts are configured with the `-BypassError` parameter in various PowerShell checks. This means that errors are bypassed during the initial testing phases, allowing for a smoother transition as you start using the pipeline.

**Why Bypass Errors?**

- **Ease of Transition**: Bypassing errors initially helps you integrate the pipeline without your builds failing due to existing issues.
- **Incremental Improvement**: Allows you to gradually fix issues in your scripts without blocking development.

**Recommendation:**

- Once you're comfortable with the pipeline and have addressed initial issues, consider removing the `-BypassError` parameters from the scripts in your `main` branch pipeline. This will enforce stricter error handling and ensure your code is fully vetted before being merged into production-ready branches.

### Step 4: Verify Repository Access

Ensure that the `NameGoesHere` service connection has access to all the repositories specified in the `resources` section of the pipeline YAML.

### Step 5: Commit and Push Changes

Commit the `azure-pipelines.yml` file to your repository and push it to a branch monitored by the pipeline (e.g., `main`).

### Step 6: Monitor the Pipeline

After pushing the changes, the pipeline should automatically start running. You can monitor its progress in the Azure DevOps Pipelines section.

### Step 7: Review the Results

Once the pipeline completes, you can review:

- **Build Summary**: An overview of the pipeline execution.
- **Code Coverage Reports**: View detailed code coverage reports generated during testing.
- **Artifacts**: Download logs and test results from the build artifacts.

### Viewing Code Coverage Reports

After a successful pipeline run, you can view the code coverage results to understand how much of your code is being tested.

**Steps to View Code Coverage:**

1. **Navigate to the Pipeline Run:**

   - Go to your Azure DevOps project and select the pipeline run you want to inspect.

2. **Access the Code Coverage Tab:**

   - In the pipeline run summary, look for the "Code Coverage" tab or section.
   - Click on it to view the coverage summary.

3. **Explore Detailed Reports:**

   - The summary provides an overview, but you can click on specific modules or files to see detailed coverage information.
   - Download the Cobertura coverage report if you need to analyze it further.

4. **Review Coverage Trends (Optional):**

   - Azure DevOps can track code coverage over time.
   - Use the "Coverage Trends" to see how your code coverage is improving with each run.

**Note:**

- Ensure that the `PublishCodeCoverageResults` task in the pipeline is configured correctly and that the coverage files are being generated and published.


## Pipeline YAML File

Below is the complete pipeline YAML file. This file defines all the steps the pipeline will perform.

```yaml
trigger:
  branches:
    include:
      - main
      - develop
      - feature/*
      - bugfix/*
      - hotfix/*
      - release/*

pool:
  vmImage: 'windows-latest'

resources:
  repositories:
    - repository: SyntaxAnalyzer
      type: git
      name: 'IaC-PowerShell-SyntaxAnalyzer'
      endpoint: NameGoesHere
      ref: refs/heads/main
    - repository: PSScriptAnalyzerWrapper
      type: git
      name: 'IaC-PowerShell-PSScriptAnalyzerWrapper'
      endpoint: NameGoesHere
      ref: refs/heads/main
    - repository: PesterTestsPs1Audit
      type: git
      name: 'IaC-Pester-AssertionAudit'
      endpoint: NameGoesHere
      ref: refs/heads/main
    - repository: PesterWrapper
      type: git
      name: 'IaC-PowerShell-PesterWrapper'
      endpoint: NameGoesHere
      ref: refs/heads/main
    - repository: ReadMeAnalyzer
      type: git
      name: 'IaC-PowerShell-ReadMeAnalyzer'
      endpoint: NameGoesHere
      ref: refs/heads/main

jobs:
  - job: MainJob
    displayName: 'Code Testing'
    steps:
      - checkout: self
        displayName: 'Checkout Main Repository'

      - checkout: SyntaxAnalyzer
        displayName: 'Checkout Syntax Analyzer Repository'
        persistCredentials: true

      - checkout: PSScriptAnalyzerWrapper
        displayName: 'Checkout PSScriptAnalyzerWrapper Repository'
        persistCredentials: true

      - checkout: PesterTestsPs1Audit
        displayName: 'Checkout Pester AssertionAudit Repository'
        persistCredentials: true

      - checkout: PesterWrapper
        displayName: 'Checkout PesterWrapper Repository'
        persistCredentials: true

      - checkout: ReadMeAnalyzer
        displayName: 'Checkout ReadMeAnalyzer Repository'
        persistCredentials: true

      - pwsh: |
          $modules = @('PSScriptAnalyzer', 'Pester')
          $modules | ForEach-Object {
              if (-not (Get-Module -ListAvailable -Name $_)) {
                  Install-Module -Name $_ -Force -Scope CurrentUser
                  Write-Output "Installed module: $_"
              } else {
                  Write-Output "Module $_ is already installed."
              }
          }

          $tools = @('dotnet-reportgenerator-globaltool')
          $toolList = dotnet tool list --global
          $tools | ForEach-Object {
              if (-not ($toolList -match $_)) {
                  dotnet tool install --global $_
                  Write-Output "Installed tool: $_"
              } else {
                  Write-Output "Tool $_ is already installed."
              }
          }
        displayName: 'Install Required Modules and Tools'

      - pwsh: |
          $repos = @(
              @{ Name = 'IaC-PowerShell-SyntaxAnalyzer'; File = 'Invoke-SyntaxAnalyzer.ps1' },
              @{ Name = 'IaC-PowerShell-PSScriptAnalyzerWrapper'; File = 'Invoke-PSLint.ps1' },
              @{ Name = 'IaC-Pester-AssertionAudit'; File = 'Invoke-PTAssertionAudit.ps1' },
              @{ Name = 'IaC-PowerShell-PesterWrapper'; File = 'Invoke-PTUnit.ps1' },
              @{ Name = 'IaC-PowerShell-ReadMeAnalyzer'; File = 'Invoke-ReadMeAnalyzer.ps1' }
          )

          foreach ($repo in $repos) {
              Push-Location "$(Build.SourcesDirectory)\$($repo.Name)"
              git config core.sparseCheckout true
              "$($repo.File)" | Out-File -FilePath .git\info\sparse-checkout -Encoding ASCII
              git read-tree -mu HEAD
              Pop-Location
          }
        displayName: 'Sparse Checkout of Required Scripts'

      - task: PowerShell@2
        displayName: 'Syntax Analysis'
        inputs:
          targetType: 'filePath'
          filePath: '$(Build.SourcesDirectory)\IaC-PowerShell-SyntaxAnalyzer\Invoke-SyntaxAnalyzer.ps1'
          arguments: '-Path "$(Build.SourcesDirectory)" -BypassError -Recurse -LogFile "$(Build.Repository.LocalPath)\SyntaxResults.log"'
          errorActionPreference: 'stop'
          failOnStderr: true

      - task: PowerShell@2
        displayName: 'Linting with PSScriptAnalyzer'
        inputs:
          targetType: 'filePath'
          filePath: '$(Build.SourcesDirectory)\IaC-PowerShell-PSScriptAnalyzerWrapper\Invoke-PSLint.ps1'
          arguments: '-Path "$(Build.SourcesDirectory)" -BypassError -Recurse -LogFile "$(Build.Repository.LocalPath)\LintResults.log"'
          errorActionPreference: 'stop'
          failOnStderr: true

      - task: PowerShell@2
        displayName: 'Pester Assertion Audit'
        inputs:
          targetType: 'filePath'
          filePath: '$(Build.SourcesDirectory)\IaC-Pester-AssertionAudit\Invoke-PTAssertionAudit.ps1'
          arguments: '-Path "$(Build.SourcesDirectory)" -BypassError -Recurse -LogFile "$(Build.Repository.LocalPath)\AuditTestResults.log"'
          errorActionPreference: 'stop'
          failOnStderr: true

      - task: PowerShell@2
        displayName: 'Running Mock Tests'
        condition: succeeded()
        inputs:
          targetType: 'filePath'
          filePath: '$(Build.SourcesDirectory)\IaC-PowerShell-PesterWrapper\Invoke-PTUnit.ps1'
          arguments: '-Path "$(Build.SourcesDirectory)" -BypassError -Recurse -TagFilter Mock -CoverageOutputFile "$(Build.Repository.LocalPath)\MockCode.xml" -LogFile "$(Build.Repository.LocalPath)\MockResults.log"'
          errorActionPreference: 'stop'
          failOnStderr: true

      - task: PowerShell@2
        displayName: 'Running Unit Tests'
        condition: succeeded()
        inputs:
          targetType: 'filePath'
          filePath: '$(Build.SourcesDirectory)\IaC-PowerShell-PesterWrapper\Invoke-PTUnit.ps1'
          arguments: '-Path "$(Build.SourcesDirectory)" -BypassError -Recurse -TagFilter SandBox -CoverageOutputFile "$(Build.Repository.LocalPath)\UnitCode.xml" -LogFile "$(Build.Repository.LocalPath)\UnitResults.log"'
          errorActionPreference: 'stop'
          failOnStderr: true

      - task: PowerShell@2
        displayName: 'ReadMe File Analysis'
        inputs:
          targetType: 'filePath'
          filePath: '$(Build.SourcesDirectory)\IaC-PowerShell-ReadMeAnalyzer\Invoke-ReadMeAnalyzer.ps1'
          arguments: '-Path "$(Build.SourcesDirectory)" -BypassError -Recurse -LogFile "$(Build.Repository.LocalPath)\ReadMeResults.log"'
          errorActionPreference: 'stop'
          failOnStderr: true

      - pwsh: |
          $installed = dotnet tool list --global | Select-String "reportgenerator"
          if (-not $installed) {
              dotnet tool install --global dotnet-reportgenerator-globaltool
          } else {
              dotnet tool update --global dotnet-reportgenerator-globaltool
          }
          $env:PATH += ";$([Environment]::GetFolderPath('UserProfile'))\.dotnet\tools"

          $coverageFiles = @(
              "$(Build.Repository.LocalPath)\MockCode.xml",
              "$(Build.Repository.LocalPath)\UnitCode.xml"
          )
          $coverageFilesJoined = [string]::Join(';', $coverageFiles)
          reportgenerator -reports:$coverageFilesJoined -targetdir:$(Build.SourcesDirectory) -reporttypes:Cobertura
        displayName: 'Consolidate Code Coverage Results'

      - task: PublishCodeCoverageResults@2
        displayName: 'Publish Code Coverage Results'
        inputs:
          summaryFileLocation: '$(Build.SourcesDirectory)\Cobertura.xml'
          failIfCoverageEmpty: true

      - pwsh: |
          $artifactPath = "$(Build.ArtifactStagingDirectory)\drop\logs"
          New-Item -ItemType Directory -Force -Path $artifactPath
          Copy-Item -Path "$(Build.Repository.LocalPath)\*Results.log" -Destination $artifactPath -Force
        displayName: 'Copy Results to Artifact Staging Directory'

      - task: PublishBuildArtifacts@1
        displayName: 'Publish Artifacts'
        inputs:
          PathtoPublish: '$(Build.ArtifactStagingDirectory)\drop'
          ArtifactName: 'drop'
          publishLocation: 'Container'

      - pwsh: |
          Write-Host "Verifying published artifacts..."
          Get-ChildItem -Path "$(Build.ArtifactStagingDirectory)\drop" -Recurse
        displayName: 'Verify Published Artifacts'
```

## Customizing the Pipeline

You may need to customize the pipeline to suit your specific needs. Here are some common customizations:

### Adjusting Error Handling

As mentioned earlier, the pipeline tasks use the `-BypassError` parameter in the PowerShell scripts. This is intended to make it easier for you to start using the pipeline without immediately failing due to existing errors in your code.

**Steps to Enforce Strict Error Handling:**

1. **Remove `-BypassError` Parameters:**

   - Edit the `arguments` in each PowerShell task in the pipeline YAML file.
   - Remove the `-BypassError` parameter from the arguments.

   For example, change:

   ```yaml
   arguments: '-Path "$(Build.SourcesDirectory)" -BypassError -Recurse -LogFile "$(Build.Repository.LocalPath)\SyntaxResults.log"'
   ```

   To:

   ```yaml
   arguments: '-Path "$(Build.SourcesDirectory)" -Recurse -LogFile "$(Build.Repository.LocalPath)\SyntaxResults.log"'
   ```

2. **Commit and Push Changes:**

   - Commit the updated `azure-pipelines.yml` file to your repository.
   - Push it to the `main` branch or the appropriate branch.

3. **Monitor the Pipeline:**

   - The pipeline will now fail if any errors are detected during the PowerShell checks.
   - Review any errors and fix them to ensure your code meets the required standards.

**Benefits:**

- **Improved Code Quality:** Enforcing strict error handling helps catch issues before code reaches production.
- **Automated Enforcement:** The pipeline will automatically prevent code with errors from being merged into production branches.

### Modifying Branch Triggers

Change the branches in the `trigger` section to match your workflow.

### Adding or Removing Repositories

If you're using different utility scripts or repositories, update the `resources` section accordingly.

### Changing Script Paths or Arguments

If your scripts are located in different paths or require different arguments, update the `filePath` and `arguments` in the PowerShell tasks.

## Troubleshooting

If you encounter issues when running the pipeline:

- **Check Repository Access**: Ensure the `NameGoesHere` service connection has the necessary permissions.
- **Verify Script Paths**: Make sure the paths to the scripts in the PowerShell tasks are correct.
- **Review Logs**: Examine the logs in the pipeline run to identify any errors.
- **Module and Tool Installation**: Ensure that required modules and tools are installed successfully during the pipeline execution.
- **Error Handling**: If builds are failing due to errors in your scripts, consider temporarily re-adding the `-BypassError` parameter to continue working while you address the issues.

## Contributors

We appreciate contributions to improve this pipeline. If you'd like to contribute, please:

- **Fork the Repository**: Create your own fork of the repository.
- **Create a Feature Branch**: Make your changes in a new branch.
- **Submit a Pull Request**: Once your changes are ready, submit a pull request for review.

Feel free to open issues for any bugs or feature requests.

## References

- [Azure DevOps Branch Naming Conventions](https://dev.azure.com/HPINCDev/CloudOperations/_git/DevOpsGovernance_BestPractices?path=/Azure-DevOps-Branch-Naming-Conventions.md&version=GBmain&_a=preview)
- [Azure Git Tag Naming Conventions](https://dev.azure.com/HPINCDev/CloudOperations/_git/DevOpsGovernance_BestPractices?path=/Azure-Git-Tag-Naming-Conventions.md&version=GBmain&_a=preview)
- [Azure DevOps Pipeline](https://dev.azure.com/HPINCDev/CloudOperations/_git/DevOpsGovernance_BestPractices?path=/DevOps-Pipeline-Guidelines.md&version=GBmain&_a=preview)
- [The Art of DevOps: Translating Complexity into Simplicity](https://dev.azure.com/HPINCDev/CloudOperations/_git/DevOpsGovernance_BestPractices)
- [Automation Paradox: Automator's Guide to Sucess](https://dev.azure.com/HPINCDev/CloudOperations/_git/AutomationGovernance_BestPractices)

## Additional Resources

Within this repository, you will find **Version 1** of this PowerShell Azure DevOps pipeline `azure-pipelines-powershell_v1.yml`. It serves as a reference for a basic PowerShell pipeline example and can be helpful if you're looking for a simpler setup or starting point.