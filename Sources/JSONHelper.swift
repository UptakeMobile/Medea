import Foundation


public enum JSONHelper {
  public static func json(from string: String) throws -> JSONObject {
    // This cannot be `nil` when `allowLossyConversion` is `true`. So we force-unwrap.
    // Aside: it should be impossible for any `String` to fail even a lossless conversion to UTF-8 (there are currently no characters unrepresentable in UTF-8), but we're being pedantic.
    let data = string.data(using: .utf8, allowLossyConversion: true)!
    return try json(from: data)
  }
  
  
  public static func json(from data: Data) throws -> JSONObject {
    do {
      let object = try JSONSerialization.jsonObject(with: data, options: [])
      guard let json = object as? JSONObject else {
        throw JSONError.nonObject
      }
      return json
      
    } catch let e as NSError {
      switch (e.domain, e.code) {
      case (NSCocoaErrorDomain, 3840):
        throw JSONError.malformed
      default:
        throw e
      }
    }
  }
  
  
  public static func data(from json: JSONObject) throws -> Data {
    guard JSONSerialization.isValidJSONObject(json) else {
      throw JSONError.malformed
    }
    return try JSONSerialization.data(withJSONObject: json, options: [])
  }
  
  
  public static func string(from json: JSONObject) throws -> String {
    let jsonData = try data(from: json)
    guard let string = String(data: jsonData, encoding: .utf8) else {
      throw StringError.encoding
    }
    return string
  }
}
