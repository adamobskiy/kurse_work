create or replace PACKAGE card_package IS
    TYPE user_card_row IS RECORD (
        cardnumber card.card_number%TYPE
    );
    TYPE tblgetuserallcards IS
        TABLE OF user_card_row;
    PROCEDURE card_add_card (
        status    OUT       VARCHAR2,
        cardnumber   IN           card.card_number%TYPE,
        userlogin    IN           card.user_login%TYPE
    );

    PROCEDURE card_update_user_login (
        cardnumber      IN              card.card_number%TYPE,
        new_userlogin   IN              card.user_login%TYPE
    );

    PROCEDURE card_delete (
        cardnumber   IN           card.card_number%TYPE
    );

    FUNCTION get_all_user_card (
        userlogin   IN          card.user_login%TYPE
    ) RETURN tblgetuserallcards
        PIPELINED;

END card_package;
/

create or replace PACKAGE BODY card_package IS

    PROCEDURE card_add_card (
         status    OUT       VARCHAR2,
        cardnumber   IN           card.card_number%TYPE,
        userlogin    IN           card.user_login%TYPE
    ) IS
        PRAGMA autonomous_transaction;
    BEGIN
        INSERT INTO card (
            card_number,
            user_login
        ) VALUES (
            cardnumber,
            userlogin
        );

        COMMIT;
        status := 'ok';
    EXCEPTION
        WHEN dup_val_on_index THEN
            status := 'Така назва уже існує';
        WHEN OTHERS THEN
            status := sqlerrm;
    END card_add_card;

    PROCEDURE card_update_user_login (
        cardnumber      IN              card.card_number%TYPE,
        new_userlogin   IN              card.user_login%TYPE
    ) IS
        PRAGMA autonomous_transaction;
    BEGIN
        UPDATE card
        SET
            card.user_login = new_userlogin
        WHERE
            card.card_number = cardnumber;

        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            RAISE value_error;
    END card_update_user_login;

    PROCEDURE card_delete (
        cardnumber   IN           card.card_number%TYPE
    ) IS
        PRAGMA autonomous_transaction;
    BEGIN
        DELETE FROM card
        WHERE
            card.card_number = cardnumber;

        COMMIT;
    END card_delete;

    FUNCTION get_all_user_card (
        userlogin   IN          card.user_login%TYPE
    ) RETURN tblgetuserallcards
        PIPELINED
    IS
    BEGIN
        FOR curr IN (
            SELECT DISTINCT
                card_number
            FROM
                card
            WHERE
                card.user_login = userlogin
        ) LOOP
            PIPE ROW ( curr );
        END LOOP;
    END get_all_user_card;

END card_package;
/

create or replace PACKAGE desease_package IS
    TYPE desease_row IS RECORD (
        disdesc desease.dis_desc%TYPE
    );
    TYPE tblgetdisdesc IS
        TABLE OF desease_row;
    PROCEDURE add_desease (
        status    OUT       VARCHAR2,
        disname   IN        desease.dis_name%TYPE,
        disdesc   IN        desease.dis_desc%TYPE
    );

    PROCEDURE del_desease (
        status    OUT       VARCHAR2,
        disname   IN        desease.dis_name%TYPE
    );

    PROCEDURE update_desease (
        status    OUT       VARCHAR2,
        disname   IN        desease.dis_name%TYPE,
        disdesc   IN        desease.dis_desc%TYPE
    );

    FUNCTION get_desease (
        disname   IN        desease.dis_name%TYPE
    ) RETURN tblgetdisdesc
        PIPELINED;

END desease_package;
/

create or replace PACKAGE BODY desease_package IS

    PROCEDURE add_desease (
        status    OUT       VARCHAR2,
        disname   IN        desease.dis_name%TYPE,
        disdesc   IN        desease.dis_desc%TYPE
    ) IS
        PRAGMA autonomous_transaction;
    BEGIN
        INSERT INTO desease (
            dis_name,
            dis_desc
        ) VALUES (
            disname,
            disdesc
        );

        COMMIT;
        status := 'ok';
    EXCEPTION
        WHEN dup_val_on_index THEN
            status := 'Така назва уже існує';
        WHEN OTHERS THEN
            status := sqlerrm;
    END add_desease;

    PROCEDURE del_desease (
        status    OUT       VARCHAR2,
        disname   IN        desease.dis_name%TYPE
    ) IS
        PRAGMA autonomous_transaction;
    BEGIN
        DELETE FROM disease_view
        WHERE
            disease_view.dis_name = disname;

        COMMIT;
        status := 'ok';
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            status := sqlerrm;
    END del_desease;

    PROCEDURE update_desease (
        status    OUT       VARCHAR2,
        disname   IN        desease.dis_name%TYPE,
        disdesc   IN        desease.dis_desc%TYPE
    ) IS
        PRAGMA autonomous_transaction;
    BEGIN
        UPDATE desease
        SET
            desease.dis_desc = disdesc
        WHERE
            desease.dis_name = disname;

        COMMIT;
        status := 'ok';
    EXCEPTION
        WHEN OTHERS THEN
            status := sqlerrm;
    END update_desease;

    FUNCTION get_desease (
        disname   IN        desease.dis_name%TYPE
    ) RETURN tblgetdisdesc
        PIPELINED
    IS
    BEGIN
        FOR curr IN (
            SELECT DISTINCT
                dis_desc
            FROM
                desease
            WHERE
                desease.dis_name = disname
        ) LOOP
            PIPE ROW ( curr );
        END LOOP;
    END get_desease;

