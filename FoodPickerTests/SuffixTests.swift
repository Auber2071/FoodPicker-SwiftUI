//
//  SuffixTests.swift
//  SuffixTests
//
//  Created by ALPS on 2023/5/1.
//

import XCTest
import SwiftUI
@testable import FoodPicker

private let store = UserDefaults(suiteName: #file)!

final class SuffixTests: XCTestCase {
    var sut: Suffix<MyWeightUnit> = .init(wrappedValue: .zero, .defaultUnit, store: store)
    @AppStorage(.preferredWeightUnit, store: store) var preferredUnit: MyWeightUnit
    
    override func setUp() {
        super.setUp()
        UserDefaults.standard.removePersistentDomain(forName: #file)
    }
    
    // test_主题_情况_结果
    // Arrange Act Assert
    func testJoinNumberAndSuffix() {
        // test_formattedString_suffixIsEmpty_shouldNotIncludeSpace
        // Arrange 设置
        sut = .init(wrappedValue: 100.1, .gram)
        
        // Act 变化
        let result = sut.projectedValue
        
        // Assert 结果
        XCTAssertEqual(result.description, "100.1 g", "没有后缀时不应该有空格键")
        
        sut = .init(wrappedValue: 100.1, .gram)
        XCTAssertEqual(sut.projectedValue.description, "100.1 g")
    }
    
    
    func testNumberFormatter_preferredPounds() {
        preferredUnit = .pound
        
        sut.wrappedValue = 100
        sut.unit = .gram
        XCTAssertEqual(sut.description, "0.2 pounds")
        
        sut.wrappedValue = -300
        sut.unit = .gram
        XCTAssertEqual(sut.description, "-0.7 pounds")
        
        sut.wrappedValue = 453.592
        sut.unit = .gram
        XCTAssertEqual(sut.description, "1 pounds")
    }
    
    func testNumberFormatter_preferredGrams() {
        sut.wrappedValue = 100
        sut.unit = .gram
        XCTAssertEqual(sut.description, "100 grams")
        
        sut.wrappedValue = 100.678
        sut.unit = .gram
        XCTAssertEqual(sut.description, "100.7 grams", "應該要在小數點第一位四捨五入")
        
        sut.wrappedValue = -100.678
        sut.unit = .gram
        XCTAssertEqual(sut.description, "-100.7 grams")
        
        sut.wrappedValue = 100.6111
        sut.unit = .gram
        XCTAssertEqual(sut.description, "100.6 grams")
    }
    
    
    
    func testNumberFormatter() throws {
        sut = .init(wrappedValue: 100, .gram)
        XCTAssertEqual(sut.projectedValue.description, "100 g")
        
        sut = .init(wrappedValue: 100.678, .gram)
        XCTAssertEqual(sut.projectedValue.description, "100.7 g")
        
        sut = .init(wrappedValue: -100.678, .gram)
        XCTAssertEqual(sut.projectedValue.description, "-100.7 g", "小数点四舍五入一位")
        
        sut = .init(wrappedValue: 100.611, .gram)
        XCTAssertEqual(sut.projectedValue.description, "100.6 g")
    }
    
}

