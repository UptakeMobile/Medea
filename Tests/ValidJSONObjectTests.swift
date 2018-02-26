import XCTest
import Medea


class ValidJSONObjectTests: XCTestCase {
  let aKey = "foo"
  let aString = "string"
  let anInt = 42
  let aFloat = 3.14
  let aBool = true
  lazy var anArray: JSONArray = [self.aString, self.anInt, self.aBool]
  lazy var anObject: JSONObject = [self.aKey: self.aString]
  lazy var aNestedArray: JSONArray = [self.aString, self.anInt, self.anObject]
  lazy var aNestedObject: JSONObject = [self.aKey: self.anArray]
  
  
  func testValid() {
    let subject = try! ValidJSONObject(anObject)
    XCTAssertEqual(aString, subject.value[aKey] as! String)
  }
  
  
  func testInvalid() {
    let expectedThrow = expectation(description: "Should throw")
    
    do {
      _ = try ValidJSONObject(["date": Date()])
    } catch JSONError.invalidType {
      expectedThrow.fulfill()
    } catch {
      fatalError("Not caught")
    }
    
    wait(for: [expectedThrow], timeout: 1)
  }
  
  
  func testValidMutability() {
    var subject = try! ValidJSONObject([:])
    try! subject.associate(key: "string", value: aString)
    try! subject.associate(key: "int", value: anInt)
    try! subject.associate(key: "float", value: aFloat)
    try! subject.associate(key: "bool", value: aBool)
    try! subject.associate(key: "array", value: anArray)
    try! subject.associate(key: "object", value: anObject)
    try! subject.associate(key: "nested array", value: aNestedArray)
    try! subject.associate(key: "nested object", value: aNestedObject)
    
    XCTAssertEqual(aString, subject.value["string"] as! String)
    XCTAssertEqual(anInt, subject.value["int"] as! Int)
    XCTAssertEqual(aFloat, subject.value["float"] as! Double)
    XCTAssertEqual(aBool, subject.value["bool"] as! Bool)
    XCTAssertEqual(aString, (subject.value["array"] as! JSONArray).first as! String)
    XCTAssertEqual(aString, (subject.value["object"] as! JSONObject)[aKey] as! String)
    XCTAssertEqual(aString, ((subject.value["nested array"] as! JSONArray).last as! JSONObject)[aKey] as! String)
    XCTAssertEqual(aString, ((subject.value["nested object"] as! JSONObject)[aKey] as! JSONArray).first as! String)
  }
  
  
  func testInvalidMutability() {
    let expectedThrow = expectation(description: "Waiting for failure associating non-JSON value.")
    var subject = try! ValidJSONObject([:])
    do {
      try subject.associate(key: aKey, value: Date())
    } catch JSONError.invalidType {
      expectedThrow.fulfill()
    } catch {
      XCTFail()
    }
    
    wait(for: [expectedThrow], timeout: 1)
  }
  
  
  func testConditionalAssociation() {
    var subject = try! ValidJSONObject([:])
    XCTAssert(subject.associateIfValid(key: "foo", value: "bar"))
    XCTAssertEqual("bar", subject.value["foo"] as! String)
    
    XCTAssertFalse(subject.associateIfValid(key: "bar", value: Date()))
    XCTAssertNil(subject.value["bar"])
  }
}
