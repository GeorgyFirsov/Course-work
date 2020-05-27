/* Переключимся на нашу созданную БД */

USE InsuranceDB

/* При добавлении нового договора необходимо
 * увеличить счетчик договоров для соответствующих
 * клиента и агента. При удалении же
 * счетчики необходимо уменьшить */

DROP TRIGGER IF EXISTS OnContractModify

GO

CREATE TRIGGER OnContractModify
    ON Contract AFTER INSERT, DELETE
    AS
 BEGIN
	   SET NOCOUNT ON

	   -- Нужны только поля с идентификаторами
	   DECLARE @IterAgentID  INTEGER
	   DECLARE @IterClientID INTEGER
	   
	   -- Будем итерироваться по всем вставленным записям
	   DECLARE InsertIterator CURSOR FOR
			   SELECT AgentID, ClientID FROM INSERTED
	   
	   OPEN InsertIterator
	   FETCH NEXT FROM InsertIterator INTO @IterAgentID, @IterClientID
	   WHILE @@FETCH_STATUS = 0
	   BEGIN
			-- Обновим таблицу с агентами - надо увеличить
			-- количество договоров
			UPDATE Agent
			   SET NumberOfContracts = NumberOfContracts + 1
			 WHERE AgentID = @IterAgentID

			-- А теперь то же самое, но с клиентом
			UPDATE Client
			   SET NumberOfContracts = NumberOfContracts + 1
			 WHERE ClientID = @IterClientID

			-- Переходим к следующей записи
			FETCH NEXT FROM InsertIterator INTO @IterAgentID, @IterClientID
	   END
	   CLOSE InsertIterator
	   DEALLOCATE InsertIterator

	   -- Проходимся теперь по удаленным записям
	   DECLARE DeleteIterator CURSOR FOR
			   SELECT AgentID, ClientID FROM DELETED
	   
	   OPEN DeleteIterator
	   FETCH NEXT FROM DeleteIterator INTO @IterAgentID, @IterClientID
	   WHILE @@FETCH_STATUS = 0
	   BEGIN
			-- Уменьшим количество договоров агента
			UPDATE Agent
			   SET NumberOfContracts = NumberOfContracts - 1
			 WHERE AgentID = @IterAgentID

			-- А теперь то же самое, но с клиентом
			UPDATE Client
			   SET NumberOfContracts = NumberOfContracts - 1
			 WHERE ClientID = @IterClientID

			-- Переходим к следующей записи
			FETCH NEXT FROM DeleteIterator INTO @IterAgentID, @IterClientID
	   END
	   CLOSE DeleteIterator
	   DEALLOCATE DeleteIterator
   END

GO

/* Триггер, запрещающий менять клиента и агента в договоре */

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

	   -- Понадобится только идентиыикатор отделения
	   DECLARE @IterDepartmentID INTEGER

	   -- Объявим курсор-итератор
	   DECLARE InsertIterator CURSOR FOR
			   SELECT DepartmentID FROM INSERTED

	   OPEN InsertIterator
	   FETCH NEXT FROM InsertIterator INTO @IterDepartmentID
	   WHILE @@FETCH_STATUS = 0
	   BEGIN
	        -- Обновим нужное отделение компании
			UPDATE Department
			   SET NumberOfEmploees = NumberOfEmploees + 1
			 WHERE DepartmentID = @IterDepartmentID

			-- Перейдем к следующему элементу
			FETCH NEXT FROM InsertIterator INTO @IterDepartmentID
	   END
	   CLOSE InsertIterator
	   DEALLOCATE InsertIterator
   END

GO