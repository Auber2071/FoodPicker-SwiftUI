//
//  MyWeightUnit.swift
//  FoodPicker
//
//  Created by ALPS on 2023/4/30.
//

import Foundation

enum EnergyUnit: String, MyUnitProtocol {
    
    static var userDefaultsKey: UserDefaults.Key = .preferredEnergyUnit
    
    static var defaultUnit: EnergyUnit = .cal
    
    case cal = "大卡"
    
    var dimension: UnitEnergy {
        switch self {
        case .cal:
            return UnitEnergy.calories
        }
    }
}

enum MyWeightUnit: String, MyUnitProtocol {
    case gram = " g", pound = " lb", ounce
    
    var dimension: UnitMass {
        switch self {
        case .gram:
            return .grams
            
        case .pound:
            return .pounds
            
        case .ounce:
            return .ounces
        }
    }
    
    static var userDefaultsKey: UserDefaults.Key = .preferredWeightUnit
    
    static var defaultUnit: MyWeightUnit = .gram
    
}

