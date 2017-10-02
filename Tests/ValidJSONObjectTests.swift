import XCTest
import Medea


class ValidJSONObjectTests: XCTestCase {
  func testValid() {
    let subject = try! ValidJSONObject(["foo":"bar"])
    XCTAssertEqual(subject.value["foo"] as! String, "bar")
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
}
