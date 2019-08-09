abstract class Result {
  factory Result.text(String text) = TextResult;
  factory Result.cancellation() = CancellationResult;
  factory Result.empty() = EmptyResult;
}
class TextResult implements Result {
  final String text;

  TextResult(this.text);
}
class CancellationResult implements Result {}
class EmptyResult implements Result {}
