# Admin Überblick

Diese Sektion dokumentiert die technische Infrastruktur, Einrichtung und Administration unseres Familienservers. Hier findest du alle Informationen für die Verwaltung, Wartung und Konfiguration des Systems.

## Tech Stack

- **Hardware:** [Beelink S12 Mini-PC](https://amzn.eu/d/fh4H9aP)
- **Betriebssystem:** Linux mit [Debian 13.1.0 (Trixie)](https://cdimage.debian.org/cdimage/release/13.1.0/amd64/iso-cd/)
- **Netzwerk:** [Tailscale](https://tailscale.com/)
- **Virtualisierung:** [Docker](https://www.docker.com/)
- **Backups:** [Restic](https://restic.net/) (Backup Software) + [Rclone](https://rclone.org/) (Cloud Schnittstelle) + [Storj](https://storj.io/) (Cloud Provider)
- **Speicher:** [WD RED HDD 4TB](https://www.westerndigital.com/products/internal-drives/wd-red-plus-sata-3-5-hdd?sku=WD40EFZZ)
- **Monitoring:** [Uptime Kuma](https://uptime.kuma.pet/)
- **Reverse Proxy:** [Caddy](https://caddyserver.com/)
- **DNS:** [Cloudflare](https://cloudflare.com)
- **Server Konfiguration:** [Ansible](https://www.ansible.com/)
- **Dateifreigabe:** [Samba](https://www.samba.org/)
- **Anwendungen:**
  - [Immich](https://immich.app/) (Fotos)
  - [Jellyfin](https://jellyfin.org/) (Filme, Serien, Musik)
  - [Gitea](https://gitea.com) (Code Hosting)
  - [Gitea Mirror](https://github.com/RayLabsHQ/gitea-mirror) (Git Repository Mirror Tool)

## Schnellstart

Um mit der Administration des Servers zu beginnen:

1. **Zugriff einrichten:** Stelle sicher, dass [Tailscale auf dem Server installiert](/admin/tailscale) ist und du SSH-Zugriff hast
2. **Repository klonen:** Klone das [GitHub Repository](https://github.com/timonrieger/homelab) für Zugriff auf Ansible Playbooks
3. **Server konfigurieren:** Führe die [Server Einrichtung](/admin/server-einrichtung) durch oder aktualisiere bestehende Konfigurationen

## Wartung

**Täglich (automatisiert):**

- Backups werden automatisch täglich ausgeführt

**Monatlich:**

- Speicherplatz prüfen (`df -h`)
- [Backup-Integrität](./backups#überwachung) testen
- Docker Clean up (`mise run ansible:cleanup-docker`)
- Anwendungen auf neueste Versionen aktualisieren (Renovate Bot)
- System Update (`mise run ansible:update-deps`)
- [Backups aufräumen](/admin/backups#aufräumen)
