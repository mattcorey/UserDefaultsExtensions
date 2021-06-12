![project status](https://github.com/mattcorey/UserDefaultsExtensions/actions/workflows/swift.yml/badge.svg)

# UserDefaultsExtensions

Utility classes to help easily work with UserDefaults

## @Published

This package includes an extension to the standard Published property wrapper to make it simple to persist properties annotated with @Published into UserDefaults.  It includes the following feature:

 - Can support any struct type that conforms to Codable
 - Can support Arrays and Dictionaries, using the `ofType` parameter, coupled with an explicit type declaration
 - Properties with a default value will maintain that, and the value will be stored in UserDefaults when the object is created for the first time.  Subsequent object initializaton will read the value from UserDefaults, and will not use the default value 

### Usage

``` Swift
import UserDefaultsExtensions

class SomeSettings: ObservableObject {
    //This property will not be saved, but will behave like a normal @Published property
    @Published
    var someTransientSetting = true
    
    //This property will be saved in the standard UserDefaults, under a key name 'boolean-example', with a default value of `false`
    // It can be extracted manually using UserDefaults.standard.boolean(forKey: 'boolean-example')
    @Published(key: "boolean-example")
    var somePersistentBoolean = false
    
    //This property will be saved in the standard UserDefaults, under a key name 'struct-example', with a default value of `SimpleStruct(name: "Bill", age: 42)`
    // It can be extracted manually using UserDefaults.standard.object(forKey: 'struct-example')
    @Published(key: "struct-example")
    var someCodableStruct = SimpleStruct(name: "Bill", age: 42)

    //This property will be saved in the standard UserDefaults, under a key name 'array-example', with a default value of `[ 10, 20, 30, 40 ]`
    // It can be extracted manually using UserDefaults.standard.array(forKey: 'array-example')
    @Published(key: "array-example", ofType: Array<Int>.self)
    var someCodableStruct: [ Int ] = [ 10, 20, 30, 40 ]

    //This property will be saved in the standard UserDefaults, under a key name 'dictionary-example', with a default value of `[ 1: SimpleStruct(name: "one", 1), 2: SimpleStruct(name: "two", 2) ]`
    // It can be extracted manually using UserDefaults.standard.array(forKey: 'dictionary-example')
    @Published(key: "dictionary-example", ofType: Dictionary<Int: SimpleStruct>.self)
    var someCodableStruct: [ Int: SimpleStruct ] = [ 1: SimpleStruct(name: "one", 1), 2: SimpleStruct(name: "two", 2) ]

}

struct SimpleStruct: Codable {
    var name: String
    var age: Int
}
```
