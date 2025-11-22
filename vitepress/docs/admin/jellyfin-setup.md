# Jellyfin

Die Jellyfin-Konfiguration liegt unter `/srv/docker/jellyfin/` (siehe [Server-Einrichtung](/admin/server-einrichtung)).

:::tip Jellyfin Dokumentation
Für Installation, Bibliotheken, Benutzer-Verwaltung, Plugins und Troubleshooting siehe die [offizielle Jellyfin-Dokumentation](https://jellyfin.org/docs/).
:::

## Verzeichnisstruktur

Die Jellyfin-Medien sind wie folgt organisiert:

```
/srv/media/family/
├── movies/          # Filme
├── series/          # Serien
└── music/           # Musik (optional)
```

**Dateinamen-Konventionen:**

Für optimale Metadaten-Erkennung folge den Jellyfin Naming Conventions:
- [Filme](https://jellyfin.org/docs/general/server/media/movies)
- [Serien](https://jellyfin.org/docs/general/server/media/shows)
- [Musik](https://jellyfin.org/docs/general/server/media/music)

## Updates

```bash
# Zum Jellyfin-Verzeichnis
cd /srv/docker/jellyfin

# Neues Image pullen
docker compose pull

# Container neu starten
docker compose up -d

# Logs prüfen
docker compose logs -f
```

:::warning Wichtig
Prüfe vor dem Update die [Release Notes](https://github.com/jellyfin/jellyfin/releases) für Breaking Changes.
:::
