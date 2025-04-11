# TINYINT 8bits
# SMALLINT 16bits
# MEDIUMINT 24bits
# INT - 32bits -2**32, 2**32
# BIGINT 64bits


CREATE TABLE ActorSample
(
    actor_id    SMALLINT unsigned NOT NULL AUTO_INCREMENT,
    first_name  VARCHAR(15)       NOT NULL,
    last_name   VARCHAR(25)       NULL,
    last_update TIMESTAMP         NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (actor_id)
);

INSERT INTO ActorSample (first_name, last_name, last_update)
SELECT first_name, last_name, last_update
FROM actor;

UPDATE ActorSample
SET first_name = 'Janusz'
WHERE actor_id = 1;

UPDATE ActorSample
SET first_name = 'Jarosław'
WHERE actor_id IN (2, 5, 8);

UPDATE ActorSample
SET first_name = 'Jacek',
    last_name  = 'S'
WHERE actor_id = 3;


UPDATE ActorSample
SET first_name = 'Andrzej'
WHERE actor_id IN (SELECT actor_id
                   FROM film_actor
                   WHERE film_id = 1);


SELECT *
FROM ActorSample
LIMIT 500;

DROP TABLE ActorSample;

