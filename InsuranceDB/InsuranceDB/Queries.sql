/* ������������ �� ���� ��������� �� */

USE InsuranceDB

/* ������� � �� */

/*
 * 1. �������, ������� ����� �������� �� ����� ���������� �����������.
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
 * 2. ����������� �������� �� ����������� ���� �� ������, ����� ������ 
 *    �� ������� �����������.
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
 * 3. �������� �� ����������� �����, ����� ��������� ������ �� ������� 
 *    �� �������� �� ������������, �� �����������.
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
 * 4. ������� �������� ��������� ������ �� ���� ����������� ���������.
 */
SELECT AVG(Contract.InsuranceAmount) AS 'AvgInsuranceAmount'
  FROM Contract 
       INNER JOIN ContractStatus 
       ON ContractStatus.ContractStatusID = Contract.ContractStatusID 
          AND ContractStatus.Status = 'Valid';

/*
 * 5. ��������� ������, ������� ���� ���� � �������� � ��������� 2222 654321.
 */
SELECT Agent.*
  FROM Agent 
       INNER JOIN Contract 
       ON Agent.AgentID = Contract.AgentID 

       INNER JOIN Client
       ON Contract.ClientID = Client.ClientID 
          AND Client.PassportId = '2222 654321';