CREATE TABLE IF NOT EXISTS "Erfassung".textkorrektur
(     
    id integer PRIMARY KEY generated always as identity, -- PK
    objekt_nr text,          -- fk NOT NULL
    korrekturrunde text           -- Kürzel zur Identifikation
);

INSERT INTO "Erfassung".textkorrektur (objekt_nr, korrekturrunde)
VALUES
(32000861, '202203'),
(32000841, '202203'),
(32000835, '202203'),
(32000845, '202203'),
(32000693, '202203'),
(32000298, '202203'),
(32000846, '202203'),
(32000848, '202203'),
(32000263, '202203'),
(32000967, '202203'),
(32000840, '202203'),
(32000836, '202203'),
(32000814, '202203'),
(32000849, '202203'),
(32000864, '202203'),
(32000862, '202203'),
(32000833, '202203'),
(32000834, '202203'),
(32000847, '202203'),
(32000844, '202203'),
(32000822, '202203'),
(32000863, '202203'),
(32000837, '202203'),
(32001105, '202203'),
(32000842, '202203'),
(32000296, '202203'),
(32000759, '202203'),
(32000677, '202203'),
(32000615, '202203'),
(32000664, '202203'),
(32000952, '202203'),
(32000867, '202203'),
(32000285, '202203'),
(32000600, '202203'),
(32000701, '202203'),
(32000220, '202203'),
(32000774, '202203'),
(32000581, '202203'),
(32000240, '202203'),
(32000212, '202203'),
(32001083, '202203'),
(32000409, '202203'),
(32000309, '202203'),
(32000704, '202203'),
(32000673, '202203'),
(32000410, '202203'),
(32000307, '202203'),
(32000506, '202203'),
(32001074, '202203'),
(32000984, '202203'),
(32001082, '202203'),
(32001071, '202203'),
(32001073, '202203'),
(32000395, '202203'),
(32000669, '202203'),
(32000651, '202203'),
(32000605, '202203'),
(32000411, '202203'),
(32001086, '202203'),
(32001081, '202203'),
(32000424, '202203'),
(32000393, '202203'),
(32000675, '202203'),
(32000670, '202203'),
(32000652, '202203'),
(32000408, '202203'),
(32000416, '202203'),
(32000354, '202203'),
(32000407, '202203'),
(32000674, '202203'),
(32000714, '202203'),
(32000405, '202203'),
(32000404, '202203');