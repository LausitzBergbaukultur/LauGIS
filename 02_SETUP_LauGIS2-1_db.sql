-- VORSICHT! Nicht zum Update einer bestehenden Instanz geeignet!
--
-- Erzeugt alle notwendigen Tabellen und Funktionen zur Datenhaltung und -verarbeitung.
-- Befüllt Definitions-Tabellen mit den vorgegebenen Werten.
-- Erwartet eine PostgreSQL Datenbank mit dem Schema 'laugis'.
--
-- Stand: 2022-09-08
-- Autor: Stefan Krug
--
--------------------------------------------------------------------------------------------------------------------------------------
-- # LAUGIS DATA
--------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------
-- # def_kategorie
--------------------------------------------------------------------------------------------------------------------------------------

DROP TABLE IF EXISTS laugis.def_kategorie;
CREATE TABLE IF NOT EXISTS laugis.def_kategorie
(
   id integer PRIMARY KEY generated always as identity,
   bezeichnung text NOT NULL,
   sortierung integer
);

INSERT INTO laugis.def_kategorie (bezeichnung, sortierung) VALUES 
    ('Kat. 1 - Bergbau', 1),
    ('Kat. 2 - Energieerzeugung', 2),
    ('Kat. 3 - Veredelung', 3),
    ('Kat. 4 - Technische Infrastruktur', 4),
    ('Kat. 5 - Sozialstrukturen', 5), 
    ('Kat. 6 - Begleit- und Folgeindustrie', 6), 
    ('Kat. 7 - Gelaendestrukturen und Rekultivierung', 7),
    ('kein Braunkohlebezug', 8)
;

--------------------------------------------------------------------------------------------------------------------------------------
-- # def_sachbegriff 
--------------------------------------------------------------------------------------------------------------------------------------

