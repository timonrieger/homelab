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

```txt
{{y}}/{{MM}}/{{dd}}/{{filename}}
```

Dies organisiert Uploads nach Jahr/Monat/Tag und erleichtert die Verwaltung.

## Verzeichnisstruktur

Die Immich-Daten sind auf zwei Datenträger aufgeteilt: unersetzliche Originale auf der HDD unter
`/srv/originals/immich`, regenerierbare Derivate und die Postgres-Datenbank auf der SSD unter
`/srv/docker/immich`. Hintergrund dazu unter [Speicherstruktur](/admin/speicher).

```txt
/srv/originals/immich/        # Originale (HDD, gesichert)
├── upload/                   # Immich Standard-Upload-Verzeichnis
└── library/
    ├── timon/                # Persönlicher Ordner (via Samba zugänglich)
    ├── linus/
    ├── …
    └── family/               # Gemeinsamer Familien-Ordner

/srv/docker/immich/           # Regenerierbare Daten + DB (SSD, nicht gespiegelt)
├── postgres/                 # Postgres-Datenbank
├── thumbs/                   # Thumbnails
├── encoded-video/            # Transcodierte Videos
├── profile/                  # Profilbilder
├── model-cache/              # ML-Modelle
└── backups/                  # Immich Datenbank-Dumps
```

Der gesamte Baum gehört dem System-Benutzer `immich` (UID 2000); die Container laufen als dieser Benutzer.
Details unter [Zugriffskontrolle](/admin/zugriffskontrolle).

- Die Ordner unter `/srv/originals/family/photos` und `/srv/originals/family/clips` werden als [External Library](https://immich.app/docs/features/libraries) in Immich eingebunden (read-only, Zugriff über die Gruppe `family`)
- Jeder Benutzer hat **Lesezugriff** auf seine Bibliothek über Samba
- **Fotos können nur über die Immich-UI hochgeladen werden** - Samba ist read-only konfiguriert
