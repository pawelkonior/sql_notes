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

DELETE
FROM ActorSample
WHERE actor_id = 1;

DELETE FROM ActorSample
WHERE 1 = 1;

TRUNCATE TABLE ActorSample;

SELECT *
FROM ActorSample
LIMIT 500;

DROP TABLE ActorSample;

