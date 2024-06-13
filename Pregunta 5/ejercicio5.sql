DO $$
DECLARE
    cadena1 varchar(20);
    cadena2 varchar(20);
    longitud_cadena1 int;
    contador int;
    letra varchar(20);
    sql text;
    columna text;
BEGIN
    cadena1 := 'gustavo';
    contador := 1;
    longitud_cadena1 := LENGTH(cadena1);
    sql := 'CREATE TABLE nombre (';
    
    WHILE contador <= longitud_cadena1 LOOP
        letra := LEFT(cadena1, 1) || contador::text || ' int,';
        cadena1 := RIGHT(cadena1, LENGTH(cadena1) - 1);
        sql := sql || letra;
        contador := contador + 1;
    END LOOP;
    
    sql := LEFT(sql, LENGTH(sql) - 1);
    sql := sql || ')';
    
    EXECUTE sql;

    cadena1 := 'christian';
    contador := 1;
    longitud_cadena1 := LENGTH(cadena1);
    
    WHILE contador <= longitud_cadena1 LOOP
        letra := LEFT(cadena1, 1);
        cadena1 := RIGHT(cadena1, LENGTH(cadena1) - 1);
        
        SELECT column_name
        INTO columna
        FROM information_schema.columns
        WHERE table_name = 'nombre'
          AND LEFT(column_name, 1) = letra
          AND ordinal_position >= contador
        LIMIT 1;
        
        sql := 'INSERT INTO nombre (' || columna || ') VALUES (1)';
        EXECUTE sql;
        
        contador := contador + 1;
    END LOOP;

    -- Calcular la suma de columnas
    DECLARE
        consulta text := '';
        consulta2 text := '';
        consulta3 text := '';
        i int := 1;
        var int;
        nombre_columna text;
    BEGIN
        SELECT COUNT(column_name)
        INTO var
        FROM information_schema.columns
        WHERE table_name = 'christian';

        WHILE i <= var LOOP
            SELECT column_name
            INTO nombre_columna
            FROM information_schema.columns
            WHERE table_name = 'nombre'
              AND ordinal_position = i;
              
            consulta := consulta || 'COALESCE(SUM(' || nombre_columna || '), 0) + ';
            i := i + 1;
        END LOOP;

        consulta2 := LEFT(consulta, LENGTH(consulta) - 3);  -- Eliminar el último ' + '
        consulta3 := 'SELECT ' || consulta2 || ' AS suma_total FROM nombre';
        EXECUTE consulta3;

        -- Mostrar la tabla
        EXECUTE 'SELECT * FROM nombre';

        -- Eliminar la tabla
        --EXECUTE 'DROP TABLE nombre';
    END;
END $$;

SELECT * FROM nombre