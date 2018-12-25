CREATE OR REPLACE PACKAGE medicine_package IS
  TYPE medicine_row IS RECORD (
    meddesc medicine.med_desc%TYPE
    );
  TYPE tblgetmeddesc IS
    TABLE OF medicine_row;
  PROCEDURE add_medicine(status out varchar2,
                         medname IN medicine.med_name%TYPE,
                         meddesc IN medicine.med_desc%TYPE);

  PROCEDURE del_medicine(
    status out varchar2,
    medname IN medicine.med_name%TYPE
  );

  PROCEDURE update_medicine(status out varchar2,
                            medname IN medicine.med_name%TYPE,
                            meddesc IN medicine.med_desc%TYPE);

  FUNCTION get_medicine(
    medname IN medicine.med_name%TYPE
  ) RETURN tblgetmeddesc
    PIPELINED;

END medicine_package;
/

CREATE OR REPLACE PACKAGE BODY medicine_package IS


  PROCEDURE add_medicine(status out varchar2,
                         medname IN medicine.med_name%TYPE,
                         meddesc IN medicine.med_desc%TYPE) IS
    PRAGMA autonomous_transaction;
  BEGIN
    INSERT INTO medicine (med_name,
                          med_desc)
    VALUES (medname,
            meddesc);

    COMMIT;
    status := 'ok';
    EXCEPTION
    WHEN DUP_VAL_ON_INDEX
    THEN
      status := 'Така назва уже існує';
    WHEN OTHERS
    THEN
      status := SQLERRM;
  END add_medicine;


  PROCEDURE del_medicine(
    status out varchar2,
    medname IN medicine.med_name%TYPE
  ) IS
    PRAGMA autonomous_transaction;
  BEGIN
    DELETE
    FROM medicine
    WHERE medicine.med_name = medname;

    COMMIT;
    status := 'ok';
    EXCEPTION
    WHEN OTHERS
    THEN
      ROLLBACK;
      status := SQLERRM;
  END del_medicine;

  PROCEDURE update_medicine(status out varchar2,
                            medname IN medicine.med_name%TYPE,
                            meddesc IN medicine.med_desc%TYPE) IS
    PRAGMA autonomous_transaction;
  BEGIN
    UPDATE medicine
    SET medicine.med_desc = meddesc
    WHERE medicine.med_name = medname;

    COMMIT;
    status := 'ok';
    EXCEPTION
    WHEN OTHERS
    THEN
      status := SQLERRM;
  END update_medicine;

  FUNCTION get_medicine(
    medname IN medicine.med_name%TYPE
  ) RETURN tblgetmeddesc
    PIPELINED
  IS
  BEGIN
    FOR curr IN (
      SELECT DISTINCT med_desc
      FROM medicine
      WHERE medicine.med_name = medname
      )
      LOOP
        PIPE ROW ( curr );
      END LOOP;
  END get_medicine;

END medicine_package;

