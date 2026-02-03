class ExploreTemplate {
  final String id;
  final String destination;
  final String imageUrl;
  final String planMarkdown;

  const ExploreTemplate({
    required this.id,
    required this.destination,
    required this.imageUrl,
    required this.planMarkdown,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'destination': destination,
    'imageUrl': imageUrl,
    'planMarkdown': planMarkdown,
  };

  factory ExploreTemplate.fromMap(Map<String, dynamic> data) {
    return ExploreTemplate(
      id: data['id'],
      destination: data['destination'],
      imageUrl: data['imageUrl'],
      planMarkdown: data['planMarkdown'],
    );
  }
}