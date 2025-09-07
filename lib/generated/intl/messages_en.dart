// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "meme": MessageLookupByLibrary.simpleMessage("Meme"),
    "meme_generator": MessageLookupByLibrary.simpleMessage("Meme generator"),
    "memes": MessageLookupByLibrary.simpleMessage("Memes"),
    "remove": MessageLookupByLibrary.simpleMessage("Delete"),
    "remove_meme": MessageLookupByLibrary.simpleMessage("Delete meme?"),
    "remove_meme_desc": MessageLookupByLibrary.simpleMessage(
      "The selected meme will be deleted permanently",
    ),
    "remove_template": MessageLookupByLibrary.simpleMessage("Delete template?"),
    "remove_template_desc": MessageLookupByLibrary.simpleMessage(
      "The selected template will be deleted permanently",
    ),
    "settings": MessageLookupByLibrary.simpleMessage("Settings"),
    "template": MessageLookupByLibrary.simpleMessage("Template"),
    "template_download": MessageLookupByLibrary.simpleMessage(
      "Download template",
    ),
    "templates": MessageLookupByLibrary.simpleMessage("Templates"),
    "templates_empty": MessageLookupByLibrary.simpleMessage(
      "Empty list of templates received",
    ),
  };
}
