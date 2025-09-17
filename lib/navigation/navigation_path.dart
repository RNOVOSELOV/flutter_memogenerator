enum NavigationPagePath {
  authPage(path: '/auth', name: 'auth'),
  mainPage(path: '/main', name: 'main'),
  memesPage(path: '/memes', name: 'memes'),
  editMemePage(path: '/edit', name: 'edit_meme'),
  templatesPage(path: '/templates', name: 'templates'),
  templateDownloadPage(path: '/template', name: 'template'),
  settingsPage(path: '/settings', name: 'settings');

  const NavigationPagePath({required this.path, required this.name});

  final String path;
  final String name;
}
