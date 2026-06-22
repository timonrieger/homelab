# Speicherstruktur

Die gesamte Datenablage folgt einer einzigen Regel, die sowohl Backups als auch die Verteilung auf die
Datenträger bestimmt:

- **`/srv/originals/`** – unersetzliche Daten (Fotos, Familienvideos, persönliche Musik) → **immer gesichert**
- **`/srv/media/`** – ersetzbare Inhalte (Jellyfin Filme/Serien, Downloads, neu beschaffbar) → **nicht gesichert**

## Datenträger

|Datenträger|Inhalt|
|---|---|
|Primäre HDD (`/mnt/hdd`)|`/srv/originals` und `/srv/media` (über Bind-Mounts eingehängt)|
|Sekundäre HDD (`/mnt/hdd2`)|`originals/` als nächtlicher rsync-Mirror von `/srv/originals`|
|SSD|Betriebssystem und alles unter `/srv/docker/` (App-Daten inkl. Immich Postgres/Thumbnails)|

:::info Bind-Mounts
`/srv/originals` und `/srv/media` sind keine eigenen Partitionen, sondern Bind-Mounts auf die primäre HDD
(`/mnt/hdd/originals` bzw. `/mnt/hdd/media`). So liegen die Daten physisch auf der HDD, sind aber unter dem
aufgeräumten `/srv`-Pfad erreichbar.
:::

## Verzeichnisstruktur

```txt
/srv/originals/              # Unersetzlich – immer gesichert (HDD)
├── music/                   # Persönliche Musik (Jellyfin)
├── family/                  # Familienmedien (Samba-Freigabe „family")
│   ├── photos/              # Immich External Library
│   ├── clips/               # Immich External Library
│   ├── movies/              # Jellyfin
│   └── music/               # Jellyfin
└── immich/
    ├── upload/
    └── library/             # Persönliche + family Ordner

/srv/media/                  # Ersetzbar – nicht gesichert (HDD)
├── movies/                  # Jellyfin Filme
├── shows/                   # Jellyfin Serien
└── downloads/               # qBittorrent

/srv/docker/                 # App-Konfiguration & -Daten (SSD)
└── immich/                  # postgres, thumbs, encoded-video, profile, backups
```

Regenerierbare Daten (Thumbnails, Transcodes, Datenbank) liegen bewusst auf der SSD unter `/srv/docker/` –
schneller im Zugriff und nicht Teil des HDD-Mirrors, da sie jederzeit aus den Originalen reproduzierbar sind.

## Weiterführend

- **Backup-Strategie** (3 Kopien, 2 Medien, 1 offsite): [Backups](/admin/backups#_3-2-1-strategie)
- **Eigentümer und Berechtigungen** dieser Verzeichnisse: [Zugriffskontrolle](/admin/zugriffskontrolle)
