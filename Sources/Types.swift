import Foundation


/// Simple type alias for `[String: Any]`, which is the closest Swift type to `JSONSerialization`'s representation of a JSON object.
public typealias JSONObject = [String: Any]



/// Simple type alias for `[Any]`, which is what `JSONSerialization` returns when decoding a JSON array.
public typealias JSONArray = [Any]



/// Errors thrown when parsing JSON.
public enum JSONError: Error {
  /// Thrown when expecting to convert to or from a given JSON type (Object, Array, String, etc) but a different type is encountered instead.
  case unexpectedType
  /// Thrown when a string representation cannot be parsed as JSON.
  case malformed
  /// Thrown when a `JSONArray` or `JSONObject` contains types that are illegal in JSON.
  case invalidType
}



/// String conversion errors.
public enum StringError: Error {
  /// Thrown when JSON decodes into a string that is not UTF-8. This should be impossible.
  case encoding
}



/// Errors with file handling
public enum FileError: LocalizedError {
  /// Unable to find a file wiht the given name.
  case fileNotFound(String)
  /// Unable to open or read the given file.
  case cannotRead(URL)
  
  
  public var errorDescription: String? {
    switch self {
    case .fileNotFound(let n):
      return "The file “\(n)” is not found."

    case .cannotRead(let url):
      return "Unable to open or read the file at \(url.absoluteString)."
    }
  }
}


