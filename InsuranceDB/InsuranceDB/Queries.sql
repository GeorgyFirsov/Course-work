/* Switch to DB */

USE InsuranceDB

/* Queries */

/*
 * 1. Clients that have contracts with all available statuses
 */
SELECT Client.*
  FROM Client
       INNER JOIN (
           SELECT Contract.ClientID
             FROM Contract
         GROUP BY Contract.ClientID
           HAVING COUNT(DISTINCT Contract.ContractStatusID) = 
                  (SELECT COUNT(DISTINCT ContractStatusID) FROM ContractStatus)
           ) AS Ids
       ON Client.ClientID = Ids.ClientID;


/*
 * 2. Valid insurance contracts of a house from fire with maximum insurance amount
 */
GO
CREATE VIEW HouseFromFire AS
SELECT Contract.*
  FROM Contract
       INNER JOIN ContractObject
       ON Contract.ContractObjectID = ContractObject.ContractObjectID
          AND ContractObject.Object = 'House'

       INNER JOIN ContractKind
       ON Contract.ContractKindID = ContractKind.ContractKindID
          AND ContractKind.Kind = 'Fire';
GO

SELECT *
  FROM HouseFromFire
 WHERE HouseFromFire.InsuranceAmount = (SELECT MAX(HouseFromFire.InsuranceAmount) FROM HouseFromFire);


/*
 * 3. Insurance contracts of life with non-maximum and non-minimum 
 *    insuranse amount
 */
GO
CREATE VIEW LifeProtect AS
SELECT Contract.*
  FROM Contract
       INNER JOIN ContractObject
       ON Contract.ContractObjectID = ContractObject.ContractObjectID
          AND ContractObject.Object = 'Life'
GO

SELECT *
  FROM LifeProtect
 WHERE LifeProtect.InsuranceAmount != (SELECT MAX(LifeProtect.InsuranceAmount) FROM LifeProtect)
   AND LifeProtect.InsuranceAmount != (SELECT MIN(LifeProtect.InsuranceAmount) FROM LifeProtect)


/*
 * 4. Average insurance amount between valid contractss
 */
SELECT AVG(Contract.InsuranceAmount) AS 'AvgInsuranceAmount'
  FROM Contract 
       INNER JOIN ContractStatus 
       ON ContractStatus.ContractStatusID = Contract.ContractStatusID 
          AND ContractStatus.Status = 'Valid';

/*
 * 5. Agents that have had a deal with client with passport 2222 654321.
 */
SELECT Agent.*
  FROM Agent 
       INNER JOIN Contract 
       ON Agent.AgentID = Contract.AgentID 

       INNER JOIN Client
       ON Contract.ClientID = Client.ClientID 
          AND Client.PassportId = '2222 654321';