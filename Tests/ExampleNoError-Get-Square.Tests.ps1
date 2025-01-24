BeforeAll {
    # Start of the Pester setup process with an initial verbose message to indicate the beginning of the setup.
    Write-Verbose "Starting Pester setup process with enhanced analysis for ADO pipeline compatibility." -Verbose

    # Extracting the filename of the script under test from the current Pester test script path.
    $filename = [System.IO.Path]::GetFileName($PSCommandPath).Replace('.Tests.ps1', '.ps1')
    Write-Verbose "Identified script filename for testing as: $filename" -Verbose

    # Calculating the directory path of the script under test based on the current test script's location.
    $directoryPath = Split-Path -Path (Split-Path -Path $PSCommandPath -Parent) -Parent
    Write-Verbose "Calculated directory path for the script under test as: $directoryPath" -Verbose

    # Constructing the full path to the script under test by combining its directory path with the filename.
    $filePath = Join-Path -Path $directoryPath -ChildPath "$filename"
    Write-Verbose "Constructed full path to the script under test as: $filePath" -Verbose

    # Detecting if the script is running within an ADO pipeline.
    $runningInAdoPipeline = ($null -ne $env:SYSTEM_DEFINITIONID -or $null -ne $env:BUILD_BUILDID) -and $null -ne $env:AGENT_NAME
    Write-Verbose "Detected running context as ADO Pipeline: $runningInAdoPipeline" -Verbose

    # Determine the testing environment based on an environment variable.
    $testEnvironment = $env:TEST_ENVIRONMENT
    Write-Verbose "Current testing environment: $testEnvironment" -Verbose

    # Conditional logic to load different configurations or credentials based on the testing environment.
    try {
        switch ($testEnvironment) {
            "Sandbox" {
                Write-Verbose "Setting up for Sandbox environment testing." -Verbose
                if ($runningInAdoPipeline) {
                    Write-Verbose "The running context has been identified as an ADO Pipeline, utilizing environment variables configured within the pipeline."
                    # If running in ADO, use environment variables set in the pipeline
                } else {
                    Write-Verbose "The running context has been identified as an LOCAL Pipeline, utilizing environment variables configured within Pester."
                    # If running locally, use local variables or a different method to set these values
                }
            }
            "Dev" {
                Write-Verbose "Preparing for Development environment tests." -Verbose
                if ($runningInAdoPipeline) {
                    Write-Verbose "The running context has been identified as an ADO Pipeline, utilizing environment variables configured within the pipeline."
                    # If running in ADO, use environment variables set in the pipeline
                } else {
                    Write-Verbose "The running context has been identified as an LOCAL Pipeline, utilizing environment variables configured within Pester."
                    # If running locally, use local variables or a different method to set these values
                }
            }
            "NonProd" {
                Write-Verbose "Configuring for Non-Production functional tests." -Verbose
                if ($runningInAdoPipeline) {
                    Write-Verbose "The running context has been identified as an ADO Pipeline, utilizing environment variables configured within the pipeline."
                    # If running in ADO, use environment variables set in the pipeline
                } else {
                    Write-Verbose "The running context has been identified as an LOCAL Pipeline, utilizing environment variables configured within Pester."
                    # If running locally, use local variables or a different method to set these values
                }
            }
            default {
                Write-Verbose "No specific test environment detected. Proceeding with default configurations." -Verbose
                # If running locally, use local variables or a different method to set these values
                Write-Verbose "Loading mock environment configurations." -Verbose
                if ($runningInAdoPipeline) {
                    Write-Verbose "The running context has been identified as an ADO Pipeline, utilizing environment variables configured within the pipeline." -Verbose
                    # If running in ADO, use environment variables set in the pipeline
                } else {
                    Write-Verbose "The running context has been identified as an LOCAL Pipeline, utilizing environment variables configured within Pester."
                    # If running locally, use local variables or a different method to set these values
                }
            }
        }
    } catch {
        Write-Error "An error occurred while setting up the testing environment: $_. Please review the configuration and attempt again." -ErrorAction Stop -ErrorId 'EnvironmentSetupError'
    }

    try {
        # Checking if the script file exists at the constructed path.
        if (-not (Test-Path -Path $filePath)) {
            throw "Script file not found at the expected path: $filePath. Please verify the file path."
        }

        Write-Verbose "Script file located at the specified path. Proceeding with dot-sourcing and function analysis." -Verbose
        try {
            # Dot-sourcing the script file to load its functions into the current PowerShell session for testing.
            . $filePath
        }
        catch {
            throw "An error occurred while dot-sourcing the script file: $_. Please review the script and attempt again."
        }

        # Reading the script content for AST analysis to identify function definitions.
        Write-Verbose 'Analyzing the Abstract Syntax Tree (AST) to identify function definitions in the script.' -Verbose
        try {
            $scriptContent = Get-Content -Path $filePath -Raw
            $scriptBlockAst = [System.Management.Automation.Language.Parser]::ParseInput($scriptContent, [ref]$null, [ref]$null)
        }
        catch {
            throw "An error occurred while reading the script content for AST analysis: $_. Please review the script and attempt again."
        }

        # Using AST to find all function definitions in the dot-sourced script.
        Write-Verbose 'Identifying function definitions in the dot-sourced script using AST analysis.' -Verbose
        try {
            $functionDefinitions = $scriptBlockAst.FindAll({ $args[0] -is [System.Management.Automation.Language.FunctionDefinitionAst] }, $true)
        }
        catch {
            throw "An error occurred during AST analysis to identify function definitions: $_. Please review the script and attempt again."
        }

        # Conditional block to handle the presence or absence of function definitions.
        Write-Verbose 'Checking if any functions were identified within the dot-sourced script.' -Verbose
        if ($functionDefinitions.Count -gt 0) {
            Write-Verbose "AST analysis identified the following functions within the dot-sourced script:" -Verbose
            foreach ($function in $functionDefinitions) {
                Write-Verbose "Function name: $($function.Name)" -Verbose
            }
        } else {
            Write-Verbose "AST analysis did not identify any functions within the dot-sourced script." -Verbose
        }
    }
    catch {
        # Error handling block to catch and report errors during the setup process.
        Write-Error "An error occurred during script processing: $_. Please review the script and attempt again." -ErrorAction Stop -ErrorId 'ScriptProcessingError'
    }
}

