@testable import SweetFoundation
import XCTest

class Tests: XCTestCase {

    // Not sure how to test that the type is correctly inferred.
    // This pretty much just ensures that the property is accessible and non-nil for a non-empty array.
    func testArrayAny() {
        let array: Array = ["Some", "Value", "Random"]
        let value = array.any

        XCTAssertNotNil(value)
    }

    func testMath() {
        var d = Math.degreesToRadians(45)
        var almostRight = d <= 0.786 && d >= 0.785
        XCTAssert(almostRight)

        d = Math.degreesToRadians(65)
        almostRight = d <= 1.135 && d >= 1.134
        XCTAssert(almostRight)

        d = Math.radiansToDegrees(Double.pi)
        almostRight = d <= 180.1 && d >= 179.99
        XCTAssert(almostRight)

        d = Math.radiansToDegrees(Double.pi / 2)
        almostRight = d <= 90.1 && d >= 89.99
        XCTAssert(almostRight)
    }

    func testBase64() {
        var string = "This is a test string"
        var string64 = string.data(using: .utf8)!.base64EncodedString()
        var string64NoPadding = string.data(using: .utf8)!.base64EncodedStringWithoutPadding()

        XCTAssertEqual(string64, "VGhpcyBpcyBhIHRlc3Qgc3RyaW5n")
        XCTAssertEqual(string64NoPadding, "VGhpcyBpcyBhIHRlc3Qgc3RyaW5n")
        XCTAssertEqual(string64NoPadding.paddedForBase64, "VGhpcyBpcyBhIHRlc3Qgc3RyaW5n")

        string = "This is a test string without padding"
        string64 = string.data(using: .utf8)!.base64EncodedString()
        string64NoPadding = string.data(using: .utf8)!.base64EncodedStringWithoutPadding()

        XCTAssertEqual(string64, "VGhpcyBpcyBhIHRlc3Qgc3RyaW5nIHdpdGhvdXQgcGFkZGluZw==")
        XCTAssertEqual(string64NoPadding, "VGhpcyBpcyBhIHRlc3Qgc3RyaW5nIHdpdGhvdXQgcGFkZGluZw")
        XCTAssertEqual(string64NoPadding.paddedForBase64, "VGhpcyBpcyBhIHRlc3Qgc3RyaW5nIHdpdGhvdXQgcGFkZGluZw==")

        string = "One-pad string"
        string64 = string.data(using: .utf8)!.base64EncodedString()
        string64NoPadding = string.data(using: .utf8)!.base64EncodedStringWithoutPadding()

        XCTAssertEqual(string64, "T25lLXBhZCBzdHJpbmc=")
        XCTAssertEqual(string64NoPadding, "T25lLXBhZCBzdHJpbmc")
        XCTAssertEqual(string64NoPadding.paddedForBase64, "T25lLXBhZCBzdHJpbmc=")
    }

    func testHexString() {
        let someData = "This is a test string".data(using: .utf8)
        let hexString = someData!.hexadecimalString()

        XCTAssertEqual(hexString, "546869732069732061207465737420737472696e67")
    }

    func testSafeAccess() {
        let array = [1, 2, 3]

        XCTAssertEqual(array.element(at: 3), nil)
    }

    func testUrlRequestDebugDescription() {
        let url = URL(string: "https://simple.org")!

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let parameters: [String: Any] = [
            "parameter1": "value"
        ]

        request.httpBody = try! JSONSerialization.data(withJSONObject: parameters, options: [])

        let description = request.debugLog()

        XCTAssertEqual(description, "https://simple.org\n[\"Content-Type\": \"application/json\"]\n{\"parameter1\":\"value\"}")
    }

    func testStringRangeConversionBeforeEmojiCluster() {
        let string = "This is a *test* string. 🧐 👩‍👩‍👧 Added some emoji clusters *here*."
        let expected = "*test*"

        let range = string.range(of: expected)!
        let nsRange = range.nsRange(on: string)

        let substring = (string as NSString).substring(with: nsRange)

        XCTAssertEqual(substring, expected)
    }

