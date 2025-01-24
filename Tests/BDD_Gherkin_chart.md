# **Business Driven Development:** *Calculate the Square of a Number*

## Gherkin Diagram

```mermaid
flowchart TB
    %% Define the swimlanes for Scenario, Given, When, and Then
    subgraph Scenario["<b>Scenario</b>"]
        direction TB
        B1[Calculating the square of a positive number]:::scenario
        B2[Calculating the square of zero]:::scenario
        B3[Calculating the square of a negative number]:::scenario
        B4[Ensuring the function handles the input correctly]:::scenario
    end

    subgraph Given["<b>Given</b>"]
        direction TB
        C1[Given I have a number 5]:::step
        C2[Given I have a number 0]:::step
        C3[Given I have a number -4]:::step
        C4[Given I have a number 7]:::step
    end

    subgraph When["<b>When</b>"]
        direction TB
        D1[When I calculate the square of the number]:::action
        D2[When I calculate the square of the number]:::action
        D3[When I calculate the square of the number]:::action
        D4[When I calculate the square of the number]:::action
    end

    subgraph Then["<b>Then</b>"]
        direction TB
        E1[Then the result should be 25]:::result
        E2[Then the result should be 0]:::result
        E3[Then the result should be 16]:::result
        E4[Then the result should be 49]:::result
    end

    %% Define the feature node
    A[Feature: Calculate the square of a number]:::feature

    %% Connect the feature node to the Scenario swimlane
    A --> B1
    A --> B2
    A --> B3
    A --> B4

    %% Connect Scenario to Given
    B1 -- Step --> C1
    B2 -- Step --> C2
    B3 -- Step --> C3
    B4 -- Step --> C4

    %% Connect Given to When
    C1 -- Action --> D1
    C2 -- Action --> D2
    C3 -- Action --> D3
    C4 -- Action --> D4

    %% Connect When to Then
    D1 -- Result --> E1
    D2 -- Result --> E2
    D3 -- Result --> E3
    D4 -- Result --> E4

    %% Styling definitions
    classDef feature fill:#f9f,stroke:#333,stroke-width:2px,padding:10px,font-size:30px;
    classDef scenario fill:#b3d9ff,stroke:#333,stroke-width:1px,padding:10px;
    classDef step fill:#ccf,stroke:#333,stroke-width:1px,padding:78px;
    classDef action fill:#cce5ff,stroke:#333,stroke-width:1px,padding:10px;
    classDef result fill:#d5a6a4,stroke:#333,stroke-width:2px,padding:62px;

    %% Apply styles
    class A feature;
    class B1,B2,B3,B4 scenario;
    class C1,C2,C3,C4 step;
    class D1,D2,D3,D4 action;
    class E1,E2,E3,E4 result;

```

## Feature

**Title:** Calculate the square of a number.

### Scenario: Calculating the square of a positive number

- **Given** I have a number 5  
- **When** I calculate the square of the number  
- **Then** the result should be 25

### Scenario: Calculating the square of zero

- **Given** I have a number 0  
- **When** I calculate the square of the number  
- **Then** the result should be 0

### Scenario: Calculating the square of a negative number

- **Given** I have a number -4  
- **When** I calculate the square of the number  
- **Then** the result should be 16

### Scenario: Ensuring the function handles the input correctly

- **Given** I have a number 7  
- **When** I calculate the square of the number  
- **Then** the result should be 49
