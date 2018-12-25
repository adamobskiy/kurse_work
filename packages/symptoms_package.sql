CREATE OR REPLACE PACKAGE symptom_package IS
    TYPE symptomdes_row IS RECORD (
        symdesc symptom.sym_desc%TYPE
    );
    TYPE tblgetsymdesc IS
        TABLE OF symptomdes_row;

    TYPE symptom_row IS RECORD (
      symanme symptom.sym_name%type,
      symdesc symptom.sym_desc%TYPE
    );
    TYPE tblgetsymdata IS
        TABLE OF symptom_row;

    PROCEDURE add_symptom (
        symname   IN        symptom.sym_name%TYPE,
        symdesc   IN        symptom.sym_desc%TYPE
    );


    PROCEDURE del_symptom (
        symname   IN        symptom.sym_name%TYPE
    );


    PROCEDURE update_symptom (
        symname   IN        symptom.sym_name%TYPE,
        symdesc   IN        symptom.sym_desc%TYPE
    );

    FUNCTION get_symptom (
        symname   IN        symptom.sym_name%TYPE
    ) RETURN tblgetsymdesc
        PIPELINED;

    FUNCTION get_symptoms (
        row_limit in integer
    ) RETURN tblgetsymdata
        PIPELINED;

END symptom_package;
/

CREATE OR REPLACE PACKAGE BODY symptom_package IS

    PROCEDURE add_symptom (
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
    END add_symptom;

    PROCEDURE del_symptom (
        symname   IN        symptom.sym_name%TYPE
    ) IS
        PRAGMA autonomous_transaction;
    BEGIN
        DELETE FROM symptom
        WHERE
            symptom.sym_name = symname;

        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            RAISE value_error;
    END del_symptom;

    PROCEDURE update_symptom (
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
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            RAISE value_error;
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
        row_limit in integer
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
            WHERE ROWNUM <= row_limit
        ) LOOP
            PIPE ROW ( curr );
        END LOOP;
    END get_symptoms;


END symptom_package;