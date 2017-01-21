/// Simple type alias for `[AnyHashable: Any]`, which is `JSONSerialization`'s representation of a JSON object.
public typealias JSONObject = [AnyHashable: Any]



/// Simple type alias for `[Any]`, which is what `JSONSerialization` returns when decoding a JSON array.
public typealias JSONArray = [Any]



/// Errors thrown when parsing JSON.
public enum JSONError: Error {
  /// Thrown when expecting to convert to or from a `JSONObject` but a `JSONArray` is encountered instead.
  case nonObject
  /// Thrown when expecting to convert to or from a `JSONArray` but a `JSONObject` is encountered instead.
  case nonArray
  /// Thrown when a string to be parsed is not valid JSON. Also thrown when a `JSONArray` or `JSONObject` contains types that are illegal in JSON.
  case malformed
}



/// String conversion errors.
public enum StringError: Error {
  /// Thrown when JSON decodes into a string that is not UTF-8. This should be impossible.
  case encoding
}
