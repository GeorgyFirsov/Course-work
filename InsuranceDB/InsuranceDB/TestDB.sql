/* Switch to our DB */

USE InsuranceDB

/* Test queries */

/* Check if data actually exists */

SELECT * FROM Agent ORDER BY AgentID

SELECT * FROM AgentPosition ORDER BY AgentPositionID

SELECT * FROM Client ORDER BY ClientID

SELECT * FROM Contract ORDER BY ContractID

SELECT * FROM ContractKind ORDER BY ContractKindID

SELECT * FROM ContractObject ORDER BY ContractObjectID

SELECT * FROM ContractStatus ORDER BY ContractStatusID

SELECT * FROM Department ORDER BY DepartmentID

SELECT * FROM DepartmentType ORDER BY DepartmentTypeID

SELECT * FROM EmploymentContract ORDER BY EmploymentContractID

/* Triggers testing */

-- Trigger will increment contract counters of agent and client
INSERT INTO Contract(
    ContractKindID, ContractObjectID, InsuranceInterest, InsuranceAmount, 
    Date, ValidityPeriod, ContractStatusID, ClientID, AgentID
    )
     VALUES (1, 3, 15, 34000, '20200401', 12, 1,  2, 2)


-- Operation will be cancelled by trigger
UPDATE Contract
   SET AgentID = 1
 WHERE ContractID = 12

/* Some testing queries for report */

SELECT 
       Agent.AgentID, 
       Agent.Name, 
       Agent.Rate, 
       EmploymentContract.Salary,
       AgentPosition.Position,
       Department.Address
  FROM Agent
       INNER JOIN EmploymentContract
       ON Agent.AgentID = EmploymentContract.AgentID

       INNER JOIN AgentPosition
       ON EmploymentContract.AgentPositionID = AgentPosition.AgentPositionID

       INNER JOIN Department
       ON Department.DepartmentID = EmploymentContract.DepartmentID
 WHERE EmploymentContract.EndDate IS NULL