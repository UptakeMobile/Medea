import Foundation



/// Normally we’d use the bundle of the test harness, but SwiftPM doesn’t yet allow us to inlcude resources (or test assets) in our packages. This is a wonky work-around until that’s sorted.
/// - SeeAlso: https://bugs.swift.org/browse/SR-2866, https://bugs.swift.org/browse/SR-4725
func fetchFakeBundle() -> Bundle {
  let path = URL(fileURLWithPath: #file)
    .deletingLastPathComponent()
    .appendingPathComponent("FakeBundle.bundle")
  return Bundle(url: path)!
}
