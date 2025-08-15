class FilterItemArgs {
  final String? value;
  final String text;

  const FilterItemArgs({
    required this.value,
    required this.text,
  });
}

const List<FilterItemArgs> dummyArgs = [
  FilterItemArgs(
    value: "arg1",
    text: "Contoh 1",
  ),
  FilterItemArgs(
    value: "arg2",
    text: "Contoh 2",
  ),
  FilterItemArgs(
    value: "arg3",
    text: "Contoh 3",
  ),
];
