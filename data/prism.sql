--
--

DROP DATABASE IF EXISTS prism;

CREATE DATABASE IF NOT EXISTS prism CHARACTER SET utf8;

-- GRANT ALL PRIVILEGES ON prism.* TO 'root' IDENTIFIED BY 'root';
-- GRANT ALL PRIVILEGES ON prism.* TO 'root'@'%' IDENTIFIED BY 'root';
GRANT ALL PRIVILEGES ON prism.* TO 'root'@'localhost';

USE prism;

    create table prism.users (
        login varchar(30) not null unique,
        description varchar(1024),
        first varchar(128),
        last varchar(128),
        pgroups varchar(128),
        password varchar(26),
        status char(1),
	locked char(1),
       	lastLogin DATE, 
        primary key (login)
    ) ENGINE=InnoDB;
	
INSERT INTO `users` VALUES ('Aaron.Nichols',NULL,'Aaron','Nichols','Manager, User',NULL,'A','N',NULL),('Amanda.Ross',NULL,'Amanda','Ross','Manager, User',NULL,'A','N',NULL),('Andrea.Hudson',NULL,'Andrea','Hudson','Manager, User',NULL,'A','N',NULL),('Barbara.Wilson',NULL,'Barbara','Wilson','Manager, User',NULL,'A','N',NULL),('Bob.Employee',NULL,'Bob','Employee','User','K7lA\\0ji=8','A','N',NULL),('Bobby.Stephens',NULL,'Bobby','Stephens','Manager, User',NULL,'A','N',NULL),('Carlos.Perkins',NULL,'Carlos','Perkins','Manager, User',NULL,'A','N',NULL),('Carolyn.Perry',NULL,'Carolyn','Perry','Manager, User',NULL,'A','N',NULL),('Catherine.Simmons',NULL,'Catherine','Simmons','Manager, User',NULL,'A','N',NULL),('Charles.Harris',NULL,'Charles','Harris','Manager, User',NULL,'A','N',NULL),('Christine.Long',NULL,'Christine','Long','Manager, User',NULL,'A','N',NULL),('David.Anderson',NULL,'David','Anderson','Manager, User',NULL,'A','N',NULL),('Debra.Wood',NULL,'Debra','Wood','Manager, User',NULL,'A','N',NULL),('Denise.Hunt',NULL,'Denise','Hunt','Super, User',NULL,'A','N',NULL),('Dennis.Barnes',NULL,'Dennis','Barnes','Manager, User',NULL,'A','N',NULL),('Douglas.Flores',NULL,'Douglas','Flores','Manager, User',NULL,'A','N',NULL),('Elizabeth.Taylor',NULL,'Elizabeth','Taylor','Manager, User',NULL,'A','N',NULL),('Eugene.Hawkins',NULL,'Eugene','Hawkins','Manager, User',NULL,'A','N',NULL),('Harold.Patterson',NULL,'Harold','Patterson','Manager, User',NULL,'A','N',NULL),('Henry.Butler',NULL,'Henry','Butler','Manager, User',NULL,'A','N',NULL),('Howard.Rose',NULL,'Howard','Rose','Manager, User',NULL,'A','N',NULL),('James.Smith',NULL,'James','Smith','Manager, User',NULL,'A','N',NULL),('Jane.Grant',NULL,'Jane','Grant','Manager, User',NULL,'A','N',NULL),('Janet.Washington',NULL,'Janet','Washington','Manager, User',NULL,'A','N',NULL),('Jennifer.Thomas',NULL,'Jennifer','Thomas','Manager, User',NULL,'A','N',NULL),('Jerry.Bennett',NULL,'Jerry','Bennett','Manager, User',NULL,'A','N',NULL),('John.Williams',NULL,'John','Williams','Manager, User',NULL,'A','N',NULL),('Kathryn.Gardner',NULL,'Kathryn','Gardner','Manager, User',NULL,'A','N',NULL),('Linda.Davis',NULL,'Linda','Davis','Manager, User',NULL,'A','N',NULL),('Lori.Ferguson',NULL,'Lori','Ferguson','Manager, User',NULL,'A','N',NULL),('Louise.Payne',NULL,'Louise','Payne','Manager, User',NULL,'A','N',NULL),('Maria.White',NULL,'Maria','White','Manager, User',NULL,'A','N',NULL),('Marie.Hughes',NULL,'Marie','Hughes','Manager, User',NULL,'A','N',NULL),('Marilyn.Dunn',NULL,'Marilyn','Dunn','Manager, User',NULL,'A','N',NULL),('Mary.Johnson',NULL,'Mary','Johnson','Manager, User',NULL,'A','N',NULL),('Michael.Miller',NULL,'Michael','Miller','Manager, User',NULL,'A','N',NULL),('Patricia.Jones',NULL,'Patricia','Jones','Manager, User',NULL,'A','N',NULL),('Patrick.Jenkins',NULL,'Patrick','Jenkins','Manager, User',NULL,'A','N',NULL),('Peter.Powell',NULL,'Peter','Powell','Manager, User',NULL,'A','N',NULL),('PRISM ADMIN',NULL,'','','User,Manager,Super','password','A','N','2012-11-01'),('Rachel.Stone',NULL,'Rachel','Stone','Manager, User',NULL,'A','N',NULL),('Randy.Knight',NULL,'Randy','Knight','Manager, User',NULL,'A','N',NULL),('Richard.Jackson',NULL,'Richard','Jackson','Manager, User',NULL,'A','N',NULL),('Robert.Brown',NULL,'Robert','Brown','Manager, User',NULL,'A','N',NULL),('Russell.Spencer',NULL,'Russell','Spencer','Manager, User',NULL,'A','N',NULL),('Sara.Berry',NULL,'Sara','Berry','Manager, User',NULL,'A','N',NULL),('Stephanie.Coleman',NULL,'Stephanie','Coleman','Manager, User',NULL,'A','N',NULL),('Susan.Martin',NULL,'Susan','Martin','Manager, User',NULL,'A','N',NULL),('Test.Employee',NULL,'Test','Employee','User','1JFFZb=F1x','A','N',NULL),('Victor.Pierce',NULL,'Victor','Pierce','Manager, User',NULL,'A','N',NULL),('whenderson',NULL,'Walter','Henderson','User,Manager,Super','password','A','Y','2012-01-01'),('William.Moore',NULL,'William','Moore','Manager, User',NULL,'A','N',NULL);


    create table prism.pgroups (
        name varchar(30) not null unique,
        description varchar(1024),
        primary key (name)
    ) ENGINE=InnoDB;
	
insert into pgroups (name,description) values ('User','This group is used to assign basic user access to PRISM');
insert into pgroups (name,description) values ('Manager','This group is used to assign manager access to PRISM');
insert into pgroups (name,description) values ('Super','This is a privileged group with superuser access to PRISM');




