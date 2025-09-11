// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name =
        (locale.countryCode?.isEmpty ?? false)
            ? locale.languageCode
            : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Meme generator`
  String get meme_generator {
    return Intl.message(
      'Meme generator',
      name: 'meme_generator',
      desc: '',
      args: [],
    );
  }

  /// `Memes`
  String get memes {
    return Intl.message('Memes', name: 'memes', desc: '', args: []);
  }

  /// `Meme`
  String get meme {
    return Intl.message('Meme', name: 'meme', desc: '', args: []);
  }

  /// `Templates`
  String get templates {
    return Intl.message('Templates', name: 'templates', desc: '', args: []);
  }

  /// `Template`
  String get template {
    return Intl.message('Template', name: 'template', desc: '', args: []);
  }

  /// `Settings`
  String get settings {
    return Intl.message('Settings', name: 'settings', desc: '', args: []);
  }

  /// `Delete`
  String get remove {
    return Intl.message('Delete', name: 'remove', desc: '', args: []);
  }

  /// `Cancel`
  String get cancel {
    return Intl.message('Cancel', name: 'cancel', desc: '', args: []);
  }

  /// `Save`
  String get save {
    return Intl.message('Save', name: 'save', desc: '', args: []);
  }

  /// `Apply`
  String get apply {
    return Intl.message('Apply', name: 'apply', desc: '', args: []);
  }

  /// `Delete meme?`
  String get remove_meme {
    return Intl.message(
      'Delete meme?',
      name: 'remove_meme',
      desc: '',
      args: [],
    );
  }

  /// `The selected meme will be deleted permanently`
  String get remove_meme_desc {
    return Intl.message(
      'The selected meme will be deleted permanently',
      name: 'remove_meme_desc',
      desc: '',
      args: [],
    );
  }

  /// `Download template`
  String get template_download {
    return Intl.message(
      'Download template',
      name: 'template_download',
      desc: '',
      args: [],
    );
  }

  /// `Empty list of templates received`
  String get templates_empty {
    return Intl.message(
      'Empty list of templates received',
      name: 'templates_empty',
      desc: '',
      args: [],
    );
  }

  /// `Delete template?`
  String get remove_template {
    return Intl.message(
      'Delete template?',
      name: 'remove_template',
      desc: '',
      args: [],
    );
  }

  /// `The selected template will be deleted permanently`
  String get remove_template_desc {
    return Intl.message(
      'The selected template will be deleted permanently',
      name: 'remove_template_desc',
      desc: '',
      args: [],
    );
  }

  /// `Error loading image`
  String get error_image_loading {
    return Intl.message(
      'Error loading image',
      name: 'error_image_loading',
      desc: '',
      args: [],
    );
  }

  /// `Exit`
  String get exit {
    return Intl.message('Exit', name: 'exit', desc: '', args: []);
  }

  /// `Do you want to exit?`
  String get exit_action {
    return Intl.message(
      'Do you want to exit?',
      name: 'exit_action',
      desc: '',
      args: [],
    );
  }

  /// `You will lose unsaved changes`
  String get exit_action_desc {
    return Intl.message(
      'You will lose unsaved changes',
      name: 'exit_action_desc',
      desc: '',
      args: [],
    );
  }

  /// `Editor`
  String get editor {
    return Intl.message('Editor', name: 'editor', desc: '', args: []);
  }

  /// `Enter text`
  String get editor_text_hint {
    return Intl.message(
      'Enter text',
      name: 'editor_text_hint',
      desc: '',
      args: [],
    );
  }

  /// `Add text`
  String get editor_add_text {
    return Intl.message(
      'Add text',
      name: 'editor_add_text',
      desc: '',
      args: [],
    );
  }

  /// `Color: `
  String get editor_color {
    return Intl.message('Color: ', name: 'editor_color', desc: '', args: []);
  }

  /// `Select color`
  String get editor_select_color {
    return Intl.message(
      'Select color',
      name: 'editor_select_color',
      desc: '',
      args: [],
    );
  }

  /// `Size: `
  String get editor_size {
    return Intl.message('Size: ', name: 'editor_size', desc: '', args: []);
  }

  /// `Weight: `
  String get editor_weight {
    return Intl.message('Weight: ', name: 'editor_weight', desc: '', args: []);
  }

  /// `Meme successfully deleted`
  String get meme_remove_success {
    return Intl.message(
      'Meme successfully deleted',
      name: 'meme_remove_success',
      desc: '',
      args: [],
    );
  }

  /// `Error deleting meme`
  String get meme_remove_error {
    return Intl.message(
      'Error deleting meme',
      name: 'meme_remove_error',
      desc: '',
      args: [],
    );
  }

  /// `Template successfully deleted`
  String get template_remove_success {
    return Intl.message(
      'Template successfully deleted',
      name: 'template_remove_success',
      desc: '',
      args: [],
    );
  }

  /// `Error deleting template`
  String get template_remove_error {
    return Intl.message(
      'Error deleting template',
      name: 'template_remove_error',
      desc: '',
      args: [],
    );
  }

  /// `Empty templates list received`
  String get empty_data {
    return Intl.message(
      'Empty templates list received',
      name: 'empty_data',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ru'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
