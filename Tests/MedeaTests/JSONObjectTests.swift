import XCTest
import Medea

class JSONObjectTests: XCTestCase {
  func testRawObject() {
    let subject = try! JSONHelper.jsonObject(from: "{\"foo\": \"bar\"}")
    XCTAssertEqual(subject["foo"] as! String, "bar")
  }
  
  
  func testRawJSONArray() {
    let shouldThrow = expectation(description: "throws notJSONObject error")
    do {
      let _ = try JSONHelper.jsonObject(from: "[1,2,3]")
    } catch JSONError.unexpectedType {
      shouldThrow.fulfill()
    } catch {}
    waitForExpectations(timeout: 0.1, handler: nil)
  }
  
  
  func testInvalidRawJSON() {
    let shouldThrow = expectation(description: "should not parse")
    do {
      let _ = try JSONHelper.jsonObject(from: "foobarbaz")
    } catch JSONError.malformed {
      shouldThrow.fulfill()
    } catch {}
    waitForExpectations(timeout: 0.1, handler: nil)
  }
  
  
  func testInvalidByOmission() {
    let shouldThrow = expectation(description: "should not parse")
    do {
      let _ = try JSONHelper.jsonObject(from: "")
    } catch JSONError.malformed {
      shouldThrow.fulfill()
    } catch {}
    waitForExpectations(timeout: 0.1, handler: nil)
  }
  
  
  func testEmptyRawJSON() {
    let subject = try! JSONHelper.jsonObject(from: "{}")
    XCTAssert(subject.isEmpty)
  }
  
  
  func testJSONObject() {
    let subject = try! JSONHelper.string(from: ["foo": "bar"])
    XCTAssertEqual(subject, "{\"foo\":\"bar\"}")
  }

  
  func testValidJSONObject() {
    let subject = try! ValidJSONObject(["baz": "thud"])
    let object = JSONHelper.string(from: subject)
    XCTAssertEqual(object, "{\"baz\":\"thud\"}")
  }
  
  
  func testInvaidJSONObject() {
    let shouldRejectValue = expectation(description: "invalid JSON value")

    do {
      let _ = try JSONHelper.string(from: ["date": Date()])
    } catch JSONError.invalidType {
      shouldRejectValue.fulfill()
    } catch {}
    waitForExpectations(timeout: 0.1, handler: nil)
  }
  
  
  func testEmptyJSONObject() {
    let subject = try! JSONHelper.string(from: [:])
    XCTAssertEqual(subject, "{}")
  }
  
  
  func testIsValid() {
    XCTAssert(JSONHelper.isValid("{\"foo\":42}"))
    XCTAssert(JSONHelper.isValid("{\"one\": \"two\"}"))
    XCTAssert(JSONHelper.isValid(["foo": 42, "bar": false, "baz": NSNull()]))
    XCTAssertFalse(JSONHelper.isValid("{1:2}"))
    XCTAssertFalse(JSONHelper.isValid(""))
    XCTAssertFalse(JSONHelper.isValid("foobar"))
    XCTAssertFalse(JSONHelper.isValid(["non-representable": Date()]))
  }
  
  
  func testValidate() {
    _ = try! JSONHelper.validate("{\"foo\":42}")
    _ = try! JSONHelper.validate("{\"one\": \"two\"}")
    _ = try! JSONHelper.validate(["foo": 42, "bar": false, "baz": NSNull()])

    let shouldRejectStringKey = expectation(description: "string with bad key")
    let shouldRejectEmptyString = expectation(description: "empty string")
    let shouldRejectString = expectation(description: "string")
    let shouldRejectValue = expectation(description: "bad value")
    
    do { try JSONHelper.validate("{1:2}") } catch JSONError.malformed {
      shouldRejectStringKey.fulfill()
    } catch { }
    
    do { try JSONHelper.validate("") } catch JSONError.malformed {
      shouldRejectEmptyString.fulfill()
    } catch { }
    
    do { try JSONHelper.validate("foobar") } catch JSONError.malformed {
      shouldRejectString.fulfill()
    } catch { }

    do { try JSONHelper.validate(["non-representable": Date()]) } catch JSONError.invalidType {
      shouldRejectValue.fulfill()
    } catch { }
    
    waitForExpectations(timeout: 1.0, handler: nil)
  }

}