    func testStringRangeConversionAfterEmojiCluster() {
        let string = "This is a *test* string. 🧐 👩‍👩‍👧 Added some emoji clusters *here*."
        let expected = "*here*"

        let range = string.range(of: expected)!
        let nsRange = range.nsRange(on: string)

        let substring = (string as NSString).substring(with: nsRange)

        XCTAssertEqual(substring, expected)
    }

    func testStringRangeConversionsIncludesNonClusterEmoji() {
        let string = "🤔 This is a *test* string."
        let expected = "*test*"

        let range = string.range(of: expected)!
        let nsRange = range.nsRange(on: string)

        let substring = (string as NSString).substring(with: nsRange)

        XCTAssertEqual(substring, expected)
    }

    func testStringRangeConversionsPlainString() {
        let string = "This is a *test* string."
        let expected = "*test*"

        let range = string.range(of: expected)!
        let nsRange = range.nsRange(on: string)

        let substring = (string as NSString).substring(with: nsRange)

        XCTAssertEqual(substring, expected)
    }

    func testStringNSRangeConversionBeforeEmojiCluster() {
        let string = NSString(string: "This is a *test* string. 🧐 👩‍👩‍👧 Added some emoji clusters *here*.")
        let expected = "*test*"

        let nsRange = string.range(of: expected)
        guard let range = nsRange.range(on: string) else {
            XCTFail("Could not get range of substring.")
            return
        }

        let substring = String((string as String)[range])

        XCTAssertEqual(substring, expected)
    }

    func testStringNSRangeConversionAfterEmojiCluster() {
        let string = NSString(string: "This is a *test* string. 🧐 👩‍👩‍👧 Added some emoji clusters *here*.")
        let expected = "*here*"

        let nsRange = string.range(of: expected)
        guard let range = nsRange.range(on: string) else {
            XCTFail("Could not get range of substring.")
            return
        }

        let substring = String((string as String)[range])

        XCTAssertEqual(substring, expected)
    }

    func testStringNSRangeConversionsIncludesNonClusterEmoji() {
        let string = NSString(string: "🤔 This is a *test* string.")
        let expected = "*test*"

        let nsRange = string.range(of: expected)
        guard let range = nsRange.range(on: string) else {
            XCTFail("Could not get range of substring.")
            return
        }

        let substring = String((string as String)[range])

        XCTAssertEqual(substring, expected)
    }

    func testStringNSRangeConversionsPlainString() {
        let string = NSString(string: "This is a *test* string.")
        let expected = "*test*"

        let nsRange = string.range(of: expected)
        guard let range = nsRange.range(on: string) else {
            XCTFail("Could not get range of substring.")
            return
        }

        let substring = String((string as String)[range])

        XCTAssertEqual(substring, expected)
    }

    func testRangesFromString() {
        let string = "This is a *test* string. 🧐 👩‍👩‍👧 Added some emoji clusters *here*."
        let nsRange = string.nsRange(of: "*here*")
        guard let range = string.range(of: "*here*") else {
            XCTFail("Could not get range of substring.")
            return
        }

        XCTAssertEqual(range.nsRange(on: string), nsRange)
        XCTAssertEqual(nsRange.range(on: string as NSString), range)
    }

    func testNSRangeSubstring() {
        let string = "This is a *test* string. 🧐 👩‍👩‍👧 Added some emoji clusters *here*."
        let range = NSRange(location: 63, length: 6)

        let substring = string.substring(with: range)

        XCTAssertEqual(substring, "*here*")
    }

    func testWholeRange() {
        let emptyString = ""
        let clusterString = "This is a test string. 🧐 👩‍👩‍👧 Added some emoji clusters here."
        let simpleString = "This is a test string."


        XCTAssertEqual(emptyString.wholeRange.lowerBound, emptyString.startIndex)
        XCTAssertEqual(emptyString.wholeRange.upperBound, emptyString.endIndex)
        XCTAssertEqual(emptyString.wholeRange.lowerBound, emptyString.wholeRange.upperBound)

        XCTAssertEqual(clusterString.wholeRange.lowerBound, clusterString.startIndex)
        XCTAssertEqual(clusterString.wholeRange.upperBound, clusterString.endIndex)

        XCTAssertEqual(simpleString.wholeRange.lowerBound, simpleString.startIndex)
        XCTAssertEqual(simpleString.wholeRange.upperBound, simpleString.endIndex)
    }
}
