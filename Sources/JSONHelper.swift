import Foundation


public enum JSONHelper {
  //MARK: - JSON from Data
  public static func jsonObject(from data: Data) throws -> JSONObject {
    return try jsonObjectFromAny(anyJSON(from: data))
  }
  
  
  public static func jsonArray(from data: Data) throws -> JSONArray {
    return try jsonArrayFromAny(anyJSON(from: data))
  }
  
  
  //MARK: - JSON from String
  public static func jsonObject(from string: String) throws -> JSONObject {
    return try  jsonObjectFromAny(anyJSON(from: data(from: string)))
  }
  
  
  public static func jsonArray(from string: String) throws -> JSONArray {
    return try jsonArrayFromAny(anyJSON(from: data(from: string)))
  }
  
  
  //MARK: - Data from JSON
  public static func data(from jsonObject: JSONObject) throws -> Data {
    return try dataFromAny(jsonObject)
  }
  
  
  public static func data(from jsonArray: JSONArray) throws -> Data {
    return try dataFromAny(jsonArray)
  }
  
  
  //MARK: - String from JSON
  public static func string(from json: JSONObject) throws -> String {
    return try string(from: data(from: json))
  }

  
  public static func string(from json: JSONArray) throws -> String {
    return try string(from: data(from: json))
  }
  
  
  //MARK: - Helpers
  private static func anyJSON(from data: Data) throws -> Any {
    do {
      return try JSONSerialization.jsonObject(with: data, options: [])
    } catch let e as NSError {
      switch (e.domain, e.code) {
      case (NSCocoaErrorDomain, 3840):
        throw JSONError.malformed
      default:
        throw e
      }
    }
  }
  
  
  private static func string(from data: Data) throws -> String {
    guard let string = String(data: data, encoding: .utf8) else {
      throw StringError.encoding
    }
    return string
  }
  
  
  private static func data(from string: String) -> Data {
    // This cannot be `nil` when `allowLossyConversion` is `true`. So we force-unwrap.
    // Aside: it should be impossible for any `String` to fail even a lossless conversion to UTF-8 (there are currently no characters unrepresentable in UTF-8), but we're being pedantic.
    return string.data(using: .utf8, allowLossyConversion: true)!
  }
  
  
  private static func dataFromAny(_ any: Any) throws -> Data {
    guard JSONSerialization.isValidJSONObject(any) else {
      throw JSONError.malformed
    }
    return try JSONSerialization.data(withJSONObject: any, options: [])
  }
  
  
  private static func jsonObjectFromAny(_ any: Any) throws -> JSONObject {
    guard let json = any as? JSONObject else {
      throw JSONError.nonObject
    }
    return json
  }
  
  
  private static func jsonArrayFromAny(_ any: Any) throws -> JSONArray {
    guard let json = any as? JSONArray else {
      throw JSONError.nonArray
    }
    return json
  }
}
