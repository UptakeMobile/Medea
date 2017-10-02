import Foundation



public struct ValidJSONArray {
  public let value: JSONArray
  
  public init(_ jsonArray: JSONArray) throws {
    try JSONHelper.validate(jsonArray)
    value = jsonArray
  }
}
