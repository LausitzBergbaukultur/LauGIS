# Referenz: Objektnummer

Dient der Konsolidierung aller Objektnummern. Objektnummern werden nach einem festen Schema über alle Objekttabellen hinweg erzeugt, siehe `fn_create_objectnumber`, und in dieser Tabelle vorgehalten. 

```SQL
SET search_path TO "Erfassung",public;
-- OR
SET search_path TO "Entwicklung",public;
```



```SQL
-- DROP TABLE "ref_Objektnummer";

CREATE TABLE IF NOT EXISTS "ref_Objektnummer"
( 	
	id integer PRIMARY KEY generated always as identity, -- PK
    objekt_nr text
);
```

