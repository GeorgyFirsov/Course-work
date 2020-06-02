from random import randint

from faker import Faker
from faker.providers import BaseProvider


class Phone(BaseProvider):
    """
    Provider for random phone number generation
    """
    def phone(self):
        fmt = '1({}){}'
        code_len = randint(2, 4)
        code = ''.join([str(randint(0, 9)) for _ in range(code_len)])
        number = ''.join([str(randint(0, 9)) for _ in range(7)])
        return fmt.format(code, number)


class PassportNumber(BaseProvider):
    """
    Provider for random passport number generation
    """
    def passport(self):
        fmt = '{} {}'
        series = ''.join([str(randint(0, 9)) for _ in range(4)])
        number = ''.join([str(randint(0, 9)) for _ in range(6)])
        return fmt.format(series, number)


class Date(BaseProvider):
    """
    Provider for random date generation
    """
    def date_(self, start_year: int = 2012):
        fmt = '{}-{:0>2}-{:0>2}'
        year = randint(start_year, 2019)
        month = randint(1, 12)
        day = randint(1, 28 if month == 2 else 30)
        return fmt.format(year, month, day)


def make_generator() -> Faker:
    """
    This function constructs a fake info generator with
    custom providers for phone number, passport number
    and date

    :return: an object-generator of fake data
    """
    fake = Faker(['en_US'])
    fake.add_provider(Phone)
    fake.add_provider(PassportNumber)
    fake.add_provider(Date)
    return fake
