# Backups

Das Backup-System basiert auf drei Komponenten:

- **[Restic](https://restic.readthedocs.io/)** - Backup-Software mit Verschlüsselung und Deduplizierung
- **[Rclone](https://rclone.org/)** - Schnittstelle zu Cloud-Speicher
- **[Storj](https://www.storj.io/)** - Dezentraler Cloud-Speicher-Anbieter

## Übersicht

Die Backup-Richtlinie folgt einer einzigen Regel: Alles unter `/srv` und `/home` wird gesichert, **außer**
den ersetzbaren Inhalten unter `/srv/media/`. Diese Trennung ist Teil der [Speicherstruktur](/admin/speicher).

**Was wird gesichert:**

- `/srv/originals/` (unersetzliche Originale: Immich-Fotos, Familienmedien, persönliche Medien)
- `/srv/docker/` (Docker-Konfigurationen und App-Daten, inkl. Immich Postgres)
- `/home/` (Benutzerdaten)

**Was wird NICHT gesichert:**

- `/srv/media/` (ersetzbare Inhalte: Jellyfin Filme/Serien, qBittorrent Downloads)
- App Caches und Logs
- System-Dateien - bei Bedarf neu aufsetzen

**Backup-Zeitplan:**

|Job|Zeit|Timeout|Skript|
|---|---|---|---|
|Immich Datenbank-Dump|täglich 01:30|-|Immich: Administration > Settings > Database Dump Settings|
|Datenbank-Dumps|täglich 01:45|-|`/root/db-dumps.sh`|
|restic Backup nach Storj|täglich 02:00|`3h`|`/home/restic/backup.sh`|
|rsync-Mirror auf die zweite HDD|täglich 05:05|`30m`|`/root/mirror.sh`|

- Retention: `--keep-daily 7 --keep-weekly 4 --keep-monthly 6 --keep-yearly 2`

Beide Cronjobs werden von `setup-backups.yaml` als root-Cronjobs angelegt.

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
- Im Repository: `playbooks/files/rclone.conf`

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

### Storj-Zugang neu einrichten

Restic-Passwort und Haupt-Access-Grant liegen im Password Manager. Daraus ein Child-Grant für `rclone.conf` erzeugen:

```bash
uplink access restrict --access $PRIMARY_GRANT --readonly=false --not-after "+365d"
```

Für einen Restore-Test reicht ein Read-only-Grant (`--readonly=true`), restic dann mit `--no-lock` ausführen.

## Datenbanken

`db-dumps.sh` legt konsistente Kopien der SQLite-Datenbanken aus `playbooks/files/db-dumps.list` und einen Hardlink
auf den neuesten Immich-Dump unter `/srv/db-dumps/` ab. Ein fehlgeschlagener Dump behält den vorherigen. `backup.sh`
meldet fehlende oder veraltete Dumps per Heartbeat als `down`.

## Sekundärer HDD-Mirror

Zusätzlich zum restic-Backup spiegelt ein nächtlicher rsync-Befehl die Originale auf die sekundäre HDD.

## Überwachung

Beide Skripte melden ihr Ergebnis per Push-Heartbeat an [Uptime Kuma](https://status.fam.timonrieger.de). Ein fehlgeschlagener oder in den Timeout gelaufener Lauf schlägt Alarm, Logs sind für die Detailanalyse.

Der Mirror meldet zusätzlich den freien Platz der zweiten HDD und schlägt unter 15 GB Alarm.

```bash
# restic-Backup
sudo -u restic tail /home/restic/backup.log -n 200

# Sekundärer HDD-Mirror
sudo tail /root/mirror.log -n 200
```

:::info Verhalten bei Fehlern

- Nach **jedem** Lauf führt das Skript `restic unlock` aus, damit ein abgebrochener oder abgelaufener
  Lauf keine Stale Locks im Repository hinterlässt.
- `forget --prune` läuft **nur nach einem erfolgreichen Backup**. Nach einem Fehlschlag bleiben alte
  Snapshots also erhalten.
:::

## Wiederherstellung

Falls der Server komplett neu aufgesetzt werden muss oder einzelne Daten wiederhergestellt werden müssen.

### Komplette Wiederherstellung

1. Neuen [Server einrichten](/admin/server-einrichtung) bis einschließlich `setup-server`
2. restic und rclone installieren, [Storj-Zugang](#storj-zugang-neu-einrichten) einrichten
3. Als root wiederherstellen (`/srv/docker`, `/srv/db-dumps`, `/home`, bei Totalverlust auch `/srv/originals`)
4. Datenbanken aus `/srv/db-dumps/` zurückspielen
5. Gitignored Konfiguration lokal vs. Server vergleichen, die neuere Seite gewinnt
6. `setup-permissions`, `setup-networks`, `restart-containers`
7. Erst danach `setup-backups`, sonst sichern bzw. spiegeln die Cronjobs ein halbfertiges System

### Einzelne Services wiederherstellen

**Bei Datenverlust oder Korruption:**

1. Betroffenen Container stoppen
2. Mit Restic spezifische Pfade wiederherstellen (z.B. `/srv/originals/immich` oder `/srv/docker`)
3. Berechtigungen prüfen/korrigieren
4. Container neu starten

Detaillierte Restic-Befehle für Restore-Operationen: [Restic Restore Dokumentation](https://restic.readthedocs.io/en/latest/050_restore.html)
