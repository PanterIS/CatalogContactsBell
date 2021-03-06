--Функции для работы с пользователями
--Добавление нового пользователя
CREATE OR REPLACE FUNCTION InsertUser(u_login VARCHAR,u_password VARCHAR) RETURNS BOOLEAN AS
$BODY$
BEGIN
    INSERT INTO "t_user" (user_login,
                            user_password)
         VALUES (
         u_login,
         u_password);
         RETURN TRUE;
EXCEPTION
 WHEN unique_violation THEN
     RETURN FALSE;
END
$BODY$
LANGUAGE 'plpgsql';

--Изменение пользователя
CREATE OR REPLACE FUNCTION ChangeUser(u_id INT,u_login VARCHAR,u_password VARCHAR) RETURNS BOOLEAN AS
$BODY$
BEGIN
    UPDATE "t_user" SET user_login = u_login, user_password = u_password  WHERE user_id=u_id;
    RETURN TRUE;
EXCEPTION
 WHEN unique_violation THEN
     RETURN FALSE;
END
$BODY$
LANGUAGE 'plpgsql';

--Удаление пользователя

CREATE OR REPLACE FUNCTION DeleteUser(u_id INT) RETURNS VOID AS
$BODY$
BEGIN
    DELETE FROM "t_user"
          WHERE user_id = u_id;
END
$BODY$
LANGUAGE 'plpgsql';


CREATE OR REPLACE FUNCTION DeleteDataUser() RETURNS TRIGGER AS
$BODY$
BEGIN
    DELETE FROM "Contact"
          WHERE user_id = OLD.user_id;
    DELETE FROM t_group
          WHERE user_id = OLD.user_id;
          RETURN OLD;
END
$BODY$
LANGUAGE 'plpgsql';

CREATE TRIGGER trig_delete_user
  BEFORE DELETE ON "t_user" FOR EACH ROW EXECUTE PROCEDURE DeleteDataUser();

--Получение данных пользователя

--Поиск пользователя в базе

CREATE OR REPLACE FUNCTION AuthorizationUser(u_login VARCHAR,u_password VARCHAR) RETURNS SETOF "t_user" AS
$BODY$
DECLARE
  r "t_user";
BEGIN
    FOR r IN
        SELECT
              *
        FROM "t_user"
            WHERE (user_login=u_login AND user_password=u_password)
    LOOP
        RETURN NEXT r;
    END LOOP;
    RETURN;
END
$BODY$
LANGUAGE plpgsql;

-- получение пользователя, а если id не указан, то всех пользователей
CREATE OR REPLACE FUNCTION getUser(u_id INT DEFAULT NULL) RETURNS SETOF "t_user" AS
$BODY$
DECLARE
  r "t_user";
BEGIN
    FOR r IN
        SELECT
              *
        FROM "t_user"
            WHERE (u_id=NULL OR (user_id = u_id))
    LOOP
        RETURN NEXT r;
    END LOOP;
    RETURN;
END
$BODY$
LANGUAGE plpgsql;

--------------------------
--Аналитика по пользователям

--Получает количество пользователей
CREATE OR REPLACE FUNCTION NumberOfUsers() RETURNS INT AS
$BODY$
DECLARE
i INT;
BEGIN
    SELECT count(*) FROM "t_user" INTO i;
    return i;
END;
$BODY$
LANGUAGE plpgsql;


--Получает сводные данные по всем пользователям

CREATE OR REPLACE FUNCTION CountingUserData() RETURNS TABLE(u_login VARCHAR,count_contact int,count_group int)  AS
$BODY$
DECLARE
r RECORD;
BEGIN
FOR r IN
    SELECT
        u.user_login,
        count(DISTINCT contact_id)  AS count_contact,
        count(DISTINCT group_id) AS count_group
    FROM "t_user" u
    LEFT JOIN "Contact" c ON u.user_id=c.user_id
    LEFT JOIN t_group g ON u.user_id=g.user_id
    GROUP BY u.user_id
    LOOP
        u_login = r.user_login;
        count_contact =r.count_contact;
        count_group = r.count_group;
        RETURN next;
    END LOOP;
END;
$BODY$
LANGUAGE plpgsql;

-- считает среднее количество контактов пользователей
CREATE OR REPLACE FUNCTION AverageUserContact() RETURNS REAL AS
$BODY$
DECLARE
i REAL;
BEGIN
    SELECT avg(t.count_contact) As avg_user FROM (
    SELECT
        u.user_id as id,
        count(DISTINCT contact_id)  AS count_contact
    FROM "t_user" u
    LEFT JOIN "Contact" c ON u.user_id=c.user_id
    GROUP BY u.user_id) As t
    INTO i;
    return i;
END;
$BODY$
LANGUAGE plpgsql;

-- считает среднее количество групп пользователей
CREATE OR REPLACE FUNCTION AverageUserGroup() RETURNS REAL AS
$BODY$
DECLARE
i REAL;
BEGIN
    SELECT avg(t.count_group) As avg_user FROM (
    SELECT
        u.user_id,
        count(DISTINCT group_id)  AS count_group
    FROM "t_user" u
    LEFT JOIN t_group c ON u.user_id=c.user_id
    GROUP BY u.user_id) As t
    INTO i;
    return i;
END;
$BODY$
LANGUAGE plpgsql;

-- получает список пользователей у которых количество контактов меньше n
CREATE OR REPLACE FUNCTION InactiveUsers(n INT) RETURNS TABLE(user_id INT,user_login VARCHAR) AS
$BODY$
DECLARE
r RECORD;
BEGIN
    FOR r IN
    SELECT
        u.user_id,
        u.user_login,
        count(DISTINCT contact_id)  AS count_contact
    FROM "t_user" u
    LEFT JOIN "Contact" c ON u.user_id=c.user_id
    GROUP BY u.user_id HAVING count(DISTINCT contact_id)<n
    LOOP
        user_id = r.user_id;
        user_login = r.user_login;
        RETURN next;
    END LOOP;
END;
$BODY$
LANGUAGE plpgsql;