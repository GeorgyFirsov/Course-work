from os import path

from DataGeneration.tables_generation import (create_clients_table,
                                              create_agents_table,
                                              create_departments_table,
                                              create_contracts_table,
                                              create_empcont_table,
                                              )

# Number of rows in test table
test_count = 1

# Format for paths of resulting tables
test_path_fmt = '..\\TablesExcel\\Test{}.csv'
release_path_fmt = '..\\TablesExcel\\{}.csv'

# Mapping between names of tables and its' generation functions with number of rows to be generated
tables_mapping = {
    'Client': (create_clients_table, 200),
    'Agent': (create_agents_table, 50),
    'Department': (create_departments_table, 10),
    'EmploymentContract': (create_empcont_table, 50),
    'Contract': (create_contracts_table, 200)
}


def main() -> None:
    """
    Main function of generation script. Runs generation function for each
    required table in 'tables_mapping'.
    """
    for name, (create, cnt) in tables_mapping.items():
        test = create(test_count)
        release = create(cnt)

        test.to_csv(path.expandvars(test_path_fmt.format(name)), index=False)
        release.to_csv(path.expandvars(release_path_fmt.format(name)), index=False)

        print(f'Table {name} written')


if __name__ == '__main__':
    main()
