//
//  CrypttTests.swift
//  CrypttTests

import XCTest
@testable import Cryptt

final class AppIconManagerTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        saveCurrentAppIcon()
    }
    
    override func tearDown() {
        super.tearDown()
        restoreAppIcon()
    }

    func test_appIconIsCorrectAfterInit() {
        let sut = makeSUT()
        let expect = currentAppIcon
        
        XCTAssertEqual(sut.getCurrentIcon(), expect)
    }
    
    func test_appIconChanged() {
        let sut = makeSUT()
        let oldIcon = currentAppIcon
        let newIcon = anyAppIconExceptCurrent
        sut.changeIcon(icon: newIcon)
        sut.updateBlock = {
            XCTAssert(self.currentAppIcon != oldIcon)
        }
    }
    
    func test_appIconChangedCorrectly() {
        let sut = makeSUT()
        let testAppIcon = anyAppIconExceptCurrent
        sut.changeIcon(icon: testAppIcon)
        sut.updateBlock = {
            XCTAssertEqual(self.currentAppIcon, testAppIcon)
        }
    }
    
    func test_appIconChangedCorrectly_ifIconWasChangedFewTimesOneByOne() {
        let sut = makeSUT()
        sut.changeIcon(icon: anyAppIconExceptCurrent)
        sut.changeIcon(icon: anyAppIconExceptCurrent)

        let testAppIcon = anyAppIconExceptCurrent
        sut.changeIcon(icon: testAppIcon)
        
        sut.updateBlock = {
            XCTAssertEqual(self.currentAppIcon, testAppIcon)
        }
    }
    
    // MARK: - Helpers
    private func makeSUT() -> AppIconManager {
        AppIconManager()
    }
    
    private var anyAppIconExceptCurrent: AppIcon {
        AppIcon.allCases.filter { $0 != currentAppIcon }.randomElement() ?? .yellowIcon
    }
    
    private var initialAppIcon: AppIcon = .yellowIcon
    private let appIconKey = "cryptt_app_icon"
    private let defaults = UserDefaults.standard

    private var currentAppIcon: AppIcon {
        guard let name = defaults.string(forKey: appIconKey) else {
            return .yellowIcon
        }
        guard let appIcon = AppIcon(rawValue: name) else {
            return .yellowIcon
        }
        return appIcon
    }
    
    private func saveCurrentAppIcon() {
        initialAppIcon = currentAppIcon
    }
    
    private func restoreAppIcon() {
        defaults.setValue(initialAppIcon.rawValue, forKey: appIconKey)
    }
}
