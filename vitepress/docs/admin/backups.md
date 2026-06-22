# Backups

Das Backup-System basiert auf drei Komponenten:

- **[Restic](https://restic.readthedocs.io/)** - Backup-Software mit Verschlüsselung und Deduplizierung
- **[Rclone](https://rclone.org/)** - Schnittstelle zu Cloud-Speicher
- **[Storj](https://www.storj.io/)** - Dezentraler Cloud-Speicher-Anbieter

## Übersicht

Die Backup-Richtlinie folgt einer einzigen Regel: Alles unter `/srv` und `/home` wird gesichert, **außer**
den ersetzbaren Inhalten unter `/srv/media/`. Diese Trennung ist Teil der [Speicherstruktur](/admin/speicher).

**Was wird gesichert:**

- `/srv/originals/` (unersetzliche Originale: Immich-Fotos, Familienmedien, persönliche Musik)
- `/srv/docker/` (Docker-Konfigurationen und App-Daten, inkl. Immich Postgres)
- `/home/` (Benutzerdaten)

**Was wird NICHT gesichert:**

- `/srv/media/` (ersetzbare Inhalte: Jellyfin Filme/Serien, qBittorrent Downloads)
- App Caches und Logs
- System-Dateien - bei Bedarf neu aufsetzen

**Backup-Zeitplan:**

- Täglich um 02:00 Uhr (automatisch via Cron)
- Retention: `--keep-daily 7 --keep-weekly 4 --keep-monthly 6 --keep-yearly 2`

## 3-2-1 Strategie

Die unersetzlichen Daten existieren in drei Kopien auf zwei Medientypen, davon eine außerhalb des Hauses:

|Kopie|Ort|Zweck|
|---|---|---|
|1|`/mnt/hdd/originals`|Live-Daten (primäre HDD)|
|2|`/mnt/hdd2/originals`|Lokaler Mirror, schnelle Wiederherstellung bei HDD-Ausfall|
|3|Storj (restic)|Offsite Disaster Recovery|

:::info Keine Netzwerklast
Beide HDDs sind physisch am Beelink angeschlossen. Der Mirror liest von einem Blockgerät und schreibt auf das
andere - reine lokale I/O, kein WLAN- oder LAN-Verkehr. Nur die Storj-Kopie nutzt die Internetverbindung.
:::

:::tip Restic Dokumentation
Für detaillierte Restic-Befehle siehe die [offizielle Restic-Dokumentation](https://restic.readthedocs.io/). Diese Seite enthält nur serverspezifische Konfigurationen.
:::

## Konfiguration

### Rclone Konfiguration

Die Rclone-Konfiguration liegt unter:

- Auf dem Server: `~/.config/rclone/rclone.conf`
- Im Repository: `ansible/files/rclone.conf`

**Storj Access Grant erstellen:**

1. Login auf [Storj Console](https://eu1.storj.io/projects/m2OneG6KQ7-/)
2. Navigiere zu **Access Keys**
3. Wähle **Access Grant**
4. Kopiere den Access Grant
5. Füge ihn in `rclone.conf` ein

### Restic Repository

Das Restic-Repository wird über Rclone auf Storj gespeichert.

**Repository initialisieren (einmalig):**

```bash
sudo -u restic restic -r rclone:storj:beelink-backup init
```

Das Passwort wird abgefragt und sollte sicher im Password Manager gespeichert werden.

## Sekundärer HDD-Mirror

Zusätzlich zum restic-Backup spiegelt ein nächtlicher rsync-Befehl die Originale auf die sekundäre HDD.

## Überwachung

```bash
# restic-Backup
sudo -u restic tail -f /home/restic/backup.log

# Sekundärer HDD-Mirror
sudo tail -f /root/mirror.log
```

## Wiederherstellung

Falls der Server komplett neu aufgesetzt werden muss oder einzelne Daten wiederhergestellt werden müssen.

### Komplette Wiederherstellung

1. Neuen [Server einrichten](/admin/server-einrichtung)
2. Rclone konfigurieren (aus `ansible/files/rclone.conf`)
3. Mit Restic das Repository verbinden und Daten wiederherstellen
4. Docker Container starten

### Einzelne Services wiederherstellen

**Bei Datenverlust oder Korruption:**

1. Betroffenen Container stoppen
2. Mit Restic spezifische Pfade wiederherstellen (z.B. `/srv/originals/immich` oder `/srv/docker`)
3. Berechtigungen prüfen/korrigieren
4. Container neu starten

Detaillierte Restic-Befehle für Restore-Operationen: [Restic Restore Dokumentation](https://restic.readthedocs.io/en/latest/050_restore.html)
