# Tailscale einrichten

[Tailscale](https://tailscale.com/) ermöglicht dir den sicheren Zugriff auf unseren Familienserver von überall auf der Welt. Du kannst dir Tailscale wie ein privates VPN-Netzwerk vorstellen, das nur für unsere Familie zugänglich ist.

:::warning Wichtig
Du kannst nur auf den Server und alle darauf liegenden Services (Immich, Jellyfin, Samba) zugreifen, wenn du mit Tailscale verbunden bist.
:::

## Installation

1. Lade die [Tailscale App](https://tailscale.com/download) herunter
2. Öffne die App und tippe auf **Get Started**
3. Melde dich mit deinem Tailscale Account an oder erstelle ein neues Konto
4. Nach der Anmeldung bist du automatisch mit dem Netzwerk verbunden

## Verwendung

### Verbindung aktivieren

**iPhone/iPad:**
- Öffne die Tailscale App und tippe auf **Connect**
- Alternativ: Gehe zu **Einstellungen** → **VPN** → **Tailscale** und aktiviere die Verbindung

**Mac:**
- Klicke auf das Tailscale-Symbol in der Menüleiste
- Wähle **Connect to Tailscale**

**Windows:**
- Klicke auf das Tailscale-Symbol in der Taskleiste
- Wähle **Connect**

**Android:**
- Öffne die Tailscale App und tippe auf **Connect**

### Verbindung trennen

Du kannst Tailscale jederzeit deaktivieren, wenn du keinen Zugriff auf den Server benötigst.

:::tip Tipp
Du musst Tailscale nur dann aktivieren, wenn du auf unsere Services zugreifen möchtest. Für die normale Internetnutzung ist die Verbindung nicht notwendig.
:::

## Exit Node (Optional)

Ein Exit Node routet deinen gesamten Internetverkehr über unseren Server. Das ist besonders nützlich in öffentlichen WLANs (Cafés, Flughäfen), da dein Datenverkehr dann verschlüsselt und sicher ist.

**Wann solltest du einen Exit Node nutzen?**
- In öffentlichen, ungesicherten WLAN-Netzwerken
- Wenn du zusätzliche Privatsphäre möchtest

**Wann ist ein Exit Node NICHT notwendig?**
- Zuhause im eigenen WLAN
- Bei der normalen Nutzung von mobilem Internet

### Exit Node aktivieren

**iPhone/iPad:**
1. Öffne die Tailscale App
2. Tippe auf die **drei Punkte** (···) neben "beelink"
3. Wähle **Use as exit node**
4. Aktiviere optional **Allow LAN access** um weiterhin auf lokale Geräte zugreifen zu können

**Mac/Windows:**
1. Klicke auf das Tailscale-Symbol
2. Wähle **Exit Node** → **beelink**
3. Optional: Aktiviere **Allow LAN access**

[Mehr über Exit Nodes erfahren](https://tailscale.com/kb/1103/exit-nodes)

## VPN on Demand (Optional)

Mit VPN on Demand verbindet sich Tailscale automatisch, wenn du es brauchst. Dies ist besonders nützlich für automatische Backups mit Immich, die im Hintergrund laufen.

[Mehr über VPN on Demand erfahren](https://tailscale.com/kb/1291/ios-vpn-on-demand)

**Empfohlene Einstellungen für automatische Backups (iOS):**

1. Öffne die Tailscale App
2. Gehe zu **Settings** → **VPN On Demand**
3. Setze folgende Einstellungen:
   - **WLAN**: Wähle **Always** (Immer)
   - **Mobilfunk**: Wähle **Always** (Immer)

Mit diesen Einstellungen verbindet sich Tailscale automatisch, sodass Immich deine Fotos auch dann sichern kann, wenn du die App nicht aktiv verwendest.

:::info Hinweis
Wenn du keine automatischen Backups nutzt, ist VPN on Demand nicht notwendig. Du kannst Tailscale dann einfach manuell aktivieren, wenn du auf den Server zugreifen möchtest.
:::

