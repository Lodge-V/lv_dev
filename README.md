# lv_dev – Grundgeruest

Zentrale Verwaltungsressource fuer Lodge V.

## Voraussetzungen
- FiveM Server mit ESX Legacy
- oxmysql
- Node.js und npm fuer den NUI-Build

## Installation
1. Ordner `lv_dev` in eine passende Ressourcen-Kategorie kopieren.
2. Im Ordner `lv_dev/web` `npm install` ausfuehren.
3. Danach `npm run build` ausfuehren.
4. In der `server.cfg` sicherstellen, dass die Abhaengigkeiten vorher gestartet werden:
   ```cfg
   ensure oxmysql
   ensure es_extended
   ensure lv_dev
   ```
5. Serverkonsole auf Startfehler pruefen.

## Aktueller Umfang
- Ressourcenmanifest und Grundstruktur
- Modulregister fuer die fuenf geplanten Module
- erste ACE-Prueffunktionen (noch nicht vollstaendig verdrahtet)
- React/TypeScript/Vite NUI-Grundlayout

## Noch nicht enthalten
- Datenbankschema und Migrationen
- produktive ACE- und Modulfreigabe
- NUI-Open-/Close-Flow
- CRUD-Funktionen und Synchronisierung
- Integration der Bestandsressourcen

## Hinweis
Dies ist Schritt 1: das technische Grundgeruest. Die Platzhaltermodule sind bewusst noch nicht funktionsfaehig.
