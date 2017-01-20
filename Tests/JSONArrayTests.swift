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
    } catch JSONError.nonArray {
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
    let shouldThrow = expectation(description: "does not parse")
    do {
      let _ = try JSONHelper.string(from: [Date(), Date()])
    } catch JSONError.malformed {
      shouldThrow.fulfill()
    } catch {}
    waitForExpectations(timeout: 1.0, handler: nil)
  }
  
  
  func testEmptyJSONArray() {
    let subject = try! JSONHelper.string(from: [])
    XCTAssertEqual(subject, "[]")
  }
  
  
  func testValidate() {
    XCTAssert(JSONHelper.validate("[1,2]"))
    XCTAssert(JSONHelper.validate("[\"one\", \"two\"]"))
    XCTAssert(JSONHelper.validate(["foo", 42, false, NSNull()]))
    XCTAssertFalse(JSONHelper.validate(""))
    XCTAssertFalse(JSONHelper.validate("foobar"))
    XCTAssertFalse(JSONHelper.validate([Date()]))
  }
}
