import Foundation


public struct ValidJSONObject {
  public let value: JSONObject
  
  public init(_ json: JSONObject) throws {
    try JSONHelper.validate(json)
    value = json
  }
}
