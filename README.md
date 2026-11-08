# lv_dev – Version 0.2.0

Zentrales Verwaltungsframework fuer Lodge V (FiveM / ESX Legacy).

## Voraussetzungen
- FiveM Server mit ESX Legacy
- oxmysql
- MariaDB / MySQL
- `oxmysql` und `es_extended` muessen vor `lv_dev` gestartet werden

## Update von 0.1.0 auf 0.2.0

1. Bestehenden Ressourcenordner sichern.
2. Neue Dateien aus diesem Paket in den Ressourcenordner uebernehmen.
3. `sql/schema.sql` einmalig in der Lodge-V-Datenbank importieren.
4. In der `server.cfg` die Startreihenfolge sicherstellen:

   ```cfg
   ensure oxmysql
   ensure es_extended
   ensure lv_dev
   ```

5. Server neu starten oder `restart lv_dev` ausfuehren.
6. Konsole pruefen. Bei fehlenden Tabellen nennt `lv_dev` die betroffenen Tabellennamen.

## ACE-Rechte

Die vorhandenen ACE-Rechte aus der bisherigen Version bleiben bestehen:

```cfg
add_ace group.developer lv_dev.all allow

# Alternativ modulbezogen:
add_ace group.developer lv_dev.blipscreator allow
add_ace group.developer lv_dev.elevator allow
add_ace group.developer lv_dev.logging allow
add_ace group.developer lv_dev.teleport allow
add_ace group.developer lv_dev.klingel allow
```

`lv_dev.all` gewaehrt Zugriff auf alle Module. Die konkreten Gruppen muessen an die bestehende Lodge-V-ACE-Konfiguration angepasst werden.

## Neu in 0.2.0
- oxmysql wird explizit ueber das FiveM-Manifest eingebunden.
- Zentrale Datenbankschnittstelle in `server/database.lua`.
- Datenbank- und Schema-Pruefung beim Start und beim Panel-Aufruf.
- Audit-Logging-Grundfunktion fuer Aktionen.
- SQL-Schema fuer Audit, Blips, Fahrstuehle, Etagen, Logging, Webhooks, Teleports und Klingeln.
- Versionsnummer auf 0.2.0 erhoeht.

## Wichtige Hinweise
- Das SQL-Schema legt nur neue `lv_dev_*`-Tabellen an und veraendert keine ESX- oder bestehenden Lodge-V-Tabellen.
- `sql/schema.sql` muss vor der Nutzung importiert werden.
- Die Datenbankfunktionen sind die Grundlage fuer die CRUD-Endpunkte im naechsten Entwicklungsschritt.
- Die eigentlichen Modul-CRUDs und die NUI-Open-/Close-Anbindung sind noch nicht Bestandteil dieser Version.
- Das ZIP enthaelt den bestehenden NUI-Build aus 0.1.0. Der React/TypeScript-Quellcode und die npm-Projektdateien waren im bereitgestellten ZIP nicht enthalten und wurden deshalb nicht rekonstruiert.
