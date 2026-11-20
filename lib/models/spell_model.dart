class Spell {
  final int index;
  final String spell;
  final String use;

  Spell({
    required this.index,
    required this.spell,
    required this.use,
  });

  factory Spell.fromJson(Map<String, dynamic> json) {
    return Spell(
      index: json['index'] ?? 0,
      spell: json['spell'] ?? '',
      use: json['use'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'index': index,
      'spell': spell,
      'use': use,
    };
  }
}
