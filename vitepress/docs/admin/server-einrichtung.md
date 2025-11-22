# Server Einrichtung

:::warning Achtung!
Die Server Einrichtung ist grundsätzlich ein einmaliges Ereignis und sollte von Administratoren durchgeführt werden. Sämtliche hier genannten Schritte sind potenziell destruktiv und verändern den Zustand des Servers.
:::

## Vorbereitung

1. Verbinde den Mini-PC mit dem Router (über LAN-Kabel)
2. Monitor anschließen (über HDMI-Kabel (gleicher Kanal wie der Monitor))
3. Tastatur und Maus anschließen (über USB-Kabel)
4. Flashe einen USB-Stick mit der gewünschten Linux-Distribution

```bash
# Alle Laufwerke auflisten
diskutil list

# USB identifizieren
# USB aushängen
diskutil unmountDisk /dev/disk6

# Linux ISO herunterladen
# z.B. https://cdimage.debian.org/cdimage/release/current/amd64/iso-cd/

# Linux ISO auf USB schreiben
sudo dd if=$HOME/Downloads/debian-13.1.0-amd64-netinst.iso of=/dev/rdisk6 bs=4m status=progress

# USB auswerfen
diskutil eject /dev/disk6
```

5. USB-Stick in USB Port des Mini-PCs stecken
6. Stromkabel anschließen und verbinden

## Booten

1. Einschalten und wiederholt F7 drücken
2. Wähle "Installieren" (nicht "Grafik-Installation")
3. Wähle das USB-Laufwerk
4. Schließe die Installation ab, bis ein hellblauer Hintergrund mit drei Auswahlmöglichkeiten angezeigt wird
5. Dort wähle "UEFI-Firmware-Einstellungen" > Erweitert > ACPI-Einstellungen
6. Setze "Enable Hibernation" auf "Disabled" (verhindert den Ruhezustand)
7. Setze "ACPI Ruhezustand" auf "Suspend Disabled"
8. Speichern, beenden und booten

Die Schritte 5-7 können auch über die Konsole aktiviert werden:

```bash
sudo systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target
```

## Server Konfiguration

### 1. Repository klonen

```bash
git clone https://github.com/timonrieger/family-server.git
cd family-server/ansible
```

### 2. Konfigurationsdateien vorbereiten

```bash
# Beispieldateien kopieren
cp files/rclone.conf.example files/rclone.conf
cp files/backup.sh.example files/backup.sh
```

Passe alle `REPLACE-ME` Platzhalter in diesen Dateien mit den richtigen Werten an.

### 3. Tailscale einrichten

Richte [Tailscale auf dem Server](/admin/tailscale) ein, sodass du über Tailscale SSH auf den Server zugreifen kannst.

### 4. Inventory konfigurieren

Passe die `inventory.ini` Datei mit deinem eingerichteten Benutzernamen an:

```ini
[beelink]
beelink ansible_user=<dein-username>
```

### 5. Verbindung testen

```bash
ansible beelink -m ping -i inventory.ini
```

Erwartete Ausgabe:
```
beelink | SUCCESS => {
    "changed": false,
    "ping": "pong"
}
```

### 6. Server einrichten

```bash
ansible-playbook -i inventory.ini setup-server.yaml --ask-become-pass
```

### 7. Backups konfigurieren

```bash
ansible-playbook -i inventory.ini setup-backups.yaml --ask-become-pass
```

### 8. Berechtigungen einrichten

```bash
ansible-playbook -i inventory.ini setup-permissions.yaml --ask-become-pass
```

Mehr Details: [Zugriffskontrolle](/admin/zugriffskontrolle)

## Wartung

### System Updates

```bash
# Regelmäßig ausführen
sudo apt update && sudo apt upgrade -y
```

### Docker Updates

```bash
# Images aktualisieren
cd /srv/docker/<service>
docker compose pull
docker compose up -d
```

### Backup-Wartung

```bash
# Alte Snapshots bereinigen (behalte letzte 30 Tage)
sudo -u restic restic -r rclone:storj:bucket/path forget --keep-daily 30 --prune
```

## Nächste Schritte

- [Zugriffskontrolle konfigurieren](/admin/zugriffskontrolle)
- [Backup-Strategie verstehen](/admin/backups)
- [Immich einrichten](/admin/immich-setup)
- [Jellyfin konfigurieren](/admin/jellyfin-setup)
- [Samba Freigaben verwalten](/admin/samba-setup)

