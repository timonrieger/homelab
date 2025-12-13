# Backups

Das Backup-System basiert auf drei Komponenten:

- **[Restic](https://restic.readthedocs.io/)** - Backup-Software mit Verschlüsselung und Deduplizierung
- **[Rclone](https://rclone.org/)** - Schnittstelle zu Cloud-Speicher
- **[Storj](https://www.storj.io/)** - Dezentraler Cloud-Speicher-Anbieter

## Übersicht

**Was wird gesichert:**

- /srv/ (Medien und Docker-Konfigurationsdateien)
- /home/ (Benutzerdaten)
- /mnt/hdd/time_machine/ (Time Machine Backups)

**Was wird NICHT gesichert:**

- System-Dateien - bei Bedarf neu aufsetzen

**Backup-Zeitplan:**

- Täglich um 00:00 Uhr (automatisch via Cron)
- Retention: unbegrenzt

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

## Überwachung

```bash
sudo -u restic tail -f /home/restic/backup.log
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
2. Mit Restic spezifische Pfade wiederherstellen (z.B. `/srv/media/immich` oder `/srv/docker`)
3. Berechtigungen prüfen/korrigieren
4. Container neu starten

Detaillierte Restic-Befehle für Restore-Operationen: [Restic Restore Dokumentation](https://restic.readthedocs.io/en/latest/050_restore.html)

## Best Practices

1. **Regelmäßige Tests:** Teste Restores mindestens monatlich
2. **Monitoring prüfen:** Checke wöchentlich das [Status Dashboard](https://status.fam.timonrieger.de)
3. **Repository-Check:** Führe monatlich `restic check` aus (siehe [Restic Dokumentation](https://restic.readthedocs.io/en/latest/045_working_with_repos.html))
4. **Kosten überwachen:** Prüfe regelmäßig Kosten im [Storj Dashboard](https://eu1.storj.io/)
5. **Passwort-Sicherheit:** Halte das Restic-Passwort sicher im Password Manager
6. **Backup-Logs prüfen:** Kontrolliere gelegentlich `/home/restic/backup.log` auf Fehler
