/* Switch to our DB */

USE InsuranceDB

/* Filling DB */

/* Let's fill codifiers */

-- AgentPosition -----------------

INSERT INTO AgentPosition (Position)
     VALUES ('Agent'),
            ('Lead agent'),
            ('Agent-manager'),
            ('Trainee agent');

-- DepartmentType ----------------

INSERT INTO DepartmentType (Type)
     VALUES ('HQ'),
            ('Office'),
            ('Regional department');

-- ContractKind ------------------

INSERT INTO ContractKind (Kind)
     VALUES ('Fire'),
            ('Accident'),
            ('Theft'),
            ('Desease'),
            ('Flooding'),
            ('Crash'),
            ('Death'),
            ('Hijacking');

-- ContractObject ----------------

INSERT INTO ContractObject (Object, State)
     VALUES ('Life',   4),
            ('Flat',   1),
            ('Flat',   0),
            ('Car',    3),
            ('Garage', 2),
            ('House',  0);

-- ContractStatus ----------------

INSERT INTO ContractStatus (Status)
     VALUES ('Valid'),
            ('Terminated'),
            ('Expired');


/* Now let's fill main tables */

-- Department --------------------

INSERT INTO Department (Address, PhoneNumber, DepartmentTypeID, NumberOfEmployees)
     VALUES ('31 Littleton Ave. New Lenox', '1(202)2091761', 1, 2),
            ('713 Rose Street Blacksburg',  '1(202)2277293', 2, 2),
            ('993 8th Ave. Evansville',     '1(202)7164388', 3, 1);

-- Agent -------------------------

INSERT INTO Agent (Name, PhoneNumber, PassportId, Rate, NumberOfContracts)
     VALUES ('Robert Anderson', '1(202)1527822', '1111 123456',    0, 4),
            ('Cameron French',  '1(202)7331878', '1111 123457',   75, 1),
            ('Ashlynn Hall',    '1(202)1796059', '1111 123458', 1500, 2),
            ('Cynthia Jordan',  '1(202)5523895', '1111 123459',    0, 2),
            ('Duane Jefferson', '1(202)5843804', '1111 123460',  100, 3);

-- EmploymentContract ------------

INSERT INTO EmploymentContract (
    Number, AgentID, Salary, AgentPositionID, DepartmentID, StartDate, /* EndDate, */ Status
    )
     VALUES (1, 3, 4000, 3, 1, '20140106', 0), /* Will be cancelled */
            (2, 1, 2000, 4, 2, '20160612', 0),
            (3, 2, 3500, 1, 2, '20160205', 0),
            (4, 3, 6000, 2, 1, '20191218', 0),
            (5, 4, 2000, 4, 1, '20171016', 0),
            (6, 5, 4000, 3, 3, '20141124', 0);

/* Cancel one contract */
UPDATE EmploymentContract
   SET EndDate = '20191217', Status = 1
 WHERE EmploymentContractID = 1

-- Client ------------------------

INSERT INTO Client (Name, PhoneNumber, PassportId, Address, NumberOfContracts, TaxNumber)
     VALUES ('Joshua Butler',     '1(0680)0849374', '2222 654321', '20 Old Berkshire St. Hattiesburg',      3,  1),
            ('Clifford Pearson',  '1(857)3446638',  '2222 654322', '7566 SE. Thatcher Street Andover',      1,  2),
            ('Kenneth Owen',      '1(1848)3851911', '2222 654323', '73 Columbia Road Ridgefield',           1,  3),
            ('Jessica Taylor',    '1(5113)6114749', '2222 654324', '8842 South Grandrose Street Jamestown', 1,  4),
            ('Edward Gallagher',  '1(15)9468847',   '2222 654325', '185 South Crescent St. Kenosha',        1,  5),
            ('Fay Turner',        '1(32)3351963',   '2222 654326', '9002 N. Ocean Dr. Allen Park',          1,  6),
            ('Katrina Floyd',     '1(20)3517439',   '2222 654327', '17 East Oklahoma St. Mays Landing',     1,  7),
            ('Daniel Oliver',     '1(8945)3955389', '2222 654328', '718 School Drive Naples',               1,  8),
            ('Leslie Hutchinson', '1(2491)2433878', '2222 654329', '83 Clinton Drive Suite 604 Ypsilanti',  1,  9),
            ('Joseph Potter',     '1(52)4224772',   '2222 654330', '851 Academy Rd. Superior',              1, 10);

-- Contract ----------------------

INSERT INTO Contract (
    ContractKindID, ContractObjectID, InsuranceInterest, InsuranceAmount, 
    Date, ValidityPeriod, ContractStatusID, ClientID, AgentID
    )
     VALUES (1, 6, 15, 70000, '20200201', 12, 1,  1, 1),
            (3, 2,  5,  5000, '20191114', 24, 2,  1, 2),
            (2, 1, 10,  1000, '20150415',  6, 3,  1, 3),
            (8, 4,  7, 10000, '20200101', 12, 1,  2, 1),
            (1, 3,  6, 15000, '20170612', 18, 2,  3, 1),
            (2, 1,  5,  6000, '20181016',  3, 3,  4, 4),
            (3, 2, 15,  8000, '20151124',  1, 1,  5, 5),
            (4, 1, 12,  3500, '20150106', 12, 2,  6, 3),
            (1, 6,  7, 12000, '20181016', 18, 3,  7, 4),
            (6, 4,  3,  4000, '20151124', 36, 1,  8, 5),
            (7, 1,  7, 11000, '20170612', 48, 2,  9, 1),
            (8, 4,  6,  9500, '20151124', 12, 3, 10, 5);

