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
        try:
            self.__cursor.callproc('user_package.add_user', [login, first_name,
                                                           last_name, birthday,
                                                           sex, password, doctor])
            return True
        except:
            return False
        # self.cursor.callproc('user_package.add_user', [login, first_name,
        #                                                last_name, birthday,
        #                                                sex, password])

    def update_user_first_name(self, login, first_name):
        self.__cursor.callproc('user_package.update_user_first_name', [login, first_name])

    def update_user_last_name(self, login, last_name):
        self.__cursor.callproc('user_package.update_user_last_name', [login, last_name])

    def update_user_birth(self, login, birthday):
        self.__cursor.callproc('user_package.update_user_birth', [login, birthday])

    def update_user_sex(self, login, sex):
        self.__cursor.callproc('user_package.update_user_sex', [login, sex])

    def del_user(self, login):
        self.__cursor.callproc('user_package.del_user', [login])

    def login_user(self, login, password):
        sql = "SELECT user_package.LOGIN_USER('{}', '{}') FROM dual".format(login, password)
        res = pd.read_sql_query(sql, self.__db)
        return res

    def get_user_info(self, login):
        sql = "SELECT * FROM TABLE(user_package.get_user_info('{}'))".format(login)
        res = pd.read_sql_query(sql, self.__db)
        return res