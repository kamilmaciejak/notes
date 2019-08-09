String validateTitle(String title) {
  if (title.isEmpty) {
    return 'Please enter title';
  }
  return null;
}

String validateText(String text) {
  if (text.isEmpty) {
    return 'Please enter text';
  }
  return null;
}
