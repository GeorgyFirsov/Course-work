/* Create a DB */

CREATE DATABASE InsuranceDB

/* Switch to the DB */

USE InsuranceDB

/* Now let's create codifiers tables */

/* 
 * IDENTITY(1,1) used for autoincrementing counter 
 */

CREATE TABLE AgentPosition (
    AgentPositionID      INTEGER     NOT NULL IDENTITY(1,1) PRIMARY KEY,
    Position             VARCHAR(25) NOT NULL UNIQUE
)

CREATE TABLE DepartmentType (
    DepartmentTypeID     INTEGER     NOT NULL IDENTITY(1,1) PRIMARY KEY,
    Type                 VARCHAR(25) NOT NULL UNIQUE
)

CREATE TABLE ContractKind (
    ContractKindID       INTEGER     NOT NULL IDENTITY(1,1) PRIMARY KEY,
    Kind                 VARCHAR(25) NOT NULL UNIQUE
)

CREATE TABLE ContractObject (
    ContractObjectID     INTEGER     NOT NULL IDENTITY(1,1) PRIMARY KEY,
    Object               VARCHAR(25) NOT NULL,
    State                TINYINT     NULL
)

CREATE TABLE ContractStatus (
    ContractStatusID     INTEGER     NOT NULL IDENTITY(1,1) PRIMARY KEY,
    Status               VARCHAR(25) NOT NULL UNIQUE
)

/* Main tables */

CREATE TABLE Department (
    DepartmentID         INTEGER     NOT NULL IDENTITY(1,1) PRIMARY KEY,
    Address              VARCHAR(50) NOT NULL UNIQUE,
    PhoneNumber          VARCHAR(15) NOT NULL,
    DepartmentTypeID     INTEGER     NOT NULL 
                                     REFERENCES DepartmentType (DepartmentTypeID),
    NumberOfEmploees     INTEGER     NULL
)

CREATE TABLE Agent (
    AgentID              INTEGER     NOT NULL IDENTITY(1,1) PRIMARY KEY,
    Name                 VARCHAR(50) NOT NULL,
    PhoneNumber          VARCHAR(15) NOT NULL,
    PassportId           VARCHAR(11) NOT NULL UNIQUE,
    Rate                 INTEGER     NULL,
    NumberOfContracts    INTEGER     NULL
)

CREATE TABLE EmploymentContract (
    EmploymentContractID INTEGER     NOT NULL IDENTITY(1,1) PRIMARY KEY,
    Number               INTEGER     NOT NULL UNIQUE,
    AgentID              INTEGER     NOT NULL 
                                     REFERENCES Agent (AgentID),
    Salary               INTEGER     NOT NULL,
    AgentPositionID      INTEGER     NOT NULL 
                                     REFERENCES AgentPosition (AgentPositionID),
    DepartmentID         INTEGER     NOT NULL 
                                     REFERENCES Department (DepartmentID),
    StartDate            DATE        NOT NULL,
    EndDate              DATE        NULL,
    Status               TINYINT     NOT NULL
)

CREATE TABLE Client (
    ClientID             INTEGER     NOT NULL IDENTITY(1,1) PRIMARY KEY,
    Name                 VARCHAR(50) NOT NULL,
    PhoneNumber          VARCHAR(15) NOT NULL,
    PassportId           VARCHAR(11) NOT NULL UNIQUE,
    Address              VARCHAR(50) NOT NULL,
    NumberOfContracts    INTEGER     NULL,
    TaxNumber            INTEGER     NOT NULL UNIQUE
)

CREATE TABLE Contract (
    ContractID           INTEGER     NOT NULL IDENTITY(1,1) PRIMARY KEY,
    ContractKindID       INTEGER     NOT NULL 
                                     REFERENCES ContractKind (ContractKindID),
    ContractObjectID     INTEGER     NOT NULL 
                                     REFERENCES ContractObject (ContractObjectID),
    InsuranceInterest    INTEGER     NOT NULL,
    InsuranceAmount      INTEGER     NOT NULL,
    Date                 DATE        NOT NULL,
    ValidityPeriod       INTEGER     NOT NULL,
    ContractStatusID     INTEGER     NOT NULL 
                                     REFERENCES ContractStatus (ContractStatusID),
    ClientID             INTEGER     NOT NULL 
                                     REFERENCES Client (ClientID),
    AgentID              INTEGER     NOT NULL 
                                     REFERENCES Agent (AgentID)
)