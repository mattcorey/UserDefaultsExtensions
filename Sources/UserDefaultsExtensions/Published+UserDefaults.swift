//
//  Published+UserDefaults.swift
//  UserDefaultsExtensions
//
//  Created by Matt Corey on 12/7/19.
//  Copyright © 2019 Matthew Corey. All rights reserved.
//

import Foundation
import Combine

private var cancellables = [String: AnyCancellable]()

public extension Published {
    init(wrappedValue defaultValue: Value, key: String) {
        var value = defaultValue

        if let tempVal = UserDefaults.standard.object(forKey: key),
            let tempValue = tempVal as? Value {

            value = tempValue
        }

        self.init(initialValue: value)
        cancellables[key] = projectedValue.sink { val in
            UserDefaults.standard.set(val, forKey: key)
        }
    }

    init<T>(wrappedValue defaultValue: T, key: String, ofType type: T.Type) where T: Codable {
        //swiftlint:disable force_cast
        var value: Value = defaultValue as! Value
        //swiftlint:enable force_cast

        if let tempData = UserDefaults.standard.data(forKey: key),
            let tempObject = try? JSONDecoder().decode(type, from: tempData),
            let tempValue = tempObject as? Value {

            value = tempValue
        }

        self.init(initialValue: value)
        cancellables[key] = projectedValue.sink { val in
            if let coded = try? JSONEncoder().encode(val as? T) {
                UserDefaults.standard.set(coded, forKey: key)
            }
        }
    }
}