END desease_package;
/

create or replace PACKAGE medicine_package IS
    TYPE medicine_row IS RECORD (
        meddesc medicine.med_desc%TYPE
    );
    TYPE tblgetmeddesc IS
        TABLE OF medicine_row;
    PROCEDURE add_medicine (
        status    OUT       VARCHAR2,
        medname   IN        medicine.med_name%TYPE,
        meddesc   IN        medicine.med_desc%TYPE
    );

    PROCEDURE del_medicine (
        status    OUT       VARCHAR2,
        medname   IN        medicine.med_name%TYPE
    );

    PROCEDURE update_medicine (
        status    OUT       VARCHAR2,
        medname   IN        medicine.med_name%TYPE,
        meddesc   IN        medicine.med_desc%TYPE
    );

    FUNCTION get_medicine (
        medname   IN        medicine.med_name%TYPE
    ) RETURN tblgetmeddesc
        PIPELINED;

END medicine_package;
/

create or replace PACKAGE BODY medicine_package IS

    PROCEDURE add_medicine (
        status    OUT       VARCHAR2,
        medname   IN        medicine.med_name%TYPE,
        meddesc   IN        medicine.med_desc%TYPE
    ) IS
        PRAGMA autonomous_transaction;
    BEGIN
        INSERT INTO medicine (
            med_name,
            med_desc
        ) VALUES (
            medname,
            meddesc
        );

        COMMIT;
        status := 'ok';
    EXCEPTION
        WHEN dup_val_on_index THEN
            status := 'Така назва уже існує';
        WHEN OTHERS THEN
            status := sqlerrm;
    END add_medicine;

    PROCEDURE del_medicine (
        status    OUT       VARCHAR2,
        medname   IN        medicine.med_name%TYPE
    ) IS
        PRAGMA autonomous_transaction;
    BEGIN
        DELETE FROM medicine_view
        WHERE
            medicine_view.med_name = medname;

        COMMIT;
        status := 'ok';
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            status := sqlerrm;
    END del_medicine;

    PROCEDURE update_medicine (
        status    OUT       VARCHAR2,
        medname   IN        medicine.med_name%TYPE,
        meddesc   IN        medicine.med_desc%TYPE
    ) IS
        PRAGMA autonomous_transaction;
    BEGIN
        UPDATE medicine
        SET
            medicine.med_desc = meddesc
        WHERE
            medicine.med_name = medname;

        COMMIT;
        status := 'ok';
    EXCEPTION
        WHEN OTHERS THEN
            status := sqlerrm;
    END update_medicine;

    FUNCTION get_medicine (
        medname   IN        medicine.med_name%TYPE
    ) RETURN tblgetmeddesc
        PIPELINED
    IS
    BEGIN
        FOR curr IN (
            SELECT DISTINCT
                med_desc
            FROM
                medicine
            WHERE
                medicine.med_name = medname
        ) LOOP
            PIPE ROW ( curr );
        END LOOP;
    END get_medicine;

END medicine_package;
/

create or replace PACKAGE symptom_package IS
    TYPE symptomdes_row IS RECORD (
        symdesc symptom.sym_desc%TYPE
    );
    TYPE tblgetsymdesc IS
        TABLE OF symptomdes_row;
    TYPE symptom_row IS RECORD (
        symanme symptom.sym_name%TYPE,
        symdesc symptom.sym_desc%TYPE
    );
    TYPE tblgetsymdata IS
        TABLE OF symptom_row;
    PROCEDURE add_symptom (
        status    OUT       VARCHAR2,
        symname   IN        symptom.sym_name%TYPE,
        symdesc   IN        symptom.sym_desc%TYPE
    );

    PROCEDURE del_symptom (
        status    OUT       VARCHAR2,
        symname   IN        symptom.sym_name%TYPE
    );

    PROCEDURE update_symptom (
        status    OUT       VARCHAR2,
        symname   IN        symptom.sym_name%TYPE,
        symdesc   IN        symptom.sym_desc%TYPE
    );

    FUNCTION get_symptom (
        symname   IN        symptom.sym_name%TYPE
    ) RETURN tblgetsymdesc
        PIPELINED;

    FUNCTION get_symptoms (
        row_limit IN   INTEGER
    ) RETURN tblgetsymdata
        PIPELINED;

