# Samba

Die Samba-Konfiguration wird über das Ansible Playbook verwaltet (siehe [Server-Einrichtung](/admin/server-einrichtung)).

:::tip Samba Dokumentation
Für Konfiguration, Freigaben, Berechtigungen und Troubleshooting siehe die [offizielle Samba-Dokumentation](https://www.samba.org/samba/docs/).
:::

## Konfiguration

Die Samba-Konfiguration liegt unter `/etc/samba/smb.conf` und wird automatisch durch das Ansible Playbook verwaltet:

```bash
# Konfiguration aktualisieren
ansible-playbook -i ansible/inventory.ini ansible/setup-permissions.yaml --ask-become-pass
```

## Benutzer-Verwaltung

Neue Benutzer müssen zu Samba hinzugefügt werden, nachdem sie vom Ansible Playbook angelegt wurden:

```bash
# Samba-Passwort für existierenden Linux-Benutzer setzen
sudo smbpasswd -a <username>

# Passwort ändern
sudo smbpasswd <username>

# Alle Benutzer anzeigen
sudo pdbedit -L
```
