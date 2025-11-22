import { defineConfig } from 'vitepress'

// https://vitepress.dev/reference/site-config
export default defineConfig({
  title: "Family Server",
  description: "Unser privater Familienserver für Fotos, Filme und Dateien. Sicher. Überall erreichbar.",
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
        ]
      }
    ],

    socialLinks: [
      { icon: 'github', link: 'https://github.com/timonrieger/family-server' },
      { icon: 'immich', link: 'http://beelink.tail12bab0.ts.net:2283/' },
      { icon: 'jellyfin', link: 'http://beelink.tail12bab0.ts.net:8096' },
    ]
  }
})
