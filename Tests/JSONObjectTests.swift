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
    } catch JSONError.nonObject {
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
  
  
  func testInvaidJSONObject() {
    let shouldThrow = expectation(description: "should not parse")
    do {
      let _ = try JSONHelper.string(from: ["date": Date()])
    } catch JSONError.malformed {
      shouldThrow.fulfill()
    } catch {}
    waitForExpectations(timeout: 0.1, handler: nil)
  }
  
  
  func testEmptyJSONObject() {
    let subject = try! JSONHelper.string(from: [:])
    XCTAssertEqual(subject, "{}")
  }
}
