enum TextType { code, url, word, sentence, paragraph }

TextType determineTextType(String text) {
  // Check if the text is code
  if (isCode(text)) {
    return TextType.code;
  }

  // Check if the text is a URL
  if (Uri.tryParse(text)?.isAbsolute ?? false) {
    return TextType.url;
  }

  // Check if the text is a single word
  if (!text.trim().contains(' ')) {
    return TextType.word;
  }

  // Check if the text is a single sentence
  if (text.endsWith('.') || text.endsWith('!') || text.endsWith('?')) {
    return TextType.sentence;
  }

  // If none of the above conditions are met, consider it a paragraph
  return TextType.paragraph;
}

bool isCode(String text) {
  // Check for keywords and punctuation common in code.
  final keywords = RegExp(
      r"\b(if|else|for|while|try|except|def|class|return|import|from|print)\b");
  final punctuation = RegExp(r"[{}()\[\];,.<>?:]+");
  final operators = RegExp(r"[+\-*/%|=!<>&]");

  // Check for presence of keywords, punctuation, and operators.
  if (keywords.hasMatch(text) ||
      punctuation.hasMatch(text) ||
      operators.hasMatch(text)) {
    return true;
  }

  // Check for specific patterns like comments or imports.
  if (RegExp(r"#.*").hasMatch(text) || RegExp(r"import\s+.*").hasMatch(text)) {
    return true;
  }

  // If none of the above patterns are found, the text is likely not code.
  return false;
}
