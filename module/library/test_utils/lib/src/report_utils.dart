String formatDescription(String description, Iterable<String>? tags) {
  if (tags == null || tags.isEmpty) return description;
  return "${tags.join(',')} : $description";
}
