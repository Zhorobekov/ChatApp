//
//  ThemeServiceTests.swift
//  ChatAppTests
//
//  Created by Эрмек Жоробеков on 09.05.2023.
//

import XCTest
@testable import ChatApp

final class ThemeServiceTests: XCTestCase {
 
    func testThemeSetNewTheme() {
        // Arrange
        let themeService = ThemeService()
        let expected = [UIUserInterfaceStyle.dark, UIUserInterfaceStyle.light].first(where: { $0 != themeService.currentTheme })!
        
        // Act
        themeService.save(theme: expected)
        
        // Assert
        XCTAssertEqual(themeService.currentTheme, expected)
    }
}
