# Immich - Fotos & Videos

![Immich](https://status.fam.timonrieger.de/api/badge/2/status)

[Immich](https://immich.app) ist unsere Lösung für Foto- und Videoverwaltung. Du kannst damit automatische Backups von deinem Smartphone erstellen, Fotos mit der Familie teilen und von überall auf deine Bilder zugreifen.

## Zugriff auf Immich

:::warning Voraussetzung
Du musst mit [Tailscale verbunden](/anwender/tailscale) sein, um auf Immich zugreifen zu können.
:::

**Im Browser:**

- [https://immich.fam.timonrieger.de](https://immich.fam.timonrieger.de) (empfohlen)
- [http://beelink:2283](http://beelink:2283)
- [http://beelink.tail12bab0.ts.net:2283](http://beelink.tail12bab0.ts.net:2283)

oder nutze die [Immich App](https://immich.app/download).

## Anmelden

1. Öffne Immich im Browser oder in der App
2. Gib eine der oben genannten Server-URLs ein
3. Melde dich mit deinen Zugangsdaten an

:::info Zugangsdaten
Falls du noch keine Zugangsdaten hast, wende dich an einen Administrator, um einen Account erstellt zu bekommen.
:::

## Automatische Backups

Die mobile App kann automatisch alle deine Fotos und Videos auf den Server hochladen.

[Mehr über automatische Backups erfahren](https://docs.immich.app/features/automatic-backup)

:::tip Tipp für iOS
Damit das Backup zuverlässig im Hintergrund läuft, solltest du zwei Einstellungen aktivieren:

1. **Tailscale VPN on Demand** aktivieren (siehe [Tailscale VPN on Demand](/anwender/tailscale#vpn-on-demand-optional)), damit Tailscale sich automatisch verbindet
2. **Hintergrundaktualisierung** für Immich aktivieren:
   - Gehe zu **iOS Einstellungen** → **Immich** → **Hintergrundaktualisierung**
   - Wähle **WLAN & Mobile Daten** (oder nur **WLAN**)

Mit diesen Einstellungen werden deine Fotos automatisch gesichert, ohne dass du die App öffnen musst.
:::

## Tipps & Tricks

:::warning Hinweis zu geteilten Bibliotheken
Die Teilung von Bibliotheken ist noch nicht vollständig implementiert ([#12614](https://github.com/immich-app/immich/issues/12614)). Daher nutzen wir ein separates Konto für die Familie. Logge dich mit deinem separaten Konto ein, um auf die geteilten Bibliotheken zuzugreifen.
:::

:::tip Speicherplatz sparen
Nachdem deine Fotos auf den Server hochgeladen wurden, kannst du sie vom Smartphone löschen, um Speicherplatz zu sparen. Sie bleiben auf dem Server gespeichert und sind jederzeit abrufbar. Dafür wähle alle Fotos in der Timeline aus und wähle "Vom Gerät löschen" aus.
:::

## Häufige Fragen

### Werden meine Fotos gelöscht, wenn ich sie vom Handy lösche?

Nein. Fotos, die bereits auf den Server hochgeladen wurden, bleiben dort gespeichert, auch wenn du sie lokal löschst.

### Kann ich Fotos auch über den Browser hochladen?

Ja, in der Web-Version kannst du über den **Upload-Button** Fotos von deinem Computer hochladen.

### Wie viel Speicherplatz habe ich?

Der Speicherplatz wird gemeinsam genutzt. Bei Fragen zum verfügbaren Speicher wende dich an einen Administrator.

### Was passiert, wenn ich nicht mit Tailscale verbunden bin?

Ohne Tailscale-Verbindung kannst du nicht auf Immich zugreifen. Deine Fotos werden dann nicht automatisch gesichert.
