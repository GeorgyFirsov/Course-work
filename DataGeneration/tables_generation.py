from random import (randint,
                    randrange,
                    choice,
                    )

import pandas as pd
import numpy as np

from DataGeneration.fake_generation import make_generator


# All following functions are used for generation of random date
# and put it into pandas.DataFrame object. It makes it to be
# easily saved into *.csv files.
#
# Tables to be generated:
# - Client
# - Agent
# - Department
# - EmploymentContract
# - Contract

def create_clients_table(count_of_entries: int) -> pd.DataFrame:
    fake = make_generator()
    clients = pd.DataFrame(columns=[
        'Name', 'PhoneNumber', 'PassportId', 'Address', 'NumberOfContracts', 'TaxNumber'
    ])

    clients['Name'] = np.array([fake.name() for _ in range(count_of_entries)])
    clients['PhoneNumber'] = np.array([fake.phone() for _ in range(count_of_entries)])
    clients['PassportId'] = np.array([fake.passport() for _ in range(count_of_entries)])
    clients['Address'] = np.array([
        fake.address().replace('\n', ' ').split(',')[0][:50] for _ in range(count_of_entries)
    ])
    clients['NumberOfContracts'] = np.zeros(count_of_entries, dtype=int)
    clients['TaxNumber'] = np.array([11 + i for i in range(count_of_entries)])
    return clients


def create_agents_table(count_of_entries: int) -> pd.DataFrame:
    fake = make_generator()
    agents = pd.DataFrame(columns=[
        'Name', 'PhoneNumber', 'PassportId', 'Rate', 'NumberOfContracts'
    ])

    agents['Name'] = np.array([fake.name() for _ in range(count_of_entries)])
    agents['PhoneNumber'] = np.array([fake.phone() for _ in range(count_of_entries)])
    agents['PassportId'] = np.array([fake.passport() for _ in range(count_of_entries)])
    agents['Rate'] = np.array([randrange(0, 300, 50) for _ in range(count_of_entries)])
    agents['NumberOfContracts'] = np.zeros(count_of_entries, dtype=int)
    return agents


def create_departments_table(count_of_entries: int) -> pd.DataFrame:
    fake = make_generator()
    deps = pd.DataFrame(columns=[
        'Address', 'PhoneNumber', 'DepartmentTypeID', 'NumberOfEmployees'
    ])

    deps['Address'] = np.array([
        fake.address().replace('\n', ' ').split(',')[0][:50] for _ in range(count_of_entries)
    ])
    deps['PhoneNumber'] = np.array([fake.phone() for _ in range(count_of_entries)])
    deps['DepartmentTypeID'] = np.array([randint(2, 3) for _ in range(count_of_entries)])
    deps['NumberOfEmployees'] = np.zeros(count_of_entries, dtype=int)
    return deps


def create_empcont_table(count_of_entries: int) -> pd.DataFrame:
    def position(salary: int) -> int:
        if salary >= 5000:
            return 3
        elif salary >= 4000:
            return 2
        elif salary >= 3000:
            return 1
        else:
            return 4

    fake = make_generator()
    empconts = pd.DataFrame(columns=[
        'Number', 'AgentID', 'Salary', 'AgentPositionID', 'DepartmentID', 'StartDate', 'Status'
    ])

    empconts['Number'] = np.arange(7, 7 + count_of_entries, 1, dtype=int)
    empconts['AgentID'] = np.arange(6, 6 + count_of_entries, 1, dtype=int)
    empconts['Salary'] = np.array([randrange(2000, 6000, 500) for _ in range(count_of_entries)])
    empconts['AgentPositionID'] = np.array([
        position(empconts['Salary'].values[i]) for i in range(count_of_entries)
    ])
    empconts['DepartmentID'] = np.array([randint(1, 13) for _ in range(count_of_entries)])
    empconts['StartDate'] = np.array([fake.date_() for _ in range(count_of_entries)])
    empconts['Status'] = np.zeros(count_of_entries, dtype=int)
    return empconts


def create_contracts_table(count_of_entries: int) -> pd.DataFrame:
    def kind_by_obj(obj: int) -> tuple:
        mapping = {
            2: (1, 3, 5), 3: (1, 3, 5), 5: (1, 3, 5),
            6: (1, 3, 5), 1: (2, 4, 7), 4: (1, 6, 7)
        }
        return mapping[obj]

    fake = make_generator()
    contracts = pd.DataFrame(columns=[
        'ContractKindID', 'ContractObjectID', 'InsuranceInterest', 'InsuranceAmount',
        'Date', 'ValidityPeriod', 'ContractStatusID', 'ClientID', 'AgentID'
    ])

    contracts['ContractObjectID'] = np.array([randint(1, 6) for _ in range(count_of_entries)])
    contracts['ContractKindID'] = np.array([
        choice(kind_by_obj(contracts['ContractObjectID'].values[i])) for i in range(count_of_entries)
    ])
    contracts['InsuranceInterest'] = np.array([randint(2, 15) for _ in range(count_of_entries)])
    contracts['InsuranceAmount'] = np.array([randrange(1500, 65000, 500) for _ in range(count_of_entries)])
    contracts['Date'] = np.array([fake.date_(2018) for _ in range(count_of_entries)])
    contracts['ValidityPeriod'] = np.array([randrange(24, 48, 12) for _ in range(count_of_entries)])
    contracts['ContractStatusID'] = np.array([1 + int(randint(0, 1000) < 150) for _ in range(count_of_entries)])
    contracts['ClientID'] = np.arange(11, 11 + count_of_entries, 1, dtype=int)
    contracts['AgentID'] = np.array([randint(1, 55) for _ in range(count_of_entries)])
    return contracts