END symptom_package;
/

create or replace PACKAGE BODY symptom_package IS

    PROCEDURE add_symptom (
        status    OUT       VARCHAR2,
        symname   IN        symptom.sym_name%TYPE,
        symdesc   IN        symptom.sym_desc%TYPE
    ) IS
        PRAGMA autonomous_transaction;
    BEGIN
        INSERT INTO symptom (
            sym_name,
            sym_desc
        ) VALUES (
            symname,
            symdesc
        );

        COMMIT;
        status := 'ok';
    EXCEPTION
        WHEN dup_val_on_index THEN
            status := 'Така назва уже існує';
        WHEN OTHERS THEN
            status := sqlerrm;
    END add_symptom;

    PROCEDURE del_symptom (
        status    OUT       VARCHAR2,
        symname   IN        symptom.sym_name%TYPE
    ) IS
        PRAGMA autonomous_transaction;
    BEGIN
        DELETE FROM symptom_view
        WHERE
            symptom_view.sym_name = symname;

        COMMIT;
        status := 'ok';
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            status := sqlerrm;
    END del_symptom;

    PROCEDURE update_symptom (
        status    OUT       VARCHAR2,
        symname   IN        symptom.sym_name%TYPE,
        symdesc   IN        symptom.sym_desc%TYPE
    ) IS
        PRAGMA autonomous_transaction;
    BEGIN
        UPDATE symptom
        SET
            symptom.sym_desc = symdesc
        WHERE
            symptom.sym_name = symname;

        COMMIT;
        status := 'ok';
    EXCEPTION
        WHEN OTHERS THEN
            status := sqlerrm;
    END update_symptom;

    FUNCTION get_symptom (
        symname   IN        symptom.sym_name%TYPE
    ) RETURN tblgetsymdesc
        PIPELINED
    IS
    BEGIN
        FOR curr IN (
            SELECT DISTINCT
                sym_desc
            FROM
                symptom
            WHERE
                symptom.sym_name = symname
        ) LOOP
            PIPE ROW ( curr );
        END LOOP;
    END get_symptom;

    FUNCTION get_symptoms (
        row_limit IN   INTEGER
    ) RETURN tblgetsymdata
        PIPELINED
    IS
    BEGIN
        FOR curr IN (
            SELECT
                sym_name,
                sym_desc
            FROM
                symptom
            WHERE
                ROWNUM <= row_limit
        ) LOOP
            PIPE ROW ( curr );
        END LOOP;
    END get_symptoms;

END symptom_package;
/

create or replace PACKAGE user_package IS
  TYPE user_info_row IS RECORD (
    loginuser user_info.login%TYPE,
    firstname user_info.first_name%TYPE,
    lastname user_info.last_name%TYPE,
    birthdayuser user_info.birthday%TYPE,
    sexuser user_info.sex%TYPE,
    doctoruser user_info.doctor%TYPE,
    submiteduser user_info.submited%type
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
                             doctoruser IN user_info.sex%TYPE,
                             submituser IN user_info.submited%TYPE);


  FUNCTION get_user_info(
    loginuser IN user_info.login%TYPE
  ) RETURN tblgetuserinfo
    PIPELINED;

  FUNCTION login_user(loginuser user_info.login%TYPE,
                      passworduser user_info.password_%TYPE) RETURN NUMBER;

END user_package;
/

create or replace PACKAGE BODY user_package IS

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
                             doctoruser IN user_info.sex%TYPE,
                             submituser IN user_info.submited%TYPE) IS
    PRAGMA autonomous_transaction;
  BEGIN
    UPDATE user_info
    SET user_info.FIRST_NAME = firstname,
        USER_INFO.LAST_NAME  = lastname,
        user_info.BIRTHDAY   = birthdayuser,
        USER_INFO.SEX        = sexuser,
        USER_INFO.DOCTOR     = doctoruser,
        USER_INFO.SUBMITED = submituser
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
                      doctor,
                      SUBMITED
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

