---
outline: deep
---
# Zugriffskontrolle

Zugriffskontrolle bedeutet, dass nur bestimmte Personen auf bestimmte Ressourcen zugreifen können. Dies ist wichtig, um Datenschutz und Sicherheit zu gewährleisten. Allerdings ist es auch wichtig, dass die Familie gemeinsam auf die Ressourcen zugreifen kann und keine Abhängigkeit von bestimmten Personen besteht.

## Dateistruktur

|**Folder**|**Reason for its mode**|**Eigentümer**|**Gruppe**|**Beschränkungen**|
|---|---|---|---|---|
|/srv/media/family|Gemeinsam genutzte Dateien, voller Lesezugriff für Familie|timon|family|750|
|/srv/media/immich|Immich and backup group need full control; not world-readable|timon|immich|750|
|/srv/docker|Besitzer kann Container verwalten, Gruppe kann nur Konfiguration lesen|timon|timon|750|
|/usr/bin/restic|Nur root und Benutzer der Gruppe restic können Backups durchführen|root|restic|750|

Die erste Ziffer bezieht sich auf dein Eigentümer, die zweite auf die Gruppe und die dritte auf den Rest. Die Ziffer setzt sich aus der Summe der einzelnen Aktionen zusammen.

:::info Beispiel
770 bedeuted, dass der Eigentümer und die Gruppe des Verzeichnisses, vollen Zugriff haben, alle anderen haben gar keinen Zugriff
:::

:::info Drive Structure
The following directories are on the HDD at `/mnt/hdd/`:

- /srv/media/family/
- /srv/media/immich/library/library/

All other directories are on the SSD.
:::

## Berechtigungen

|**Action**|**Value**|**Meaning**|
|---|---|---|
|Lesen (r)|4|kann Dateien anzeigen/auflisten|
|Schreiben (w)|2|kann ändern/hinzufügen/entfernen|
|Ausführen (x)|1|kann Verzeichnis betreten oder Dateien ausführen|

:::info
Verwende root:root, wenn das Verzeichnis Teil der Systemstruktur ist, die Sie abschalten wollen.
Verwende timon:timon, wenn timon den Inhalt aktiv verwalten oder besitzen soll.

Die Standardberechtigung für den neu erstellten Ordner ist `0777 - 0022 (unmask) = 0755`
:::

## Einrichtung der Freigaben

Alle Einstellungen für Dateifreigaben werden in der `setup-permissions.yaml` Datei gespeichert. Diese Datei wird von Ansible ausgeführt, um die Berechtigungen und Freigaben zu konfigurieren. Dabei werden auch Nutzerprofile für Samba erstellt.

:::info
Die Berechtigungen werden in der [Server Einrichtung](server-einrichtung.md#8-berechtigungen-einrichten) ausgeführt.
:::

## FAQ

### Was bestimmt die Standardberechtigungen für einen neuen Ordner?

Die `umask` des Prozesses bestimmt den Standardmodus; die Berechtigungen für übergeordnete Ordner werden nicht automatisch übertragen.

### Gewährt das Root-Eigentum an einem Ordner Zugriff auf alle Kinder?

Nein, bestehende oder neue Unterordner behalten ihre eigenen Rechte, sofern sie nicht explizit geändert werden.

### Was ist der Unterschied zwischen root:root und einem sudo-Benutzer für den Besitz eines Ordners?

Root:root sperrt den Ordner auf der Systemebene; sudo-Benutzer können ihn ändern, wenn sie eskalieren. Verwende sudo-Benutzer als Eigentümer, wenn dieser Benutzer den Inhalt aktiv verwaltet.

### Kann Docker in einen Host-Ordner schreiben, der Root gehört?

Ja, wenn der Container im Inneren als root läuft. Wenn er als Nicht-Root läuft, muss die UID innerhalb des Containers mit dem Host-Eigentum übereinstimmen oder Schreibrechte haben.

### Was ist der Zweck von `append: true` bei der Benutzererstellung in Ansible?

Es fügt den Benutzer zu den angegebenen Gruppen hinzu, ohne bestehende Gruppenmitgliedschaften zu entfernen.

### Wie kann ich einen Ordner für eine Gruppe freigeben, aber für andere privat machen?

Setze die Gruppe des Ordners auf die gewünschte Gruppe und den Modus auf 0750 (oder 0770 für Gruppenschreiben). Setze optional das setgid-Bit, damit neue Dateien die Gruppe erben.

### Wie erstelle ich ein Benutzerkonto ohne Login?

Setze die Shell beim Anlegen des Benutzers auf `/usr/sbin/nologin`.

### Kann ich die Anmeldung für einen nologin-Benutzer später aktivieren?

Ja, ändern Sie die Shell auf `/bin/bash` und entsperre das Passwort.

### Wie erzwinge ich den Datenschutz pro Benutzer in einem gemeinsamen Verzeichnis?

Lege für jeden Benutzer einen eigenen Ordner an, der dem jeweiligen Benutzer mit dem Modus 0700 gehört.

### Beeinflusst der Docker-Compose-Ordner den Container-Zugriff auf gemountete Volumes?

Nein, der Zugriff wird durch die Eigentümerschaft/Berechtigungen des Host-Ordners und die UID/GID innerhalb des Containers bestimmt, nicht dadurch, wo sich die Compose-Datei befindet.
