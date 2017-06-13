import Foundation


/// Simple type alias for `[String: Any]`, which is the closest Swift type to `JSONSerialization`'s representation of a JSON object.
public typealias JSONObject = [String: Any]



/// Simple type alias for `[Any]`, which is what `JSONSerialization` returns when decoding a JSON array.
public typealias JSONArray = [Any]



public enum AnyJSON {
  case null, bool(Bool), number(NSNumber), string(String), array(JSONArray), object(JSONObject)
  
  public init(_ value: Any) throws {
    switch value {
    case is NSNull:
      self = .null
    case let b as Bool:
      self = .bool(b)
    case let n as NSNumber:
      self = .number(n)
    case let s as String:
      self = .string(s)
    case let a as JSONArray:
      self = .array(a)
    case let d as JSONObject:
      self = .object(d)
    default:
      throw JSONError.invalidType
    }
  }
}


public extension AnyJSON {
  func objectValue() throws -> JSONObject {
    guard case .object(let d) = self else {
      throw JSONError.unexpectedType
    }
    return d
  }
  
  
  func arrayValue() throws -> JSONArray {
    guard case .array(let a) = self else {
     throw JSONError.unexpectedType
    }
    return a
  }
  
  
  func stringValue() throws -> String {
    guard case .string(let s) = self else {
      throw JSONError.unexpectedType
    }
    return s
  }
  
  
  func boolValue() throws -> Bool {
    guard case .bool(let b) = self else {
      throw JSONError.unexpectedType
    }
    return b
  }
  
  
  func numberValue() throws -> NSNumber {
    guard case .number(let n) = self else {
      throw JSONError.unexpectedType
    }
    return n
  }
  
  
  var isNull: Bool {
    switch self {
    case .null:
      return true
    default:
      return false
    }
  }
  
  
  var isNotNull: Bool {
    return !isNull
  }
}



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
