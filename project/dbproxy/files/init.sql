begin transaction;
insert into "RealEstateObject" ("Description", "Floor", "Square", "Rooms", "Region", "City", "Street", "Building", "Code", "RealEstateType")
values ('Убитая хата', '3/5', '33.4', '3', 'Пермский край', 'Пермь', 'Васькина', '5', '59000000123', 0);
insert into "Announcement" ("Price", "CreationDate", "RealEstateObjectId", "AnnouncementType")
values (1500000, CURRENT_TIMESTAMP(3), (SELECT "last_value" FROM "RealEstateObject_Id_seq"), 0);
commit;