DROP TABLE IF EXISTS laugis.def_sachbegriff;
CREATE TABLE IF NOT EXISTS laugis.def_sachbegriff
(
    id integer PRIMARY KEY generated always as identity,
    sachbegriff text NOT NULL,
    kategorie smallint,                 -- fk
    ref_sachbegriff_id integer,         -- fk Verweis auf übergeordnete Sachbegriffe
    show_anlage bool,                   -- TRUE wenn der Sachbegriff für Anlage-Objekte geeignet ist
    sortierung integer,                 

CONSTRAINT fkey_kategorie FOREIGN KEY (kategorie)
    REFERENCES laugis.def_kategorie (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION,

CONSTRAINT fkey_sachbegriff FOREIGN KEY (ref_sachbegriff_id)
    REFERENCES laugis.def_sachbegriff (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
);

INSERT INTO laugis.def_sachbegriff (kategorie, id, ref_sachbegriff_id, sachbegriff, show_anlage, sortierung) 
OVERRIDING SYSTEM VALUE
VALUES 
(1,1100 ,1100,'Bergbauanlage',false,1000),
(1,1101 ,1100,'Abbaufeld',false,1001),
(1,1102 ,1100,'Abproduktenhalde',false,1002),
(1,1103 ,1100,'Altbergbaugebiet',false,1003),
(1,1104 ,1100,'Auffahrrampe',false,1004),
(1,1105 ,1100,'Befund',false,1005),
(1,1106 ,1100,'Bergamt',false,1006),
(1,1107 ,1100,'Bergschmiede',false,1007),
(1,1108 ,1100,'Bethaus',false,1008),
(1,1109 ,1100,'Bruchfeld',false,1009),
(1,1110 ,1100,'Bunker',false,1010),
(1,1111 ,1100,'Damm',false,1011),
(1,1112 ,1100,'Devastierungsfläche',false,1012),
(1,1113 ,1100,'Fahrtrum',true ,1013),
(1,1114 ,1100,'Fluterhaus',false,1014),
(1,1115 ,1100,'Fördergerüst',true ,1015),
(1,1116 ,1100,'Fördermaschinengebäude',false,1016),
(1,1117 ,1100,'Fördertrum',true ,1017),
(1,1118 ,1100,'Förderturm',true ,1018),
(1,1119 ,1100,'Gewässerverlegung',false,1019),
(1,1120 ,1100,'Grube',false,1020),
(1,1121 ,1100,'Grubeneinbauten',false,1021),
(1,1122 ,1100,'Grubenwehrgebäude',false,1022),
(1,1123 ,1100,'Halde',false,1023),
(1,1124 ,1100,'Hochwasserschutzanlage',false,1024),
(1,1125 ,1100,'Huthaus',false,1025),
(1,1126 ,1100,'Kaue',false,1026),
(1,1127 ,1100,'Kesselhaus',false,1027),
(1,1128 ,1100,'Kompressorenstation',true ,1028),
(1,1129 ,1100,'Kunsttrum',true ,1029),
(1,1130 ,1100,'Leitstand',false,1030),
(1,1131 ,1100,'Lichtloch',false,1031),
(1,1132 ,1100,'Magazin',false,1032),
(1,1133 ,1100,'Mannschaftsbad',false,1033),
(1,1134 ,1100,'Maschinenhaus',false,1034),
(1,1135 ,1100,'Mundloch',false,1035),
(1,1136 ,1100,'Pinge',false,1036),
(1,1137 ,1100,'Planum',false,1037),
(1,1138 ,1100,'Rampe',false,1038),
(1,1139 ,1100,'Rekultivierungsfläche',false,1039),
(1,1140 ,1100,'Schacht',true ,1040),
(1,1141 ,1100,'Schachtaufsattelung',false,1041),
(1,1142 ,1100,'Schachteinbauten',false,1042),
(1,1143 ,1100,'Schachtgebäude',false,1043),
(1,1144 ,1100,'Seilbahn',false,1044),
(1,1145 ,1100,'Siebgebäude',false,1045),
(1,1146 ,1100,'Sohle',false,1046),
(1,1147 ,1100,'Sozialgebäude',false,1047),
(1,1148 ,1100,'Spitzkehre',false,1048),
(1,1149 ,1100,'Stapelplatz',false,1049),
(1,1150 ,1100,'Stollen',false,1050),
(1,1151 ,1100,'Straßenverlegung',false,1051),
(1,1152 ,1100,'Tagebaufläche',false,1052),
(1,1153 ,1100,'Tagebaurestloch',false,1053),
(1,1154 ,1100,'Tagebauvorfeld',false,1054),
(1,1155 ,1100,'Tagegebäude/Tagesanlagen',false,1055),
(1,1156 ,1100,'Tankanlage',false,1056),
(1,1167 ,1100,'Tiefbaufläche',false,1057),
(1,1168 ,1100,'Tief- und Tagebaufläche',false,1058),
(1,1157 ,1100,'Turbinenhaus',false,1059),
(1,1158 ,1100,'Übergabestation',true ,1060),
(1,1159 ,1100,'Umspurrampe',true ,1061),
(1,1160 ,1100,'Verladeanlage',false,1062),
(1,1161 ,1100,'Verschiebebandanlage',false,1063),
(1,1162 ,1100,'Verwaltungsgebäude',false,1064),
(1,1163 ,1100,'Wache',false,1065),
(1,1164 ,1100,'Waschkaue',false,1066),
(1,1165 ,1100,'Wassersammelbecken',false,1067),
(1,1166 ,1100,'Werkstattgebäude',false,1068),
(1,1200 ,1200,'Bergbaugerät',false,1069),
(1,1201 ,1200,'Abraumförderbrücke',true ,1070),
(1,1202 ,1200,'Absetzer',true ,1071),
(1,1203 ,1200,'Aufgabe-Trichter-Fahrzeug',false,1072),
(1,1204 ,1200,'Bandanlage',true ,1073),
(1,1205 ,1200,'Bandantriebsstation',false,1074),
(1,1206 ,1200,'Bandbrücke',true ,1075),
(1,1207 ,1200,'Bandrückmaschine',true ,1076),
(1,1208 ,1200,'Bandschleifenwagen',true ,1077),
(1,1209 ,1200,'Bandwagen',true ,1078),
(1,1210 ,1200,'Birkpflug',false,1079),
(1,1211 ,1200,'Brecheranlage',false,1080),
(1,1212 ,1200,'Dampfkessel',true ,1081),
(1,1213 ,1200,'Dampfturbine',true ,1082),
(1,1214 ,1200,'Eimerkettenbagger',true ,1083),
(1,1215 ,1200,'Fördergutträger',true ,1084),
(1,1216 ,1200,'Fördermaschine',true ,1085),
(1,1217 ,1200,'Förderwagen',true ,1086),
(1,1218 ,1200,'Generator',true ,1087),
(1,1219 ,1200,'Gleisrückmaschine',true ,1088),
(1,1220 ,1200,'Grubenbahn',true ,1089),
(1,1221 ,1200,'Hängebank',false,1090),
(1,1222 ,1200,'Hilfsgerät',true ,1091),
(1,1223 ,1200,'Kabeltrommelwagen',true ,1092),
(1,1224 ,1200,'Kohlebahn',true ,1093),
(1,1225 ,1200,'Kompressor',true ,1094),
(1,1226 ,1200,'Kratzerkettenförderer',false,1095),
(1,1227 ,1200,'Kreuzungsbauwerk',false,1096),
(1,1228 ,1200,'Leitungstrommel',false,1097),
(1,1229 ,1200,'Maschinen-/Anlagenteil',true ,1098),
(1,1230 ,1200,'Rückladegerät',true ,1099),
(1,1231 ,1200,'Schachtbohrgerät',true ,1100),
(1,1232 ,1200,'Schaufelradbagger',true ,1101),
(1,1233 ,1200,'Sprühanlage',true ,1102),
(1,1234 ,1200,'Waage',true ,1103),
(1,1235 ,1200,'Wasserrad',true ,1104),
(1,1236 ,1200,'Wasserturbine',true ,1105),
(1,1300 ,1300,'Bergbauwasserwirtschaftliche Anlage',false,1106),
(1,1301 ,1300,'Abschlag',false,1107),
(1,1302 ,1300,'Absetzbecken',true ,1108),
(1,1303 ,1300,'Aquädukt',false,1109),
(1,1304 ,1300,'Belüftungsanlagen',true ,1110),
(1,1305 ,1300,'Brunnen',false,1111),
(1,1306 ,1300,'Dichtwand',false,1112),
(1,1307 ,1300,'Entwässerungsbrunnen',true ,1113),
(1,1308 ,1300,'Entwässerungsstrecke',true ,1114),
(1,1309 ,1300,'Filterbrunnen',true ,1115),
(1,1310 ,1300,'Grubenentwässerungsanlage',false,1116),
(1,1311 ,1300,'Grubenwasserreinigungsanlage',false,1117),
(1,1312 ,1300,'Kalksilos',true ,1118),
(1,1313 ,1300,'Leitungssystem',true ,1119),
(1,1314 ,1300,'Leitungssystem',true ,1120),
(1,1315 ,1300,'Pegel',false,1121),
(1,1316 ,1300,'Vorfluter',false,1122),
(1,1001 ,NULL,'Feuerlöschteich',false,1123),
(1,1002 ,NULL,'Feuerwache',false,1124),
(1,1003 ,NULL,'Feuerwachturm',false,1125),
(1,1004 ,NULL,'Feuerwehr-Fahrzeuge',true ,1126),
(1,1400 ,1400,'Kran',false,1127),
(1,1401 ,1400,'Drehkran',true ,1128),
(1,1402 ,1400,'Laufkran',true ,1129),
(1,1403 ,1400,'Portalkran',true ,1130),
(1,1005 ,NULL,'Schlauchturm',false,1131),
(1,1006 ,NULL,'Schütz',false,1132),
(1,1500 ,1500,'Schutzbauwerke',false,1133),
(1,1501 ,1500,'Damm',false,1134),
(1,1502 ,1500,'Flutrinne',false,1135),
(1,1503 ,1500,'Haben',false,1136),
(1,1504 ,1500,'Hochwassermarke',false,1137),
(1,1505 ,1500,'Überlaufgraben',false,1138),
(1,1007 ,NULL,'Spritzenhaus',false,1139),
(1,1008 ,NULL,'Staudamm',false,1140),
(1,1600 ,1600,'Talsperre',false,1141),
(1,1601 ,1600,'Schieberhaus',false,1142),
(1,1602 ,1600,'Tosbecken',false,1143),
(1,1603 ,1600,'Wärterhaus',false,1144),
(1,1009 ,NULL,'Wehr',false,1145),
--
(2,2001,NULL,'Energiespeicheranlage',TRUE,2000),
(2,2100,2100,'Erneuerbare Energien',FALSE,2001),
(2,2101,2100,'Biogasanlage',FALSE,2002),
(2,2102,2100,'Energiepflanzen',FALSE,2003),
(2,2103,2100,'Pumpspeicherwerk',FALSE,2004),
(2,2104,2100,'Solarfeld',FALSE,2005),
(2,2105,2100,'Wasserkraftwerk',FALSE,2006),
(2,2106,2100,'Windkraftwerk',FALSE,2007),
(2,2200,2200,'Heizkraftwerk',FALSE,2008),
(2,2201,2200,'Ascheverladung',FALSE,2009),
(2,2202,2200,'Bandförderbrücke',FALSE,2010),
(2,2203,2200,'Braunkohlebunker',FALSE,2011),
(2,2204,2200,'Braunkohleförderbandanlage',FALSE,2012),
(2,2205,2200,'Bunker',FALSE,2013),
(2,2206,2200,'Dampferzeuger',FALSE,2014),
(2,2207,2200,'Dampfturbine',FALSE,2015),
(2,2208,2200,'Druckrohrleitung',FALSE,2016),
(2,2209,2200,'Elektrofilter',FALSE,2017),
(2,2210,2200,'Fernwärme- und Prozessdampfauskoppelung',FALSE,2018),
(2,2211,2200,'Filteranlage',FALSE,2019),
(2,2212,2200,'Freiluftschaltanlage',FALSE,2020),
(2,2213,2200,'Generator',FALSE,2021),
(2,2214,2200,'Gipslager',FALSE,2022),
(2,2215,2200,'Hilfkessel',FALSE,2023),
(2,2216,2200,'Kesselhaus',FALSE,2024),
(2,2217,2200,'Kohlemühle',FALSE,2025),
(2,2218,2200,'Kohlenlager',FALSE,2026),
(2,2219,2200,'Kohlenstaubleitung',FALSE,2027),
(2,2220,2200,'Kompressorengebäude',FALSE,2028),
(2,2221,2200,'Kondensator',FALSE,2029),
(2,2222,2200,'Kühlteich',FALSE,2030),
(2,2223,2200,'Kühlturm',FALSE,2031),
(2,2224,2200,'Luftvorwärmer',FALSE,2032),
(2,2225,2200,'Maschinenhaus',FALSE,2033),
(2,2226,2200,'Rauchgasabführungsrohr',FALSE,2034),
(2,2227,2200,'Rauchgasentschwefelungsanlage',FALSE,2035),
(2,2228,2200,'Rauchgaskanal',FALSE,2036),
(2,2229,2200,'Saugzuggebläse',FALSE,2037),
(2,2230,2200,'Schaltzentrale',FALSE,2038),
(2,2231,2200,'Schlagradmühle',FALSE,2039),
(2,2232,2200,'Schornstein',FALSE,2040),
(2,2233,2200,'Sozialgebäude',FALSE,2041),
(2,2234,2200,'Speisewasserpumpe',FALSE,2042),
(2,2235,2200,'Transformator',FALSE,2043),
(2,2236,2200,'Turbinenhaus',FALSE,2044),
(2,2237,2200,'Umspannanlage',FALSE,2045),
(2,2238,2200,'Wasserbehälter',FALSE,2046),
(2,2239,2200,'Wasserstoffstation',FALSE,2047),
(2,2002,NULL,'Kavernenkraftwerk',FALSE,2048),
(2,2300,2300,'Kohlekraftwerk',FALSE,2049),
(2,2301,2300,'Ascheverladung',FALSE,2050),
(2,2302,2300,'Bandanlage',FALSE,2051),
(2,2303,2300,'Bandförderbrücke',FALSE,2052),
(2,2304,2300,'Braunkohleförderbandanlage',FALSE,2053),
(2,2305,2300,'Bunker',FALSE,2054),
(2,2306,2300,'Dampferzeuger',TRUE,2055),
(2,2307,2300,'Dampfkessel',FALSE,2056),
(2,2308,2300,'Dampfkühler',FALSE,2057),
(2,2309,2300,'Dampfmaschine',FALSE,2058),
(2,2310,2300,'Dampfturbine',TRUE,2059),
(2,2311,2300,'Druckrohrleitung',FALSE,2060),
(2,2312,2300,'Economiser',FALSE,2061),
(2,2313,2300,'Elektrofilter',FALSE,2062),
(2,2314,2300,'Entaschungsanlage',FALSE,2063),
(2,2315,2300,'Entsalzungsanlage',FALSE,2064),
(2,2316,2300,'Fernwärme- und Prozessdampfauskoppelung',FALSE,2065),
(2,2317,2300,'Feuerungsanlage',FALSE,2066),
(2,2318,2300,'Filteranlage',FALSE,2067),
(2,2319,2300,'Förderbandanlage',FALSE,2068),
(2,2320,2300,'Freileitungsmast',FALSE,2069),
(2,2321,2300,'Freiluftschaltanlage',FALSE,2070),
(2,2322,2300,'Generator',TRUE,2071),
(2,2323,2300,'Generatorableitung',FALSE,2072),
(2,2324,2300,'Gipslager',TRUE,2073),
(2,2325,2300,'Hilfkessel',TRUE,2074),
(2,2326,2300,'Kesselhaus',TRUE,2075),
(2,2327,2300,'Kohlemühle',TRUE,2076),
(2,2328,2300,'Kohlenlager',TRUE,2077),
(2,2329,2300,'Kohlenstaubleitung',TRUE,2078),
(2,2330,2300,'Kompressorengebäude',TRUE,2079),
(2,2331,2300,'Kondensator',FALSE,2080),
(2,2332,2300,'Kühlteich',FALSE,2081),
(2,2333,2300,'Kühlturm',FALSE,2082),
(2,2334,2300,'Leitstand',FALSE,2083),
(2,2335,2300,'Luftvorwärmer',FALSE,2084),
(2,2336,2300,'Maschinenhaus',FALSE,2085),
(2,2337,2300,'Rauchgasabführungsrohr',FALSE,2086),
(2,2338,2300,'Rauchgasentschwefelungsanlage',FALSE,2087),
(2,2339,2300,'Rauchgaskanal',FALSE,2088),
(2,2340,2300,'Rohkohlebunker',TRUE,2089),
(2,2341,2300,'Saugzuggebläse',FALSE,2090),
(2,2342,2300,'Schaltzentrale',FALSE,2091),
(2,2343,2300,'Schlagradmühle',FALSE,2092),
(2,2344,2300,'Schornstein',FALSE,2093),
(2,2345,2300,'Sozialgebäude',FALSE,2094),
(2,2346,2300,'Speisewasserpumpe',FALSE,2095),
(2,2347,2300,'Transformator',FALSE,2096),
(2,2348,2300,'Turbine',FALSE,2097),
(2,2349,2300,'Turbinenhaus',FALSE,2098),
(2,2350,2300,'Überhitzer',FALSE,2099),
(2,2351,2300,'Umspannanlage',FALSE,2100),
(2,2352,2300,'Umspanner',FALSE,2101),
(2,2353,2300,'Verwaltungsgebäude',FALSE,2102),
(2,2354,2300,'Wasserbehälter',FALSE,2103),
(2,2355,2300,'Wasserstoffstation',FALSE,2104),
(2,2356,2300,'Werkstattgebäude',FALSE,2105),
(2,2400,2400,'Kran',FALSE,2106),
(2,2401,2400,'Drehkran',TRUE,2107),
(2,2402,2400,'Laufkran',TRUE,2108),
(2,2403,2400,'Portalkran',TRUE,2109),
(2,2003,NULL,'Pumpenspeicherwerk',FALSE,2110),
(2,2004,NULL,'Transformatorenstation',FALSE,2111),
(2,2005,NULL,'Umspannwerk',TRUE,2112),
(2,2006,NULL,'Wasserkraftwerk',FALSE,2113),
(2,2007,NULL,'Windkraftwerk',FALSE,2114),
(2,2008,NULL,'Windrad',FALSE,2115),
--
(3,3100,3100,'Brikettfabrik',FALSE,3000),
(3,3101,3100,'Bandbrücke',FALSE,3001),
(3,3102,3100,'Brecheranlage',FALSE,3002),
(3,3103,3100,'Brikettpresse',FALSE,3003),
(3,3104,3100,'Bunker',FALSE,3004),
(3,3105,3100,'Dampfkessel',FALSE,3005),
(3,3106,3100,'Dampfturbine',FALSE,3006),
(3,3107,3100,'Drehkran',FALSE,3007),
(3,3108,3100,'Einfriedung',FALSE,3008),
(3,3109,3100,'Elevator',FALSE,3009),
(3,3110,3100,'Entstaubungsanlage',FALSE,3010),
(3,3111,3100,'Förderbandanlage',FALSE,3011),
(3,3112,3100,'Freileitung',FALSE,3012),
(3,3113,3100,'Fuchs',FALSE,3013),
(3,3114,3100,'Generator',FALSE,3014),
(3,3115,3100,'Hammermühle',FALSE,3015),
(3,3116,3100,'Kesselhaus',FALSE,3016),
(3,3117,3100,'"Kraftzentrale, elektrische"',FALSE,3017),
(3,3118,3100,'Kühlhaus',FALSE,3018),
(3,3119,3100,'Kühlturm',FALSE,3019),
(3,3120,3100,'Lagerhaus/-gebäude',FALSE,3020),
(3,3121,3100,'Laufkran',FALSE,3021),
(3,3122,3100,'Lehrwerkstatt',TRUE,3022),
(3,3123,3100,'Leitstand',FALSE,3023),
(3,3124,3100,'Magazin',TRUE,3024),
(3,3125,3100,'Mahlanlage',FALSE,3025),
(3,3126,3100,'Maschinenhaus',TRUE,3026),
(3,3127,3100,'Nassdienst',TRUE,3027),
(3,3128,3100,'Portalkran',FALSE,3028),
(3,3129,3100,'Pressengebäude',TRUE,3029),
(3,3130,3100,'Produktionsgebäude',FALSE,3030),
(3,3131,3100,'Redleranlage',FALSE,3031),
(3,3132,3100,'Rüttelsieb',FALSE,3032),
(3,3133,3100,'Schornstein',TRUE,3033),
(3,3134,3100,'Siebanlage',FALSE,3034),
(3,3135,3100,'Sozialgebäude',TRUE,3035),
(3,3136,3100,'Stapelplatz',FALSE,3036),
(3,3137,3100,'Stapelwand',FALSE,3037),
(3,3138,3100,'Technische Ausstattung',TRUE,3038),
(3,3139,3100,'Trockendienst',FALSE,3039),
(3,3140,3100,'Trockner/Trocknungsanlage',FALSE,3040),
(3,3141,3100,'Turbine',FALSE,3041),
(3,3142,3100,'Turbinenhaus',TRUE,3042),
(3,3143,3100,'Umspannanlage',TRUE,3043),
(3,3144,3100,'Verladeanlage',TRUE,3044),
(3,3145,3100,'Verwaltungsgebäude',TRUE,3045),
(3,3146,3100,'Waage',TRUE,3046),
(3,3147,3100,'Waschkaue',FALSE,3047),
(3,3148,3100,'Werkstattgebäude',TRUE,3048),
(3,3149,3100,'Wirbelschichtekohle/Staubproduktion',FALSE,3049),
(3,3150,3100,'Wrasenschlot/Brüden',TRUE,3050),
(3,3200,3200,'Kokerei',TRUE,3051),
(3,3201,3200,'Dekanteranlage/ Mischbrennstoffanlage',FALSE,3052),
(3,3202,3200,'Koksalterungsanlage',FALSE,3053),
(3,3203,3200,'Kokshalde',FALSE,3054),
(3,3204,3200,'Schwefelgewinnungsanlage',FALSE,3055),
(3,3205,3200,'Tanklager',FALSE,3056),
(3,3001,NULL,'Montanwachsfabrik',FALSE,3057),
(3,3300,NULL,'Schwelerei/Schwelwerk',FALSE,3058),
(3,3301,3300,'Laborgebäude',TRUE,3059),
(3,3302,3300,'Magazin',FALSE,3060),
(3,3303,3300,'Schornstein',TRUE,3061),
(3,3304,3300,'Schwelhaus',TRUE,3062),
(3,3305,3300,'Schwelofen',FALSE,3063),
(3,3306,3300,'Sozialgebäude',FALSE,3064),
(3,3307,3300,'Verwaltungsgebäude',TRUE,3065),
(3,3308,3300,'Werkstattgebäude',FALSE,3066),
(3,3002,NULL,'Hydrierwerk',FALSE,3067),
--
(4,4100,4100,'Bahnbetriebsanlage',FALSE,4000),
(4,4101,4100,'Ausbesserungswerk',FALSE,4001),
(4,4102,4100,'Bahnbetriebswerk',TRUE,4002),
(4,4103,4100,'Bahnheizwerk',FALSE,4003),
(4,4104,4100,'Bahnmeisterei',FALSE,4004),
(4,4105,4100,'Bekohlungsanlage',TRUE,4005),
(4,4106,4100,'Drehscheibe',TRUE,4006),
(4,4107,4100,'Eisenbahn-Stromversorgung',FALSE,4007),
(4,4108,4100,'Eisenbahn-Wasserversorgung',FALSE,4008),
(4,4109,4100,'Leitzentrale',FALSE,4009),
(4,4110,4100,'Lokschuppen',FALSE,4010),
(4,4111,4100,'Rangierbahnhof',FALSE,4011),
(4,4112,4100,'Reichsbahnamt',FALSE,4012),
(4,4113,4100,'Ringlokschuppen',TRUE,4013),
(4,4114,4100,'Schaltbefehlsstelle',TRUE,4014),
(4,4115,4100,'Schiebebühne',TRUE,4015),
(4,4116,4100,'Versorgungsgebäude',TRUE,4016),
(4,4117,4100,'Wasserkran',FALSE,4017),
(4,4118,4100,'Wasserturm',FALSE,4018),
(4,4119,4100,'Werkstatt',FALSE,4019),
(4,4200,4200,'Bahnkörper',FALSE,4020),
(4,4201,4200,'Eisenbahndamm',FALSE,4021),
(4,4202,4200,'Gleise',FALSE,4022),
(4,4203,4200,'Stützmauer',FALSE,4023),
(4,4204,4200,'Weichen',FALSE,4024),
(4,4001,NULL,'Bahnübergang',FALSE,4025),
(4,4002,NULL,'Bahnwärterhaus',FALSE,4026),
(4,4003,NULL,'Brücke',FALSE,4027),
(4,4004,NULL,'Brückenteil',FALSE,4028),
(4,4005,NULL,'Brückenwärterhaus',TRUE,4029),
(4,4006,NULL,'Chausseehaus',FALSE,4030),
(4,4007,NULL,'Containerbahnhof',FALSE,4031),
(4,4008,NULL,'Durchlass',FALSE,4032),
(4,4300,4300,'Eisenbahnanlage',FALSE,4033),
(4,4301,4300,'Feldbahn',TRUE,4034),
(4,4302,4300,'Industriebahn',TRUE,4035),
(4,4303,4300,'Kohlenbahn',TRUE,4036),
(4,4304,4300,'Werkbahn',TRUE,4037),
(4,4350,4350,'Eisenbahnbauten',FALSE,4038),
(4,4351,4350,'Verwaltungsgebäude',FALSE,4039),
(4,4250,4250,'Eisenbahnbrücke',FALSE,4040),
(4,4251,4250,'Kreuzungsbauwerk',FALSE,4041),
(4,4252,4250,'Signalbrücke',FALSE,4042),
(4,4253,4250,'Viadukt',FALSE,4043),
(4,4254,4250,'Wegeüberführung',FALSE,4044),
(4,4255,4250,'Wegeunterführung',FALSE,4045),
(4,4009,NULL,'Eisenbahntunnel',FALSE,4046),
(4,4150,4150,'Eisenbahnwagen',FALSE,4047),
(4,4151,4150,'Bahndienstwagen',FALSE,4048),
(4,4152,4150,'Doppelstockwagen',FALSE,4049),
(4,4153,4150,'Güterwagen',FALSE,4050),
(4,4154,4150,'Kohlewagen',FALSE,4051),
(4,4155,4150,'Kranwagen',FALSE,4052),
(4,4156,4150,'Reisezugwagen',FALSE,4053),
(4,4180,4180,'Energieerzeugungsanlagenteil',FALSE,4054),
(4,4181,4180,'Freileitungsmast',FALSE,4055),
(4,4010,NULL,'Fernmeldeeinrichtung',FALSE,4056),
(4,4011,NULL,'Fuhrpark/Garagenhof',FALSE,4057),
(4,4012,NULL,'Furt',FALSE,4058),
(4,4170,4170,'Fußgängerbrücke',FALSE,4059),
(4,4171,4170,'Viadukt',FALSE,4060),
(4,4013,NULL,'Fußgängerunterführung',FALSE,4061),
(4,4014,NULL,'Gasversorgung',FALSE,4062),
(4,4280,4280,'Güterbahnhof',FALSE,4063),
(4,4281,4280,'Güterschuppen',FALSE,4064),
(4,4282,4280,'Güterwaage',FALSE,4065),
(4,4283,4280,'Laderampe',TRUE,4066),
(4,4284,4280,'Ladestraße',TRUE,4067),
(4,4285,4280,'Toilettenhäuschen',TRUE,4068),
(4,4286,4280,'Wirtschaftsgebäude',FALSE,4069),
(4,4380,4380,'Gütertransportanlage',FALSE,4070),
(4,4381,4380,'Bahndamm',FALSE,4071),
(4,4382,4380,'Bahnstrecke',FALSE,4072),
(4,4383,4380,'Fundament',FALSE,4073),
(4,4384,4380,'Kettenbahn',FALSE,4074),
(4,4385,4380,'Kohlenbahn',FALSE,4075),
(4,4386,4380,'Seilbahn',FALSE,4076),
(4,4387,4380,'Seilbahnmast',FALSE,4077),
(4,4388,4380,'Verladerampe',FALSE,4078),
(4,4015,NULL,'Industriebahnhof',FALSE,4079),
(4,4016,NULL,'Kilometerstein',FALSE,4080),
(4,4400,4400,'Kran',FALSE,4081),
(4,4401,4400,'Drehkran',FALSE,4082),
(4,4402,4400,'Laufkran',FALSE,4083),
(4,4403,4400,'Portalkran',FALSE,4084),
(4,4017,NULL,'Läutewerk',FALSE,4085),
(4,4410,4410,'Leitungssystem',FALSE,4086),
(4,4411,4410,'Fernwärmekanal',FALSE,4087),
(4,4420,4420,'Lokomotive',TRUE,4088),
(4,4421,4420,'Dampflokomotive',TRUE,4089),
(4,4422,4420,'Diesellokomotive',TRUE,4090),
(4,4423,4420,'Elektrolokomotive',TRUE,4091),
(4,4430,4430,'Nahverkehrsbauten',FALSE,4092),
(4,4431,4430,'Betriebshof',FALSE,4093),
(4,4432,4430,'Busbahnhof',FALSE,4094),
(4,4433,4430,'Fahrleitungen',FALSE,4095),
(4,4434,4430,'Kontorhaus',FALSE,4096),
(4,4435,4430,'Pförtnerhaus',FALSE,4097),
(4,4436,4430,'Schornstein',FALSE,4098),
(4,4437,4430,'Straßenbahndepot',TRUE,4099),
(4,4438,4430,'Verwaltungsgebäude',TRUE,4100),
(4,4439,4430,'Wartehäuschen',TRUE,4101),
(4,4450,4450,'Nahverkehrsfahrzeuge',FALSE,4102),
(4,4451,4450,'O-Bus',TRUE,4103),
(4,4452,4450,'Omnibus',TRUE,4104),
(4,4453,4450,'Pferdebahn',TRUE,4105),
(4,4454,4450,'Seilbahn',TRUE,4106),
(4,4455,4450,'Straßenbahn',TRUE,4107),
(4,4456,4450,'Taxi',TRUE,4108),
(4,4457,4450,'Zahnradbahn',TRUE,4109),
(4,4018,NULL,'Nutzkraftwagen',FALSE,4110),
(4,4019,NULL,'Parkhaus',FALSE,4111),
(4,4460,4460,'Personenbahnhof',FALSE,4112),
(4,4461,4460,'Bahnsteig',FALSE,4113),
(4,4462,4460,'Bahnsteighalle',FALSE,4114),
(4,4463,4460,'Empfangsgebäude',FALSE,4115),
(4,4464,4460,'Grenzübergangsbahnhof',FALSE,4116),
(4,4465,4460,'Güterabfertigung',TRUE,4117),
(4,4466,4460,'Toilettenhäuschen',FALSE,4118),
(4,4467,4460,'Unterführung',FALSE,4119),
(4,4468,4460,'Wartehalle',FALSE,4120),
(4,4469,4460,'Wirtschaftsgebäude',TRUE,4121),
(4,4020,NULL,'Personenkraftwagen',TRUE,4122),
(4,4021,NULL,'Post',FALSE,4123),
(4,4022,NULL,'Postbahnhof',FALSE,4124),
(4,4023,NULL,'Rangier- und Verschiebebahnhof',FALSE,4125),
(4,4024,NULL,'Rastplatz',FALSE,4126),
(4,4025,NULL,'Reiterstein',FALSE,4127),
(4,4026,NULL,'Schranke',FALSE,4128),
(4,4480,4480,'Signalanlagen',FALSE,4129),
(4,4481,4480,'Elektromechanisch',FALSE,4130),
(4,4482,4480,'Formsignal',FALSE,4131),
(4,4483,4480,'Hauptsignal',FALSE,4132),
(4,4484,4480,'Lichtsignal',FALSE,4133),
(4,4490,4490,'Stadtbeleuchtung',FALSE,4134),
(4,4491,4490,'elektrisch',FALSE,4135),
(4,4492,4490,'Gasbeleuchtung',FALSE,4136),
(4,4493,4490,'Kandelaber',FALSE,4137),
(4,4494,4490,'Laterne',FALSE,4138),
(4,4500,4500,'Stellwerk',FALSE,4139),
(4,4501,4500,'Brückenstellwerk',FALSE,4140),
(4,4502,4500,'Elektrisch',FALSE,4141),
(4,4503,4500,'Gleisbildstellwerk',FALSE,4142),
(4,4504,4500,'Mechanisch',FALSE,4143),
(4,4505,4500,'Reiterstellwerk',FALSE,4144),
(4,4506,4500,'Relaisstellwerk',FALSE,4145),
(4,4507,4500,'Stellwerksturm',FALSE,4146),
(4,4510,4510,'Straße',FALSE,4147),
(4,4511,4510,'Chaussee',FALSE,4148),
(4,4512,4510,'Pflaster',FALSE,4149),
(4,4520,4520,'Straßenbrücke',FALSE,4150),
(4,4521,4520,'Autobahnbrücke',FALSE,4151),
(4,4522,4520,'Viadukt',FALSE,4152),
(4,4523,4520,'Zufahrtsbrücke',FALSE,4153),
(4,4027,NULL,'Straßenfahrzeuge',FALSE,4154),
(4,4530,4530,'Straßenmobiliar',FALSE,4155),
(4,4531,4530,'Geländer',FALSE,4156),
(4,4028,NULL,'Straßentunnel',TRUE,4157),
(4,4029,NULL,'Tanksäule',FALSE,4158),
(4,4030,NULL,'Tankstelle',FALSE,4159),
(4,4031,NULL,'Triebwagen',FALSE,4160),
(4,4032,NULL,'Verkehrsleiteinrichtungen',FALSE,4161),
(4,4033,NULL,'Wagenhalle',FALSE,4162),
(4,4540,4540,'Wasserversorgungs- und Abwasseranlage',FALSE,4163),
(4,4541,4540,'Anzucht',FALSE,4164),
(4,4542,4540,'Aquädukt',FALSE,4165),
(4,4543,4540,'Brunnen',FALSE,4166),
(4,4544,4540,'Brunnenhaus',FALSE,4167),
(4,4545,4540,'Handschwengelpumpe',FALSE,4168),
(4,4546,4540,'Hydrant',FALSE,4169),
(4,4547,4540,'Hydraulischer Widder',TRUE,4170),
(4,4548,4540,'Kläranlage',TRUE,4171),
(4,4549,4540,'Pumpe',FALSE,4172),
(4,4550,4540,'Pumpenhaus',FALSE,4173),
(4,4551,4540,'Schachtabdeckung',FALSE,4174),
(4,4552,4540,'Schöpfstelle',FALSE,4175),
(4,4553,4540,'Wasserhochbehälter',FALSE,4176),
(4,4554,4540,'Wasserkunst',FALSE,4177),
(4,4555,4540,'Wasserleitung',TRUE,4178),
(4,4556,4540,'Wasserstube',FALSE,4179),
(4,4557,4540,'Wasserturm',FALSE,4180),
(4,4558,4540,'Zisterne',FALSE,4181),
(4,4570,4570,'Wasserwerk',FALSE,4182),
(4,4571,4570,'Dampfkessel',FALSE,4183),
(4,4572,4570,'Dampfturbine',FALSE,4184),
(4,4573,4570,'Fabrikgebäude',FALSE,4185),
(4,4574,4570,'Generator',FALSE,4186),
(4,4575,4570,'Kessel- und Maschinenhaus',FALSE,4187),
(4,4576,4570,'Kontorhaus',TRUE,4188),
(4,4577,4570,'Labor',TRUE,4189),
(4,4578,4570,'Pförtnerhaus',TRUE,4190),
(4,4579,4570,'Pumpe',TRUE,4191),
(4,4580,4570,'Schaltwarte',FALSE,4192),
(4,4581,4570,'Schornstein',FALSE,4193),
(4,4582,4570,'Verwaltungsgebäude',FALSE,4194),
(4,4583,4570,'Wasseraufbereitungsanlage',FALSE,4195),
(4,4584,4570,'Wasserspeicher',FALSE,4196),
(4,4034,NULL,'Wegestein',FALSE,4197),
--
(5,5100,5100,'Abfallentsorgung',FALSE,5000),
(5,5101,5100,'Verwaltungsgebäude',FALSE,5001),
(5,5001,NULL,'Akademie',FALSE,5002),
(5,5002,NULL,'Altenheim',FALSE,5003),
(5,5003,NULL,'Apotheke',FALSE,5004),
(5,5004,NULL,'Arbeiterwohnhaus',FALSE,5005),
(5,5005,NULL,'Arbeits- und Besserungsanstalt',FALSE,5006),
(5,5006,NULL,'Armenhaus',FALSE,5007),
(5,5007,NULL,'Ausflugslokal',FALSE,5008),
(5,5110,5110,'Aussichtsgebäude',FALSE,5009),
(5,5111,5110,'Aussichtsturm',FALSE,5010),
(5,5008,NULL,'Badeanstalt',FALSE,5011),
(5,5009,NULL,'Bankgebäude',FALSE,5012),
(5,5010,NULL,'Baude',FALSE,5013),
(5,5120,5120,'Bauplastik',FALSE,5014),
(5,5121,5120,'Nischenfigur',FALSE,5015),
(5,5122,5120,'Portalfigur',FALSE,5016),
(5,5123,5120,'Relief',FALSE,5017),
(5,5124,5120,'Säulenfigur',FALSE,5018),
(5,5130,5130,'Beamtenwohnhaus',FALSE,5019),
(5,5131,5130,'Betriebsbeamtenwohnhaus',FALSE,5020),
(5,5132,5130,'Eisenbahnerwohnhaus',FALSE,5021),
(5,5133,5130,'Steigerhaus',FALSE,5022),
(5,5011,NULL,'Bedürfnisanstalt',FALSE,5023),
(5,5140,5140,'Berufsschule',FALSE,5024),
(5,5141,5140,'Lehrlingswohnheim',FALSE,5025),
(5,5150,5150,'Bodenrelief',FALSE,5026),
(5,5151,5150,'Bodenmodellierung',FALSE,5027),
(5,5160,5160,'Botanischer Garten',FALSE,5028),
(5,5161,5160,'Alpinum',FALSE,5029),
(5,5162,5160,'Anzuchtfläche',FALSE,5030),
(5,5163,5160,'Arboretum',FALSE,5031),
(5,5164,5160,'Forstbotanischer Garten',FALSE,5032),
(5,5165,5160,'Pflanzenabteilung',FALSE,5033),
(5,5166,5160,'Pflanzensammlung',FALSE,5034),
(5,5167,5160,'Pinetum',FALSE,5035),
(5,5168,5160,'Rhododendrongarten/-park',FALSE,5036),
(5,5169,5160,'Rosarium',FALSE,5037),
(5,5170,5160,'Systemgarten',FALSE,5038),
(5,5180,5180,'Bürogebäude',FALSE,5039),
(5,5181,5180,'Verwaltungsgebäude',FALSE,5040),
(5,5200,5200,'Denkmal',FALSE,5042),
(5,5201,5200,'1933/1945',FALSE,5043),
(5,5202,5200,'1945/1989',FALSE,5044),
(5,5203,5200,'bis 1933',FALSE,5045),
(5,5204,5200,'Brunnenplastik',FALSE,5046),
(5,5205,5200,'Büste',FALSE,5047),
(5,5206,5200,'Denkmal 1. Weltkrieg',FALSE,5048),
(5,5207,5200,'Denkmal 2. Weltkrieg',FALSE,5049),
(5,5208,5200,'Denkmal Deutsch-Franz. Krieg',FALSE,5050),
(5,5209,5200,'Eiszeit',FALSE,5051),
(5,5210,5200,'Reiterstatue',FALSE,5052),
(5,5211,5200,'Relief',FALSE,5053),
(5,5212,5200,'Sitzstatue',FALSE,5054),
(5,5213,5200,'Statue',FALSE,5055),
(5,5214,5200,'Tierplastik',FALSE,5056),
(5,5215,5200,'Torso',FALSE,5057),
(5,5216,5200,'VdN/OdF',FALSE,5058),
(5,5220,5220,'Eisenbahnanlage',FALSE,5059),
(5,5221,5220,'Pioniereisenbahn',FALSE,5060),
(5,5013,NULL,'Erinnerungsort',FALSE,5061),
(5,5230,5230,'Fabrikpark/Werksgarten',FALSE,5062),
(5,5231,5230,'Pausengarten',FALSE,5063),
(5,5232,5230,'Vorgarten',FALSE,5064),
(5,5014,NULL,'Fachschule',FALSE,5065),
(5,5015,NULL,'Feuerlöschteich',FALSE,5066),
(5,5016,NULL,'Feuerwache',FALSE,5067),
(5,5017,NULL,'Feuerwachturm',FALSE,5068),
(5,5018,NULL,'Feuerwehr-Fahrzeuge',FALSE,5069),
(5,5019,NULL,'Feuerwehrdepot',FALSE,5070),
(5,5240,5240,'Forschungseinrichtung',FALSE,5071),
(5,5241,5240,'Institut',FALSE,5072),
(5,5020,NULL,'Freibad',FALSE,5073),
(5,5021,NULL,'Freilichtmuseum',FALSE,5074),
(5,5022,NULL,'Gartenstadt',FALSE,5075),
(5,5640,5640,'Gastgewerbe',FALSE,5076),
(5,5641,5640,'Ausflugslokal',FALSE,5077),
(5,5642,5640,'Café',FALSE,5078),
(5,5643,5640,'Gästehaus',FALSE,5079),
(5,5644,5640,'Gaststätte',FALSE,5080),
(5,5645,5640,'Gastwirtschaftsgarten',FALSE,5081),
(5,5646,5640,'Hotel',FALSE,5082),
(5,5647,5640,'Kurhotel',FALSE,5083),
(5,5270,5270,'Gedenkstein',FALSE,5084),
(5,5271,5270,'1933/1945',FALSE,5085),
(5,5272,5270,'1945/1989',FALSE,5086),
(5,5273,5270,'bis 1933',FALSE,5087),
(5,5274,5270,'Gedenkstein 1. Weltkrieg',FALSE,5088),
(5,5275,5270,'Gedenkstein 2. Weltkrieg',FALSE,5089),
(5,5276,5270,'Gedenkstein Deutsche',FALSE,5090),
(5,5277,5270,'Gedenkstein Deutsch-Franz. Krieg',FALSE,5091),
(5,5278,5270,'Gedenkstein Franzosen',FALSE,5092),
(5,5279,5270,'Gedenkstein Italiener',FALSE,5093),
(5,5280,5270,'Gedenkstein Polen',FALSE,5094),
(5,5281,5270,'Gedenkstein Sowjetbürger',FALSE,5095),
(5,5282,5270,'Jüdisch',FALSE,5096),
(5,5283,5270,'Napoleon',FALSE,5097),
(5,5284,5270,'VdN/OdF',FALSE,5098),
(5,5300,5300,'Gedenktafel',FALSE,5099),
(5,5301,5300,'1933/1945',FALSE,5100),
(5,5302,5300,'1945/1989',FALSE,5101),
(5,5303,5300,'bis 1933',FALSE,5102),
(5,5304,5300,'Gedenktafel 1. Weltkrieg',FALSE,5103),
(5,5305,5300,'Gedenktafel 2. Weltkrieg',FALSE,5104),
(5,5306,5300,'Gedenktafel Deutsche',FALSE,5105),
(5,5307,5300,'Gedenktafel Deutsch-Franz. Krieg',FALSE,5106),
(5,5308,5300,'Gedenktafel Franzosen',FALSE,5107),
(5,5309,5300,'Gedenktafel Italiener',FALSE,5108),
(5,5310,5300,'Gedenktafel Polen',FALSE,5109),
(5,5311,5300,'Gedenktafel Sowjetbürger',FALSE,5110),
(5,5312,5300,'Jüdisch',FALSE,5111),
(5,5313,5300,'Napoleon',FALSE,5112),
(5,5314,5300,'VdN/OdF',FALSE,5113),
(5,5320,5320,'Gehölz',FALSE,5114),
(5,5321,5320,'Dorfeiche',FALSE,5115),
(5,5322,5320,'Dorflinde',FALSE,5116),
(5,5323,5320,'Formgehölz',FALSE,5117),
(5,5330,5330,'Geschäftshaus',FALSE,5118),
(5,5331,5330,'Krankenkasse',TRUE,5119),
(5,5332,5330,'Versicherungsgebäude',FALSE,5120),
(5,5024,NULL,'Gewerbeschule',FALSE,5121),
(5,5025,NULL,'Gewerkschaftshaus',FALSE,5122),
(5,5026,NULL,'Hallenbad',FALSE,5123),
(5,5027,NULL,'Handelshaus',FALSE,5124),
(5,5028,NULL,'Handelsschule',FALSE,5125),
(5,5340,5340,'Hausgarten/Wohngarten',FALSE,5126),
(5,5341,5340,'Blumengarten',FALSE,5127),
(5,5342,5340,'Gartenhof',FALSE,5128),
(5,5343,5340,'Gartenplatz',FALSE,5129),
(5,5344,5340,'Gemüsegarten',FALSE,5130),
(5,5345,5340,'Obstgarten',FALSE,5131),
(5,5346,5340,'Vorgarten',FALSE,5132),
(5,5029,NULL,'Hochschule',FALSE,5133),
(5,5350,5350,'Hotel',FALSE,5134),
(5,5030,NULL,'Internat',FALSE,5135),
(5,5031,NULL,'Jugendheim/Kinderheim',FALSE,5136),
(5,5032,NULL,'Jugendherberge/Ferienlager/Ferienheim',FALSE,5137),
(5,5033,NULL,'Kantine',FALSE,5138),
(5,5034,NULL,'Kaufhaus',FALSE,5139),
(5,5035,NULL,'Kaufmannshaus',FALSE,5140),
(5,5036,NULL,'Kegelbahn',FALSE,5141),
(5,5037,NULL,'Kinderbewahranstalt',FALSE,5142),
(5,5038,NULL,'Kindergarten',FALSE,5143),
(5,5039,NULL,'Kinderheim',FALSE,5144),
(5,5040,NULL,'Kinderkrippe',FALSE,5145),
(5,5041,NULL,'Kino',FALSE,5146),
(5,5042,NULL,'Kiosk',FALSE,5147),
(5,5043,NULL,'Kommunikationszentrum',FALSE,5148),
(5,5044,NULL,'Kulturhaus',FALSE,5149),
(5,5360,5360,'Künstlerische Bauausstattung',FALSE,5150),
(5,5361,5360,'Bleiglasfenster',FALSE,5151),
(5,5362,5360,'Farbglasfenster',FALSE,5152),
(5,5363,5360,'Fliesenfußboden',FALSE,5153),
(5,5364,5360,'Handlauf',FALSE,5154),
(5,5365,5360,'Holzdecke',FALSE,5155),
(5,5366,5360,'Stuck',FALSE,5156),
(5,5367,5360,'Wandvertäfelung',FALSE,5157),
(5,5045,NULL,'Kurbad',FALSE,5158),
(5,5046,NULL,'Kureinrichtung',FALSE,5159),
(5,5370,5370,'Laden',FALSE,5160),
(5,5371,5370,'Bäckerei',FALSE,5161),
(5,5372,5370,'Fleischerei',FALSE,5162),
(5,5373,5370,'Verkaufspavillon',FALSE,5163),
(5,5047,NULL,'Lagerhaus',FALSE,5164),
(5,5048,NULL,'Landhaus',FALSE,5165),
(5,5049,NULL,'Ledigenwohnheim',FALSE,5166),
(5,5050,NULL,'Lehrpfad',FALSE,5167),
(5,5051,NULL,'Markthalle',FALSE,5168),
(5,5380,5380,'Mietshaus',FALSE,5169),
(5,5381,5380,'Doppelmietshaus',FALSE,5170),
(5,5052,NULL,'Museum',FALSE,5171),
(5,5400,5400,'Parkanlage',FALSE,5172),
(5,5401,5400,'Blumengarten',FALSE,5173),
(5,5402,5400,'Dahliengarten',FALSE,5174),
(5,5403,5400,'Fabrikpark',FALSE,5175),
(5,5404,5400,'Kulturpark',FALSE,5176),
(5,5405,5400,'Rosengarten',FALSE,5177),
(5,5406,5400,'Spielanlage',FALSE,5178),
(5,5407,5400,'Sportanlage',FALSE,5179),
(5,5408,5400,'Stadtpark',FALSE,5180),
(5,5409,5400,'Staudengarten',FALSE,5181),
(5,5410,5400,'Volkspark',FALSE,5182),
(5,5411,5400,'Waldpark',FALSE,5183),
(5,5420,5420,'Pension',FALSE,5184),
(5,5421,5420,'Kurpension',FALSE,5185),
(5,5053,NULL,'Pflegeheim',FALSE,5186),
(5,5430,5430,'Platz',FALSE,5187),
(5,5431,5430,'Festplatz',FALSE,5188),
(5,5432,5430,'Marktplatz',FALSE,5189),
(5,5054,NULL,'Poliklinik/ Krankenhaus',FALSE,5190),
(5,5055,NULL,'Post',FALSE,5191),
(5,5440,5440,'Sammlung',FALSE,5192),
(5,5441,5440,'Technik',FALSE,5193),
(5,5056,NULL,'Schlauchturm',FALSE,5194),
(5,5450,5450,'Schlossgarten / -park',FALSE,5195),
(5,5451,5450,'Baumgarten/Obstgarten',FALSE,5196),
(5,5452,5450,'Boskett',FALSE,5197),
(5,5453,5450,'Boulingrin',FALSE,5198),
(5,5454,5450,'Eremitage',FALSE,5199),
(5,5455,5450,'Küchengarten',FALSE,5200),
(5,5456,5450,'Orangerieparterre',FALSE,5201),
(5,5457,5450,'Parterre',FALSE,5202),
(5,5458,5450,'Schlossterrasse',FALSE,5203),
(5,5459,5450,'Ziergarten',FALSE,5204),
(5,5460,5450,'Blumengarten',FALSE,5205),
(5,5461,5450,'Pleasure-ground',FALSE,5206),
(5,5462,5450,'Rosengarten',FALSE,5207),
(5,5463,5450,'Schlossterrasse',FALSE,5208),
(5,5057,NULL,'Schule',FALSE,5209),
(5,5058,NULL,'Schutzhütte',FALSE,5210),
(5,5059,NULL,'Seminar',FALSE,5211),
(5,5470,5470,'Siedlung',FALSE,5212),
(5,5471,5470,'Doppelwohnhäuser',FALSE,5213),
(5,5472,5470,'Einfamilienwohnhäuser',FALSE,5214),
(5,5473,5470,'Einfriedung',FALSE,5215),
(5,5474,5470,'Eisenbahnersiedlung',FALSE,5216),
(5,5475,5470,'Garage',FALSE,5217),
(5,5476,5470,'Heizhaus',FALSE,5218),
(5,5477,5470,'Mehrfamilienwohnhäuser',FALSE,5219),
(5,5478,5470,'Reihenhäuser',FALSE,5220),
(5,5479,5470,'Siedlungshäuser',FALSE,5221),
(5,5480,5470,'Waschhaus',FALSE,5222),
(5,5481,5470,'Werkssiedlung',FALSE,5223),
(5,5482,5470,'Wirtschaftsgebäude',FALSE,5224),
(5,5483,5470,'Wohngrün',FALSE,5225),
(5,5060,NULL,'Sozialeinrichtung',FALSE,5226),
(5,5061,NULL,'Sparkasse',FALSE,5227),
(5,5062,NULL,'Spedition',FALSE,5228),
(5,5063,NULL,'Spielpavillon',FALSE,5229),
(5,5064,NULL,'Sporthalle',FALSE,5230),
(5,5065,NULL,'Sportlerheim',FALSE,5231),
(5,5066,NULL,'Sportplatz',FALSE,5232),
(5,5067,NULL,'Spritzenhaus',FALSE,5233),
(5,5490,5490,'Stadion',FALSE,5234),
(5,5491,5490,'Tribüne',FALSE,5235),
(5,5500,5500,'Stadt- und Siedlungsgrün',FALSE,5236),
(5,5501,5500,'Blockinnenhof',FALSE,5237),
(5,5502,5500,'Gebäudevorplatz',FALSE,5238),
(5,5503,5500,'Kirchplatz/Kirchpark',FALSE,5239),
(5,5504,5500,'Mietergarten',TRUE,5240),
(5,5505,5500,'Schmuckplatz',FALSE,5241),
(5,5506,5500,'Siedlungsgrün',FALSE,5242),
(5,5507,5500,'Spielplatz',FALSE,5243),
(5,5508,5500,'Stadtplatz',FALSE,5244),
(5,5509,5500,'Stadtwald',FALSE,5245),
(5,5510,5500,'Straßengrün',FALSE,5246),
(5,5511,5500,'Vorgarten',FALSE,5247),
(5,5512,5500,'Wohngrün',FALSE,5248),
(5,5068,NULL,'Stadtquartier',FALSE,5249),
(5,5069,NULL,'Technikum',FALSE,5250),
(5,5083,NULL,'Torhaus',FALSE,5251),
(5,5070,NULL,'Treppenanlage',FALSE,5252),
(5,5071,NULL,'Turnhalle',FALSE,5253),
(5,5072,NULL,'Verbrauchergenossenschaft',FALSE,5254),
(5,5073,NULL,'Versorgungszentrum',FALSE,5255),
(5,5520,5520,'Villa',FALSE,5256),
(5,5521,5520,'Direktorenvilla',FALSE,5257),
(5,5522,5520,'Fabrikantenvilla',FALSE,5258),
(5,5530,5530,'Villengarten/Landhausgarten',FALSE,5259),
(5,5531,5530,'Badegarten',FALSE,5260),
(5,5532,5530,'Blumengarten',FALSE,5261),
(5,5533,5530,'Gartenhof',FALSE,5262),
(5,5534,5530,'Gartenplatz',FALSE,5263),
(5,5535,5530,'Gemüsegarten',FALSE,5264),
(5,5536,5530,'Obstgarten',FALSE,5265),
(5,5537,5530,'Senkgarten',FALSE,5266),
(5,5538,5530,'Tennisplatz',FALSE,5267),
(5,5539,5530,'Vorgarten',FALSE,5268),
(5,5074,NULL,'Waisenhaus',FALSE,5269),
(5,5550,5550,'Wand- und Deckenbild',FALSE,5270),
(5,5551,5550,'Malerei',FALSE,5271),
(5,5552,5550,'Mosaik',FALSE,5272),
(5,5553,5550,'Sgraffito',FALSE,5273),
(5,5075,NULL,'Wasserelement',FALSE,5274),
(5,5560,5560,'Wegesystem',FALSE,5275),
(5,5561,5560,'Promenade',FALSE,5276),
(5,5562,5560,'Sitzplatz',FALSE,5277),
(5,5570,5570,'Werbung',FALSE,5278),
(5,5571,5570,'Leuchtwerbung',FALSE,5279),
(5,5076,NULL,'Wildgehege',FALSE,5280),
(5,5077,NULL,'Wochenendhaus',FALSE,5281),
(5,5078,NULL,'Wohn- und Bürogebäude',FALSE,5282),
(5,5079,NULL,'Wohn- und Geschäftshaus',FALSE,5283),
(5,5600,5600,'Wohnanlage',FALSE,5284),
(5,5601,5600,'Doppelwohnhaus',FALSE,5285),
(5,5602,5600,'Einfriedung',FALSE,5286),
(5,5603,5600,'Garage',FALSE,5287),
(5,5604,5600,'Heizhaus',FALSE,5288),
(5,5605,5600,'Mehrfamilienwohnhaus',FALSE,5289),
(5,5606,5600,'Reihenhaus',FALSE,5290),
(5,5607,5600,'Waschhaus',FALSE,5291),
(5,5608,5600,'Wirtschaftsgebäude',FALSE,5292),
(5,5609,5600,'Wohngrün',FALSE,5293),
(5,5080,NULL,'Wohnblock',FALSE,5294),
(5,5620,5620,'Wohnhaus',FALSE,5295),
(5,5621,5620,'Beamtenwohnhaus',FALSE,5296),
(5,5622,5620,'Blockstube',FALSE,5297),
(5,5623,5620,'Direktorenwohnhaus',FALSE,5298),
(5,5624,5620,'Doppelwohnhaus',FALSE,5299),
(5,5625,5620,'Einfamilienwohnhaus',FALSE,5300),
(5,5626,5620,'Fabrikantenwohnhaus',FALSE,5301),
(5,5627,5620,'Mehrfamilienwohnhaus',FALSE,5302),
(5,5628,5620,'Oberlaube',FALSE,5303),
(5,5629,5620,'Reihenhaus',FALSE,5304),
(5,5630,5620,'Vorlaube',FALSE,5305),
(5,5081,NULL,'Wohnturm',FALSE,5306),
(5,5082,NULL,'Zeltplatz',FALSE,5307),
(5,5650,5650,'Kirche',FALSE,5308),
--
(6,6100,6100,'Bodenrelief',FALSE,6000),
(6,6101,6100,'Stützmauer',FALSE,6001),
(6,6001,NULL,'Brauerei',FALSE,6002),
(6,6002,NULL,'Brennerei',FALSE,6003),
(6,6110,6110,'Chemisch-Pharmazeutische Industrie',FALSE,6004),
(6,6111,6110,'Technische Ausstattung',FALSE,6005),
(6,6120,6120,'Eisenhütte',FALSE,6006),
(6,6121,6120,'Dampfkessel',FALSE,6007),
(6,6122,6120,'Dampfturbine',FALSE,6008),
(6,6123,6120,'Einfriedung',FALSE,6009),
(6,6124,6120,'Gebläse',FALSE,6010),
(6,6125,6120,'Gebläsehaus',FALSE,6011),
(6,6126,6120,'Generator',FALSE,6012),
(6,6127,6120,'Halde',FALSE,6013),
(6,6128,6120,'Hängebahn',FALSE,6014),
(6,6129,6120,'Hochofen',FALSE,6015),
(6,6130,6120,'Hüttengebäude',FALSE,6016),
(6,6131,6120,'Kesselhaus',FALSE,6017),
(6,6132,6120,'Kontorhaus',FALSE,6018),
(6,6133,6120,'Maschinenhaus',TRUE,6019),
(6,6134,6120,'Ofenhaus/-gebäude',TRUE,6020),
(6,6135,6120,'Pförtnerhaus',TRUE,6021),
(6,6136,6120,'Röstanlage',TRUE,6022),
(6,6137,6120,'Schornstein',TRUE,6023),
(6,6138,6120,'Sozialgebäude',TRUE,6024),
(6,6139,6120,'Verwaltungsgebäude',TRUE,6025),
(6,6140,6120,'Wasserturbine',FALSE,6026),
(6,6150,6150,'Farbenfabrik',FALSE,6027),
(6,6151,6150,'Technische Ausstattung',FALSE,6028),
(6,6003,NULL,'Ferrolegierungswerk',FALSE,6029),
(6,6160,6160,'Gießerei',FALSE,6030),
(6,6161,6160,'Produktionsgebäude',FALSE,6031),
(6,6162,6160,'Verwaltungsgebäude',FALSE,6032),
(6,6170,6170,'Glashütte',FALSE,6033),
(6,6171,6170,'Schmelzofen',FALSE,6034),
(6,6172,6170,'Technische Ausstattung',FALSE,6035),
(6,6180,6180,'Kran',FALSE,6036),
(6,6181,6180,'Drehkran',FALSE,6037),
(6,6182,6180,'Laufkran',FALSE,6038),
(6,6183,6180,'Portalkran',FALSE,6039),
(6,6200,6200,'Maschinenbauindustrieanlage',FALSE,6040),
(6,6201,6200,'Dampfkessel',FALSE,6041),
(6,6202,6200,'Dampfturbine',FALSE,6042),
(6,6203,6200,'Einfriedung',FALSE,6043),
(6,6204,6200,'Fabrikgebäude',FALSE,6044),
(6,6205,6200,'Fabrikhalle',FALSE,6045),
(6,6206,6200,'Fahrzeugmaschinenbau',FALSE,6046),
(6,6207,6200,'Generator',FALSE,6047),
(6,6208,6200,'Kessel- und Maschinenhaus',FALSE,6048),
(6,6209,6200,'Kontorhaus',FALSE,6049),
(6,6210,6200,'Pförtnerhaus',FALSE,6050),
(6,6211,6200,'Schornstein',FALSE,6051),
(6,6212,6200,'Sozialgebäude',FALSE,6052),
(6,6213,6200,'Technische Ausstattung',FALSE,6053),
(6,6214,6200,'Textilmaschinenbau',FALSE,6054),
(6,6215,6200,'Verwaltungsgebäude',FALSE,6055),
(6,6004,NULL,'Mineralölanlage',FALSE,6056),
(6,6220,6220,'Papier- und Kartonagenfabrik',FALSE,6057),
(6,6221,6220,'Dampfkessel',FALSE,6058),
(6,6222,6220,'Dampfturbine',FALSE,6059),
(6,6223,6220,'Einfriedung',FALSE,6060),
(6,6224,6220,'Fabrikgebäude',FALSE,6061),
(6,6225,6220,'Generator',FALSE,6062),
(6,6226,6220,'Hebe- und Fördertechnik',FALSE,6063),
(6,6227,6220,'Imprägnieranlage',FALSE,6064),
(6,6228,6220,'Kessel- und Maschinenhaus',FALSE,6065),
(6,6229,6220,'Kontorhaus',FALSE,6066),
(6,6230,6220,'Pförtnerhaus',FALSE,6067),
(6,6231,6220,'Sägegatter',FALSE,6068),
(6,6232,6220,'Schornstein',FALSE,6069),
(6,6233,6220,'Sozialgebäude',FALSE,6070),
(6,6234,6220,'Späneturm',FALSE,6071),
(6,6235,6220,'Technische Ausstattung',FALSE,6072),
(6,6236,6220,'Trockenkammer',FALSE,6073),
(6,6237,6220,'Trockenschuppen',FALSE,6074),
(6,6238,6220,'Verwaltungsgebäude',FALSE,6075),
(6,6240,6240,'Schwermaschinenindustrie',FALSE,6076),
(6,6242,6240,'Dampfkessel',FALSE,6077),
(6,6243,6240,'Dampfturbine',FALSE,6078),
(6,6244,6240,'Fabrikgebäude',FALSE,6079),
(6,6245,6240,'Generator',TRUE,6080),
(6,6246,6240,'Kessel- und Maschinenhaus',TRUE,6081),
(6,6247,6240,'Kontorhaus',TRUE,6082),
(6,6248,6240,'Pförtnerhaus',TRUE,6083),
(6,6249,6240,'Schornstein',FALSE,6084),
(6,6250,6240,'Technische Ausstattung',TRUE,6085),
(6,6251,6240,'Verwaltungsgebäude',FALSE,6086),
(6,6005,NULL,'Stahlwerk',FALSE,6087),
(6,6260,6260,'Textilfabrik',FALSE,6088),
(6,6261,6260,'Appreturanstalten',FALSE,6089),
(6,6262,6260,'Bleiche',FALSE,6090),
(6,6263,6260,'Dampfkessel',FALSE,6091),
(6,6264,6260,'Dampfturbine',TRUE,6092),
(6,6265,6260,'Einfriedung',FALSE,6093),
(6,6266,6260,'Fabrikgebäude',TRUE,6094),
(6,6267,6260,'Faktorenhaus',FALSE,6095),
(6,6268,6260,'Färberei',FALSE,6096),
(6,6269,6260,'Generator',TRUE,6097),
(6,6270,6260,'Handschuhfabrik',TRUE,6098),
(6,6271,6260,'Kessel- und Maschinenhaus',FALSE,6099),
(6,6272,6260,'Kontorhaus',FALSE,6100),
(6,6273,6260,'Pförtnerhaus',TRUE,6101),
(6,6274,6260,'Remise',FALSE,6102),
(6,6275,6260,'Rahmenberg',FALSE,6103),
(6,6276,6260,'Schornstein',FALSE,6104),
(6,6277,6260,'Seilerei',FALSE,6105),
(6,6278,6260,'Spinnerei',FALSE,6106),
(6,6279,6260,'Stickerei',FALSE,6107),
(6,6280,6260,'Strickerei',TRUE,6108),
(6,6281,6260,'Strumpffabrik',FALSE,6109),
(6,6282,6260,'Technische Ausstattung',TRUE,6110),
(6,6283,6260,'Tuchfabrik',FALSE,6111),
(6,6284,6260,'Verwaltungsgebäude',TRUE,6112),
(6,6285,6260,'Weberei',TRUE,6113),
(6,6286,6260,'Wirkerei',TRUE,6114),
(6,6290,6290,'Walzwerk',FALSE,6115),
(6,6291,6290,'Produktionsgebäude',TRUE,6116),
(6,6292,6290,'Verwaltungsgebäude',FALSE,6117),
(6,6300,6300,'Werkstatt',FALSE,6118),
(6,6301,6300,'Schlosserei',FALSE,6119),
(6,6302,6300,'Technische Ausstattung',TRUE,6120),
(6,6310,6310,'Ziegelei',FALSE,6121),
(6,6311,6310,'Hebe- und Fördertechnik',TRUE,6122),
(6,6312,6310,'Ringbrandofen',FALSE,6123),
(6,6313,6310,'Schornstein',FALSE,6124),
(6,6314,6310,'Technische Ausstattung',FALSE,6125),
(6,6315,6310,'Tongrube',FALSE,6126),
(6,6316,6310,'Trockenschuppen',FALSE,6127),
(6,6317,6310,'Verwaltungsgebäude',FALSE,6128),
(6,6318,6310,'Ziegelbrennofen',FALSE,6129),
(6,6006,NULL,'Zuckerfabrik',FALSE,6130),
--
(7,7100,7100,'Altlastensanierung',FALSE,7001),
(7,7101,7100,'Abproduktenhalde',FALSE,7002),
(7,7102,7100,'Deponie',FALSE,7003),
(7,7001,NULL,'Anlegestelle',FALSE,7004),
(7,7110,7110,'Aussichtspunkt',FALSE,7005),
(7,7111,7110,'Aussichtsplatz',FALSE,7006),
(7,7112,7110,'Aussichtsturm',FALSE,7007),
(7,7002,NULL,'Bauausstellung',FALSE,7008),
(7,7003,NULL,'Bootshaus',FALSE,7009),
(7,7004,NULL,'Brücke',FALSE,7010),
(7,7005,NULL,'Forst',FALSE,7011),
(7,7120,7120,'Gartenbau',FALSE,7012),
(7,7121,7120,'Baumgarten / Obstanbau',FALSE,7013),
(7,7122,7120,'Baumschule',FALSE,7014),
(7,7123,7120,'Gärtnerei',FALSE,7015),
(7,7006,NULL,'Gartenschau',FALSE,7016),
(7,7007,NULL,'Gastwirtschaftsgarten',FALSE,7017),
(7,7130,7130,'Gehölz',FALSE,7018),
(7,7131,7130,'Allee',FALSE,7019),
(7,7132,7130,'Baumgruppe',FALSE,7020),
(7,7133,7130,'Baumpaar',FALSE,7021),
(7,7134,7130,'Baumraster',FALSE,7022),
(7,7135,7130,'Baumreihe',FALSE,7023),
(7,7136,7130,'Baumrondell',FALSE,7024),
(7,7137,7130,'Dorfeiche',FALSE,7025),
(7,7138,7130,'Dorflinde',FALSE,7026),
(7,7139,7130,'Formgehölz',FALSE,7027),
(7,7140,7130,'Gedenkbaum',FALSE,7028),
(7,7141,7130,'Hain',FALSE,7029),
(7,7142,7130,'Solitärbaum',FALSE,7030),
(7,7143,7130,'Tanzlinde',FALSE,7031),
(7,7144,7130,'Torbaum',FALSE,7032),
(7,7150,7150,'Geländerelief',FALSE,7033),
(7,7151,7150,'Bodenmodellierung',FALSE,7034),
(7,7152,7150,'Bruchfeld',FALSE,7035),
(7,7153,7150,'Damm',FALSE,7036),
(7,7154,7150,'Halde',FALSE,7037),
(7,7155,7150,'Insel',FALSE,7038),
(7,7156,7150,'Kippe',FALSE,7039),
(7,7157,7150,'Stützmauer',FALSE,7040),
(7,7158,7150,'Tagebaurestloch',FALSE,7041),
(7,7159,7150,'Terrassierung',FALSE,7042),
(7,7008,NULL,'Kleinbauwerk',FALSE,7043),
(7,7170,7170,'Kleingartenanlage',FALSE,7044),
(7,7171,7170,'Kleingarten',FALSE,7045),
(7,7172,7170,'Kleingartenlaube',FALSE,7046),
(7,7173,7170,'Vereinsplatz',FALSE,7047),
(7,7180,7180,'Landwirtschaft',FALSE,7048),
(7,7181,7180,'Ackerbau',FALSE,7049),
(7,7182,7180,'Energiepflanzen',FALSE,7050),
(7,7183,7180,'Weinberg',FALSE,7051),
(7,7184,7180,'Weingut',FALSE,7052),
(7,7009,NULL,'Naherholungsgebiet',FALSE,7053),
(7,7190,7190,'Parkanlage',FALSE,7054),
(7,7191,7190,'Fabrikpark',FALSE,7055),
(7,7192,7190,'Kulturpark',FALSE,7056),
(7,7193,7190,'Sondergarten',FALSE,7057),
(7,7194,7190,'Stadtpark',FALSE,7058),
(7,7195,7190,'Volkspark',FALSE,7059),
(7,7196,7190,'Waldpark',FALSE,7060),
(7,7010,NULL,'Renaturierung',FALSE,7061),
(7,7200,7200,'"Freizeitanlage (Spiel, Sport)"',FALSE,7062),
(7,7201,7200,'Badesee',FALSE,7063),
(7,7202,7200,'Rodelbahn',FALSE,7064),
(7,7203,7200,'Spielplatz',FALSE,7065),
(7,7204,7200,'Sportplatz',FALSE,7066),
(7,7205,7200,'Strandbad',FALSE,7067),
(7,7206,7200,'Wassersportanlage',FALSE,7068),
(7,7210,7210,'Straßen / Wege',FALSE,7069),
(7,7211,7210,'Dammweg',FALSE,7070),
(7,7212,7210,'Promenade',FALSE,7071),
(7,7213,7210,'Straßenverlegung',FALSE,7072),
(7,7214,7210,'Treppenanlage',FALSE,7073),
(7,7215,7210,'Wanderweg',FALSE,7074),
(7,7216,7210,'Zufahrt',FALSE,7075),
(7,7011,NULL,'Tagebaurestsee',FALSE,7076),
(7,7220,7220,'Tierpark/Wildpark',FALSE,7077),
(7,7221,7220,'Fasanerie',FALSE,7078),
(7,7222,7220,'Tiergehege',FALSE,7079),
(7,7223,7220,'Wildgehege',FALSE,7080),
(7,7230,7230,'Wasserbauliche Einrichtung',FALSE,7081),
(7,7231,7230,'Fischweg',FALSE,7082),
(7,7232,7230,'Flutrinne',FALSE,7083),
(7,7233,7230,'Gewässerverlegung',FALSE,7084),
(7,7234,7230,'Kanal',FALSE,7085),
(7,7235,7230,'Pegelhaus',FALSE,7086),
(7,7236,7230,'Quellenanlage',FALSE,7087),
(7,7237,7230,'Rückhaltebecken',FALSE,7088),
(7,7238,7230,'Schiffshebewerk',FALSE,7089),
(7,7239,7230,'Schleuse',FALSE,7090),
(7,7240,7230,'Speicherbecken',FALSE,7091),
(7,7241,7230,'Staudamm',FALSE,7092),
(7,7242,7230,'Staumauer',FALSE,7093),
(7,7243,7230,'Stausee',FALSE,7094),
(7,7244,7230,'Überlaufgraben',FALSE,7095),
(7,7245,7230,'Wassergraben',FALSE,7096),
(7,7246,7230,'Wasserreservoir',FALSE,7097),
(7,7247,7230,'Wehr',FALSE,7098),
--
(NULL,9999,NULL,'FREITEXT',TRUE,9999)
;

--------------------------------------------------------------------------------------------------------------------------------------
-- # def_erfasser 
--------------------------------------------------------------------------------------------------------------------------------------

DROP TABLE IF EXISTS laugis.def_erfasser;
CREATE TABLE IF NOT EXISTS laugis.def_erfasser
(
    id integer PRIMARY KEY generated always as identity,
    name text NOT NULL,
    sortierung integer,
    username text
);

INSERT INTO laugis.def_Erfasser (name, sortierung, username) VALUES 
    ('Louise Warnow', 1, 'lwarnow'),
    ('Franz Dietzmann', 2, 'fdietzmann'),
    ('Kirsten Krepelin', 3, 'kkrepelin'),
    ('Barbara Kuendiger', 4, 'bkuendiger'),
    ('Kaja Boelcke', 5, 'kteschner'),
    ('Stefan Krug', 6, 'skrug'),
    ('Tanja Trittel', 7, 'ttrittel')
;

--------------------------------------------------------------------------------------------------------------------------------------
-- # def_schutzstatus
--------------------------------------------------------------------------------------------------------------------------------------

DROP TABLE IF EXISTS laugis.def_schutzstatus;
CREATE TABLE IF NOT EXISTS laugis.def_schutzstatus
(
    id integer PRIMARY KEY generated always as identity,
    bezeichnung text NOT NULL,
    sortierung integer
);

INSERT INTO laugis.def_schutzstatus (bezeichnung, sortierung) VALUES 
    ('Kulturdenkmal', 1),
    ('Denkmalverdacht', 2)
;

--------------------------------------------------------------------------------------------------------------------------------------
-- # def_jahresschnitt
--------------------------------------------------------------------------------------------------------------------------------------

DROP TABLE IF EXISTS laugis.def_jahresschnitt;
CREATE TABLE IF NOT EXISTS laugis.def_jahresschnitt
(
    id integer PRIMARY KEY generated always as identity,
    bezeichnung text NOT NULL,
    sortierung integer
);

INSERT INTO laugis.def_jahresschnitt (bezeichnung, sortierung) VALUES 
    ('1936-1943', 1),
    ('1989', 2),
    ('2021', 3)
;

--------------------------------------------------------------------------------------------------------------------------------------
-- # def_nutzungsart
--------------------------------------------------------------------------------------------------------------------------------------

DROP TABLE IF EXISTS laugis.def_nutzungsart;
CREATE TABLE IF NOT EXISTS laugis.def_nutzungsart
(
    id integer PRIMARY KEY generated always as identity,
    bezeichnung text NOT NULL,
    sortierung integer
);

INSERT INTO laugis.def_nutzungsart (bezeichnung, sortierung) VALUES 
    ('Wasser', 1),
    ('Wald', 2),
    ('Naturschutzgebiet', 3), -- Schraffur
    ('Grünflächen', 4),
    ('Landwirtschaft', 5),
    ('Offene Flächen', 6),
    ('Industriegebiet', 7),
    ('Siedlungsfläche', 8),
    ('Verkehr', 9),
    ('Eisenbahn', 10),
    ('Erneuerbare Energien', 11) -- Schraffur
;

-- Erweiterung Nutzungsart um Hierarchisierung
ALTER TABLE IF EXISTS laugis.def_nutzungsart
    ADD COLUMN uebergeordnet smallint,
    ADD CONSTRAINT "fkey uebernutzungsart" FOREIGN KEY (uebergeordnet)
    REFERENCES laugis.def_nutzungsart (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION;

-- Alteinträge migrieren
-- Alteinträge sind stets übergeordnet
 UPDATE laugis.def_nutzungsart
    SET uebergeordnet = id;

INSERT INTO laugis.def_nutzungsart (bezeichnung, uebergeordnet) VALUES 
    ('Mischwald', 2),
    ('Laubwald', 2),
    ('Nadelwald', 2),
    ('Weidefläche', 4),
    ('Garten, Parkanlage', 4),
    ('Unland (Sümpfe, Moore)', 4),
    ('Baumschule', 5),
    ('Obtsanbau', 5),
    ('Weinbau', 5),
    ('Tagebau', 6)
;

-- Sortierung in def_nutzungsart anpassen
UPDATE laugis.def_nutzungsart
SET sortierung = 1
WHERE id = 1;

UPDATE laugis.def_nutzungsart
SET sortierung = 2
WHERE id = 2;

UPDATE laugis.def_nutzungsart
SET sortierung = 3
WHERE id = 12;

UPDATE laugis.def_nutzungsart
SET sortierung = 4
WHERE id = 13;

UPDATE laugis.def_nutzungsart
SET sortierung = 5
WHERE id = 14;

UPDATE laugis.def_nutzungsart
SET sortierung = 6
WHERE id = 4;

UPDATE laugis.def_nutzungsart
SET sortierung = 7
WHERE id = 15;

UPDATE laugis.def_nutzungsart
SET sortierung = 8
WHERE id = 16;

UPDATE laugis.def_nutzungsart
SET sortierung = 9
WHERE id = 17;

UPDATE laugis.def_nutzungsart
SET sortierung = 10
WHERE id = 5;

UPDATE laugis.def_nutzungsart
SET sortierung = 11
WHERE id = 18;

UPDATE laugis.def_nutzungsart
SET sortierung = 12
WHERE id = 19;

UPDATE laugis.def_nutzungsart
SET sortierung = 13
WHERE id = 20;

UPDATE laugis.def_nutzungsart
SET sortierung = 14
WHERE id = 6;

UPDATE laugis.def_nutzungsart
SET sortierung = 15
WHERE id = 21;

UPDATE laugis.def_nutzungsart
SET sortierung = 16
WHERE id = 7;

UPDATE laugis.def_nutzungsart
SET sortierung = 17
WHERE id = 8;

UPDATE laugis.def_nutzungsart
SET sortierung = 18
WHERE id = 9;

UPDATE laugis.def_nutzungsart
SET sortierung = 19
WHERE id = 10;

UPDATE laugis.def_nutzungsart
SET sortierung = 20
WHERE id = 11;

UPDATE laugis.def_nutzungsart
SET sortierung = 21
WHERE id = 3;

--------------------------------------------------------------------------------------------------------------------------------------
-- # def_datierung
--------------------------------------------------------------------------------------------------------------------------------------

-- # Beschreibt die Ereignisarten der Datierungen
DROP TABLE IF EXISTS laugis.def_datierung;
CREATE TABLE IF NOT EXISTS laugis.def_datierung
(
    id integer PRIMARY KEY generated always as identity,
    bezeichnung text NOT NULL,
    sortierung integer
);

INSERT INTO laugis.def_datierung (bezeichnung, sortierung) VALUES 
    ('Abbruch', 1),
    ('Abteufung', 2),
    ('Aufstellung', 3),
    ('Ausführung', 4),
    ('Baujahr', 5),
    ('Brand', 6),
    ('Entstehung', 7),
    ('Erbauung', 8),
    ('Errichtung', 9),
    ('Erweiterung', 10),
    ('Flutung', 11),
    ('Grundsteinlegung', 12),
    ('Gründung', 13),
    ('Neubau', 14),
    ('Ortsabbruch', 15),
    ('Planung', 16),
    ('Produktion', 17),
    ('Restaurierung', 18),
    ('Rückbau', 19),
    ('Sanierung', 20),
    ('Stilllegung', 21),
    ('Teilabbruch', 22),
    ('Teilrückbau', 23),
    ('Teilortsabbruch', 24),
    ('Translozierung', 25),
    ('Umbau', 26),
    ('Umsiedlung', 27),
    ('Veränderung', 28),
    ('Verfüllung', 29),
    ('Wiederaufbau', 30),
    ('FREITEXT', 999)
;

INSERT INTO laugis.def_datierung (bezeichnung, sortierung) VALUES 
('Aufschluss', 31),
('Abbau', 32),
('Entwässerung', 33);

UPDATE laugis.def_datierung
SET sortierung = 1
WHERE id = 33;

UPDATE laugis.def_datierung
SET sortierung = 2
WHERE id = 1;

UPDATE laugis.def_datierung
SET sortierung = 3
WHERE id = 2;

UPDATE laugis.def_datierung
SET sortierung = 4
WHERE id = 32;

UPDATE laugis.def_datierung
SET sortierung = 5
WHERE id = 3;

UPDATE laugis.def_datierung
SET sortierung = 6
WHERE id = 4;

UPDATE laugis.def_datierung
SET sortierung = 7
WHERE id = 5;

UPDATE laugis.def_datierung
SET sortierung = 8
WHERE id = 6;

UPDATE laugis.def_datierung
SET sortierung = 9
WHERE id = 7;

UPDATE laugis.def_datierung
SET sortierung = 10
WHERE id = 34;

UPDATE laugis.def_datierung
SET sortierung = 11
WHERE id = 8;

UPDATE laugis.def_datierung
SET sortierung = 12
WHERE id = 9;

UPDATE laugis.def_datierung
SET sortierung = 13
WHERE id = 10;

UPDATE laugis.def_datierung
SET sortierung = 14
WHERE id = 11;

UPDATE laugis.def_datierung
SET sortierung = 15
WHERE id = 12;

UPDATE laugis.def_datierung
SET sortierung = 16
WHERE id = 13;

UPDATE laugis.def_datierung
SET sortierung = 17
WHERE id = 14;

UPDATE laugis.def_datierung
SET sortierung = 18
WHERE id = 15;

UPDATE laugis.def_datierung
SET sortierung = 19
WHERE id = 16;

UPDATE laugis.def_datierung
SET sortierung = 20
WHERE id = 17;

UPDATE laugis.def_datierung
SET sortierung = 21
WHERE id = 18;

UPDATE laugis.def_datierung
SET sortierung = 22
WHERE id = 19;

UPDATE laugis.def_datierung
SET sortierung = 23
WHERE id = 20;

UPDATE laugis.def_datierung
SET sortierung = 24
WHERE id = 21;

UPDATE laugis.def_datierung
SET sortierung = 25
WHERE id = 22;

UPDATE laugis.def_datierung
SET sortierung = 26
WHERE id = 24;

UPDATE laugis.def_datierung
SET sortierung = 27
WHERE id = 23;

UPDATE laugis.def_datierung
SET sortierung = 28
WHERE id = 25;

UPDATE laugis.def_datierung
SET sortierung = 29
WHERE id = 26;

UPDATE laugis.def_datierung
SET sortierung = 30
WHERE id = 27;

UPDATE laugis.def_datierung
SET sortierung = 31
WHERE id = 28;

UPDATE laugis.def_datierung
SET sortierung = 32
WHERE id = 29;

UPDATE laugis.def_datierung
SET sortierung = 33
WHERE id = 30;

UPDATE laugis.def_datierung
SET sortierung = (sortierung*10);

UPDATE laugis.def_datierung
SET sortierung = 35
WHERE id = 35;

UPDATE laugis.def_datierung
SET sortierung = 205
WHERE id = 36;

--------------------------------------------------------------------------------------------------------------------------------------
-- # def_material
--------------------------------------------------------------------------------------------------------------------------------------

DROP TABLE IF EXISTS laugis.def_material;
CREATE TABLE IF NOT EXISTS laugis.def_material
(
    id integer PRIMARY KEY generated always as identity,
    bezeichnung text NOT NULL,
    sortierung integer
);

INSERT INTO laugis.def_material (bezeichnung, sortierung) VALUES 
('Aluminium', 1),
('Beton', 2),
('Betonziegel', 3),
('Bimsbeton', 4),
('Blei', 5),
('Bruchstein', 6),
('Edelstahl', 7),
('Findling', 8),
('Fliese', 9),
('GFK', 10),
('Glas', 11),
('Glasbaustein', 12),
('Glasfasergewebe', 13),
('Granit', 14),
('Gussbeton', 15),
('Gusseisen', 16),
('Gussstahl', 17),
('Hecke', 18),
('Hochdruckschichtpressstoffplatte', 19),
('Holz', 20),
('Kalksandstein', 21),
('Kalkstein', 22),
('Kalktuff', 23),
('Keramik', 24),
('Klinker', 25),
('Kunststein', 26),
('Kupfer', 27),
('Kupferblech', 28),
('Lehm', 29),
('Lehmstrohwickel', 30),
('Lehmziegel', 31),
('Leichtbeton', 32),
('Lesestein', 33),
('Marmor', 34),
('Muschelkalk', 35),
('Naturstein', 36),
('Porphyr', 37),
('Porzellan', 38),
('Raseneisenstein', 39),
('Sandstein', 40),
('Schiefer', 41),
('Schlackestein', 42),
('Schmiedeeisen', 43),
('Stahl', 44),
('Stahlbeton', 45),
('Stahlblech', 46), 
('Stahlplatte', 47),
('Stahlseil', 48),
('Stahlträger', 49),
('Stampfbeton', 50),
('Terrakotta', 51),
('Ton', 52),
('Travertin', 53),
('Wellblech', 54),
('Ziegel', 55),
('Zinkblech', 56),
('Zinkguss', 57),
('Putz', 58),
('Gehölze', 59),
('Stauden / Wechselflor', 60),
('Rasen / Wiese', 61),
('Asphalt', 62),
('Kies / Sand', 63),
('Wasser', 64),
('Bronze', 65),
('Feldstein', 66),
('FREITEXT', 999)
;

UPDATE laugis.def_material
SET sortierung = 1
WHERE id = 1;

UPDATE laugis.def_material
SET sortierung = 2
WHERE id = 62;

UPDATE laugis.def_material
SET sortierung = 3
WHERE id = 2;

UPDATE laugis.def_material
SET sortierung = 4
WHERE id = 3;

UPDATE laugis.def_material
SET sortierung = 5
WHERE id = 4;

UPDATE laugis.def_material
SET sortierung = 6
WHERE id = 5;

UPDATE laugis.def_material
SET sortierung = 7
WHERE id = 65;

UPDATE laugis.def_material
SET sortierung = 8
WHERE id = 6;

UPDATE laugis.def_material
SET sortierung = 9
WHERE id = 7;

UPDATE laugis.def_material
SET sortierung = 10
WHERE id = 66;

UPDATE laugis.def_material
SET sortierung = 11
WHERE id = 8;

UPDATE laugis.def_material
SET sortierung = 12
WHERE id = 9;

UPDATE laugis.def_material
SET sortierung = 999
WHERE id = 67;

UPDATE laugis.def_material
SET sortierung = 14
WHERE id = 59;

UPDATE laugis.def_material
SET sortierung = 15
WHERE id = 10;

UPDATE laugis.def_material
SET sortierung = 16
WHERE id = 11;

UPDATE laugis.def_material
SET sortierung = 17
WHERE id = 12;

UPDATE laugis.def_material
SET sortierung = 17
WHERE id = 13;

UPDATE laugis.def_material
SET sortierung = 18
WHERE id = 14;

UPDATE laugis.def_material
SET sortierung = 19
WHERE id = 15;

UPDATE laugis.def_material
SET sortierung = 20
WHERE id = 16;

UPDATE laugis.def_material
SET sortierung = 21
WHERE id = 17;

UPDATE laugis.def_material
SET sortierung = 22
WHERE id = 18;

UPDATE laugis.def_material
SET sortierung = 23
WHERE id = 19;

UPDATE laugis.def_material
SET sortierung = 24
WHERE id = 20;

UPDATE laugis.def_material
SET sortierung = 25
WHERE id = 21;

UPDATE laugis.def_material
SET sortierung = 26
WHERE id = 22;

UPDATE laugis.def_material
SET sortierung = 27
WHERE id = 23;

UPDATE laugis.def_material
SET sortierung = 28
WHERE id = 24;

UPDATE laugis.def_material
SET sortierung = 29
WHERE id = 63;

UPDATE laugis.def_material
SET sortierung = 30
WHERE id = 25;

UPDATE laugis.def_material
SET sortierung = 31
WHERE id = 26;

UPDATE laugis.def_material
SET sortierung = 32
WHERE id = 27;

UPDATE laugis.def_material
SET sortierung = 33
WHERE id = 28;

UPDATE laugis.def_material
SET sortierung = 34
WHERE id = 29;

UPDATE laugis.def_material
SET sortierung = 35
WHERE id = 30;

UPDATE laugis.def_material
SET sortierung = 36
WHERE id = 31;

UPDATE laugis.def_material
SET sortierung = 37
WHERE id = 32;

UPDATE laugis.def_material
SET sortierung = 38
WHERE id = 33;

UPDATE laugis.def_material
SET sortierung = 39
WHERE id = 34;

UPDATE laugis.def_material
SET sortierung = 40
WHERE id = 35;

UPDATE laugis.def_material
SET sortierung = 41
WHERE id = 36;

UPDATE laugis.def_material
SET sortierung = 42
WHERE id = 37;

UPDATE laugis.def_material
SET sortierung = 43
WHERE id = 38;

UPDATE laugis.def_material
SET sortierung = 44
WHERE id = 58;

UPDATE laugis.def_material
SET sortierung = 45
WHERE id = 39;

UPDATE laugis.def_material
SET sortierung = 46
WHERE id = 61;

UPDATE laugis.def_material
SET sortierung = 47
WHERE id = 40;

UPDATE laugis.def_material
SET sortierung = 48
WHERE id = 41;

UPDATE laugis.def_material
SET sortierung = 49
WHERE id = 42;

UPDATE laugis.def_material
SET sortierung = 50
WHERE id = 43;

UPDATE laugis.def_material
SET sortierung = 51
WHERE id = 44;

UPDATE laugis.def_material
SET sortierung = 52
WHERE id = 45;

UPDATE laugis.def_material
SET sortierung = 53
WHERE id = 46;

UPDATE laugis.def_material
SET sortierung = 54
WHERE id = 47;

UPDATE laugis.def_material
SET sortierung = 55
WHERE id = 48;

UPDATE laugis.def_material
SET sortierung = 56
WHERE id = 49;

UPDATE laugis.def_material
SET sortierung = 57
WHERE id = 50;

UPDATE laugis.def_material
SET sortierung = 58
WHERE id = 60;

UPDATE laugis.def_material
SET sortierung = 59
WHERE id = 51;

UPDATE laugis.def_material
SET sortierung = 60
WHERE id = 52;

UPDATE laugis.def_material
SET sortierung = 61
WHERE id = 53;

UPDATE laugis.def_material
SET sortierung = 62
WHERE id = 64;

UPDATE laugis.def_material
SET sortierung = 63
WHERE id = 54;

UPDATE laugis.def_material
SET sortierung = 64
WHERE id = 55;

UPDATE laugis.def_material
SET sortierung = 65
WHERE id = 56;

UPDATE laugis.def_material
SET sortierung = 66
WHERE id = 57;

--------------------------------------------------------------------------------------------------------------------------------------
-- # def_personen
--------------------------------------------------------------------------------------------------------------------------------------

DROP TABLE IF EXISTS laugis.def_personen;
CREATE TABLE IF NOT EXISTS laugis.def_personen
(
    id integer PRIMARY KEY generated always as identity,
    bezeichnung text NOT NULL,
    is_ausfuehrend bool,
    sortierung integer
);

INSERT INTO laugis.def_personen (bezeichnung, is_ausfuehrend, sortierung) VALUES 
('Architekt:in', false, 1),
('Architekturbüro', false, 2),
('Auftraggeber:in', false, 3),
('Ausführung', true, 4),
('Bauausführung', true, 5),
('Bauherr:in', false, 6),
('Hersteller', true, 7),
('Umbau', true, 8),
('Planung', false, 9),
('Projektpartner:in', false, 10),
('Bauleitung', false, 11),
('Baumeister:in', true, 12),
('Bauunternehmer:in', false, 13),
('Eigentümer:in', false, 14),   
('Betreiber:in', false, 15),
('Entwurf', false, 16),
('Projektleitung', false, 17),
('Unterstützer:in', false, 18),
('FREITEXT', null, 999)
;


UPDATE laugis.def_personen
SET sortierung = 1
WHERE id = 1;

UPDATE laugis.def_personen
SET sortierung = 2
WHERE id = 2;

UPDATE laugis.def_personen
SET sortierung = 3
WHERE id = 3;

UPDATE laugis.def_personen
SET sortierung = 4
WHERE id = 4;

UPDATE laugis.def_personen
SET sortierung = 5
WHERE id = 5;

UPDATE laugis.def_personen
SET sortierung = 6
WHERE id = 6;

UPDATE laugis.def_personen
SET sortierung = 7
WHERE id = 11;

UPDATE laugis.def_personen
SET sortierung = 8
WHERE id = 12;

UPDATE laugis.def_personen
SET sortierung = 9
WHERE id = 13;

UPDATE laugis.def_personen
SET sortierung = 10
WHERE id = 15;

UPDATE laugis.def_personen
SET sortierung = 11
WHERE id = 14;

UPDATE laugis.def_personen
SET sortierung = 12
WHERE id = 16;

UPDATE laugis.def_personen
SET sortierung = 13
WHERE id = 7;

UPDATE laugis.def_personen
SET sortierung = 14
WHERE id = 9;

UPDATE laugis.def_personen
SET sortierung = 15
WHERE id = 17;

UPDATE laugis.def_personen
SET sortierung = 16
WHERE id = 10;

UPDATE laugis.def_personen
SET sortierung = 17
WHERE id = 8;

UPDATE laugis.def_personen
SET sortierung = 18
WHERE id = 18;

--------------------------------------------------------------------------------------------------------------------------------------
-- # def_blickbeziehung
--------------------------------------------------------------------------------------------------------------------------------------

DROP TABLE IF EXISTS laugis.def_blickbeziehung;
CREATE TABLE IF NOT EXISTS laugis.def_blickbeziehung
(
    id integer PRIMARY KEY generated always as identity,
    bezeichnung text NOT NULL,
    sortierung integer
);

INSERT INTO laugis.def_blickbeziehung (bezeichnung, sortierung) VALUES 
    ('gerichtet', 1),
    ('ungerichtet', 2),
    ('undefiniert', 3)
;

--------------------------------------------------------------------------------------------------------------------------------------
-- # def_bearbeitung
--------------------------------------------------------------------------------------------------------------------------------------

DROP TABLE IF EXISTS laugis.def_bearbeitung;
CREATE TABLE IF NOT EXISTS laugis.def_bearbeitung
(
    id integer PRIMARY KEY generated always as identity,
    bezeichnung text NOT NULL,
    sortierung integer
);

INSERT INTO laugis.def_bearbeitung (bezeichnung, sortierung) VALUES 
    ('in Bearbeitung', 1),
    ('in Prüfung', 2),
    ('abgeschlossen', 3)
;

--------------------------------------------------------------------------------------------------------------------------------------
-- # def_dachform
--------------------------------------------------------------------------------------------------------------------------------------

DROP TABLE IF EXISTS laugis.def_dachform;
CREATE TABLE IF NOT EXISTS laugis.def_dachform
(
    id integer PRIMARY KEY generated always as identity,
    bezeichnung text NOT NULL,
    sortierung integer
);

INSERT INTO laugis.def_dachform (bezeichnung, sortierung) VALUES
('Berliner Dach', 1),
('Bogendach', 2),
('Faltdach', 3),
('Flachdach', 4),
('Fußwalm', 5),
('Giebelwalm', 6),
('Glockendach', 7),
('Halbkegeldach', 8),
('Halbwalmdach', 9),
('Kegeldach', 10),
('Kopfwalm', 11),
('Kreuzdach', 12),
('Krüppelwalmdach', 13),
('Kuppeldach', 14),
('Mansarddach', 15),
('Mansarddach mit Schopf', 16),
('Mansardgiebeldach', 17),
('Mansardwalmdach', 18),
('Pagodendach', 19),
('Pultdach', 20),
('Pyramidendach', 21),
('Satteldach', 22),
('Satteldach (geschweift)', 23),
('Schalendach', 24),
('Schleppdach', 25),
('Schmetterlingsdach', 26),
('Schopfwalm', 27),
('Schweifhaube', 28),
('Sheddach', 29),
('Terrassendach', 30),
('Tonnendach', 31),
('Walmdach', 32),
('Walmdach (geschweift)', 33),
('Wellendach', 34),
('Zeltdach', 35),
('FREITEXT', 999)
;

--------------------------------------------------------------------------------------------------------------------------------------
-- # def_konstruktion
--------------------------------------------------------------------------------------------------------------------------------------

DROP TABLE IF EXISTS laugis.def_konstruktion;
CREATE TABLE IF NOT EXISTS laugis.def_konstruktion
(
    id integer PRIMARY KEY generated always as identity,
    bezeichnung text NOT NULL,
    sortierung integer
);

INSERT INTO laugis.def_konstruktion (bezeichnung, sortierung) VALUES
('Binderkonstruktion', 1),
('Blockbauweise', 2),
('Blockbohlenbauweise', 3),
('Blockständerbauweise', 4),
('Fachwerk', 5),
('Fertigbauweise', 6),
('Gitterbinderkonstruktion', 7),
('Gitterträgerkonstruktion', 8),
('Großblockbauweise', 9),
('Hypar-Schalenkonstruktion', 10),
('Lehmstampfbauweise', 11),
('Massivbauweise', 12),
('Montagebauweise', 13),
('Plattenbauweise', 14),
('Plattenbauweise Typ P2', 15),
('Plattenbauweise Typ Q6', 16),
('Rahmenbauweise', 17),
('Rahmenbinderkonstruktion', 18),
('Schalenkonstruktion', 19),
('Schottenbauweise', 20),
('Skelettbauweise', 21),
('Spannbetonkonstruktion', 22),
('Stabknotenfachwerk', 23),
('Gleitbauweise', 24),
('Stahlfachwerk', 25),
('Lammellenkonstruktion', 26),
('Ständerbauweise', 27),
('Tafelbauweise', 28),
('Umgebinde', 29),
('Wandständerbauweise', 30),
('Ständerkonstruktion', 31),
('Gerüstbauweise', 32),
('Hohlkastenkonstruktion', 33),
('FREITEXT', 999)
;

UPDATE laugis.def_konstruktion
SET sortierung = (sortierung*10);

UPDATE laugis.def_konstruktion
SET sortierung = 85
WHERE id = 24;

UPDATE laugis.def_konstruktion
SET sortierung = 235
WHERE id = 31;

UPDATE laugis.def_konstruktion
SET sortierung = 65
WHERE id = 32;

UPDATE laugis.def_konstruktion
SET sortierung = 95
WHERE id = 33;

UPDATE laugis.def_konstruktion
SET sortierung = 105
WHERE id = 26;


--------------------------------------------------------------------------------------------------------------------------------------
-- # obj_basis
--------------------------------------------------------------------------------------------------------------------------------------

-- In der Tabelle obj_basis werden die Metadaten und Deskriptoren sämtlicher Objekte abgelegt.
-- Die explizite Beschreibung der einzelnen Objekte findet durch Erweiterungstabellen statt. 

DROP TABLE IF EXISTS laugis.obj_basis;
CREATE TABLE IF NOT EXISTS laugis.obj_basis
(     
    -- # Metadaten
    objekt_id integer PRIMARY KEY generated always as identity, -- PK
    objekt_nr integer UNIQUE,       -- 5000
    rel_objekt_nr integer,          -- fk
    status_bearbeitung smallint,    -- fk
    erfassungsdatum date,           -- 9580
    aenderungsdatum date,           -- 9950
    letzte_aenderung timestamp,     -- meta zur Filterung
    geloescht bool,                 -- meta zur Filterung
    -- erfasser -> rel

    -- # Deskriptoren
    kategorie smallint,             -- fk NOT NULL
    sachbegriff integer,            -- fk 5230
    sachbegriff_alt text,           -- 5230 (als Altdaten-temp sowie für Freitexte)
    beschreibung text,              -- 9980
    beschreibung_ergaenzung text,   -- 9980
    lagebeschreibung text,          -- 5125
    -- quellen_literatur -> rel     -- 8330
    notiz_intern text,              -- 9984 '9980 = Kommentar'
    hida_nr text,                   -- 5000
    -- datierung -> rel
    -- Person_werk -> rel   
    -- Soziet_werk -> rel
    -- Person_verantw -> rel
    -- Soziet_verantw -> rel
    -- bilder_extern -> rel
    -- bilder_intern -> rel
    bilder_anmerkung text,          -- temp zur Migration sowie als Anmerkungsfeld

        -- # Stammdaten
    bezeichnung text,               -- 9990
    bauwerksname_eigenname text,    -- 5202
    -- erhaltungszustand            -- fk 5210 -> wird als text an notiz_intern übergeben
    schutzstatus smallint,          -- fk
    foerderfaehig bool, 
    -- funktion -> rel

    -- # Lokalisatoren
    kreis text,                     -- 5098
    gemeinde text,                  -- 5100
    ort text,                       -- 5108
    sorbisch text,                  -- 5115
    strasse text,                   -- 5116
    hausnummer text,                -- 5117
    gem_flur text,                  -- 5120

-- Referenz zu übergeordneten Objekten
CONSTRAINT fkey_rel_objekt_nr FOREIGN KEY (rel_objekt_nr)
    REFERENCES laugis.obj_basis (objekt_nr) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION,

CONSTRAINT fkey_status_bearbeitung FOREIGN KEY (status_bearbeitung)
    REFERENCES laugis.def_bearbeitung (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION,

CONSTRAINT fkey_kategorie FOREIGN KEY (kategorie)
    REFERENCES laugis.def_kategorie (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION,

CONSTRAINT fkey_sachbegriff FOREIGN KEY (sachbegriff)
    REFERENCES laugis.def_sachbegriff (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION,

CONSTRAINT fkey_schutzstatus FOREIGN KEY (schutzstatus)
    REFERENCES laugis.def_schutzstatus (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
);

--------------------------------------------------------------------------------------------------------------------------------------
-- # obj_tech
--------------------------------------------------------------------------------------------------------------------------------------

-- In der Tabelle obj_tech werden die Architekturdaten von Einzelobjekten und Anlagen abgelegt.
-- Einzelobjekte und Anlagen bestehen aus zusammenhängenden Einträgen in obj_basis und obj_tech.

DROP TABLE IF EXISTS laugis.obj_tech;
CREATE TABLE IF NOT EXISTS laugis.obj_tech
(     
    -- # Metadaten
    tech_id integer PRIMARY KEY generated always as identity, -- PK
    ref_objekt_id integer,          -- fk NOT NULL
    techn_anlage bool,              -- Kennzeichen zur Auswahl der Deskriptoren

    -- # Deskriptoren allgemein
    -- material -> ref              -- 5280
    material_alt text,
    -- konstruktion_technik -> ref  -- 5300
    konstruktion_alt text,

    -- # Deskriptoren architektonisch
    geschosszahl smallint,          -- 5390
    achsenzahl smallint,            -- 5392
    -- grundriss -> ref             -- 5244
    grundriss text,
    -- dachform -> ref              -- 5910     
    dachform_alt text,
    
    -- # Deskriptoren technische Anlage
    antrieb text,                   -- 5930
    abmessung text,                 -- ?
    gewicht text,                   -- ?

-- Referenz zur übergeordneten Objekt-Base
CONSTRAINT fkey_objekt_id FOREIGN KEY (ref_objekt_id)
    REFERENCES laugis.obj_basis (objekt_id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
);

--------------------------------------------------------------------------------------------------------------------------------------
-- # geo_line
--------------------------------------------------------------------------------------------------------------------------------------

-- In dieser Tabelle werden Geometrien vom Typ 'Multiline' vorgehalten.
-- Über den fk_objekt_id wird die Geometrie einem Basis-Objekt zugeordnet 

DROP TABLE IF EXISTS laugis.geo_line;
CREATE TABLE IF NOT EXISTS laugis.geo_line
(     
    -- # Metadaten
    geo_id integer PRIMARY KEY generated always as identity, -- PK
    ref_objekt_id integer,          -- fk NOT NULL
    geom geometry(MultiLinestring, 25833),

-- Referenz zur übergeordneten Objekt-Base
CONSTRAINT fkey_objekt_id FOREIGN KEY (ref_objekt_id)
    REFERENCES laugis.obj_basis (objekt_id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
);

--------------------------------------------------------------------------------------------------------------------------------------
-- # geo_point
--------------------------------------------------------------------------------------------------------------------------------------

-- In dieser Tabelle werden Geometrien vom Typ 'Multipoint' vorgehalten.
-- Über den fk_objekt_id wird die Geometrie einem Basis-Objekt zugeordnet 

DROP TABLE IF EXISTS laugis.geo_point;
CREATE TABLE IF NOT EXISTS laugis.geo_point
(     
    -- # Metadaten
    geo_id integer PRIMARY KEY generated always as identity, -- PK
    ref_objekt_id integer,          -- fk NOT NULL
    geom geometry(MultiPoint, 25833),

-- Referenz zur übergeordneten Objekt-Base
CONSTRAINT fkey_objekt_id FOREIGN KEY (ref_objekt_id)
    REFERENCES laugis.obj_basis (objekt_id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
);

--------------------------------------------------------------------------------------------------------------------------------------
-- # geo_polygon
--------------------------------------------------------------------------------------------------------------------------------------

-- In dieser Tabelle werden Geometrien vom Typ 'Multipolygon' vorgehalten.
-- Über den fk_objekt_id wird die Geometrie einem Basis-Objekt zugeordnet 

DROP TABLE IF EXISTS laugis.geo_poly;
CREATE TABLE IF NOT EXISTS laugis.geo_poly
(     
    -- # Metadaten
    geo_id integer PRIMARY KEY generated always as identity, -- PK
    ref_objekt_id integer,          -- fk NOT NULL
    geom geometry(MultiPolygon, 25833),

-- Referenz zur übergeordneten Objekt-Base
CONSTRAINT fkey_objekt_id FOREIGN KEY (ref_objekt_id)
    REFERENCES laugis.obj_basis (objekt_id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
);

--------------------------------------------------------------------------------------------------------------------------------------
-- # rel_bilder
--------------------------------------------------------------------------------------------------------------------------------------

DROP TABLE IF EXISTS laugis.rel_bilder;
CREATE TABLE IF NOT EXISTS laugis.rel_bilder
(     
    relation_id integer PRIMARY KEY generated always as identity, -- PK
    ref_objekt_id integer,          -- fk NOT NULL
    dateiname text,                 -- Dateiname incl. Endung
    intern bool,                    -- Kennzeichen 'nicht zur Veröffentlichung'

-- Referenz zur übergeordneten Objekt-Base
CONSTRAINT fkey_objekt_id FOREIGN KEY (ref_objekt_id)
    REFERENCES laugis.obj_basis (objekt_id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
);

--------------------------------------------------------------------------------------------------------------------------------------
-- # rel_blickbeziehung
--------------------------------------------------------------------------------------------------------------------------------------

-- In dieser Tabelle werden die Relationen zwischen obj_basis und def_blick vorgehalten. 

DROP TABLE IF EXISTS laugis.rel_blickbeziehung;
CREATE TABLE IF NOT EXISTS laugis.rel_blickbeziehung
(     
    relation_id integer PRIMARY KEY generated always as identity, -- PK
    ref_objekt_id integer,          -- fk NOT NULL
    beschreibung text,              -- Beschreibung der Blickbeziehung
    rel_objekt_nr integer,          -- Referenz auf ObjektNr
    ref_blick_id integer,           -- fk NOT NULL, Blickart

-- Referenz zur übergeordneten Objekt-Base
CONSTRAINT fkey_objekt_id FOREIGN KEY (ref_objekt_id)
    REFERENCES laugis.obj_basis (objekt_id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION,

-- Referenz zur ziel Objekt-Base
CONSTRAINT fkey_rel_objekt_nr FOREIGN KEY (rel_objekt_nr)
    REFERENCES laugis.obj_basis (objekt_nr) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION,

-- Referenz zur erfasser-Tabelle
CONSTRAINT fkey_blick_id FOREIGN KEY (ref_blick_id)
    REFERENCES laugis.def_blickbeziehung (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
);

--------------------------------------------------------------------------------------------------------------------------------------
-- # rel_dachform
--------------------------------------------------------------------------------------------------------------------------------------

-- In dieser Tabelle werden die Relationen zwischen obj_basis und def_dachform vorgehalten. 

DROP TABLE IF EXISTS laugis.rel_dachform;
CREATE TABLE IF NOT EXISTS laugis.rel_dachform
(     
    relation_id integer PRIMARY KEY generated always as identity, -- PK
    ref_objekt_id integer,          -- fk NOT NULL
    ref_dachform_id integer,        -- fk NOT NULL

-- Referenz zur übergeordneten Objekt-Base
CONSTRAINT fkey_objekt_id FOREIGN KEY (ref_objekt_id)
    REFERENCES laugis.obj_basis (objekt_id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION,

-- Referenz zur erfasser-Tabelle
CONSTRAINT fkey_dachform_id FOREIGN KEY (ref_dachform_id)
    REFERENCES laugis.def_dachform (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
);

--------------------------------------------------------------------------------------------------------------------------------------
-- # rel_datierung
--------------------------------------------------------------------------------------------------------------------------------------

-- In dieser Tabelle werden die Relationen zwischen obj_basis und def_datierung vorgehalten. 

DROP TABLE IF EXISTS laugis.rel_datierung;
CREATE TABLE IF NOT EXISTS laugis.rel_datierung
(     
    relation_id integer PRIMARY KEY generated always as identity, -- PK
    ref_objekt_id integer,          -- fk NOT NULL
    datierung text,                 -- formatierte Datumsangabe
    ref_ereignis_id integer,       -- fk NOT NULL, Datierungsart
    alt_ereignis text,             -- alternative Datierungsart

-- Referenz zur übergeordneten Objekt-Base
CONSTRAINT fkey_objekt_id FOREIGN KEY (ref_objekt_id)
    REFERENCES laugis.obj_basis (objekt_id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION,

-- Referenz zur erfasser-Tabelle
CONSTRAINT fkey_datierung_id FOREIGN KEY (ref_ereignis_id)
    REFERENCES laugis.def_datierung (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
);

--------------------------------------------------------------------------------------------------------------------------------------
-- # rel_erfasser
--------------------------------------------------------------------------------------------------------------------------------------

-- In dieser Tabelle werden die Relationen zwischen obj_basis und def_erfasser vorgehalten. 

DROP TABLE IF EXISTS laugis.rel_erfasser;
CREATE TABLE IF NOT EXISTS laugis.rel_erfasser
(     
    relation_id integer PRIMARY KEY generated always as identity, -- PK
    ref_objekt_id integer,          -- fk NOT NULL
    ref_erfasser_id integer,        -- fk NOT NULL
    is_creator bool,                -- Urheberkennzeichen

-- Referenz zur übergeordneten Objekt-Base
CONSTRAINT fkey_objekt_id FOREIGN KEY (ref_objekt_id)
    REFERENCES laugis.obj_basis (objekt_id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION,

-- Referenz zur erfasser-Tabelle
CONSTRAINT fkey_erfasser_id FOREIGN KEY (ref_erfasser_id)
    REFERENCES laugis.def_erfasser (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
);

--------------------------------------------------------------------------------------------------------------------------------------
-- # rel_konstruktion
--------------------------------------------------------------------------------------------------------------------------------------

-- In dieser Tabelle werden die Relationen zwischen obj_basis und def_dachform vorgehalten. 

DROP TABLE IF EXISTS laugis.rel_konstruktion;
CREATE TABLE IF NOT EXISTS laugis.rel_konstruktion
(     
    relation_id integer PRIMARY KEY generated always as identity, -- PK
    ref_objekt_id integer,          -- fk NOT NULL
    ref_konstruktion_id integer,        -- fk NOT NULL

-- Referenz zur übergeordneten Objekt-Base
CONSTRAINT fkey_objekt_id FOREIGN KEY (ref_objekt_id)
    REFERENCES laugis.obj_basis (objekt_id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION,

-- Referenz zur erfasser-Tabelle
CONSTRAINT fkey_dachform_id FOREIGN KEY (ref_konstruktion_id)
    REFERENCES laugis.def_konstruktion (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
);

--------------------------------------------------------------------------------------------------------------------------------------
-- # rel_literatur
--------------------------------------------------------------------------------------------------------------------------------------

DROP TABLE IF EXISTS laugis.rel_literatur;
CREATE TABLE IF NOT EXISTS laugis.rel_literatur
(     
    relation_id integer PRIMARY KEY generated always as identity, -- PK
    ref_objekt_id integer,          -- fk NOT NULL
    literatur text,                 -- Freitext Nutzungsart
    lib_ref text,                   -- Referenz zur Literaturverwaltung

-- Referenz zur übergeordneten Objekt-Base
CONSTRAINT fkey_objekt_id FOREIGN KEY (ref_objekt_id)
    REFERENCES laugis.obj_basis (objekt_id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
);

--------------------------------------------------------------------------------------------------------------------------------------
-- # rel_material
--------------------------------------------------------------------------------------------------------------------------------------

-- In dieser Tabelle werden die Relationen zwischen obj_basis und def_erfasser vorgehalten. 

DROP TABLE IF EXISTS laugis.rel_material;
CREATE TABLE IF NOT EXISTS laugis.rel_material
(     
    relation_id integer PRIMARY KEY generated always as identity, -- PK
    ref_objekt_id integer,          -- fk NOT NULL
    ref_material_id integer,        -- fk NOT NULL


-- Referenz zur übergeordneten Objekt-Base
CONSTRAINT fkey_objekt_id FOREIGN KEY (ref_objekt_id)
    REFERENCES laugis.obj_basis (objekt_id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION,

-- Referenz zur erfasser-Tabelle
CONSTRAINT fkey_material_id FOREIGN KEY (ref_material_id)
    REFERENCES laugis.def_material (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
);

--------------------------------------------------------------------------------------------------------------------------------------
-- # rel_nutzung
--------------------------------------------------------------------------------------------------------------------------------------

DROP TABLE IF EXISTS laugis.rel_nutzung;
CREATE TABLE IF NOT EXISTS laugis.rel_nutzung
(     
    relation_id integer PRIMARY KEY generated always as identity, -- PK
    ref_objekt_id integer,          -- fk NOT NULL
    nutzungsart text,               -- Freitext Nutzungsart
    datierung text,                 -- formatierte Datumsangabe

-- Referenz zur übergeordneten Objekt-Base
CONSTRAINT fkey_objekt_id FOREIGN KEY (ref_objekt_id)
    REFERENCES laugis.obj_basis (objekt_id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
);

--------------------------------------------------------------------------------------------------------------------------------------
-- # rel_personen
--------------------------------------------------------------------------------------------------------------------------------------

-- In dieser Tabelle werden die Relationen zwischen obj_basis und def_personen vorgehalten. 

DROP TABLE IF EXISTS laugis.rel_personen;
CREATE TABLE IF NOT EXISTS laugis.rel_personen
(     
    relation_id integer PRIMARY KEY generated always as identity, -- PK
    ref_objekt_id integer,          -- fk NOT NULL
    bezeichnung text,               -- Name oder Firma
    ref_funktion_id integer,        -- fk NOT NULL, Funktionsbeschreibung
    alt_funktion text,              -- alternative Funktionsbeschreibung
    is_sozietaet bool,               -- Kennzeichen: natürliche person / sozietät

-- Referenz zur übergeordneten Objekt-Base
CONSTRAINT fkey_objekt_id FOREIGN KEY (ref_objekt_id)
    REFERENCES laugis.obj_basis (objekt_id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION,

-- Referenz zur erfasser-Tabelle
CONSTRAINT fkey_datierung_id FOREIGN KEY (ref_funktion_id)
    REFERENCES laugis.def_personen (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
);

--------------------------------------------------------------------------------------------------------------------------------------
-- # obj_lwk
--------------------------------------------------------------------------------------------------------------------------------------

-- Bildet die Landschaftswandel-Objekte ab.
-- Wird analog zur obj_basis mit geo-Objekten verknüpft.

DROP TABLE IF EXISTS laugis.obj_lwk;
CREATE TABLE IF NOT EXISTS laugis.obj_lwk
(   
    -- # Metadaten
    objekt_id integer PRIMARY KEY generated always as identity, -- PK
    erfassungsdatum date,           -- 9580
    aenderungsdatum date,           -- 9950
    letzte_aenderung timestamp,     -- meta zur Filterung
    geloescht bool,                 -- meta zur Filterung
    erfassung smallint,

    -- Identifikatoren
    beschriftung text,              -- Bezeichnung und Identifikation
    jahresschnitt smallint,
    nutzungsart smallint,
    
    -- geo -> rel

    CONSTRAINT fkey_erfassung FOREIGN KEY (erfassung)
    REFERENCES laugis.def_erfasser (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION,

    CONSTRAINT fkey_jahresschnitt FOREIGN KEY (jahresschnitt)
    REFERENCES laugis.def_jahresschnitt (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION,

    CONSTRAINT fkey_nutzungsart FOREIGN KEY (nutzungsart)
    REFERENCES laugis.def_nutzungsart (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
);

--------------------------------------------------------------------------------------------------------------------------------------
-- # geo_lwk_line
--------------------------------------------------------------------------------------------------------------------------------------

-- In dieser Tabelle werden Geometrien vom Typ 'Multiline' vorgehalten.
-- Über den fk_objekt_id wird die Geometrie einem lwk-Objekt zugeordnet 

DROP TABLE IF EXISTS laugis.geo_lwk_line;
CREATE TABLE IF NOT EXISTS laugis.geo_lwk_line
(     
    -- # Metadaten
    geo_id integer PRIMARY KEY generated always as identity, -- PK
    ref_objekt_id integer,          -- fk NOT NULL
    geom geometry(MultiLinestring, 25833),

-- Referenz zur übergeordneten Objekt-Base
CONSTRAINT fkey_objekt_id FOREIGN KEY (ref_objekt_id)
    REFERENCES laugis.obj_lwk (objekt_id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
);


--------------------------------------------------------------------------------------------------------------------------------------
-- # geo_lwk_poly
--------------------------------------------------------------------------------------------------------------------------------------

-- In dieser Tabelle werden Geometrien vom Typ 'Multipolygon' vorgehalten.
-- Über den fk_objekt_id wird die Geometrie einem LWK-Objekt zugeordnet 

DROP TABLE IF EXISTS laugis.geo_lwk_poly;
CREATE TABLE IF NOT EXISTS laugis.geo_lwk_poly
(     
    -- # Metadaten
    geo_id integer PRIMARY KEY generated always as identity, -- PK
    ref_objekt_id integer,          -- fk NOT NULL
    geom geometry(MultiPolygon, 25833),

-- Referenz zur übergeordneten Objekt-Base
CONSTRAINT fkey_objekt_id FOREIGN KEY (ref_objekt_id)
    REFERENCES laugis.obj_lwk (objekt_id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
);

-- obj_lwk um neue Referenz-Spalte erweitern
ALTER TABLE IF EXISTS laugis.obj_lwk
    ADD COLUMN grundlage smallint,
    ADD CONSTRAINT fkey_grundlage FOREIGN KEY (grundlage)
    REFERENCES laugis.rel_grundlage (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    ;

-- Altdaten migrieren
UPDATE laugis.obj_lwk
    SET grundlage = jahresschnitt
    ;

-- obj_lwk anpassen
ALTER TABLE IF EXISTS laugis.obj_lwk DROP CONSTRAINT IF EXISTS fkey_jahresschnitt;
ALTER TABLE IF EXISTS laugis.obj_lwk DROP COLUMN IF EXISTS jahresschnitt
;






























--------------------------------------------------------------------------------------------------------------------------------------
-- # LAUGIS FUNCTION
--------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------
-- # check_sachbegriff_anlage
--------------------------------------------------------------------------------------------------------------------------------------

-- Prueft uebergeordente Sachbegriffe auf untergeordnete Anlagen-Sachbegriffe

CREATE OR REPLACE FUNCTION laugis.check_sachbegriff_anlage(
    _sachbegriff_id integer,
    _ref_sachbegriff_id integer
    )
RETURNS bool AS $$

BEGIN 

---------------------------------------------------------------------------------------------------------------
-- erweiterte Sachbegriffe abfangen -> folgender Prozess behandelt ausschließlich uebergeordnete Sachbegriffe
---------------------------------------------------------------------------------------------------------------

    IF (_sachbegriff_id != _ref_sachbegriff_id) THEN
        RETURN FALSE;
    END IF;

---------------------------------------------------------------------------------------------------------------
-- untergeordnete Sachbegriffe ermitteln
---------------------------------------------------------------------------------------------------------------

    IF TRUE IN (SELECT sb.show_anlage
        FROM laugis.def_sachbegriff AS sb 
        WHERE sb.ref_sachbegriff_id = _sachbegriff_id) THEN
        RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;

END;
$$ LANGUAGE plpgsql;

--------------------------------------------------------------------------------------------------------------------------------------
-- # delete_objekt
--------------------------------------------------------------------------------------------------------------------------------------

-- Setzt das Flag 'geloescht' auf true

CREATE OR REPLACE FUNCTION laugis.delete_objekt(_objekt_id integer)
RETURNS VOID
AS $$
BEGIN
  UPDATE laugis.obj_basis
  SET geloescht = TRUE
  WHERE objekt_id = _objekt_id;
END;
$$ LANGUAGE plpgsql;

--------------------------------------------------------------------------------------------------------------------------------------
-- # remove_bilder
--------------------------------------------------------------------------------------------------------------------------------------

-- löscht einen Relations-Eintrag

CREATE OR REPLACE FUNCTION laugis.remove_bilder(_rel_id integer)
RETURNS VOID
AS $$

BEGIN
  DELETE FROM laugis.rel_bilder
  WHERE relation_id = _rel_id;
END;
$$ LANGUAGE plpgsql;

--------------------------------------------------------------------------------------------------------------------------------------
-- # remove_blickbeziehung
--------------------------------------------------------------------------------------------------------------------------------------

-- löscht einen Relations-Eintrag

CREATE OR REPLACE FUNCTION laugis.remove_blickbeziehung(_rel_id integer)
RETURNS VOID
AS $$

BEGIN
  DELETE FROM laugis.rel_blickbeziehung
  WHERE relation_id = _rel_id;
END;
$$ LANGUAGE plpgsql;

--------------------------------------------------------------------------------------------------------------------------------------
-- # remove_dachform
--------------------------------------------------------------------------------------------------------------------------------------

-- löscht einen Relations-Eintrag

CREATE OR REPLACE FUNCTION laugis.remove_dachform(_rel_id integer)
RETURNS VOID
AS $$

BEGIN
  DELETE FROM laugis.rel_dachform
  WHERE relation_id = _rel_id;
END;
$$ LANGUAGE plpgsql;

--------------------------------------------------------------------------------------------------------------------------------------
-- # remove_datierung
--------------------------------------------------------------------------------------------------------------------------------------

-- löscht einen Relations-Eintrag

CREATE OR REPLACE FUNCTION laugis.remove_datierung(_rel_id integer)
RETURNS VOID
AS $$

BEGIN
  DELETE FROM laugis.rel_datierung
  WHERE relation_id = _rel_id;
END;
$$ LANGUAGE plpgsql;

--------------------------------------------------------------------------------------------------------------------------------------
-- # remove_erfasser
--------------------------------------------------------------------------------------------------------------------------------------

-- löscht einen Relations-Eintrag

CREATE OR REPLACE FUNCTION laugis.remove_erfasser(_rel_id integer)
RETURNS VOID
AS $$

BEGIN
  DELETE FROM laugis.rel_erfasser
  WHERE relation_id = _rel_id;
END;
$$ LANGUAGE plpgsql;

--------------------------------------------------------------------------------------------------------------------------------------
-- # remove_konstruktion
--------------------------------------------------------------------------------------------------------------------------------------

-- löscht einen Relations-Eintrag

CREATE OR REPLACE FUNCTION laugis.remove_konstruktion(_rel_id integer)
RETURNS VOID
AS $$

BEGIN
  DELETE FROM laugis.rel_konstruktion
  WHERE relation_id = _rel_id;
END;
$$ LANGUAGE plpgsql;

--------------------------------------------------------------------------------------------------------------------------------------
-- # remove_literatur
--------------------------------------------------------------------------------------------------------------------------------------

-- löscht einen Relations-Eintrag

CREATE OR REPLACE FUNCTION laugis.remove_literatur(_rel_id integer)
RETURNS VOID
AS $$

BEGIN
  DELETE FROM laugis.rel_literatur
  WHERE relation_id = _rel_id;
END;
$$ LANGUAGE plpgsql;

--------------------------------------------------------------------------------------------------------------------------------------
-- # remove_material
--------------------------------------------------------------------------------------------------------------------------------------

-- löscht einen Relations-Eintrag

CREATE OR REPLACE FUNCTION laugis.remove_material(_rel_id integer)
RETURNS VOID
AS $$

BEGIN
  DELETE FROM laugis.rel_material
  WHERE relation_id = _rel_id;
END;
$$ LANGUAGE plpgsql;

--------------------------------------------------------------------------------------------------------------------------------------
-- # remove_nutzung
--------------------------------------------------------------------------------------------------------------------------------------

-- löscht einen Relations-Eintrag

CREATE OR REPLACE FUNCTION laugis.remove_nutzung(_rel_id integer)
RETURNS VOID
AS $$

BEGIN
  DELETE FROM laugis.rel_nutzung
  WHERE relation_id = _rel_id;
END;
$$ LANGUAGE plpgsql;

--------------------------------------------------------------------------------------------------------------------------------------
-- # remove_personen
--------------------------------------------------------------------------------------------------------------------------------------

-- löscht einen Relations-Eintrag

CREATE OR REPLACE FUNCTION laugis.remove_personen(_rel_id integer)
RETURNS VOID
AS $$

BEGIN
  DELETE FROM laugis.rel_personen
  WHERE relation_id = _rel_id;
END;
$$ LANGUAGE plpgsql;

--------------------------------------------------------------------------------------------------------------------------------------
-- # return_bilder
--------------------------------------------------------------------------------------------------------------------------------------

-- Gibt für ein Objekt die Fotoliste rel_fotos als JSON(text) zurück
-- Format: [{relation_id, objekt_id, dateiname, intern, titelbild}]

CREATE OR REPLACE FUNCTION laugis.return_bilder(
  _objekt_id integer              -- pk
  ) 
RETURNS text AS $$

DECLARE 
  _ar text;
BEGIN

SELECT (json_agg(row_to_json(rel))) AS row_value
    FROM laugis.obj_basis AS obb
        JOIN laugis.rel_bilder AS rel ON rel.ref_objekt_id = obb.objekt_id
        WHERE obb.objekt_id = _objekt_id
INTO _ar;

RETURN _ar;

END;
$$ LANGUAGE plpgsql;

--------------------------------------------------------------------------------------------------------------------------------------
-- # return_blickbeziehung
--------------------------------------------------------------------------------------------------------------------------------------

-- Gibt für ein Objekt die Blickbeziehungen rel_datierung als JSON(text) zurück
-- Format: [{relation_id, objekt_id, beschreibung, rel_objekt_nr, ref_blick_id}]

CREATE OR REPLACE FUNCTION laugis.return_blickbeziehung(
  _objekt_id integer              -- pk
  ) 
RETURNS text AS $$

DECLARE 
  _ar text;
BEGIN

SELECT (json_agg(row_to_json(rel))) AS row_value
    FROM laugis.obj_basis AS obb
        JOIN laugis.rel_blickbeziehung AS rel ON rel.ref_objekt_id = obb.objekt_id
        WHERE obb.objekt_id = _objekt_id
INTO _ar;

RETURN _ar;

END;
$$ LANGUAGE plpgsql;

--------------------------------------------------------------------------------------------------------------------------------------
-- # return_dachform
--------------------------------------------------------------------------------------------------------------------------------------

-- Gibt für ein Objekt die Erfasserliste rel_dachform als JSON(text) zurück
-- Format: [{rel_id, obj_id, dachform_id, dachform_alt}]

CREATE OR REPLACE FUNCTION laugis.return_dachform(
  _objekt_id integer              -- pk
  ) 
RETURNS text AS $$

DECLARE 
  _ar text;
BEGIN

SELECT (json_agg(row_to_json(rel))) AS row_value
    FROM laugis.obj_basis AS obb
        JOIN laugis.rel_dachform AS rel ON rel.ref_objekt_id = obb.objekt_id
        JOIN laugis.def_dachform AS def ON rel.ref_dachform_id = def.id
        WHERE obb.objekt_id = _objekt_id
        --ORDER By def.sortierung
INTO _ar;

RETURN _ar;

END;
$$ LANGUAGE plpgsql;

--------------------------------------------------------------------------------------------------------------------------------------
-- # return_datierung
--------------------------------------------------------------------------------------------------------------------------------------

-- Gibt für ein Objekt die Datierungsliste rel_datierung als JSON(text) zurück
-- Format: [{relation_id, objekt_id, datierung, ref_ereignis_id, alt_ereignis}]

CREATE OR REPLACE FUNCTION laugis.return_datierung(
  _objekt_id integer              -- pk
  ) 
RETURNS text AS $$

DECLARE 
  _ar text;
BEGIN

SELECT (json_agg(row_to_json(rel) ORDER BY LEFT(NULLIF(regexp_replace(rel.datierung, '\D','','g'), ''), 4))) AS row_value
    FROM laugis.obj_basis AS obb
        JOIN laugis.rel_datierung AS rel ON rel.ref_objekt_id = obb.objekt_id
        JOIN laugis.def_datierung AS def ON rel.ref_ereignis_id = def.id
        WHERE obb.objekt_id = _objekt_id
INTO _ar;

RETURN _ar;

END;
$$ LANGUAGE plpgsql;

--------------------------------------------------------------------------------------------------------------------------------------
-- # return_erfasser
--------------------------------------------------------------------------------------------------------------------------------------

-- Gibt für ein Objekt die Erfasserliste rel_erfasser als JSON(text) zurück
-- Format: [{rel_id, obj_id, erf_id, is_erfasser}]

CREATE OR REPLACE FUNCTION laugis.return_erfasser(
  _objekt_id integer              -- pk
  ) 
RETURNS text AS $$

DECLARE 
  _ar text;
BEGIN

SELECT (json_agg(row_to_json(rel))) AS row_value
    FROM laugis.obj_basis AS obb
        JOIN laugis.rel_erfasser AS rel ON rel.ref_objekt_id = obb.objekt_id
        JOIN laugis.def_erfasser AS def ON rel.ref_erfasser_id = def.id
        WHERE obb.objekt_id = _objekt_id
INTO _ar;

RETURN _ar;

END;
$$ LANGUAGE plpgsql;

--------------------------------------------------------------------------------------------------------------------------------------
-- # return_konstruktion
--------------------------------------------------------------------------------------------------------------------------------------

-- Gibt für ein Objekt die Erfasserliste rel_konstruktion als JSON(text) zurück
-- Format: [{rel_id, obj_id, dachform_id, dachform_alt}]

CREATE OR REPLACE FUNCTION laugis.return_konstruktion(
  _objekt_id integer              -- pk
  ) 
RETURNS text AS $$

DECLARE 
  _ar text;
BEGIN

SELECT (json_agg(row_to_json(rel))) AS row_value
    FROM laugis.obj_basis AS obb
        JOIN laugis.rel_konstruktion AS rel ON rel.ref_objekt_id = obb.objekt_id
        JOIN laugis.def_konstruktion AS def ON rel.ref_konstruktion_id = def.id
        WHERE obb.objekt_id = _objekt_id
        --ORDER By def.sortierung
INTO _ar;

RETURN _ar;

END;
$$ LANGUAGE plpgsql;

--------------------------------------------------------------------------------------------------------------------------------------
-- # return_literatur
--------------------------------------------------------------------------------------------------------------------------------------

-- Gibt für ein Objekt die Literaturliste als JSON(text) zurück
-- Format: [{relation_id, objekt_id, literatur}]

CREATE OR REPLACE FUNCTION laugis.return_literatur(
  _objekt_id integer              -- pk
  ) 
RETURNS text AS $$

DECLARE 
  _ar text;
BEGIN

SELECT (json_agg(row_to_json(rel))) AS row_value
    FROM laugis.obj_basis AS obb
        JOIN laugis.rel_literatur AS rel ON rel.ref_objekt_id = obb.objekt_id
        WHERE obb.objekt_id = _objekt_id
INTO _ar;

RETURN _ar;

END;
$$ LANGUAGE plpgsql;

--------------------------------------------------------------------------------------------------------------------------------------
-- # return_material
--------------------------------------------------------------------------------------------------------------------------------------

-- Gibt für ein Objekt die Erfasserliste rel_erfasser als JSON(text) zurück
-- Format: [{rel_id, obj_id, erf_id, is_erfasser}]

CREATE OR REPLACE FUNCTION laugis.return_material(
  _objekt_id integer              -- pk
  ) 
RETURNS text AS $$

DECLARE 
  _ar text;
BEGIN

SELECT (json_agg(row_to_json(rel))) AS row_value
    FROM laugis.obj_basis AS obb
        JOIN laugis.rel_material AS rel ON rel.ref_objekt_id = obb.objekt_id
        JOIN laugis.def_material AS def ON rel.ref_material_id = def.id
        WHERE obb.objekt_id = _objekt_id
        --ORDER By def.sortierung
INTO _ar;

RETURN _ar;

END;
$$ LANGUAGE plpgsql;

--------------------------------------------------------------------------------------------------------------------------------------
-- # return_nutzung
--------------------------------------------------------------------------------------------------------------------------------------

-- Gibt für ein Objekt die Nutzungsliste rel_nutzung als JSON(text) zurück

CREATE OR REPLACE FUNCTION laugis.return_nutzung(
  _objekt_id integer              -- pk
  ) 
RETURNS text AS $$

DECLARE 
  _ar text;
BEGIN

SELECT (json_agg(row_to_json(rel) ORDER BY LEFT(NULLIF(regexp_replace(rel.datierung, '\D','','g'), ''), 4))) AS row_value
    FROM laugis.obj_basis AS obb
        JOIN laugis.rel_nutzung AS rel ON rel.ref_objekt_id = obb.objekt_id
        WHERE obb.objekt_id = _objekt_id
INTO _ar;

RETURN _ar;

END;
$$ LANGUAGE plpgsql;

--------------------------------------------------------------------------------------------------------------------------------------
-- # return_personen
--------------------------------------------------------------------------------------------------------------------------------------

-- Gibt für ein Objekt die Personenliste rel_personen als JSON(text) zurück
-- Format: [{relation_id, objekt_id, bezeichnung, ref_funktion_id, alt_funktion}]

CREATE OR REPLACE FUNCTION laugis.return_personen(
  _objekt_id integer              -- pk
  ) 
RETURNS text AS $$

DECLARE 
  _ar text;
BEGIN

SELECT (json_agg(row_to_json(rel))) AS row_value
    FROM laugis.obj_basis AS obb
        JOIN laugis.rel_personen AS rel ON rel.ref_objekt_id = obb.objekt_id
        JOIN laugis.def_personen AS def ON rel.ref_funktion_id = def.id
        WHERE obb.objekt_id = _objekt_id
INTO _ar;

RETURN _ar;

END;
$$ LANGUAGE plpgsql;

--------------------------------------------------------------------------------------------------------------------------------------
-- # update_bilder
--------------------------------------------------------------------------------------------------------------------------------------

-- Setzt die Werte für eine bestehende oder neue Bilder-Relation
-- Gibt die ID des bearbeiteten Eintrags zurück

CREATE OR REPLACE FUNCTION laugis.update_bilder(
  _relation_id integer,            -- pk IF NOT NULL -> UPDATE
  _ref_objekt_id integer,          -- fk
  _dateiname text,
  _intern bool,
  _titelbild bool
  ) 

RETURNS INTEGER AS $$

DECLARE 
  _rel_id integer = _relation_id;
  _is_update bool = NULL;
BEGIN

  -- check if UPDATE or INSERT
  IF (_rel_id IS NOT NULL) THEN
    _is_update = TRUE;
  ELSE
    _is_update = FALSE;
  END IF;

  IF (_is_update) THEN
    UPDATE laugis.rel_bilder
    SET
        ref_objekt_id = _ref_objekt_id,
        dateiname = _dateiname,
        intern = _intern,
        titelbild = _titelbild
    WHERE relation_id = _relation_id;
  ELSE
    INSERT INTO laugis.rel_bilder(
        ref_objekt_id,
        dateiname,
        intern,
        titelbild
        )
      VALUES (
        _ref_objekt_id,
        _dateiname,
        _intern,
        _titelbild
        )
      RETURNING rel_bilder.relation_id INTO _relation_id;
  END IF;
 
-- return (inserted) rel id
RETURN _relation_id;

END;
$$ LANGUAGE plpgsql;

--------------------------------------------------------------------------------------------------------------------------------------
-- # update_blickbeziehung
--------------------------------------------------------------------------------------------------------------------------------------

-- Setzt die Werte für eine bestehende oder neue Blickbeziehung-Relation
-- Gibt die ID des bearbeiteten Eintrags zurück

CREATE OR REPLACE FUNCTION laugis.update_blickbeziehung(
  _relation_id integer,            -- pk IF NOT NULL -> UPDATE
  _ref_objekt_id integer,          -- fk
  _beschreibung text,
  _rel_objekt_nr integer,          -- rel fk
  _ref_blick_id integer
  ) 

RETURNS INTEGER AS $$

DECLARE 
  _rel_id integer = _relation_id;
  _is_update bool = NULL;
BEGIN

  -- check if UPDATE or INSERT
  IF (_rel_id IS NOT NULL) THEN
    _is_update = TRUE;
  ELSE
    _is_update = FALSE;
  END IF;

  IF (_is_update) THEN
    UPDATE laugis.rel_blickbeziehung
    SET
        ref_objekt_id = _ref_objekt_id,
        beschreibung = _beschreibung,
        rel_objekt_nr = _rel_objekt_nr,
        ref_blick_id = _ref_blick_id
    WHERE relation_id = _relation_id;
  ELSE
    INSERT INTO laugis.rel_blickbeziehung(
        ref_objekt_id,
        beschreibung,
        rel_objekt_nr,
        ref_blick_id
        )
      VALUES (
        _ref_objekt_id,
        _beschreibung,
        _rel_objekt_nr,
        _ref_blick_id
        )
      RETURNING rel_blickbeziehung.relation_id INTO _relation_id;
  END IF;
 
-- return (inserted) rel id
RETURN _relation_id;

END;
$$ LANGUAGE plpgsql;

--------------------------------------------------------------------------------------------------------------------------------------
-- # update_dachform
--------------------------------------------------------------------------------------------------------------------------------------

-- Setzt die Werte für eine bestehende oder neue Dachform-Relation
-- Gibt die ID des bearbeiteten Eintrags zurück

CREATE OR REPLACE FUNCTION laugis.update_dachform(
  _relation_id integer,            -- pk IF NOT NULL -> UPDATE
  _ref_objekt_id integer,          -- fk
  _ref_dachform_id integer         -- fk
  ) 

RETURNS INTEGER AS $$

DECLARE 
  _rel_id integer = _relation_id;
  _is_update bool = NULL;
BEGIN

  -- check if UPDATE or INSERT
  IF (_rel_id IS NOT NULL) THEN
    _is_update = TRUE;
  ELSE
    _is_update = FALSE;
  END IF;

  IF (_is_update) THEN
    UPDATE laugis.rel_dachform
    SET
        ref_objekt_id = _ref_objekt_id,
        ref_dachform_id = _ref_dachform_id
    WHERE relation_id = _relation_id;
  ELSE
    INSERT INTO laugis.rel_dachform(
        ref_objekt_id,
        ref_dachform_id
        )
      VALUES (
        _ref_objekt_id,
        _ref_dachform_id
        )
      RETURNING rel_dachform.relation_id INTO _relation_id;
  END IF;
 
-- return (inserted) rel id
RETURN _relation_id;

END;
$$ LANGUAGE plpgsql;

--------------------------------------------------------------------------------------------------------------------------------------
-- # update_datierung
--------------------------------------------------------------------------------------------------------------------------------------

-- Setzt die Werte für eine bestehende oder neue Datierung-Relation
-- Gibt die ID des bearbeiteten Eintrags zurück

CREATE OR REPLACE FUNCTION laugis.update_datierung(
  _relation_id integer,            -- pk IF NOT NULL -> UPDATE
  _ref_objekt_id integer,          -- fk
  _datierung text,
  _ref_ereignis_id integer,        -- fk
  _alt_ereignis text
  ) 

RETURNS INTEGER AS $$

DECLARE 
  _rel_id integer = _relation_id;
  _is_update bool = NULL;
BEGIN

  -- check if UPDATE or INSERT
  IF (_rel_id IS NOT NULL) THEN
    _is_update = TRUE;
  ELSE
    _is_update = FALSE;
  END IF;

  IF (_is_update) THEN
    UPDATE laugis.rel_datierung
    SET
        ref_objekt_id = _ref_objekt_id,
        datierung = _datierung,
        ref_ereignis_id = _ref_ereignis_id,
        alt_ereignis = _alt_ereignis
    WHERE relation_id = _relation_id;
  ELSE
    INSERT INTO laugis.rel_datierung(
        ref_objekt_id,
        datierung,
        ref_ereignis_id,
        alt_ereignis
        )
      VALUES (
        _ref_objekt_id,
        _datierung,
        _ref_ereignis_id,
        _alt_ereignis
        )
      RETURNING rel_datierung.relation_id INTO _relation_id;
  END IF;
 
-- return (inserted) rel id
RETURN _relation_id;

END;
$$ LANGUAGE plpgsql;

--------------------------------------------------------------------------------------------------------------------------------------
-- # update_erfasser
--------------------------------------------------------------------------------------------------------------------------------------

-- Setzt die Werte für eine bestehende oder neue Erfasser-Relation
-- Gibt die ID des bearbeiteten Eintrags zurück

CREATE OR REPLACE FUNCTION laugis.update_erfasser(
  -- # Metadaten
  _relation_id integer,            -- pk IF NOT NULL -> UPDATE
  _ref_objekt_id integer,          -- fk
  _ref_erfasser_id integer,        -- fk
  _is_creator bool
  ) 

RETURNS INTEGER AS $$

DECLARE 
  _rel_id integer = _relation_id;
  _is_update bool = NULL;
BEGIN

  -- check if UPDATE or INSERT
  IF (_rel_id IS NOT NULL) THEN
    _is_update = TRUE;
  ELSE
    _is_update = FALSE;
  END IF;

  IF (_is_update) THEN
    UPDATE laugis.rel_erfasser
    SET
        ref_objekt_id = _ref_objekt_id,
        ref_erfasser_id = _ref_erfasser_id,
        is_creator = _is_creator
    WHERE relation_id = _relation_id;
  ELSE
    INSERT INTO laugis.rel_erfasser(
        ref_objekt_id,
        ref_erfasser_id,
        is_creator)
      VALUES (
        _ref_objekt_id,
        _ref_erfasser_id,
        _is_creator
        )
      RETURNING rel_erfasser.relation_id INTO _relation_id;
  END IF;
 
-- return (inserted) rel id
RETURN _relation_id;

END;
$$ LANGUAGE plpgsql;

--------------------------------------------------------------------------------------------------------------------------------------
-- # update_konstruktion
--------------------------------------------------------------------------------------------------------------------------------------

-- Setzt die Werte für eine bestehende oder neue konstruktion-Relation
-- Gibt die ID des bearbeiteten Eintrags zurück

CREATE OR REPLACE FUNCTION laugis.update_konstruktion(
  _relation_id integer,            -- pk IF NOT NULL -> UPDATE
  _ref_objekt_id integer,          -- fk
  _ref_konstruktion_id integer
  ) 

RETURNS INTEGER AS $$

DECLARE 
  _rel_id integer = _relation_id;
  _is_update bool = NULL;
BEGIN

  -- check if UPDATE or INSERT
  IF (_rel_id IS NOT NULL) THEN
    _is_update = TRUE;
  ELSE
    _is_update = FALSE;
  END IF;

  IF (_is_update) THEN
    UPDATE laugis.rel_konstruktion
    SET
        ref_objekt_id = _ref_objekt_id,
        ref_konstruktion_id = _ref_konstruktion_id
    WHERE relation_id = _relation_id;
  ELSE
    INSERT INTO laugis.rel_konstruktion(
        ref_objekt_id,
        ref_konstruktion_id
        )
      VALUES (
        _ref_objekt_id,
        _ref_konstruktion_id
        )
      RETURNING rel_konstruktion.relation_id INTO _relation_id;
  END IF;
 
-- return (inserted) rel id
RETURN _relation_id;

END;
$$ LANGUAGE plpgsql;

--------------------------------------------------------------------------------------------------------------------------------------
-- # update_literatur
--------------------------------------------------------------------------------------------------------------------------------------

-- Setzt die Werte für eine bestehende oder neue Literatur-Relation
-- Gibt die ID des bearbeiteten Eintrags zurück

CREATE OR REPLACE FUNCTION laugis.update_literatur(
  _relation_id integer,            -- pk IF NOT NULL -> UPDATE
  _ref_objekt_id integer,          -- fk
  _literatur text,
  _lib_ref text
  ) 

RETURNS INTEGER AS $$

DECLARE 
  _rel_id integer = _relation_id;
  _is_update bool = NULL;
BEGIN

  -- check if UPDATE or INSERT
  IF (_rel_id IS NOT NULL) THEN
    _is_update = TRUE;
  ELSE
    _is_update = FALSE;
  END IF;

  IF (_is_update) THEN
    UPDATE laugis.rel_literatur
    SET
        ref_objekt_id = _ref_objekt_id,
        literatur = _literatur,
        lib_ref = _lib_ref
    WHERE relation_id = _relation_id;
  ELSE
    INSERT INTO laugis.rel_literatur(
        ref_objekt_id,
        literatur,
        lib_ref
        )
      VALUES (
        _ref_objekt_id,
        _literatur,
        _lib_ref
        )
      RETURNING rel_literatur.relation_id INTO _relation_id;
  END IF;
 
-- return (inserted) rel id
RETURN _relation_id;

END;
$$ LANGUAGE plpgsql;

--------------------------------------------------------------------------------------------------------------------------------------
-- # update_material
--------------------------------------------------------------------------------------------------------------------------------------

-- Setzt die Werte für eine bestehende oder neue Nutzung-Relation
-- Gibt die ID des bearbeiteten Eintrags zurück

CREATE OR REPLACE FUNCTION laugis.update_material(
  _relation_id integer,            -- pk IF NOT NULL -> UPDATE
  _ref_objekt_id integer,          -- fk
  _ref_material_id integer
  ) 

RETURNS INTEGER AS $$

DECLARE 
  _rel_id integer = _relation_id;
  _is_update bool = NULL;
BEGIN

  -- check if UPDATE or INSERT
  IF (_rel_id IS NOT NULL) THEN
    _is_update = TRUE;
  ELSE
    _is_update = FALSE;
  END IF;

  IF (_is_update) THEN
    UPDATE laugis.rel_material
    SET
        ref_objekt_id = _ref_objekt_id,
        ref_material_id = _ref_material_id
    WHERE relation_id = _relation_id;
  ELSE
    INSERT INTO laugis.rel_material(
        ref_objekt_id,
        ref_material_id
        )
      VALUES (
        _ref_objekt_id,
        _ref_material_id
        )
      RETURNING rel_material.relation_id INTO _relation_id;
  END IF;
 
-- return (inserted) rel id
RETURN _relation_id;

END;
$$ LANGUAGE plpgsql;

--------------------------------------------------------------------------------------------------------------------------------------
-- # update_nutzung
--------------------------------------------------------------------------------------------------------------------------------------

-- Setzt die Werte für eine bestehende oder neue Nutzung-Relation
-- Gibt die ID des bearbeiteten Eintrags zurück

CREATE OR REPLACE FUNCTION laugis.update_nutzung(
  _relation_id integer,            -- pk IF NOT NULL -> UPDATE
  _ref_objekt_id integer,          -- fk
  _nutzungsart text,
  _datierung text
  ) 

RETURNS INTEGER AS $$

DECLARE 
  _rel_id integer = _relation_id;
  _is_update bool = NULL;
BEGIN

  -- check if UPDATE or INSERT
  IF (_rel_id IS NOT NULL) THEN
    _is_update = TRUE;
  ELSE
    _is_update = FALSE;
  END IF;

  IF (_is_update) THEN
    UPDATE laugis.rel_nutzung
    SET
        ref_objekt_id = _ref_objekt_id,
        nutzungsart = _nutzungsart,
        datierung = _datierung
    WHERE relation_id = _relation_id;
  ELSE
    INSERT INTO laugis.rel_nutzung(
        ref_objekt_id,
        nutzungsart,
        datierung
        )
      VALUES (
        _ref_objekt_id,
        _nutzungsart,
        _datierung
        )
      RETURNING rel_nutzung.relation_id INTO _relation_id;
  END IF;
 
-- return (inserted) rel id
RETURN _relation_id;

END;
$$ LANGUAGE plpgsql;

--------------------------------------------------------------------------------------------------------------------------------------
-- # update_obj_basis
--------------------------------------------------------------------------------------------------------------------------------------

-- Setzt die Werte für ein bestehendes oder neues Basis-Objekt
-- Erzeugt eine definierte Objektnummer
-- Legt entsprechend der Geometrie-Art einen passenden verknüpften Eintrag an
-- Setzt das Flag 'geloescht' auf false
-- Fügt in 'letzte_aenderung' den aktuellen Timestamp
-- Gibt die ID des bearbeiteten Eintrags zurück

CREATE OR REPLACE FUNCTION laugis.update_obj_basis(
  -- # Metadaten
  _objekt_id integer,              -- pk IF NOT NULL -> UPDATE
  _objekt_nr integer,              -- 5000
  _rel_objekt_nr integer,          -- fk
  _status_bearbeitung smallint,    -- fk
  _erfassungsdatum date,           -- 9580
  _aenderungsdatum date,           -- 9950
  
  -- # Deskriptoren
  _kategorie smallint,             -- fk NOT NULL
  _sachbegriff integer,            -- fk 5230
  _sachbegriff_alt text,           -- 5230 (als Altdaten-temp sowie für Freitexte)
  _beschreibung text,              -- 9980
  _beschreibung_ergaenzung text,   -- 9980
  _lagebeschreibung text,          -- 5125
  _notiz_intern text,              -- 9984 '9980 = Kommentar'
  _hida_nr text,                   -- 5000
  _bilder_anmerkung text,          -- temp und anmerkung

  -- # Stammdaten
  _bezeichnung text,               -- 9990
  _bauwerksname_eigenname text,    -- 5202
  _schutzstatus smallint,          -- fk
  _foerderfaehig bool, 
    
  -- # Lokalisatoren
  _kreis text,                     -- 5098
  _gemeinde text,                  -- 5100
  _ort text,                       -- 5108
  _sorbisch text,                  -- 5115
  _strasse text,                   -- 5116
  _hausnummer text,                -- 5117
  _gem_flur text,                  -- 5120

  -- # Geometrie
  _geom geometry                   -- undefined geometry
  ) 
RETURNS INTEGER AS $$

DECLARE
  _ob_id integer = _objekt_id;
  _is_update bool = NULL;
BEGIN

  -- check if UPDATE or INSERT
  IF (_objekt_id IS NOT NULL) THEN
    _is_update = TRUE;
  ELSE
    _is_update = FALSE;
  END IF;

---------------------------------------------------------------------------------------------------------------
-- Handle obj_basis entries
---------------------------------------------------------------------------------------------------------------

  IF (_is_update) THEN
    UPDATE laugis.obj_basis
    SET
        objekt_nr               = _objekt_nr,
        rel_objekt_nr           = _rel_objekt_nr,
        status_bearbeitung      = _status_bearbeitung,
        erfassungsdatum         = _erfassungsdatum,
        aenderungsdatum         = _aenderungsdatum,
        letzte_aenderung        = NOW(),
        kategorie               = _kategorie,
        sachbegriff             = _sachbegriff,
        sachbegriff_alt         = _sachbegriff_alt,
        beschreibung            = _beschreibung,
        beschreibung_ergaenzung = _beschreibung_ergaenzung,
        lagebeschreibung        = _lagebeschreibung,
        notiz_intern            = _notiz_intern,
        hida_nr                 = _hida_nr,
        bilder_anmerkung        = _bilder_anmerkung,
        bezeichnung             = _bezeichnung,
        bauwerksname_eigenname  = _bauwerksname_eigenname,
        schutzstatus            = _schutzstatus,
        foerderfaehig           = _foerderfaehig,
        kreis                   = _kreis,
        gemeinde                = _gemeinde,
        ort                     = _ort,
        sorbisch                = _sorbisch,
        strasse                 = _strasse,
        hausnummer              = _hausnummer,
        gem_flur                = _gem_flur
    WHERE objekt_id             = _ob_id;
  ELSE
    INSERT INTO laugis.obj_basis(
        objekt_nr,
        rel_objekt_nr,
        status_bearbeitung,
        erfassungsdatum,
        aenderungsdatum,
        letzte_aenderung,
        geloescht,
        kategorie,
        sachbegriff,
        sachbegriff_alt,
        beschreibung,
        beschreibung_ergaenzung,
        lagebeschreibung,
        notiz_intern,
        hida_nr,
        bilder_anmerkung,
        bezeichnung,
        bauwerksname_eigenname,
        schutzstatus,
        foerderfaehig,
        kreis,
        gemeinde,
        ort,
        sorbisch,
        strasse,
        hausnummer,
        gem_flur)
      VALUES (
        _objekt_nr,
        _rel_objekt_nr,
        _status_bearbeitung,
        _erfassungsdatum,
        _aenderungsdatum,
        NOW(),
        FALSE,
        _kategorie,
        _sachbegriff,
        _sachbegriff_alt,
        _beschreibung,
        _beschreibung_ergaenzung,
        _lagebeschreibung,
        _notiz_intern,
        _hida_nr,
        _bilder_anmerkung,
        _bezeichnung,
        _bauwerksname_eigenname,
        _schutzstatus,
        _foerderfaehig,
        _kreis,
        _gemeinde,
        _ort,
        _sorbisch,
        _strasse,
        _hausnummer,
        _gem_flur)
      RETURNING obj_basis.objekt_id INTO _ob_id;
  END IF;

---------------------------------------------------------------------------------------------------------------
-- Objekt-Nr generation
---------------------------------------------------------------------------------------------------------------

  IF NOT (_is_update) AND (_objekt_nr IS NULL) THEN
    -- generate nr by adding 32.000.000 to the identifier 
    _objekt_nr = (_ob_id + 32000000);
    
    UPDATE laugis.obj_basis
    SET
        objekt_nr = _objekt_nr
    WHERE objekt_id = _ob_id;
  END IF;

---------------------------------------------------------------------------------------------------------------
-- Geometry handling
---------------------------------------------------------------------------------------------------------------

  IF (ST_GeometryType(_geom) = 'ST_MultiPolygon') THEN 
    
    IF (_is_update) THEN
        UPDATE laugis.geo_poly
        SET geom = _geom
        WHERE ref_objekt_id = _ob_id;  
    ELSE 
        INSERT INTO laugis.geo_poly(
            ref_objekt_id,
            geom
            )
          VALUES (
            _ob_id,
            _geom);
    END IF;  
  
  ELSEIF (ST_GeometryType(_geom) = 'ST_MultiLineString') THEN
    
    IF (_is_update) THEN
        UPDATE laugis.geo_line
        SET geom = _geom
        WHERE ref_objekt_id = _ob_id;    
    ELSE  
        INSERT INTO laugis.geo_line(
            ref_objekt_id,
            geom
            )
          VALUES (
            _ob_id,
            _geom);
    END IF;  

  ELSEIF (ST_GeometryType(_geom) = 'ST_MultiPoint') THEN
    
    IF (_is_update) THEN
        UPDATE laugis.geo_point
        SET geom = _geom
        WHERE ref_objekt_id = _ob_id;
    ELSE 
        INSERT INTO laugis.geo_point(
            ref_objekt_id,
            geom
            )
          VALUES (
            _ob_id,
            _geom);
    END IF;  

  END IF;

-- return (inserted) object id
RETURN _ob_id;

END;
$$ LANGUAGE plpgsql;

--------------------------------------------------------------------------------------------------------------------------------------
-- # update_obj_tech
--------------------------------------------------------------------------------------------------------------------------------------

-- insert/update obj_tech returning new id

CREATE OR REPLACE FUNCTION laugis.update_obj_tech(
    _ref_objekt_id integer,          -- fk NOT NULL
    _techn_anlage bool,
    -- # Deskriptoren allg
    _material_alt text,
    _konstruktion_alt text,
    -- # Deskriptoren arch
    _geschosszahl smallint,          -- 5390
    _achsenzahl smallint,             -- 5392
    _grundriss text,
    _dachform_alt text,
    -- # Deskriptoren tech
    _antrieb text,
    _abmessung text,             
    _gewicht text
    ) 
RETURNS INTEGER AS $$

DECLARE 
  _ob_id integer;
  _tech_id integer;
BEGIN

---------------------------------------------------------------------------------------------------------------
-- Identify existing entries. No result -> NULL
---------------------------------------------------------------------------------------------------------------

    SELECT tech_id 
    INTO _tech_id
    FROM laugis.obj_tech
    WHERE ref_objekt_id = _ref_objekt_id
    FETCH FIRST 1 ROWS ONLY;

---------------------------------------------------------------------------------------------------------------
-- Handle obj_arch entries
---------------------------------------------------------------------------------------------------------------

    IF (_tech_id IS NULL) THEN
        INSERT INTO laugis.obj_tech(
            ref_objekt_id,
            techn_anlage,
            material_alt,
            konstruktion_alt,
            geschosszahl,
            achsenzahl,
            grundriss,
            dachform_alt,
            antrieb,
            abmessung,             
            gewicht
            )
        VALUES (
            _ref_objekt_id,
            _techn_anlage,
            _material_alt,
            _konstruktion_alt,
            _geschosszahl,
            _achsenzahl,
            _grundriss,
            _dachform_alt,
            _antrieb,
            _abmessung,             
            _gewicht
            )
            RETURNING tech_id INTO _tech_id;
    ELSE
        UPDATE laugis.obj_tech
        SET
            techn_anlage = _techn_anlage,
            material_alt = _material_alt,
            konstruktion_alt = _konstruktion_alt,
            geschosszahl = _geschosszahl,
            achsenzahl = _achsenzahl,
            grundriss = _grundriss,
            dachform_alt = _dachform_alt,
            antrieb= _antrieb,
            abmessung = _abmessung,             
            gewicht = _gewicht
        WHERE tech_id = _tech_id;
    END IF;

    RETURN _tech_id;

END;
$$ LANGUAGE plpgsql;

--------------------------------------------------------------------------------------------------------------------------------------
-- # update_personen
--------------------------------------------------------------------------------------------------------------------------------------

-- Setzt die Werte für eine bestehende oder neue Personen-Relation
-- Gibt die ID des bearbeiteten Eintrags zurück

CREATE OR REPLACE FUNCTION laugis.update_personen(
  _relation_id integer,            -- pk IF NOT NULL -> UPDATE
  _ref_objekt_id integer,          -- fk
  _bezeichnung text,
  _ref_funktion_id integer,        -- fk
  _alt_funktion text,
  _is_sozietaet bool
  ) 

RETURNS INTEGER AS $$

DECLARE 
  _rel_id integer = _relation_id;
  _is_update bool = NULL;
BEGIN

  -- check if UPDATE or INSERT
  IF (_rel_id IS NOT NULL) THEN
    _is_update = TRUE;
  ELSE
    _is_update = FALSE;
  END IF;

  IF (_is_update) THEN
    UPDATE laugis.rel_personen
    SET
        ref_objekt_id = _ref_objekt_id,
        bezeichnung = _bezeichnung,
        ref_funktion_id = _ref_funktion_id,
        alt_funktion = _alt_funktion,
        is_sozietaet = _is_sozietaet
    WHERE relation_id = _relation_id;
  ELSE
    INSERT INTO laugis.rel_personen(
        ref_objekt_id,
        bezeichnung,
        ref_funktion_id,
        alt_funktion,
        is_sozietaet
        )
      VALUES (
        _ref_objekt_id,
        _bezeichnung,
        _ref_funktion_id,
        _alt_funktion,
        _is_sozietaet
        )
      RETURNING rel_personen.relation_id INTO _relation_id;
  END IF;
 
-- return (inserted) rel id
RETURN _relation_id;

END;
$$ LANGUAGE plpgsql;

--------------------------------------------------------------------------------------------------------------------------------------
-- # get_erfasserid_by_user
--------------------------------------------------------------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION laugis.get_erfasserid_by_user()
RETURNS integer AS $$
BEGIN 
    RETURN(SELECT erf.id
        FROM laugis.def_erfasser as erf
        WHERE erf.username = current_user
        LIMIT 1);
END;
$$ LANGUAGE plpgsql;


--------------------------------------------------------------------------------------------------------------------------------------
-- # update_obj_lwk
--------------------------------------------------------------------------------------------------------------------------------------

-- Setzt die Werte für ein bestehendes oder neues LWK-Objekt
-- Legt entsprechend der Geometrie-Art einen passenden verknüpften Eintrag an
-- Setzt das Flag 'geloescht' auf false
-- Fügt in 'letzte_aenderung' den aktuellen Timestamp
-- Gibt die ID des bearbeiteten Eintrags zurück

CREATE OR REPLACE FUNCTION laugis.update_obj_lwk(
  -- # Metadaten  
  _objekt_id integer, -- PK
  _erfassungsdatum date,     -- 9580
  _aenderungsdatum date,     -- 9950
  _erfassung smallint,

  -- Identifikatoren
  _beschriftung text,        -- Bezeichnung und Identifikation
  _grundlage smallint,
  _nutzungsart smallint,

  -- # Geometrie
  _geom geometry                   -- undefined geometry
  ) 
RETURNS INTEGER AS $$

DECLARE
  _ob_id integer = _objekt_id;
  _is_update bool = NULL;
BEGIN

  -- check if UPDATE or INSERT
  IF (_objekt_id IS NOT NULL) THEN
    _is_update = TRUE;
  ELSE
    _is_update = FALSE;
  END IF;

---------------------------------------------------------------------------------------------------------------
-- Handle obj_basis entries
---------------------------------------------------------------------------------------------------------------

  IF (_is_update) THEN
    UPDATE laugis.obj_lwk
    SET
        erfassungsdatum         = _erfassungsdatum,
        aenderungsdatum         = _aenderungsdatum,
        letzte_aenderung        = NOW(),
        erfassung               = _erfassung,
        beschriftung            = _beschriftung,
        grundlage               = _grundlage,
        nutzungsart             = _nutzungsart
    WHERE objekt_id             = _ob_id;
  ELSE
    INSERT INTO laugis.obj_lwk(
        erfassungsdatum,
        aenderungsdatum,
        letzte_aenderung,
        geloescht,
        erfassung,
        beschriftung,
        grundlage,
        nutzungsart
        )
      VALUES (
        _erfassungsdatum,
        _aenderungsdatum,
        NOW(),
        FALSE,
        _erfassung,
        _beschriftung,
        _grundlage,
        _nutzungsart
        )
      RETURNING obj_lwk.objekt_id INTO _ob_id;
  END IF;

---------------------------------------------------------------------------------------------------------------
-- Geometry handling
---------------------------------------------------------------------------------------------------------------

  IF (ST_GeometryType(_geom) = 'ST_MultiPolygon') THEN 
    
    IF (_is_update) THEN
        UPDATE laugis.geo_lwk_poly
        SET geom = _geom
        WHERE ref_objekt_id = _ob_id;  
    ELSE 
        INSERT INTO laugis.geo_lwk_poly(
            ref_objekt_id,
            geom
            )
          VALUES (
            _ob_id,
            _geom);
    END IF;  
  
  ELSEIF (ST_GeometryType(_geom) = 'ST_MultiLineString') THEN
    
    IF (_is_update) THEN
        UPDATE laugis.geo_lwk_line
        SET geom = _geom
        WHERE ref_objekt_id = _ob_id;    
    ELSE  
        INSERT INTO laugis.geo_lwk_line(
            ref_objekt_id,
            geom
            )
          VALUES (
            _ob_id,
            _geom);
    END IF; 
  END IF;

-- return (inserted) object id
RETURN _ob_id;

END;
$$ LANGUAGE plpgsql;

---------------------------------------------------------------------------------------------------------------
-- delete_lwk
---------------------------------------------------------------------------------------------------------------

-- Setzt das Flag 'geloescht' auf true

CREATE OR REPLACE FUNCTION laugis.delete_lwk(_objekt_id integer)
RETURNS VOID
AS $$
BEGIN
  UPDATE laugis.obj_lwk
  SET geloescht = TRUE
  WHERE objekt_id = _objekt_id;
END;
$$ LANGUAGE plpgsql;

---------------------------------------------------------------------------------------------------------------
-- change_objecttype
---------------------------------------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION laugis.change_objecttype(
  _objekt_id integer              -- pk
  ) 
RETURNS VOID AS $$

BEGIN
-- check current type
IF (SELECT COUNT(*)
    FROM laugis.obj_basis AS ob
    JOIN laugis.obj_tech AS ot ON ot.ref_objekt_id = ob.objekt_id
    WHERE ob.objekt_id = _objekt_id) > 0 THEN

  -- Objekt ist ein Einzelobjekt -> obj_tech-Eintrag entfernen
  DELETE FROM laugis.obj_tech AS ot
    WHERE ot.ref_objekt_id = _objekt_id;

ELSE
  -- Objekt ist Objektbereich -> obj_tech-Eintrag anlegen
  PERFORM laugis.update_obj_tech(
    _objekt_id,
    NULL,
    NULL,
    NULL,
    NULL, 
    NULL,
    NULL,
    NULL,
    NULL,
    NULL,
    NULL
  );
END IF;

END;
$$ LANGUAGE plpgsql;

---------------------------------------------------------------------------------------------------------------
-- read_bilder
---------------------------------------------------------------------------------------------------------------

-- Gibt für ein Objekt die aggregierten Bildereinträge zurück (read only)

CREATE OR REPLACE FUNCTION laugis.read_bilder(
  _objekt_id integer              -- pk
  ) 
RETURNS text AS $$

DECLARE 
  _ar text;
BEGIN

SELECT (string_agg(COALESCE(rel.dateiname, ''), ' | ')) AS row_value
    FROM laugis.obj_basis AS ob
        JOIN laugis.rel_bilder AS rel ON rel.ref_objekt_id = ob.objekt_id
        WHERE ob.objekt_id = _objekt_id
INTO _ar;

RETURN _ar;

END;
$$ LANGUAGE plpgsql;

---------------------------------------------------------------------------------------------------------------
-- read_blickbeziehung
---------------------------------------------------------------------------------------------------------------

-- Gibt für ein Objekt die aggregierten Blickbeziehungen zurück (read only)

CREATE OR REPLACE FUNCTION laugis.read_blickbeziehung(
  _objekt_id integer              -- pk
  ) 
RETURNS text AS $$

DECLARE 
  _ar text;
BEGIN

SELECT (string_agg(def.bezeichnung || ': ' || COALESCE(rel.beschreibung, '') || ' -> ' || COALESCE(rel_ob.bezeichnung, ''), ' | ')) AS row_value
    FROM laugis.obj_basis AS ob
        JOIN laugis.rel_blickbeziehung AS rel ON rel.ref_objekt_id = ob.objekt_id
        JOIN laugis.def_blickbeziehung AS def ON rel.ref_blick_id = def.id
        LEFT JOIN laugis.obj_basis AS rel_ob ON rel.rel_objekt_nr = rel_ob.objekt_nr
        WHERE ob.objekt_id = _objekt_id
INTO _ar;

RETURN _ar;

END;
$$ LANGUAGE plpgsql;

---------------------------------------------------------------------------------------------------------------
-- read_dachform
---------------------------------------------------------------------------------------------------------------

-- Gibt für ein Objekt die aggregierten Dachformen zurück (read only)

CREATE OR REPLACE FUNCTION laugis.read_dachform(
  _objekt_id integer              -- pk
  ) 
RETURNS text AS $$

DECLARE 
  _ar text;
BEGIN

SELECT (string_agg(def.bezeichnung, ', ')) AS row_value
    FROM laugis.obj_basis AS ob
        JOIN laugis.rel_dachform AS rel ON rel.ref_objekt_id = ob.objekt_id
        JOIN laugis.def_dachform AS def ON rel.ref_dachform_id = def.id
        WHERE ob.objekt_id = _objekt_id
INTO _ar;

RETURN _ar;

END;
$$ LANGUAGE plpgsql;

---------------------------------------------------------------------------------------------------------------
-- read_datierung
---------------------------------------------------------------------------------------------------------------

-- Gibt für ein Objekt die aggregierten Datierungseinträge zurück (read only)

CREATE OR REPLACE FUNCTION laugis.read_datierung(
  _objekt_id integer              -- pk
  ) 
RETURNS text AS $$

DECLARE 
  _ar text;
BEGIN

SELECT (string_agg(subquery.bezeichnung || ': ' || COALESCE(subquery.datierung, ''), ' | ')) AS row_value
FROM (
  SELECT def.bezeichnung, rel.datierung
  FROM laugis.obj_basis AS ob
        JOIN laugis.rel_datierung AS rel ON rel.ref_objekt_id = ob.objekt_id
        JOIN laugis.def_datierung AS def ON rel.ref_ereignis_id = def.id
    WHERE ob.objekt_id = _objekt_id
    ORDER BY LEFT(NULLIF(regexp_replace(rel.datierung, '\D','','g'), ''), 4)
    ) AS subquery
INTO _ar;

RETURN _ar;

END;
$$ LANGUAGE plpgsql;

---------------------------------------------------------------------------------------------------------------
-- read_erfasser
---------------------------------------------------------------------------------------------------------------

-- Gibt für ein Objekt die primäre Ersteller:in oder nur die Beitragenden read only zurück.
-- Das Kennzeichen _only_ceator::bool bestimmt den Modus. 
-- Mehrere Erfasser:innen werden aggregiert übergeben.

CREATE OR REPLACE FUNCTION laugis.read_erfasser(
  _objekt_id integer,              -- pk
  _only_creator bool                -- kennzeichen
  ) 
RETURNS text AS $$

DECLARE 
  _ar text;
BEGIN
  
SELECT (string_agg(def.name, ', ')) AS row_value
    FROM laugis.obj_basis AS ob
        JOIN laugis.rel_erfasser AS rel ON rel.ref_objekt_id = ob.objekt_id
        JOIN laugis.def_erfasser AS def ON rel.ref_erfasser_id = def.id
        WHERE ob.objekt_id = _objekt_id
          AND rel.is_creator = _only_creator
INTO _ar;

RETURN _ar;

END;
$$ LANGUAGE plpgsql;

---------------------------------------------------------------------------------------------------------------
-- read_konstruktion
---------------------------------------------------------------------------------------------------------------

-- Gibt für ein Objekt die aggregierten Konstruktionsarten/Techniken zurück (read only)

CREATE OR REPLACE FUNCTION laugis.read_konstruktion(
  _objekt_id integer              -- pk
  ) 
RETURNS text AS $$

DECLARE 
  _ar text;
BEGIN

SELECT (string_agg(def.bezeichnung, ', ')) AS row_value
    FROM laugis.obj_basis AS ob
        JOIN laugis.rel_konstruktion AS rel ON rel.ref_objekt_id = ob.objekt_id
        JOIN laugis.def_konstruktion AS def ON rel.ref_konstruktion_id = def.id
        WHERE ob.objekt_id = _objekt_id
INTO _ar;

RETURN _ar;

END;
$$ LANGUAGE plpgsql;

---------------------------------------------------------------------------------------------------------------
-- read_literatur
---------------------------------------------------------------------------------------------------------------

-- Gibt für ein Objekt die aggregierten Literatureinträge zurück (read only)

CREATE OR REPLACE FUNCTION laugis.read_literatur(
  _objekt_id integer              -- pk
  ) 
RETURNS text AS $$

DECLARE 
  _ar text;
BEGIN

SELECT string_agg(rel.literatur, ' | ') AS row_value
    FROM laugis.obj_basis AS ob
        JOIN laugis.rel_literatur AS rel ON rel.ref_objekt_id = ob.objekt_id
        WHERE ob.objekt_id = _objekt_id
INTO _ar;

RETURN _ar;

END;
$$ LANGUAGE plpgsql;

---------------------------------------------------------------------------------------------------------------
-- read_material
---------------------------------------------------------------------------------------------------------------

-- Gibt für ein Objekt die aggregierten Materialien zurück (read only)

CREATE OR REPLACE FUNCTION laugis.read_material(
  _objekt_id integer              -- pk
  ) 
RETURNS text AS $$

DECLARE 
  _ar text;
BEGIN

SELECT (string_agg(def.bezeichnung, ', ')) AS row_value
    FROM laugis.obj_basis AS ob
        JOIN laugis.rel_material AS rel ON rel.ref_objekt_id = ob.objekt_id
        JOIN laugis.def_material AS def ON rel.ref_material_id = def.id
        WHERE ob.objekt_id = _objekt_id
INTO _ar;

RETURN _ar;

END;
$$ LANGUAGE plpgsql;

---------------------------------------------------------------------------------------------------------------
-- read_nutzung
---------------------------------------------------------------------------------------------------------------

-- Gibt für ein Objekt die aggregierten und sortierten Nutzungseinträge zurück (read only)

CREATE OR REPLACE FUNCTION laugis.read_nutzung(
  _objekt_id integer              -- pk
  ) 
RETURNS text AS $$

DECLARE 
  _ar text;
BEGIN

SELECT (string_agg(COALESCE(subquery.nutzungsart, '') || ' ' || COALESCE(subquery.datierung, ''), ' | ')) AS row_value
FROM (
  SELECT rel.nutzungsart, rel.datierung
  FROM laugis.obj_basis AS ob
        JOIN laugis.rel_nutzung AS rel ON rel.ref_objekt_id = ob.objekt_id
    WHERE ob.objekt_id = _objekt_id
    ORDER BY LEFT(NULLIF(regexp_replace(rel.datierung, '\D','','g'), ''), 4)
        ) AS subquery
INTO _ar;

RETURN _ar;

END;
$$ LANGUAGE plpgsql;

---------------------------------------------------------------------------------------------------------------
-- read_personen
---------------------------------------------------------------------------------------------------------------

-- Gibt für ein Objekt die aggregierten Personeneinträge zurück (read only)

CREATE OR REPLACE FUNCTION laugis.read_personen(
  _objekt_id integer              -- pk
  ) 
RETURNS text AS $$

DECLARE 
  _ar text;
BEGIN

SELECT (string_agg(def.bezeichnung || ': ' || COALESCE(rel.bezeichnung, ''), ' | ')) AS row_value
    FROM laugis.obj_basis AS ob
        JOIN laugis.rel_personen AS rel ON rel.ref_objekt_id = ob.objekt_id
        JOIN laugis.def_personen AS def ON rel.ref_funktion_id = def.id
        WHERE ob.objekt_id = _objekt_id
INTO _ar;

RETURN _ar;

END;
$$ LANGUAGE plpgsql;