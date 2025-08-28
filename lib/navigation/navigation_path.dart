enum NavigationPagePath {
  mainPage(path: '/main', name: 'main'),
  memesPage(path: '/memes', name: 'memes'),
  editMemePage(path: '/memes/edit', name: 'edit_meme'),
  templatesPage(path: '/templates', name: 'templates'),
  settingsPage(path: '/settings', name: 'settings');

  const NavigationPagePath({
    required this.path,
    required this.name,
  });

  final String path;
  final String name;
}
