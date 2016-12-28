public typealias JSONObject = [AnyHashable: Any]

public enum JSONError: Error {
  case nonObject, malformed
}

public enum StringError: Error {
  case encoding
}
