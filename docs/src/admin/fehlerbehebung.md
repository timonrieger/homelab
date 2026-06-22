# Fehlerbehebung

Dieser Abschnitt enthält Informationen zur Fehlerbehebung bei allgemeinen Problemen.

## APT Cache Update Fehler

### Problem

Ansibles `apt` Modul schlägt mit einem leeren Fehler fehl, wenn `update_cache: true` verwendet wird. Das liegt daran, dass `python3-apt` eine `FetchFailedException` ohne Meldung auslöst, wenn Repositories die Signaturprüfung nicht bestehen (z.B. der SHA1-Schlüssel des Fish Shell-Repos wird von Debian Trixies `sqv` seit 2026-02-01 abgelehnt).

### Fix

Aktualisieren Sie den Fish Shell GPG-Schlüssel, um die SHA256-signierte Version zu erhalten:

```bash
curl -fsSL https://download.opensuse.org/repositories/shells:fish:release:4/Debian_13/Release.key | sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/shells_fish_release_4.gpg
```
