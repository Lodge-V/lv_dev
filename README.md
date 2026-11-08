# lv_dev – Version 0.3.0

Zentrales Verwaltungsframework fuer Lodge V (FiveM / ESX Legacy).

## Voraussetzungen
- FiveM Server mit ESX Legacy
- oxmysql
- MariaDB / MySQL
- `oxmysql` und `es_extended` muessen vor `lv_dev` gestartet werden

## Installation / Update

1. Bestehenden Ressourcenordner sichern.
2. Dateien aus dem Release-Paket in den Ressourcenordner uebernehmen.
3. `sql/schema.sql` einmalig in der Lodge-V-Datenbank importieren (bei einem Update nicht erneut erforderlich, wenn das Schema bereits vollstaendig angelegt wurde).
4. In der `server.cfg` die Startreihenfolge sicherstellen:

   ```cfg
   ensure oxmysql
   ensure es_extended
   ensure lv_dev
   ```

5. Server neu starten oder `restart lv_dev` ausfuehren.
6. Konsole auf Datenbank- und Callback-Meldungen pruefen.

## ACE-Rechte

```cfg
add_ace group.developer lv_dev.all allow

# Alternativ modulbezogen:
add_ace group.developer lv_dev.blipscreator allow
add_ace group.developer lv_dev.elevator allow
add_ace group.developer lv_dev.logging allow
add_ace group.developer lv_dev.teleport allow
add_ace group.developer lv_dev.klingel allow
```

`lv_dev.all` gewaehrt Zugriff auf alle Module. Gruppen bitte an die bestehende Lodge-V-ACE-Konfiguration anpassen.

## CRUD-Callbacks in 0.3.0

Die serverseitigen ESX-Callbacks verwenden dieses Namensschema:

- `lv_dev:server:<module>:list`
- `lv_dev:server:<module>:create`
- `lv_dev:server:<module>:update`
- `lv_dev:server:<module>:delete`

Unterstuetzte Module: `blipscreator`, `elevator`, `logging`, `teleport`, `klingel`.

Jeder Callback prueft die passende ACE-Berechtigung serverseitig. Schreibaktionen werden ueber die Audit-Funktion protokolliert. Werte werden validiert und SQL-Werte parametrisiert. Tabellen- und Spaltennamen sind fest im Servercode definiert.

Beispiel fuer einen Client-Aufruf:

```lua
ESX.TriggerServerCallback('lv_dev:server:blipscreator:list', function(result)
    if not result or not result.success then
        print(result and result.message or 'Unbekannter Fehler')
        return
    end

    print(('Blips geladen: %s'):format(#result.data))
end)
```

## Aktueller Funktionsumfang

- Datenbankverbindung und erforderliche Tabellen werden geprueft.
- Audit-Logging fuer Erstellen, Aktualisieren, Loeschen und verweigerte Zugriffe.
- CRUD-Callbacks fuer Blips, Fahrstuhl-Stammdaten, Logging-Kategorien, Teleportpunkte und Klingeln.
- Serverseitige ACE-Pruefung und Eingabevalidierung.

## Noch nicht enthalten

- NUI-Open-/Close-Anbindung und fertige React-Verwaltungsseiten.
- Etagen-CRUD fuer Fahrstuehle.
- Verwaltung mehrerer Webhooks je Logging-Kategorie.
- Laufzeit-Integration der Datensaetze in die bestehenden Lodge-V-Ressourcen (Blips, Fahrstuhl, Klingel, Logging, Teleport). Die Tabellen allein aktivieren diese Funktionen nicht automatisch.

