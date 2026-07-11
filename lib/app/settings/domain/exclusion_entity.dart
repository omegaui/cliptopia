class ExclusionEntity {
  final String name;
  final String pattern;

  ExclusionEntity({required this.name, required this.pattern});

  bool anyMatch(String text) {
    return pattern.allMatches(text).isNotEmpty;
  }

  Map<String, String> toMap() {
    return {
      'name': name,
      'pattern': pattern,
    };
  }
}
