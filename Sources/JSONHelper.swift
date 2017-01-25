import Foundation



/// `JSONHelper` is a bag of functions for converting to and from JSON representations. It's a *very* thin wrapper around `JSONSerialization`.
public enum JSONHelper {
  //MARK: - JSON from Data
  /**
   Decodes `Data` representation of a JSON object into a `JSONObject`.
   
   * parameter data: The bytes of a string representing a JSON object, encoded as UTF-8.
   * throws: Throws standard `Error` if `data` is unreadable or not UTF-8. Throws `JSONError.malformed` if `data` does not represent JSON and `JSONError.nonObject` if `data` represents a JSON array.
   * returns: A `JSONObject` representation of `data`.
   */
  public static func jsonObject(from data: Data) throws -> JSONObject {
    return try jsonObjectFromAny(anyJSON(from: data))
  }
  
  
  /**
   Decodes `Data` representation of a JSON array into a `JSONAbject`.
   
   * parameter data: The bytes of a string representing a JSON array, encoded as UTF-8.
   * throws: Throws standard `Error` if `data` is unreadable or not UTF-8. Throws `JSONError.malformed` if `data` does not represent JSON and `JSONError.nonArray` if `data` represents a JSON object.
   * returns: A `JSONObject` representation of `data`.
   */
  public static func jsonArray(from data: Data) throws -> JSONArray {
    return try jsonArrayFromAny(anyJSON(from: data))
  }
  
  
  //MARK: - JSON from String
  /**
   Parses `String` representation of a JSON object into a `JSONObject`.
   
   * parameter string: A string representing a JSON object.
   * throws: `JSONError.malformed` if `data` does not represent JSON and `JSONError.nonObject` if `data` represents a JSON array.
   * returns: A `JSONObject` representation of `string`.
   */
  public static func jsonObject(from string: String) throws -> JSONObject {
    return try  jsonObjectFromAny(anyJSON(from: data(from: string)))
  }
  
  
  /**
   Parses `String` representation of a JSON array into a `JSONArray`.
   
   * parameter string: A string representing a JSON object.
   * throws: `JSONError.malformed` if `data` does not represent JSON and `JSONError.nonObject` if `data` represents a JSON array.
   * returns: A `JSONObject` representation of `string`.
   */
  public static func jsonArray(from string: String) throws -> JSONArray {
    return try jsonArrayFromAny(anyJSON(from: data(from: string)))
  }
  
  
  //MARK: - Data from JSON
  /**
   Serializes a `JSONObject` into `Data`.
   
   * parameter jsonObject: The JSONObject to serialize.
   * throws: `JSONError.malformed` if `JSONObject` isn't a valid JSON object.
   * returns: The bytes of a string representing a JSON object, encoded as UTF-8.
   */
  public static func data(from jsonObject: JSONObject) throws -> Data {
    return try dataFromAny(jsonObject)
  }
  
  
  /**
   Serializes a `JSONArray` into `Data`.
   
   * parameter jsonArray: The JSONArray to serialize.
   * throws: `JSONError.malformed` if `JSONArray` isn't an array of JSON-safe values.
   * returns: The bytes of a string representing a JSON array, encoded as UTF-8.
   */
  public static func data(from jsonArray: JSONArray) throws -> Data {
    return try dataFromAny(jsonArray)
  }
  
  
  //MARK: - String from JSON
  /**
   Serializes a `JSONObject` into a `String`.
   
   * parameter jsonObject: The JSONObject to serialize.
   * throws: `JSONError.malformed` if `JSONObject` isn't a valid JSON object. `StringError.encoding` will be thrown if the serialized JSON can't be represented by a UTF-8 string, but that should be impossible.
   * returns: A string representing a JSON object, encoded as UTF-8.
   */
  public static func string(from json: JSONObject) throws -> String {
    return try string(from: data(from: json))
  }
  
  
  /**
   Serializes a `JSONArray` into a `String`.
   
   * parameter jsonArray: The JSONArray to serialize.
   * throws: `JSONError.malformed` if `JSONArray` isn't an array of JSON-safe values. `StringError.encoding` will be thrown if the serialized JSON can't be represented by a UTF-8 string, but that should be impossible.
   * returns: A string representing a JSON array, encoded as UTF-8.
   */
  public static func string(from json: JSONArray) throws -> String {
    return try string(from: data(from: json))
  }
  
  
  //MARK: - Validation
  /**
   Validates whether the given `String` is well-formed JSON.
   
   * parameter string: The string to validate.
   * returns: `true` if the string represents valid JSON. Otherwise: `false`.
   */
  public static func isValid(_ string: String) -> Bool {
    return isValid(data(from: string))
  }
  
  
  /**
   Validates whether the given bytes represent well-formed JSON string.
   
   * parameter data: The bytes to validate.
   * returns: `true` if `data` represents the bytes of a UTF-8 encoded string, and said string depicts valid JSON. Otherwise: `false`.
   */
  public static func isValid(_ data: Data) -> Bool {
    if let _ = try? jsonObject(from: data) {
      return true
    }
    if let _ = try? jsonArray(from: data) {
      return true
    }
    return false
  }
  
  
  /**
   Validates whether the given `JSONObject` contains only valid JSON types.
   
   * parameter jsonObject: The object to validate.
   * returns: `true` if `jsonObject` contains only types representable in JSON. Otherwise: `false`.
   */
  public static func isValid(_ jsonObject: JSONObject) -> Bool {
    if let _ = try? dataFromAny(jsonObject) {
      return true
    }
    return false
  }
  
  
  /**
   Validates whether the given `JSONArray` contains only valid JSON types.
   
   * parameter jsonArray: The array to validate.
   * returns: `true` if `jsonArray` contains only types representable in JSON. Otherwise: `false`.
   */
  public static func isValid(_ jsonArray: JSONArray) -> Bool {
    if let _ = try? dataFromAny(jsonArray) {
      return true
    }
    return false
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