create or replace PACKAGE mds_package AS
  TYPE mds_row IS RECORD (
    mdsdate mds.mds_date%TYPE
    );
  TYPE tblgetmds IS
    TABLE OF mds_row;

  TYPE mds_med_row IS RECORD (
    type_mds_med_name mds.medicine_med_name%TYPE
    );
  TYPE table_mds_med IS
    TABLE OF mds_med_row;

  TYPE mds_des_row IS RECORD (
    type_mds_dis_name mds.DESEASE_DIS_NAME%TYPE
    );
  TYPE table_mds_des IS
    TABLE OF mds_des_row;


  PROCEDURE add_mds(
                    status    OUT       VARCHAR2,
                    mdsdesease IN mds.desease_dis_name%TYPE,
                    mdssymptom IN mds.symptom_sym_name%TYPE,
                    mdsmedicine IN mds.medicine_med_name%TYPE);

  PROCEDURE del_mds(
    mdsdate IN mds.mds_date%TYPE
  );

  PROCEDURE update_mdsdesease(mdsdate IN mds.mds_date%TYPE,
                              mdsdesease IN mds.desease_dis_name%TYPE);

  PROCEDURE update_mdssymptom(status OUT VARCHAR2,
                              mdsdate IN mds.mds_date%TYPE,
                              mdssymptom IN mds.symptom_sym_name%TYPE);

  PROCEDURE update_mdsmedicine(mdsdate IN mds.mds_date%TYPE,
                               mdsmedicine IN mds.medicine_med_name%TYPE);

  FUNCTION get_mds(
    mdsdate IN mds.mds_date%TYPE
  ) RETURN tblgetmds
    PIPELINED;

  FUNCTION get_medication_list(
    symptomname IN mds.symptom_sym_name%TYPE
  ) RETURN table_mds_med
    PIPELINED;


  FUNCTION   get_medication_list_by_dis(
    disname IN mds.DESEASE_DIS_NAME%TYPE
  ) RETURN table_mds_med
    PIPELINED;

  FUNCTION get_disease_list(
    symptomname IN mds.symptom_sym_name%TYPE
  ) RETURN table_mds_des
    PIPELINED;

END mds_package;
/

create or replace PACKAGE BODY mds_package IS

  PROCEDURE add_mds(
                    status    OUT       VARCHAR2,
                    mdsdesease IN mds.desease_dis_name%TYPE,
                    mdssymptom IN mds.symptom_sym_name%TYPE,
                    mdsmedicine IN mds.medicine_med_name%TYPE) IS
    PRAGMA autonomous_transaction;
  BEGIN
    INSERT INTO mds (mds_date,
                     desease_dis_name,
                     symptom_sym_name,
                     medicine_med_name)
    VALUES (systimestamp,
            mdsdesease,
            mdssymptom,
            mdsmedicine);

    COMMIT;
    status := 'ok';
    EXCEPTION
        WHEN dup_val_on_index THEN
            status := 'Така назва уже існує';
        WHEN OTHERS THEN
            status := sqlerrm;
  END add_mds;

  PROCEDURE del_mds(
    mdsdate IN mds.mds_date%TYPE
  ) IS
    PRAGMA autonomous_transaction;
  BEGIN
    DELETE
    FROM mds
    WHERE mds.mds_date = mdsdate;

    COMMIT;
    EXCEPTION
    WHEN OTHERS
    THEN
      ROLLBACK;
      RAISE value_error;
  END del_mds;

  PROCEDURE update_mdsdesease(mdsdate IN mds.mds_date%TYPE,
                              mdsdesease IN mds.desease_dis_name%TYPE) IS
    PRAGMA autonomous_transaction;
  BEGIN
    UPDATE mds
    SET mds.desease_dis_name = mdsdesease
    WHERE mds.mds_date = mdsdate;

    COMMIT;
    EXCEPTION
    WHEN OTHERS
    THEN
      ROLLBACK;
      RAISE value_error;
  END update_mdsdesease;

  PROCEDURE update_mdssymptom(status OUT VARCHAR2,
                              mdsdate IN mds.mds_date%TYPE,
                              mdssymptom IN mds.symptom_sym_name%TYPE) IS
    PRAGMA autonomous_transaction;
  BEGIN
    UPDATE mds
    SET mds.symptom_sym_name = mdssymptom
    WHERE mds.mds_date = mdsdate;

    COMMIT;
    status := 'ok';
    EXCEPTION
    WHEN OTHERS
    THEN
      status := sqlerrm;
  END update_mdssymptom;

  PROCEDURE update_mdsmedicine(mdsdate IN mds.mds_date%TYPE,
                               mdsmedicine IN mds.medicine_med_name%TYPE) IS
    PRAGMA autonomous_transaction;
  BEGIN
    UPDATE mds
    SET mds.medicine_med_name = mdsmedicine
    WHERE mds.mds_date = mdsdate;

    COMMIT;
    EXCEPTION
    WHEN OTHERS
    THEN
      ROLLBACK;
      RAISE value_error;
  END update_mdsmedicine;

  FUNCTION get_mds(
    mdsdate IN mds.mds_date%TYPE
  ) RETURN tblgetmds
    PIPELINED
  IS
  BEGIN
    FOR curr IN (
      SELECT DISTINCT mds_date
      FROM mds
      WHERE mds.mds_date = mdsdate
      )
      LOOP
        PIPE ROW ( curr );
      END LOOP;
  END get_mds;

  FUNCTION get_medication_list(
    symptomname IN mds.symptom_sym_name%TYPE
  ) RETURN table_mds_med
    PIPELINED
  IS
  BEGIN
    --128
    FOR curr IN (
      SELECT DISTINCT mds.medicine_med_name
      FROM mds
      WHERE mds.symptom_sym_name = symptomname
      )
      LOOP
        PIPE ROW ( curr );
      END LOOP;
  END get_medication_list;


  FUNCTION get_disease_list(
    symptomname IN mds.symptom_sym_name%TYPE
  ) RETURN table_mds_des
    PIPELINED
  IS
  BEGIN

    FOR curr IN (
      SELECT DISTINCT mds.DESEASE_DIS_NAME
      FROM mds
      WHERE mds.symptom_sym_name = symptomname
      )
      LOOP
        PIPE ROW ( curr );
      END LOOP;
  END get_disease_list;

  FUNCTION   get_medication_list_by_dis(
    disname IN mds.DESEASE_DIS_NAME%TYPE
  ) RETURN table_mds_med
    PIPELINED
      IS
  BEGIN

    FOR curr IN (
      SELECT DISTINCT mds.MEDICINE_MED_NAME
      FROM mds
      WHERE mds.DESEASE_DIS_NAME = disname
      )
      LOOP
        PIPE ROW ( curr );
      END LOOP;
  END get_medication_list_by_dis;


