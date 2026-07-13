---
outline: deep
---
# Zugriffskontrolle

Zugriffskontrolle bedeutet, dass nur bestimmte Personen und Dienste auf bestimmte Ressourcen zugreifen können. Das gesamte System folgt fünf Regeln, die in einem Satz zusammengefasst sind:

> Jede App ist ein eigener Benutzer, dem ihre eigenen Datenverzeichnisse gehören; Familieninhalte werden nur lesend über die Gruppe `family` geteilt, private Immich-Bibliotheken über personalisierte Samba-Freigaben; Ansible erstellt jedes Verzeichnis; timon administriert mit sudo.

## Die fünf Regeln

1. **Jede App läuft als eigener System-Benutzer, deklariert in der Konfiguration.** Ein Benutzer pro App, ohne Login-Shell, mit fester UID. Jede Compose-Datei deklariert ihn explizit mit den Werten aus der `.env`. Es wird sich **nie** auf den Standard-Benutzer eines Images verlassen.
2. **Jeder App gehören ihre Daten; niemand sonst darf hineinschreiben.** Die Daten-Verzeichnisse gehören der App. Die Konfigurations-Ebene gehört dagegen timon.
3. **Geteilt wird nur über genau zwei Mechanismen:** *Gruppen-Lesezugriff* über `family` für Familieninhalte, und *personalisierte Samba-Freigaben* für die privaten Immich-Bibliotheken.
4. **Ansible ist der einzige Ersteller jedes Bind-Mount-Verzeichnisses.** Kein Host-Verzeichnis darf von Docker automatisch oder von Hand erstellt werden.
5. **Admin-Zugriff ist sudo, nicht Gruppenmitgliedschaft.** timon gehört keinen App-Gruppen an und besitzt keine App-Daten. Root liest für Backups ohnehin alles.

## Benutzer

|**Benutzer**|**UID**|**Führt aus**|**Gruppen**|
|---|---|---|---|
|timon|1000|Mensch, Admin (sudo)|family|
|linus, martin, birgit|1001+|nur Samba, kein Login|family|
|immich|2000|immich-server, immich-ml|family (liest externe Bibliotheken)|
|jellyfin|2001|jellyfin|family (liest Familien-Medien)|
|gitea|2002|gitea|—|
|mealie|2003|mealie|—|
|qbittorrent|2004|qbittorrent|—|
|uptime-kuma|2005|uptime-kuma|—|
|gitea-mirror|2006|gitea-mirror|—|

Die Gruppe `family` hat die feste GID **1002**. Zustandslose API-Clients bekommen keinen Benutzer und keine Host-Mounts, sie halten einen API-Key, keine Dateien.

## Dateistruktur

|**Pfad**|**Eigentümer**|**Modus**|**Grund**|
|---|---|---|---|
|/srv, /srv/media, /srv/originals|root:root|0755|reine Struktur, hier liegt nichts direkt|
|/srv/docker/\<app\>|timon:timon|0750|Konfigurations-Ebene|
|/srv/docker/\<app\>/\<data\>|app:app|0750|Daten-Ebene|
|/srv/originals/immich/**|immich:immich|0750|Immich-Medien; Lesezugriff nur über die Samba-Freigaben|
|/srv/originals/family/**|timon:family|2750|Familien-Medien; immich und jellyfin lesen über die Gruppe|
|/srv/originals/music|timon:family|2750|jellyfin liest über die Gruppe|
|/srv/media/{movies,shows}|timon:family|2750|ersetzbare Medien, jellyfin liest|
|/srv/media/downloads|qbittorrent:qbittorrent|0750|qbittorrent schreibt|
|/usr/bin/restic|root:restic|0750|nur root und die Gruppe restic führen Backups aus|

Wo diese Verzeichnisse physisch liegen, ist unter [Speicherstruktur](/admin/speicher) dokumentiert.

## Ausnahmen

Bewusst kurz gehalten — alles andere folgt den Regeln ohne Sonderfälle:

|**App**|**Ausnahme**|**Grund**|
|---|---|---|
|caddy|läuft als Image-Standard (root)|bindet :80/:443 im Container; Daten liegen in Named Volumes, kein Host-Baum betroffen|
|immich postgres|Postgres-UID des Images besitzt `/srv/docker/immich/postgres`|Datenbank-Images verwalten ihren Benutzer selbst|
|gitea|Image-Init benötigt root|der interne git-Benutzer wird über `USER_UID=2002` auf den gitea-Benutzer gemappt|
|gluetun|läuft als root|benötigt `NET_ADMIN` für das VPN|

## Berechtigungen

|**Action**|**Value**|**Meaning**|
|---|---|---|
|Lesen (r)|4|kann Dateien anzeigen/auflisten|
|Schreiben (w)|2|kann ändern/hinzufügen/entfernen|
|Ausführen (x)|1|kann Verzeichnis betreten oder Dateien ausführen|

Die erste Ziffer bezieht sich auf den Eigentümer, die zweite auf die Gruppe und die dritte auf den Rest. Eine führende `2` (z. B. `2750`) ist das setgid-Bit: neue Dateien erben die Gruppe des Verzeichnisses.

:::info Beispiel
750 bedeutet: der Eigentümer hat vollen Zugriff, die Gruppe darf lesen und das Verzeichnis betreten, alle anderen haben gar keinen Zugriff.
:::

## Einrichtung

Alle Benutzer, Gruppen, Verzeichnisse, ACLs und Samba-Freigaben werden von `setup-permissions.yaml` konfiguriert. Die PUID/PGID-Werte in den `.env.example`-Dateien der Apps müssen mit den UIDs aus dem Playbook übereinstimmen.

:::info
Die Berechtigungen werden in der [Server Einrichtung](server-einrichtung.md#9-berechtigungen-einrichten) ausgeführt.
:::
