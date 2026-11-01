# Samba - Dateifreigabe

Samba ermöglicht dir den Zugriff auf die Dateien des Servers über das Netzwerk. Du kannst von deinen Geräten auf gemeinsame Dateien zugreifen, als wären sie lokal gespeichert.

:::warning Voraussetzung
Du musst mit [Tailscale verbunden](/anwender/tailscale) sein, um auf die Dateifreigaben zugreifen zu können.
:::

## Verbindung herstellen

Verbinde dein Gerät über die Server-URL smb://beelink mit dem SMB-Netzwerk, um auf die Dateifreigaben des Servers zuzugreifen. Als Server URL nutze `smb://beelink`.

## Verfügbare Freigaben

Nach der Verbindung siehst du die verfügbaren Freigaben:

- **family** - Gemeinsame Medienbibliothek für Familienfotos, -videos, -musik, etc.
- **immich** - Deine persönliche Immich-Bibliothek (nur lesend)
- **media** - Filme und Serien (ersetzbar, nicht gesichert)
- **_username_** - Dein persönlicher Ordner für deine Dateien

:::info Immich-Freigabe
Die Freigabe `immich` zeigt dir nur deine eigene Immich-Bibliothek. Sie ist schreibgeschützt - neue Fotos und Videos lädst du über die [Immich-Oberfläche](/anwender/immich) hoch.
:::

:::info Berechtigungen
Du hast nur Zugriff auf die Freigaben, für die du berechtigt bist. Falls du zusätzliche Berechtigungen benötigst, wende dich an einen Administrator.
:::

## Tipps & Tricks

:::tip Backup
Wichtige Dateien auf dem Server werden automatisch gesichert. Trotzdem solltest du besonders wichtige Daten zusätzlich lokal speichern.
:::

:::tip Verbindungsgeschwindigkeit
Die Geschwindigkeit hängt von deiner Internetverbindung ab:

- Im gleichen WLAN: Sehr schnell
- Über Tailscale von außerhalb: Abhängig von der Upload-Geschwindigkeit des Servers und deiner Download-Geschwindigkeit
:::

## Häufige Fragen

### Ich kann keine Verbindung herstellen - was tun?

1. Stelle sicher, dass du mit Tailscale verbunden bist
2. Überprüfe, ob du die richtige Serveradresse verwendest (`beelink` oder `smb://beelink`)
3. Kontrolliere deine Zugangsdaten
4. Versuche, den Server neu zu verbinden
5. Falls das Problem weiterhin besteht, wende dich an einen Administrator

### Kann ich offline auf die Dateien zugreifen?

Nein, du benötigst eine aktive Tailscale-Verbindung. Wenn du Dateien offline benötigst, kopiere sie vorher auf dein lokales Gerät.

### Werden meine Änderungen sofort für alle sichtbar?

Ja, Änderungen werden direkt auf dem Server gespeichert und sind sofort für alle anderen Nutzer sichtbar, sofern sie die notwendigen Berechtigungen haben.

### Wie viel Speicherplatz habe ich?

Ausreichend, der Speicherplatz wird gemeinsam genutzt. Bei Fragen zum verfügbaren Speicher wende dich an einen Administrator.
