begin transaction;
insert into "RealEstateObject" ("Description", "Floor", "Square", "Rooms", "Region", "City", "Street", "Building", "Code", "RealEstateType")
values ('Светлая просторная квартира в ЖК Триумф Квартал 2. Дому всего 6 лет. Квартира формата Студия: большая кухня-гостиная 33,3 кв.м, гардеробная 3 кв.м, совмещенный санузел 6,1 кв.м, коридор 7,5 кв.м. Общая площадь без учета балкона - 49,9 кв.м. Окна квартиры выходят на солнечную юго-восточную сторону. ', '3/5', '33.4', '3', 'Пермский край', 'Пермь', 'Васькина', '5', '59000000123', 0);
insert into "Announcement" ("Price", "CreationDate", "RealEstateObjectId", "AnnouncementType")
values (1500000, CURRENT_TIMESTAMP(3), (SELECT "last_value" FROM "RealEstateObject_Id_seq"), 0);
commit;