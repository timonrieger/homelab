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

## Wartung

**Täglich (automatisiert):**
- Backups werden automatisch täglich ausgeführt
- Backup-Status wird auf healthchecks.io gemeldet

**Wöchentlich:**
- Docker Container Status prüfen (`ds`)

**Monatlich:**
- Speicherplatz prüfen (`df -h`)
- [Backup-Integrität](./backups#überwachung) testen
- Anwendungen auf neueste Versionen aktualisieren
  - Docker: `docker compose pull && docker compose up -d`
  - Apt: `sudo apt update && sudo apt upgrade -y`