END mds_package;
/

create or replace PACKAGE user_mds_package IS
    TYPE user_mds_row IS RECORD (
        cardnumber user_mds.mds_mds_date%TYPE
    );
    TYPE tblgetusermds IS
        TABLE OF user_mds_row;
    PROCEDURE add_user_mds (
        userlogin   IN           user_mds.user_login%TYPE,
        mdsdate    IN           user_mds.mds_mds_date%TYPE
    );

    PROCEDURE user_mds_delete (
        userlogin   IN           user_mds.user_login%TYPE
    );

    FUNCTION get_all_user_mds (
        userlogin   IN           user_mds.user_login%TYPE
    ) RETURN tblgetusermds
        PIPELINED;

END user_mds_package;
/

create or replace PACKAGE BODY user_mds_package IS

    PROCEDURE add_user_mds (
        userlogin   IN           user_mds.user_login%TYPE,
        mdsdate    IN           user_mds.mds_mds_date%TYPE
    ) IS
        PRAGMA autonomous_transaction;
    BEGIN
        INSERT INTO user_mds (
            user_login,
            mds_mds_date
        ) VALUES (
            userlogin,
            mdsdate
        );

        COMMIT;
    END add_user_mds;

    PROCEDURE user_mds_delete (
        userlogin   IN           user_mds.user_login%TYPE
    ) IS
        PRAGMA autonomous_transaction;
    BEGIN
        DELETE FROM user_mds
        WHERE
             user_mds.user_login = userlogin;

        COMMIT;
    END user_mds_delete;

    FUNCTION get_all_user_mds (
        userlogin   IN           user_mds.user_login%TYPE
    ) RETURN tblgetusermds
        PIPELINED
    IS
    BEGIN
        FOR curr IN (
            SELECT DISTINCT
                mds_mds_date
            FROM
                user_mds
            WHERE
                user_mds.user_login = userlogin
        ) LOOP
            PIPE ROW ( curr );
        END LOOP;
    END get_all_user_mds;

END user_mds_package;
/

create or replace PACKAGE PKG_TEST AS
TYPE X IS TABLE OF VARCHAR2(30);
PROCEDURE XYZ(Y IN X);
END PKG_TEST;
/

create or replace PACKAGE  BODY PKG_TEST AS
PROCEDURE XYZ(Y IN X) AS
BEGIN
  FOR I IN Y.FIRST..Y.LAST
    LOOP
      DBMS_OUTPUT.PUT_LINE('THE VALUE OF I IS'||Y(I));
    END LOOP;
  END;
END PKG_TEST;
/

