import { defineConfig } from 'vitepress'

// https://vitepress.dev/reference/site-config
export default defineConfig({
  title: "Homelab",
  description: "Homelab für Fotos, Filme und Dateien. Sicher. Überall erreichbar.",
  lastUpdated: true,
  themeConfig: {
    // https://vitepress.dev/reference/default-theme-config
    nav: [
      { text: 'Home', link: '/' },
    ],
    search: {
      provider: "local"
    },
    sidebar: [
      {
        text: 'Für Anwender',
        items: [
          { text: 'Überblick', link: '/anwender/' },
          { text: 'Tailscale', link: '/anwender/tailscale' },
          { text: 'Immich', link: '/anwender/immich' },
          { text: 'Jellyfin', link: '/anwender/jellyfin' },
          { text: 'Samba', link: '/anwender/samba' },
        ]
      },
      {
        text: 'Für Administratoren',
        items: [
          { text: 'Überblick', link: '/admin/' },
          { text: 'Server Einrichtung', link: '/admin/server-einrichtung' },
          { text: 'Zugriffskontrolle', link: '/admin/zugriffskontrolle' },
          { text: 'Backups', link: '/admin/backups' },
          { text: 'Tailscale Setup', link: '/admin/tailscale' },
          { text: 'Immich Setup', link: '/admin/immich-setup' },
          { text: 'Jellyfin Setup', link: '/admin/jellyfin-setup' },
          { text: 'Samba Setup', link: '/admin/samba-setup' },
          { text: 'Fehlerbehebung', link: '/admin/fehlerbehebung' },
        ]
      }
    ],

    socialLinks: [
      { icon: 'github', link: 'https://github.com/timonrieger/homelab' },
      { icon: 'immich', link: 'https://immich.fam.timonrieger.de' },
      { icon: 'jellyfin', link: 'https://jellyfin.fam.timonrieger.de' },
      { icon: 'gitea', link: 'https://git.fam.timonrieger.de' },
      { icon: 'uptimekuma', link: 'https://status.fam.timonrieger.de' },
    ]
  }
})
