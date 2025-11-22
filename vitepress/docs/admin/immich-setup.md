# Immich

Die Immich-Konfiguration liegt unter `/srv/docker/immich/` (siehe [Server-Einrichtung](/admin/server-einrichtung)).

:::tip Immich Dokumentation
Für Installation, Benutzer-Verwaltung, Bibliotheken und Troubleshooting siehe die [offizielle Immich-Dokumentation](https://immich.app/docs).
:::

## Konfiguration

### Storage Template

Nach der Installation empfohlenes Storage Template setzen:

1. Login als Admin
2. **Administration** → **Server Settings** → **Storage Template**
3. Template eintragen:

```
{{y}}/{{MM}}/{{dd}}/{{filename}}
```

Dies organisiert Uploads nach Jahr/Monat/Tag und erleichtert die Verwaltung.

## Verzeichnisstruktur

Die Immich-Daten sind wie folgt organisiert:

```
/srv/media/immich/
├── upload/          # Immich Standard-Upload-Verzeichnis
└── library/
    └── library/
        ├── user1/   # Persönlicher Ordner User 1 (via Samba zugänglich)
        ├── user2/   # Persönlicher Ordner User 2 (via Samba zugänglich)
        └── ...
```

- Die Ordner unter `/srv/media/family/photos` werden als [External Library](https://immich.app/docs/features/libraries) in Immich eingebunden
- Jeder Benutzer hat **Lesezugriff** auf die Bibliotheken über [Samba](/admin/samba)
- **Fotos können nur über die Immich-UI hochgeladen werden** - Samba ist read-only konfiguriert

## Updates

```bash
# Zum Immich-Verzeichnis
cd /srv/docker/immich

# Neue Images pullen
docker compose pull

# Container neu starten
docker compose up -d

# Logs prüfen
docker compose logs -f immich-server
```

:::warning Wichtig
Prüfe vor dem Update die [Release Notes](https://github.com/immich-app/immich/releases) für Breaking Changes.
:::
