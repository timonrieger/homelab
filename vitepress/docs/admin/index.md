# Admin Überblick

![Backup](https://healthchecks.io/b/2/5ded10ce-57ba-47ef-8914-21c5bc581992.svg)

Diese Sektion dokumentiert die technische Infrastruktur, Einrichtung und Administration unseres Familienservers. Hier findest du alle Informationen für die Verwaltung, Wartung und Konfiguration des Systems.

## Tech Stack

- **Hardware:** [Beelink S12 Mini-PC](https://amzn.eu/d/fh4H9aP)
- **Betriebssystem:** Linux mit [Debian 13.1.0 (Trixie)](https://cdimage.debian.org/cdimage/release/13.1.0/amd64/iso-cd/)
- **Netzwerk:** [Tailscale](https://tailscale.com/)
- **Virtualisierung:** [Docker](https://www.docker.com/)
- **Backups:** [Restic](https://restic.net/) (Backup Software) + [Rclone](https://rclone.org/) (Cloud Schnittstelle) + [Storj](https://storj.io/) (Cloud Provider)
- **Speicher:** [WD RED HDD 4TB](https://www.westerndigital.com/products/internal-drives/wd-red-plus-sata-3-5-hdd?sku=WD40EFZZ)
- **Server Konfiguration:** [Ansible](https://www.ansible.com/)
- **Anwendungen:**
  - [Immich](https://immich.app/) (Fotos)
  - [Jellyfin](https://jellyfin.org/) (Filme, Serien, Musik)
  - [Samba](https://www.samba.org/) (Dateifreigabe)

## Dokumentation

### Einrichtung & Konfiguration
- [Server Einrichtung](/admin/server-einrichtung) - Initiale Installation und Setup
- [Zugriffskontrolle](/admin/zugriffskontrolle) - Berechtigungen und Sicherheit
- [Backups](/admin/backups) - Backup-Konfiguration und -Verwaltung

### Services
- [Tailscale](/admin/tailscale) - VPN-Netzwerk Server-Installation
- [Immich](/admin/immich-setup) - Foto-Management Server-Setup
- [Jellyfin](/admin/jellyfin-setup) - Media-Server Setup
- [Samba](/admin/samba-setup) - Dateifreigabe Konfiguration

## Schnellstart

Um mit der Administration des Servers zu beginnen:

1. **Zugriff einrichten:** Stelle sicher, dass [Tailscale auf dem Server installiert](/admin/tailscale) ist und du SSH-Zugriff hast
2. **Repository klonen:** Klone das [GitHub Repository](https://github.com/timonrieger/family-server) für Zugriff auf Ansible Playbooks
3. **Server konfigurieren:** Führe die [Server Einrichtung](/admin/server-einrichtung) durch oder aktualisiere bestehende Konfigurationen

## Wichtige Befehle

### SSH Zugriff
```bash
ssh <username>@beelink
```

### Docker Container verwalten
```bash
# Status aller Container prüfen
docker ps -a

# Container starten/stoppen
docker compose up -d
docker compose down

# Logs anzeigen
docker compose logs -f
```

### Backups prüfen
```bash
# Backup Status
sudo -u restic restic -r <repository> snapshots

# Letztes Backup prüfen
sudo -u restic restic -r <repository> snapshots --last
```

### System Updates
```bash
# System aktualisieren
sudo apt update && sudo apt upgrade -y

# Docker Images aktualisieren
cd /srv/docker/<service>
docker compose pull
docker compose up -d
```

## Wartung

### Regelmäßige Aufgaben

**Täglich (automatisiert):**
- Backups werden automatisch um 02:00 Uhr ausgeführt
- Backup-Status wird auf healthchecks.io gemeldet

**Wöchentlich:**
- System Updates prüfen und installieren
- Speicherplatz prüfen (`df -h`)
- Docker Container Status prüfen (`docker ps -a`)

**Monatlich:**
- Backup-Integrität testen
- Log-Dateien prüfen und bereinigen
- Nicht verwendete Docker Images entfernen (`docker system prune`)

### Monitoring

**Backup Status:**
- [Healthchecks Dashboard](https://healthchecks.io/checks/) - Backup-Monitoring
- Badge oben auf dieser Seite zeigt aktuellen Status

**System Status:**
```bash
# System-Ressourcen
htop

# Festplatten-Auslastung
df -h

# Docker Container Status
docker stats
```

## Sicherheit

### Best Practices

1. **SSH-Keys verwenden:** Authentifizierung über SSH-Keys statt Passwörter
2. **Regelmäßige Updates:** System und Docker Images aktuell halten
3. **Zugriffskontrolle:** [Berechtigungen](/admin/zugriffskontrolle) regelmäßig prüfen
4. **Backups testen:** Regelmäßig Restore-Tests durchführen
5. **Tailscale:** Server nur über Tailscale erreichbar, keine Port-Forwarding

### Wichtige Dateien

**Auf dem Server:**
- `/srv/docker/` - Docker Compose Konfigurationen
- `/srv/media/` - Media-Dateien und Datenbanken
- `/etc/samba/smb.conf` - Samba Konfiguration
- `/home/<user>/.config/rclone/rclone.conf` - Rclone Konfiguration
- `/usr/local/bin/backup.sh` - Backup Script

**Im Repository:**
- `ansible/` - Ansible Playbooks und Konfiguration
- `docker/` - Docker Compose Templates
- `vitepress/` - Diese Dokumentation

## Support & Ressourcen

- **GitHub Repository:** [timonrieger/family-server](https://github.com/timonrieger/family-server)
- **Immich Dokumentation:** [immich.app/docs](https://immich.app/docs)
- **Jellyfin Dokumentation:** [jellyfin.org/docs](https://jellyfin.org/docs)
- **Tailscale Dokumentation:** [tailscale.com/kb](https://tailscale.com/kb)

