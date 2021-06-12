import XCTest
@testable import UserDefaultsExtensions

final class UserDefaultsExtensionsTests: XCTestCase {
    
    override func tearDown() {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "test-int")
        defaults.removeObject(forKey: "test-string")
        defaults.removeObject(forKey: "test-int-array")
        defaults.removeObject(forKey: "test-struct-array")
        defaults.removeObject(forKey: "test-dictionary")
    }
    
    func testPublishedAnnotation_fromClean() {
        tearDown()

        let defaults = UserDefaults.standard
        
        //Verify that it's empty
        XCTAssertEqual(defaults.integer(forKey: "test-int"), 0)
        XCTAssertNil(defaults.string(forKey: "test-string"))
        XCTAssertNil(defaults.array(forKey: "test-int-array"))
        XCTAssertNil(defaults.array(forKey: "test-struct-array"))
        XCTAssertNil(defaults.array(forKey: "test-dictionary"))

        let properties = SimpleExample()
        XCTAssertEqual(properties.intSample, 42)
        XCTAssertEqual(properties.stringSample, "I'm a String")
        XCTAssertEqual(properties.intArraySample, [ 1, 2, 3, 4, 5 ])
        XCTAssertEqual(properties.intStructSample, [ SimpleStruct(name: "one", age: 1), SimpleStruct(name: "two", age: 2) ])
        XCTAssertEqual(properties.dictionarySample, [ 1: SimpleStruct(name: "one", age: 1), 2: SimpleStruct(name: "two", age: 2) ])
        
        //Verify that it's been populated
        XCTAssertEqual(defaults.integer(forKey: "test-int"), 42)
        XCTAssertEqual(defaults.string(forKey: "test-string"), "I'm a String")
        validateFromType(key: "test-int-array", ofType: Array<Int>.self, expectedValue: [ 1, 2, 3, 4, 5 ])
        validateFromType(key: "test-struct-array", ofType: Array<SimpleStruct>.self, expectedValue: [ SimpleStruct(name: "one", age: 1), SimpleStruct(name: "two", age: 2) ])
        validateFromType(key: "test-dictionary", ofType: Dictionary<Int, SimpleStruct>.self, expectedValue: [ 1: SimpleStruct(name: "one", age: 1), 2: SimpleStruct(name: "two", age: 2) ])

        //Make Changes
        properties.intSample = 84
        properties.stringSample = "Am I still a String?"
        properties.intArraySample += [ 100, 99, 98, 97, 96, 95 ]
        properties.intStructSample += [ SimpleStruct(name: "Hello", age: 8) ]
        properties.dictionarySample[11] = SimpleStruct(name: "Eleven", age: 11)
        
        XCTAssertEqual(properties.intSample, 84)
        XCTAssertEqual(properties.stringSample, "Am I still a String?")
        XCTAssertEqual(properties.intArraySample, [ 1, 2, 3, 4, 5, 100, 99, 98, 97, 96, 95 ])
        XCTAssertEqual(properties.intStructSample, [ SimpleStruct(name: "one", age: 1), SimpleStruct(name: "two", age: 2), SimpleStruct(name: "Hello", age: 8) ])
        XCTAssertEqual(properties.dictionarySample, [ 1: SimpleStruct(name: "one", age: 1), 2: SimpleStruct(name: "two", age: 2), 11: SimpleStruct(name: "Eleven", age: 11) ])
        
        //Verify that it's been populated
        XCTAssertEqual(defaults.integer(forKey: "test-int"), 84)
        XCTAssertEqual(defaults.string(forKey: "test-string"), "Am I still a String?")
        validateFromType(key: "test-int-array", ofType: Array<Int>.self, expectedValue: [ 1, 2, 3, 4, 5, 100, 99, 98, 97, 96, 95 ])
        validateFromType(key: "test-struct-array", ofType: Array<SimpleStruct>.self, expectedValue: [ SimpleStruct(name: "one", age: 1), SimpleStruct(name: "two", age: 2), SimpleStruct(name: "Hello", age: 8) ])
        validateFromType(key: "test-dictionary", ofType: Dictionary<Int, SimpleStruct>.self, expectedValue: [ 1: SimpleStruct(name: "one", age: 1), 2: SimpleStruct(name: "two", age: 2), 11: SimpleStruct(name: "Eleven", age: 11) ])
    }

    func testPublishedAnnotation_fromPreviousValues() {
        let defaults = UserDefaults.standard

        //Verify that it's empty
        defaults.set(99, forKey: "test-int")
        defaults.set("Still a String", forKey: "test-string")
        defaults.set(try? JSONEncoder().encode([ 6, 7, 8, 9 ]), forKey: "test-int-array")
        defaults.set(try? JSONEncoder().encode([ SimpleStruct(name: "three", age: 3), SimpleStruct(name: "four", age: 4) ]), forKey: "test-struct-array")
        defaults.set(try? JSONEncoder().encode([ 3: SimpleStruct(name: "three", age: 3), 4: SimpleStruct(name: "four", age: 4) ]), forKey: "test-dictionary")

        let properties = SimpleExample()
        XCTAssertEqual(properties.intSample, 99)
        XCTAssertEqual(properties.stringSample, "Still a String")
        XCTAssertEqual(properties.intArraySample, [ 6, 7, 8, 9 ])
        XCTAssertEqual(properties.intStructSample, [ SimpleStruct(name: "three", age: 3), SimpleStruct(name: "four", age: 4) ])
        XCTAssertEqual(properties.dictionarySample, [ 3: SimpleStruct(name: "three", age: 3), 4: SimpleStruct(name: "four", age: 4) ])
        
        //Verify that it's been populated
        XCTAssertEqual(defaults.integer(forKey: "test-int"), 99)
        XCTAssertEqual(defaults.string(forKey: "test-string"), "Still a String")
        validateFromType(key: "test-int-array", ofType: Array<Int>.self, expectedValue: [ 6, 7, 8, 9 ])
        validateFromType(key: "test-struct-array", ofType: Array<SimpleStruct>.self, expectedValue: [ SimpleStruct(name: "three", age: 3), SimpleStruct(name: "four", age: 4) ])
        validateFromType(key: "test-dictionary", ofType: Dictionary<Int, SimpleStruct>.self, expectedValue: [ 3: SimpleStruct(name: "three", age: 3), 4: SimpleStruct(name: "four", age: 4) ])
        
        //Make Changes
        properties.intSample = 84
        properties.stringSample = "Am I still a String?"
        properties.intArraySample += [ 100, 99, 98, 97, 96, 95 ]
        properties.intStructSample += [ SimpleStruct(name: "Hello", age: 8) ]
        properties.dictionarySample[11] = SimpleStruct(name: "Eleven", age: 11)
        
        XCTAssertEqual(properties.intSample, 84)
        XCTAssertEqual(properties.stringSample, "Am I still a String?")
        XCTAssertEqual(properties.intArraySample, [ 1, 2, 3, 4, 5, 100, 99, 98, 97, 96, 95 ])
        XCTAssertEqual(properties.intStructSample, [ SimpleStruct(name: "one", age: 1), SimpleStruct(name: "two", age: 2), SimpleStruct(name: "Hello", age: 8) ])
        XCTAssertEqual(properties.dictionarySample, [ 1: SimpleStruct(name: "one", age: 1), 2: SimpleStruct(name: "two", age: 2), 11: SimpleStruct(name: "Eleven", age: 11) ])
        
        //Verify that it's been populated
        XCTAssertEqual(defaults.integer(forKey: "test-int"), 84)
        XCTAssertEqual(defaults.string(forKey: "test-string"), "Am I still a String?")
        validateFromType(key: "test-int-array", ofType: Array<Int>.self, expectedValue: [ 1, 2, 3, 4, 5, 100, 99, 98, 97, 96, 95 ])
        validateFromType(key: "test-struct-array", ofType: Array<SimpleStruct>.self, expectedValue: [ SimpleStruct(name: "one", age: 1), SimpleStruct(name: "two", age: 2), SimpleStruct(name: "Hello", age: 8) ])
        validateFromType(key: "test-dictionary", ofType: Dictionary<Int, SimpleStruct>.self, expectedValue: [ 1: SimpleStruct(name: "one", age: 1), 2: SimpleStruct(name: "two", age: 2), 11: SimpleStruct(name: "Eleven", age: 11) ])
    }

    fileprivate func validateFromType<T>(key: String, ofType type: T.Type, expectedValue: T) where T: Codable & Equatable {
        if let tempData = UserDefaults.standard.data(forKey: key),
           let value = try? JSONDecoder().decode(type, from: tempData) {
            XCTAssertEqual(value, expectedValue)
        } else {
            XCTFail("Couldn't deserialize test-int-array")
        }
    }
}

class SimpleExample: ObservableObject {
    @Published(key: "test-int")
    var intSample = 42
    
    @Published(key: "test-string")
    var stringSample = "I'm a String"
    
    @Published(key: "test-int-array", ofType: Array<Int>.self)
    var intArraySample: [ Int ] = [ 1, 2, 3, 4, 5 ]
    
    @Published(key: "test-struct-array", ofType: Array<SimpleStruct>.self)
    var intStructSample: [ SimpleStruct ] = [ SimpleStruct(name: "one", age: 1), SimpleStruct(name: "two", age: 2) ]
    
    @Published(key: "test-dictionary", ofType: Dictionary<Int, SimpleStruct>.self)
    var dictionarySample: [ Int: SimpleStruct ] = [ 1: SimpleStruct(name: "one", age: 1), 2: SimpleStruct(name: "two", age: 2) ]
}

struct SimpleStruct: Codable, Equatable {
    var name: String
    var age: Int
}
