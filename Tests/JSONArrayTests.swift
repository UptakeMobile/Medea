import XCTest
import Medea

class JSONArrayTests: XCTestCase {
  func testRawArray() {
    let subject = try! JSONHelper.jsonArray(from: "[\"foo\", \"bar\"]")
    XCTAssertEqual(subject as! [String], ["foo", "bar"])
  }
  
  
  func testRawJSONObject() {
    let shouldThrow = expectation(description: "throws notJSONArray error")
    do {
      let _ = try JSONHelper.jsonArray(from: "{\"foo\": \"bar\"}")
    } catch JSONError.unexpectedType {
      shouldThrow.fulfill()
    } catch {}
    waitForExpectations(timeout: 1.0, handler: nil)
  }
  
  
  func testInvalidRawJSON() {
    let shouldThrow = expectation(description: "does not parse")
    do {
      let _ = try JSONHelper.jsonArray(from: "foobarbaz")
    } catch JSONError.malformed {
      shouldThrow.fulfill()
    } catch {}
    waitForExpectations(timeout: 0.1, handler: nil)
  }
  
  
  func testInvalidByOmission() {
    let shouldThrow = expectation(description: "does not parse")
    do {
      let _ = try JSONHelper.jsonArray(from: "")
    } catch JSONError.malformed {
      shouldThrow.fulfill()
    } catch {}
    waitForExpectations(timeout: 0.1, handler: nil)
  }
  
  
  func testEmptyRawJSON() {
    let subject = try! JSONHelper.jsonArray(from: "[]")
    XCTAssert(subject.isEmpty)
  }
  
  
  func testJSONArray() {
    let subject = try! JSONHelper.string(from: ["foo", "bar"])
    XCTAssertEqual(subject, "[\"foo\",\"bar\"]")
  }
  
  
  func testInvaidJSONArray() {
    let shouldThrow = expectation(description: "invalid json array")
    do {
      let _ = try JSONHelper.string(from: [Date(), Date()])
    } catch JSONError.invalid {
      shouldThrow.fulfill()
    } catch {}
    waitForExpectations(timeout: 1.0, handler: nil)
  }
  
  
  func testEmptyJSONArray() {
    let subject = try! JSONHelper.string(from: [])
    XCTAssertEqual(subject, "[]")
  }
  
  
  func testIsValid() {
    XCTAssert(JSONHelper.isValid("[1,2]"))
    XCTAssert(JSONHelper.isValid("[\"one\", \"two\"]"))
    XCTAssert(JSONHelper.isValid(["foo", 42, false, NSNull()]))
    XCTAssertFalse(JSONHelper.isValid(""))
    XCTAssertFalse(JSONHelper.isValid("foobar"))
    XCTAssertFalse(JSONHelper.isValid([Date()]))
  }
  
  
  func testValidate() {
    _ = try! JSONHelper.validate("[1,2]")
    _ = try! JSONHelper.validate("[\"one\", \"two\"]")
    _ = try! JSONHelper.validate("[true, false]")
    _ = try! JSONHelper.validate("[null]")
    _ = try! JSONHelper.validate(["foo", 42, false, NSNull()])
    
    let shouldRejectEmptyString = expectation(description: "empty string")
    let shouldRejectString = expectation(description: "string")
    let shouldRejectElement = expectation(description: "bad element")
    
    do { try JSONHelper.validate("") } catch JSONError.malformed {
      shouldRejectEmptyString.fulfill()
    } catch { }

    do { try JSONHelper.validate("foobar") } catch JSONError.malformed {
      shouldRejectString.fulfill()
    } catch { }
    
    do { try JSONHelper.validate([Date()]) } catch JSONError.invalid {
      shouldRejectElement.fulfill()
    } catch { }
    
    waitForExpectations(timeout: 1.0, handler: nil)
  }
}
