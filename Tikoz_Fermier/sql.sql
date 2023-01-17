INSERT INTO `addon_account` (name, label, shared) VALUES 
	('society_fermier','fermier',1)
;

INSERT INTO `datastore` (name, label, shared) VALUES 
	('society_fermier','fermier',1)
;

INSERT INTO `addon_inventory` (name, label, shared) VALUES 
	('society_fermier', 'fermier', 1)
;

INSERT INTO `jobs` (`name`, `label`) VALUES
('fermier', 'Fermier')
;

INSERT INTO `job_grades` (job_name, grade, name, label, salary, skin_male, skin_female) VALUES
  ('fermier',0,'recrue','Débutant', 50,'{}','{}'),
  ('fermier',1,'gerant','Expert', 60,'{}','{}'),
  ('fermier',2,'boss','Patron', 70,'{}','{}')
  ;

INSERT INTO `items` (`name`, `label`, `limit`) VALUES
("laitpur", "lait pur", 50),
("briqlait", "brique de lait", 50),
("pomme", "pomme", 50),
('cidre', "cidre", 50)
;
