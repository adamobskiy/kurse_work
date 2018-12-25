create or replace PACKAGE user_package IS
  TYPE user_info_row IS RECORD (
    loginuser user_info.login%TYPE,
    firstname user_info.first_name%TYPE,
    lastname user_info.last_name%TYPE,
    birthdayuser user_info.birthday%TYPE,
    sexuser user_info.sex%TYPE,
    doctoruser user_info.doctor%TYPE
    );
  TYPE tblgetuserinfo IS
    TABLE OF user_info_row;
  PROCEDURE add_user(user_login OUT user_info.login%TYPE,
                     status out varchar2,
                     loginuser IN user_info.login%TYPE,
                     firstname IN user_info.first_name%TYPE,
                     lastname IN user_info.last_name%TYPE,
                     birthdayuser IN user_info.birthday%TYPE,
                     sexuser IN user_info.sex%TYPE,
                     passworduser IN user_info.password_%TYPE,
                     doctoruser IN user_info.doctor%TYPE);

  PROCEDURE del_user(
    loginuser IN user_info.login%TYPE
  );

  PROCEDURE update_user_first_name(status OUT varchar2,
                                   loginuser IN user_info.login%TYPE,
                                   firstname IN user_info.first_name%TYPE);

  PROCEDURE update_user_last_name(status OUT varchar2,
                                  loginuser IN user_info.login%TYPE,
                                  lastname IN user_info.last_name%TYPE);

  PROCEDURE update_user_birthday(status OUT varchar2,
                                 loginuser IN user_info.login%TYPE,
                                 birthdayuser IN user_info.birthday%TYPE);

  PROCEDURE update_user_sex(status OUT varchar2,
                            loginuser IN user_info.login%TYPE,
                            sexuser IN user_info.sex%TYPE);

  PROCEDURE update_user_doctor(status OUT varchar2,
                               loginuser IN user_info.login%TYPE,
                               doctoruser IN user_info.sex%TYPE);

  PROCEDURE update_user_submit(status OUT varchar2,
                               loginuser IN user_info.login%TYPE,
                               submituser IN user_info.submited%TYPE);


  PROCEDURE update_user_info(status OUT varchar2,
                             loginuser IN user_info.login%TYPE,
                             firstname IN user_info.first_name%TYPE,
                             lastname IN user_info.last_name%TYPE,
                             birthdayuser IN user_info.birthday%TYPE,
                             sexuser IN user_info.sex%TYPE,
                             doctoruser IN user_info.sex%TYPE);


  FUNCTION get_user_info(
    loginuser IN user_info.login%TYPE
  ) RETURN tblgetuserinfo
    PIPELINED;

  FUNCTION login_user(loginuser user_info.login%TYPE,
                      passworduser user_info.password_%TYPE) RETURN NUMBER;

END user_package;
/


