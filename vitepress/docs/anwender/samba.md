# Samba - Dateifreigabe

Samba ermöglicht dir den Zugriff auf die Dateien des Servers über das Netzwerk. Du kannst von deinen Geräten auf gemeinsame Dateien zugreifen, als wären sie lokal gespeichert.

:::warning Voraussetzung
Du musst mit [Tailscale verbunden](/anwender/tailscale) sein, um auf die Dateifreigaben zugreifen zu können.
:::

## Verbindung herstellen

[Frage ChatGPT](https://chat.openai.com/?q=Wie%20kann%20ich%20auf%20die%20Dateifreigaben%20des%20Servers%20zugreifen%20%C3%BCber%20das%20SMB%20Netzwerk%2C%20zum%20Beispiel%20mit%20der%20Server-URL%20smb%3A%2F%2Fbeelink%3F%20Ich%20nutze%20Windows%2C%20Android%2C%20MacOS%20und%20iOS). Als Server URL nutze `smb://beelink`.

## Verfügbare Freigaben

Nach der Verbindung siehst du die verfügbaren Freigaben:

- **media** - Gemeinsame Medienbibliothek für Fotos, Videos, Musik, etc.
- **_username_** - Dein persönlicher Ordner für deine Dateien

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
