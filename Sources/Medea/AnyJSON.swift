import Foundation



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
