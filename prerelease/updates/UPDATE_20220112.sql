-- auf Style-Ebene: rename "nachnutzungspotential" -> obsolet

ALTER TABLE IF EXISTS "Erfassung"."obj_Einzelobjekt"
    ADD COLUMN foerderfaehig boolean;

ALTER TABLE IF EXISTS "Erfassung"."obj_Einzelobjekt_line"
    ADD COLUMN foerderfaehig boolean;

ALTER TABLE IF EXISTS "Erfassung"."obj_Objektbereich"
    ADD COLUMN foerderfaehig boolean;

ALTER TABLE IF EXISTS "Erfassung"."obj_Objektbereich_line"
    ADD COLUMN foerderfaehig boolean;