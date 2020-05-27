/* Переключимся на нашу созданную БД */

USE InsuranceDB

/* Запросы к БД */

/*
 * 1. Клиенты, которые имеют договоры со всеми возможными состояниями.
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
 * 2. Действующие договоры на страхование дачи от пожара, сумма выплат 
 *    по которым максимальна.
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
 * 3. Договоры на страхование жизни, сумма страховых выплат по которым 
 *    не является ни максимальной, ни минимальной.
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
 * 4. Среднее значение страховых выплат по всем действующим договорам.
 */
SELECT AVG(Contract.InsuranceAmount) AS 'AvgInsuranceAmount'
  FROM Contract 
       INNER JOIN ContractStatus 
       ON ContractStatus.ContractStatusID = Contract.ContractStatusID 
          AND ContractStatus.Status = 'Valid';

/*
 * 5. Страховые агенты, которые вели дела с клиентом с паспортом 2222 654321.
 */
SELECT Agent.*
  FROM Agent 
       INNER JOIN Contract 
       ON Agent.AgentID = Contract.AgentID 

       INNER JOIN Client
       ON Contract.ClientID = Client.ClientID 
          AND Client.PassportId = '2222 654321';