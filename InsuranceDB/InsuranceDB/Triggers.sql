/* Switch to our DB */

USE InsuranceDB

/* On adding/deleting a contract we need
 * to increment/decrement counters of 
 * corresponding agent and client */

DROP TRIGGER IF EXISTS OnContractModify

GO

CREATE TRIGGER OnContractModify
    ON Contract AFTER INSERT, DELETE
    AS
 BEGIN
	   SET NOCOUNT ON

	   -- We need identifiers
	   DECLARE @IterAgentID  INTEGER
	   DECLARE @IterClientID INTEGER
	   
	   -- We'll iterate over all inserted rows
	   DECLARE InsertIterator CURSOR FOR
			   SELECT AgentID, ClientID FROM INSERTED
	   
	   OPEN InsertIterator
	   FETCH NEXT FROM InsertIterator INTO @IterAgentID, @IterClientID
	   WHILE @@FETCH_STATUS = 0
	   BEGIN
			-- Let's update agents table - we need to
			-- increment contracts counter
			UPDATE Agent
			   SET NumberOfContracts = NumberOfContracts + 1
			 WHERE AgentID = @IterAgentID

			-- Now he same deal with client
			UPDATE Client
			   SET NumberOfContracts = NumberOfContracts + 1
			 WHERE ClientID = @IterClientID

			-- And let's go to the next row
			FETCH NEXT FROM InsertIterator INTO @IterAgentID, @IterClientID
	   END
	   CLOSE InsertIterator
	   DEALLOCATE InsertIterator

	   -- Iteration over deleted rows
	   DECLARE DeleteIterator CURSOR FOR
			   SELECT AgentID, ClientID FROM DELETED
	   
	   OPEN DeleteIterator
	   FETCH NEXT FROM DeleteIterator INTO @IterAgentID, @IterClientID
	   WHILE @@FETCH_STATUS = 0
	   BEGIN
			-- Decrement agent's contracts counter
			UPDATE Agent
			   SET NumberOfContracts = NumberOfContracts - 1
			 WHERE AgentID = @IterAgentID

			-- The same deal with client
			UPDATE Client
			   SET NumberOfContracts = NumberOfContracts - 1
			 WHERE ClientID = @IterClientID

			-- to the next row!
			FETCH NEXT FROM DeleteIterator INTO @IterAgentID, @IterClientID
	   END
	   CLOSE DeleteIterator
	   DEALLOCATE DeleteIterator
   END

GO

/* Trigger that prohibits any modifications of existing contracts */

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

	   -- We need an identifier
	   DECLARE @IterDepartmentID INTEGER

	   -- Declare cursor for iteration
	   DECLARE InsertIterator CURSOR FOR
			   SELECT DepartmentID FROM INSERTED

	   OPEN InsertIterator
	   FETCH NEXT FROM InsertIterator INTO @IterDepartmentID
	   WHILE @@FETCH_STATUS = 0
	   BEGIN
	        -- Updating corresponding department entry
			UPDATE Department
			   SET NumberOfEmploees = NumberOfEmploees + 1
			 WHERE DepartmentID = @IterDepartmentID

			-- To the next element
			FETCH NEXT FROM InsertIterator INTO @IterDepartmentID
	   END
	   CLOSE InsertIterator
	   DEALLOCATE InsertIterator
   END

GO