CREATE OR REPLACE PACKAGE BODY user_package IS

  PROCEDURE add_user(user_login OUT user_info.login%TYPE,
                     status OUT varchar2,
                     loginuser IN user_info.login%TYPE,
                     firstname IN user_info.first_name%TYPE,
                     lastname IN user_info.last_name%TYPE,
                     birthdayuser IN user_info.birthday%TYPE,
                     sexuser IN user_info.sex%TYPE,
                     passworduser IN user_info.password_%TYPE,
                     doctoruser IN user_info.doctor%TYPE) IS
    PRAGMA autonomous_transaction;
  BEGIN
    INSERT INTO user_info (login,
                           first_name,
                           last_name,
                           birthday,
                           sex,
                           PASSWORD_,
                           doctor)
    VALUES (loginuser,
            firstname,
            lastname,
            birthdayuser,
            sexuser,
            passworduser,
            doctoruser) RETURNING login
             INTO user_login;
    COMMIT;
    status := 'ok';
    EXCEPTION
    WHEN DUP_VAL_ON_INDEX
    THEN
      status := 'Користувач з таким іменем уже існує';
    WHEN OTHERS
    THEN
      status := SQLERRM;
  END add_user;


  PROCEDURE del_user(
    loginuser IN user_info.login%TYPE
  ) IS
    PRAGMA autonomous_transaction;
  BEGIN
    DELETE
    FROM user_info
    WHERE user_info.login = loginuser;

    COMMIT;
    EXCEPTION
    WHEN OTHERS
    THEN
      ROLLBACK;
      RAISE value_error;
  END del_user;

  PROCEDURE update_user_first_name(status OUT varchar2,
                                   loginuser IN user_info.login%TYPE,
                                   firstname IN user_info.first_name%TYPE) IS
    PRAGMA autonomous_transaction;
  BEGIN
    UPDATE user_info
    SET user_info.first_name = firstname
    WHERE user_info.login = loginuser;

    COMMIT;
    status := 'ok';
    EXCEPTION
    WHEN OTHERS
    THEN
      status := SQLERRM;
  END update_user_first_name;

  PROCEDURE update_user_last_name(status OUT varchar2,
                                  loginuser IN user_info.login%TYPE,
                                  lastname IN user_info.last_name%TYPE) IS
    PRAGMA autonomous_transaction;
  BEGIN
    UPDATE user_info
    SET user_info.last_name = lastname
    WHERE user_info.login = loginuser;

    COMMIT;
    status := 'ok';
    EXCEPTION
    WHEN OTHERS
    THEN
      status := SQLERRM;
  END update_user_last_name;

  PROCEDURE update_user_birthday(status OUT varchar2,
                                 loginuser IN user_info.login%TYPE,
                                 birthdayuser IN user_info.birthday%TYPE) IS
    PRAGMA autonomous_transaction;
  BEGIN
    UPDATE user_info
    SET user_info.birthday = birthdayuser
    WHERE user_info.login = loginuser;

    COMMIT;
    status := 'ok';
    EXCEPTION
    WHEN OTHERS
    THEN
      status := SQLERRM;
  END update_user_birthday;

  PROCEDURE update_user_sex(status OUT varchar2,
                            loginuser IN user_info.login%TYPE,
                            sexuser IN user_info.sex%TYPE) IS
    PRAGMA autonomous_transaction;
  BEGIN
    UPDATE user_info
    SET user_info.sex = sexuser
    WHERE user_info.login = loginuser;

    COMMIT;
    status := 'ok';
    EXCEPTION
    WHEN OTHERS
    THEN
      status := SQLERRM;
  END update_user_sex;

  PROCEDURE update_user_doctor(status OUT varchar2,
                               loginuser IN user_info.login%TYPE,
                               doctoruser IN user_info.sex%TYPE) IS
    PRAGMA autonomous_transaction;
  BEGIN
    UPDATE user_info
    SET user_info.doctor = doctoruser
    WHERE user_info.login = loginuser;

    COMMIT;
    status := 'ok';
    EXCEPTION
    WHEN OTHERS
    THEN
      status := SQLERRM;
  END update_user_doctor;


  PROCEDURE update_user_submit(status OUT varchar2,
                               loginuser IN user_info.login%TYPE,
                               submituser IN user_info.submited%TYPE) IS
    PRAGMA autonomous_transaction;
  BEGIN
    UPDATE user_info
    SET user_info.SUBMITED = submituser
    WHERE user_info.login = loginuser;

    COMMIT;
    status := 'ok';
    EXCEPTION
    WHEN OTHERS
    THEN
      status := SQLERRM;
  END update_user_submit;


  PROCEDURE update_user_info(status OUT varchar2,
                             loginuser IN user_info.login%TYPE,
                             firstname IN user_info.first_name%TYPE,
                             lastname IN user_info.last_name%TYPE,
                             birthdayuser IN user_info.birthday%TYPE,
                             sexuser IN user_info.sex%TYPE,
                             doctoruser IN user_info.sex%TYPE) IS
    PRAGMA autonomous_transaction;
  BEGIN
    UPDATE user_info
    SET user_info.FIRST_NAME = firstname,
        USER_INFO.LAST_NAME  = lastname,
        user_info.BIRTHDAY   = birthdayuser,
        USER_INFO.SEX        = sexuser,
        USER_INFO.DOCTOR     = doctoruser
    WHERE user_info.login = loginuser;
    COMMIT;
    status := 'ok';
    EXCEPTION
    WHEN OTHERS
    THEN
      status := SQLERRM;
  END update_user_info;

  FUNCTION
    get_user_info(
    loginuser IN user_info.login%TYPE
  )
    RETURN
      tblgetuserinfo
    PIPELINED
  IS
  BEGIN
    FOR curr IN (
      SELECT DISTINCT login,
                      first_name,
                      last_name,
                      birthday,
                      sex,
                      doctor
      FROM user_info
      WHERE user_info.login = loginuser
      )
      LOOP
        PIPE ROW ( curr );
      END LOOP;
  END get_user_info;

  FUNCTION
    login_user(loginuser user_info.login%TYPE,
               passworduser user_info.password_%TYPE)
    RETURN
      NUMBER
  IS
    res
      NUMBER(1);
  BEGIN
    SELECT COUNT(*) INTO res
    FROM user_info
    WHERE user_info.login = loginuser
      AND user_info.password_ = passworduser;

    return (res);
  END login_user;

END user_package;
/

