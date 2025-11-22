# Tailscale Server-Installation

Diese Anleitung beschreibt die Installation und Konfiguration von Tailscale auf dem Server.

## Installation auf dem Server

### 1. Tailscale installieren

Tailscale ist bereits installiert nach der Server-Einrichtung.

### 2. Tailscale starten und authentifizieren

```bash
# Tailscale starten
sudo tailscale up

# Tailscale SSH aktivieren
sudo tailscale set --ssh

# Status prüfen
sudo tailscale status
```

Der Befehl `tailscale up` gibt eine URL aus, über die du den Server mit deinem Tailscale-Konto authentifizieren kannst.

### 3. Exit Node aktivieren (optional)

[Tailscale Guide to Exit Nodes](https://tailscale.com/kb/1408/quick-guide-exit-nodes?q=exit+node)

## SSH über Tailscale

SSH ist standardmäßig über Tailscale erreichbar:

```bash
# Von einem anderen Gerät im Tailscale-Netzwerk
ssh <username>@beelink
# oder
ssh <username>@beelink.tail12bab0.ts.net
```