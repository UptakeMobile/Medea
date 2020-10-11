import XCTest
import Medea


class ValidJSONArrayTests: XCTestCase {
  func testValid() {
    let subject = try! ValidJSONArray(["foo","bar"])
    XCTAssertEqual(subject.value.first as! String, "foo")
    XCTAssertEqual(subject.value.last as! String, "bar")
  }
  
  
  func testInvalid() {
    let expectedThrow = expectation(description: "Should throw")
    
    do {
      _ = try ValidJSONArray([Date()])
    } catch JSONError.invalidType {
      expectedThrow.fulfill()
    } catch {
      fatalError("Not caught")
    }
    
    wait(for: [expectedThrow], timeout: 1)
  }
}

