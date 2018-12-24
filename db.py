import cx_Oracle
import pandas as pd


user_name = 'my_name'
password = 'my_name'
server = 'xe'


class UserPackage:
    def __init__(self):
        self.__db = cx_Oracle.connect(user_name, password, server)
        self.__cursor = self.__db.cursor()

    def add_user(self, login, first_name, last_name, birthday, sex, password, doctor):
        user_login = self.__cursor.var(cx_Oracle.STRING)
        status = self.__cursor.var(cx_Oracle.STRING)
        self.__cursor.callproc('user_package.add_user', [user_login, status,login, first_name,
                                                           last_name, birthday,
                                                           sex, password, doctor])
        return user_login.getvalue(), status.getvalue()

    def update_user_first_name(self, status, login, first_name):
        self.__cursor.callproc('user_package.update_user_first_name', [status, login, first_name])

    def update_user_last_name(self, status, login, last_name):
        self.__cursor.callproc('user_package.update_user_last_name', [status, login, last_name])

    def update_user_birthday(self, status, login, birthday):
        self.__cursor.callproc('user_package.update_user_birthday', [status, login, birthday])

    def update_user_sex(self, status, login, sex):
        self.__cursor.callproc('user_package.update_user_sex', [status, login, sex])

    def update_user_doctor(self, status, login, doctor):
        self.__cursor.callproc('user_package.update_user_doctor', [status, login, doctor])

    def update_user_info_detail(self, login, first_name, last_name, birthday, sex, doctor):
        status_first_name = self.__cursor.var(cx_Oracle.STRING)
        status_last_name = self.__cursor.var(cx_Oracle.STRING)
        status_birthday = self.__cursor.var(cx_Oracle.STRING)
        status_sex = self.__cursor.var(cx_Oracle.STRING)
        status_doctor = self.__cursor.var(cx_Oracle.STRING)
        self.update_user_first_name(status_first_name, login, first_name)
        self.update_user_last_name(status_last_name, login, last_name)
        self.update_user_birthday(status_birthday, login, birthday)
        self.update_user_sex(status_sex, login, sex)
        self.update_user_doctor(status_doctor, login, doctor)
        return (status_first_name.getvalue(),
                status_last_name.getvalue(),
                status_birthday.getvalue(),
                status_sex.getvalue(),
                status_doctor.getvalue())

    def update_user_info(self, login, first_name, last_name, birthday, sex, doctor):
        status = self.__cursor.var(cx_Oracle.STRING)
        self.__cursor.callproc('user_package.update_user_info', [status, login, first_name, last_name, birthday, sex, doctor])
        return status.getvalue()

    def del_user(self, login):
        self.__cursor.callproc('user_package.del_user', [login])

    def login_user(self, login, password):
        sql = "SELECT user_package.LOGIN_USER('{}', '{}') FROM dual".format(login, password)
        res = pd.read_sql_query(sql, self.__db)
        return res

    def its_doctor(self, login):
        sql = "SELECT doctor from user_info where login = '{}'".format(login)
        res = pd.read_sql_query(sql, self.__db)
        return res['DOCTOR'][0]

    def get_user_info(self, login):
        sql = "SELECT * FROM TABLE(user_package.get_user_info('{}'))".format(login)
        res = pd.read_sql_query(sql, self.__db)
        return res




