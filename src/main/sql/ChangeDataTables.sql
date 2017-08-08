﻿----------------------------
--Функции для занесение данных в таблицы

-- Добавление нового контакта

CREATE OR REPLACE FUNCTION InsertContact(u_id INT,c_name VARCHAR) RETURNS VOID AS
$BODY$
BEGIN
    INSERT INTO "Contact" (	contact_name,
                            user_id)
    	 VALUES (
         c_name,
         u_id)
         ON CONFLICT (contact_name) DO NOTHING;
END
$BODY$
LANGUAGE 'plpgsql';


-- добавление детальных данных контакта
CREATE OR REPLACE FUNCTION InsertContactDetails(c_id INT,d_type VARCHAR,d_value VARCHAR) RETURNS VOID AS
$BODY$
BEGIN
    INSERT INTO "ContactDetails" (
    								details_type,
                                    details_value,
                                    contact_id)
        	VALUES (
    			d_type,
                d_value,
                c_id);
END
$BODY$
LANGUAGE 'plpgsql';

-- Добавление новой группы

CREATE OR REPLACE FUNCTION InsertGroup(u_id INT,g_name VARCHAR) RETURNS VOID AS
$BODY$
BEGIN
    INSERT INTO "Group" (
    					 group_name,
                            user_id)
    	 VALUES (
         g_name,
         u_id)
         ON CONFLICT (group_name) DO NOTHING;
END
$BODY$
LANGUAGE 'plpgsql';

--Добавление группы у контакта

CREATE OR REPLACE FUNCTION InsertGroupInContact(c_id INT,g_id INT) RETURNS VOID AS
$BODY$
BEGIN
    INSERT INTO "Contact_group" (contact_id,group_id)
    	 				VALUES (c_id,g_id);
END
$BODY$
LANGUAGE 'plpgsql';

--Изменение контакта
CREATE OR REPLACE FUNCTION ChangeContact(c_id INT,c_name VARCHAR) RETURNS VOID AS
$BODY$
BEGIN
UPDATE "Contact" SET contact_name = c_name WHERE contact_id=c_id;
END
$BODY$
LANGUAGE 'plpgsql';

-- Изменение группы
CREATE OR REPLACE FUNCTION ChangeGroup(g_id INT,g_name VARCHAR) RETURNS VOID AS
$BODY$
BEGIN
UPDATE "Group" SET group_name = g_name WHERE group_id=g_id;
END
$BODY$
LANGUAGE 'plpgsql';

--изменение контактной информации
CREATE OR REPLACE FUNCTION ChangeContactDetails(d_id INT,d_type VARCHAR,d_value VARCHAR) RETURNS VOID AS
$BODY$
BEGIN
UPDATE "ContactDetails"
	SET
 	details_type = d_type,
	details_value = d_value
  	WHERE details_id=d_id;
END
$BODY$
LANGUAGE 'plpgsql';

--Удаление детальных данных контакта

CREATE OR REPLACE FUNCTION DeleteContactDetails(d_id INT) RETURNS VOID AS
$BODY$
BEGIN
	DELETE FROM "ContactDetails"
  		WHERE details_id = d_id;
END
$BODY$
LANGUAGE 'plpgsql';

CREATE OR REPLACE FUNCTION DeleteAllContactDetails(c_id INT) RETURNS VOID AS
$BODY$
BEGIN
	DELETE FROM "ContactDetails"
  		WHERE  contact_id = c_id;
END
$BODY$
LANGUAGE 'plpgsql';

--Удаление группs из контакта

CREATE OR REPLACE FUNCTION DeleteGroupFromContact(g_id INT,c_id INT) RETURNS VOID AS
$BODY$
BEGIN
	DELETE FROM "Contact_group"
  		WHERE group_id = g_id;
       	WHERE contact_id = c_id;
END
$BODY$
LANGUAGE 'plpgsql';

CREATE OR REPLACE FUNCTION DeleteAllGroupFromContact(c_id INT) RETURNS VOID AS
$BODY$
BEGIN
	DELETE FROM "Contact_group"
  		WHERE contact_id = c_id;
END
$BODY$
LANGUAGE 'plpgsql';

--Удаление контакта

CREATE OR REPLACE FUNCTION DeleteContact(c_id INT) RETURNS VOID AS
$BODY$
BEGIN
	PERFORM DeleteAllContactDetails(c_id);
	PERFORM DeleteAllGroupFromContact(c_id);
	DELETE FROM "Contact"
 		 WHERE contact_id = c_id;
END
$BODY$
LANGUAGE 'plpgsql';

CREATE OR REPLACE FUNCTION DeleteAllContact(u_id INT) RETURNS VOID AS
$BODY$
BEGIN
	FOR
	PERFORM DeleteAllContactDetails(c_id);
	PERFORM DeleteAllGroupFromContact(c_id);
	DELETE FROM "Contact"
 		 WHERE contact_id = c_id;
END
$BODY$
LANGUAGE 'plpgsql';