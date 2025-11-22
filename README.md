# Family Server

## Ansible

```bash
cd ansible
ansible-playbook -i inventory.ini setup_server.yaml --ask-become-pass
```

## System File Structure

Shared files are stored in `/srv`.
chown -R timon:timon → make timon the owner of everything
chmod -R 775 → owner & group can fully read/write/execute, everyone else can only read/execute.

Configuration for samba is stored in `/etc/samba/smb.conf`.
```bash
sudo nano /etc/samba/smb.conf
```

To allow users to access the samba share, give them a password.
```bash
sudo smbpasswd -a timon
```

To restart the samba service, run:
```bash
sudo systemctl restart smbd
```

## Tailscale

Tailscale is installed to provide secure, zero-config VPN access to the server from anywhere. It creates a mesh VPN network that allows you to access the server remotely without exposing ports or configuring complex firewall rules.

After the server is provisioned, Tailscale needs to be authenticated:
```bash
sudo tailscale up
sudo tailscale status
```

This will provide a URL to authenticate via your Tailscale account.

The server will automatically join your Tailscale network.
To join the network from a new device, login with the same OICD provider as the account was created with. To join a network as a different user, follow [this guide](https://youtu.be/Vt4PDUXB_fg?t=644).

## Caddy

Caddy is installed to provide a web server for the server.
It is running in docker with [docker compose](https://caddyserver.com/docs/running#docker-compose) and uses the [caddyserver/cloudflare plugin](https://caddyserver.com/docs/build#docker) to automatically update the DNS records for the server.

This allows the server to be accessed via a custom domain name, caddy then reverse proxies the requests to the internal services. See [this guide](https://youtu.be/Vt4PDUXB_fg?t=214) for more details.