# Jellyfin

Die Jellyfin-Konfiguration liegt unter `/srv/docker/jellyfin/` (siehe [Server-Einrichtung](/admin/server-einrichtung)).

:::tip Jellyfin Dokumentation
Für Installation, Bibliotheken, Benutzer-Verwaltung, Plugins und Troubleshooting siehe die [offizielle Jellyfin-Dokumentation](https://jellyfin.org/docs/).
:::

## Verzeichnisstruktur

Jellyfin bindet seine Bibliotheken aus mehreren Pfaden ein:

- `/srv/originals/family/{movies,music}` – Familieninhalte (gesichert)
- `/srv/originals/users/<user>/{movies,music,books}` – persönliche Filme, Musik, Hörbücher und Bücher je Benutzer (gesichert)
- `/srv/media/{movies,shows}` – Filme und Serien (ersetzbar, nicht gesichert)

Die vollständige Verteilung auf die Datenträger ist unter [Speicherstruktur](/admin/speicher) dokumentiert.

**Dateinamen-Konventionen:**

Für optimale Metadaten-Erkennung folge den Jellyfin Naming Conventions:

- [Filme](https://jellyfin.org/docs/general/server/media/movies)
- [Serien](https://jellyfin.org/docs/general/server/media/shows)
- [Musik](https://jellyfin.org/docs/general/server/media/music)
- [Bücher](https://jellyfin.org/docs/general/server/media/books)
