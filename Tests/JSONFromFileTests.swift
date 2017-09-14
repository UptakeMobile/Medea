import XCTest
import Medea



class JSONFromFileTests: XCTestCase {
  func testThrowsNotFound() {
    let shouldThrow = expectation(description: "Waiting for error")
    do {
      _ = try JSONHelper.anyJSON(fromFileNamed: "foo")
    } catch FileError.fileNotFound {
      shouldThrow.fulfill()
    } catch {
      fatalError("unexpected error")
    }
    
    wait(for: [shouldThrow], timeout: 1)
  }
  
  
  func testFileWithoutExtension() {
    let json = try? JSONHelper.anyJSON(fromFileNamed: "object", bundle: Bundle(for: type(of: self)))
    XCTAssertNotNil(json)
  }
  
  
  func testFileWithExtension() {
    let json = try? JSONHelper.anyJSON(fromFileNamed: "object", extension: "ext", bundle: Bundle(for: type(of: self)))
    XCTAssertNotNil(json)
  }
  
  
  func testObjectFile() {
    let json = try! JSONHelper.jsonObject(fromFileNamed: "object", bundle: Bundle(for: type(of: self)))
    XCTAssertEqual(json["hello"] as! String, "world")
  }
  
  
  func testArrayFile() {
    let json = try! JSONHelper.jsonArray(fromFileNamed: "array", bundle: Bundle(for: type(of: self)))
    XCTAssertEqual(json.count, 3)
    XCTAssertEqual(json[0] as! Int, 1)
    XCTAssertEqual(json[1] as! Int, 2)
    XCTAssertEqual(json[2] as! Int, 3)
  }
  
  

}
