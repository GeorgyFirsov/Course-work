/* ������������ �� ���� ��������� �� */

USE InsuranceDB

/* ��� ���������� ������ �������� ����������
 * ��������� ������� ��������� ��� ���������������
 * ������� � ������. ��� �������� ��
 * �������� ���������� ��������� */

DROP TRIGGER IF EXISTS OnContractModify

GO

CREATE TRIGGER OnContractModify
    ON Contract AFTER INSERT, DELETE
    AS
 BEGIN
	   SET NOCOUNT ON

	   -- ����� ������ ���� � ����������������
	   DECLARE @IterAgentID  INTEGER
	   DECLARE @IterClientID INTEGER
	   
	   -- ����� ������������� �� ���� ����������� �������
	   DECLARE InsertIterator CURSOR FOR
			   SELECT AgentID, ClientID FROM INSERTED
	   
	   OPEN InsertIterator
	   FETCH NEXT FROM InsertIterator INTO @IterAgentID, @IterClientID
	   WHILE @@FETCH_STATUS = 0
	   BEGIN
			-- ������� ������� � �������� - ���� ���������
			-- ���������� ���������
			UPDATE Agent
			   SET NumberOfContracts = NumberOfContracts + 1
			 WHERE AgentID = @IterAgentID

			-- � ������ �� �� �����, �� � ��������
			UPDATE Client
			   SET NumberOfContracts = NumberOfContracts + 1
			 WHERE ClientID = @IterClientID

			-- ��������� � ��������� ������
			FETCH NEXT FROM InsertIterator INTO @IterAgentID, @IterClientID
	   END
	   CLOSE InsertIterator
	   DEALLOCATE InsertIterator

	   -- ���������� ������ �� ��������� �������
	   DECLARE DeleteIterator CURSOR FOR
			   SELECT AgentID, ClientID FROM DELETED
	   
	   OPEN DeleteIterator
	   FETCH NEXT FROM DeleteIterator INTO @IterAgentID, @IterClientID
	   WHILE @@FETCH_STATUS = 0
	   BEGIN
			-- �������� ���������� ��������� ������
			UPDATE Agent
			   SET NumberOfContracts = NumberOfContracts - 1
			 WHERE AgentID = @IterAgentID

			-- � ������ �� �� �����, �� � ��������
			UPDATE Client
			   SET NumberOfContracts = NumberOfContracts - 1
			 WHERE ClientID = @IterClientID

			-- ��������� � ��������� ������
			FETCH NEXT FROM DeleteIterator INTO @IterAgentID, @IterClientID
	   END
	   CLOSE DeleteIterator
	   DEALLOCATE DeleteIterator
   END

GO

/* �������, ����������� ������ ������� � ������ � �������� */

DROP TRIGGER IF EXISTS OnContractUpdate

GO

CREATE TRIGGER OnContractUpdate
    ON Contract AFTER UPDATE
	AS 
 BEGIN
	   IF ( UPDATE(AgentID) OR UPDATE(ClientID) )
	   BEGIN
			 ROLLBACK
	   END
   END

GO

DROP TRIGGER IF EXISTS OnEmploymentContractModify

GO

CREATE TRIGGER OnEmploymentContractModify
    ON EmploymentContract AFTER INSERT
	AS
 BEGIN
       SET NOCOUNT ON

	   -- ����������� ������ ������������� ���������
	   DECLARE @IterDepartmentID INTEGER

	   -- ������� ������-��������
	   DECLARE InsertIterator CURSOR FOR
			   SELECT DepartmentID FROM INSERTED

	   OPEN InsertIterator
	   FETCH NEXT FROM InsertIterator INTO @IterDepartmentID
	   WHILE @@FETCH_STATUS = 0
	   BEGIN
	        -- ������� ������ ��������� ��������
			UPDATE Department
			   SET NumberOfEmploees = NumberOfEmploees + 1
			 WHERE DepartmentID = @IterDepartmentID

			-- �������� � ���������� ��������
			FETCH NEXT FROM InsertIterator INTO @IterDepartmentID
	   END
	   CLOSE InsertIterator
	   DEALLOCATE InsertIterator
   END

GO