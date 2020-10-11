import Foundation



public struct ValidJSONObject {
  public private(set) var value: JSONObject
  
  
  public init(_ json: JSONObject) throws {
    try JSONHelper.validate(json)
    value = json
  }
  
  
  /**
   Sets (i.e. *associates*) `value` with a given `key`. Blows up if `value` is not valid JSON.
   
   - parameter key: The key to associate `value` with — if `value` is valid JSON.
   - parameter value: A JSON value to be associated with `key`. An error will be thrown if this is not valid JSON.
   
   - throws: `JSONError.invalid` if `value` isn't valid JSON.
   
   - note: We'd like to model this as a `subscript` instead, but there's currently no way to make a subscript setter `throw`.
   */
  mutating public func associate(key: String, value: Any) throws {
    try JSONHelper.validate([value])
    self.value[key] = value
  }
  
  
  /**
   Sets (i.e. *associates*) `value` for a given `key`, but only if `value` is valid JSON.
   
   - parameter key: The key to associate `value` with — if `value` is valid JSON.
   - parameter value: A JSON value to be associated with `key`. If it is not valid JSON, it will not be associated.
   - returns: `true` if `value` is valid JSON and `key` and `value` are successfully associated. `false` if `value` is not valid JSON.
   
   - note: It'd make sense to model this as a `subscript`, but subscripts are generally thought of as assignment in Swift. A conditional subscript would be weird and unexpected behavior.
   */
  @discardableResult mutating public func associateIfValid(key: String, value: Any) -> Bool {
    do {
      try associate(key: key, value: value)
      return true
    } catch {
      return false
    }
  }
}