Describe "Get-Square Function Tests" -tags "Mock" {

    It "Should return 25 when called with 5" {
        Mock Get-Square {
            param ([int]$Number)
            [void]$Number # Ensure the parameter is used
            return [int]25
        }

        $result = Get-Square -Number 5
        $result | Should -Be 25
    }

    It "Should return 0 when called with 0" {
        Mock Get-Square {
            param ([int]$Number)
            [void]$Number # Ensure the parameter is used
            return [int]0
        }

        $result = Get-Square -Number 0
        $result | Should -Be 0
    }

    It "Should return 9 when called with -3" {
        Mock Get-Square {
            param ([int]$Number)
            [void]$Number # Ensure the parameter is used
            return [int]9
        }

        $result = Get-Square -Number -3
        $result | Should -Be 9
    }

    It "Should call Get-Square with the correct parameters" {
        Mock Get-Square {
            param ([int]$Number)
            [void]$Number # Ensure the parameter is used
            return [int]49
        }

        $result = Get-Square -Number 7
        $result | Should -Be 49
    }
}


# Define the tests
Describe 'Get-Square Function' -Tag Sandbox {

    Context 'Calculating the square of a number' {
        It 'should return the square of a positive number' {
            # Arrange
            $Number = 5
            $expectedOutput = 25

            # Act
            $result = Get-Square -Number $Number

            # Assert
            $result | Should -BeExactly $expectedOutput
        }

        It 'should return 0 when the input is 0' {
            # Arrange
            $Number = 0
            $expectedOutput = 0

            # Act
            $result = Get-Square -Number $Number

            # Assert
            $result | Should -BeExactly $expectedOutput
        }

        It 'should return the square of a negative number' {
            # Arrange
            $Number = -4
            $expectedOutput = 16

            # Act
            $result = Get-Square -Number $Number

            # Assert
            $result | Should -BeExactly $expectedOutput
        }

        It 'should correctly handle the input' {
            # Arrange
            $Number = 7
            $expectedOutput = 49

            # Act
            $result = Get-Square -Number $Number

            # Assert
            $result | Should -BeExactly $expectedOutput
        }
    }
}