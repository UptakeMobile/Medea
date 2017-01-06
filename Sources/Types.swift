public typealias JSONObject = [AnyHashable: Any]
public typealias JSONArray = [Any]

public enum JSONError: Error {
  case nonObject, nonArray, malformed
}

public enum StringError: Error {
  case encoding
}
