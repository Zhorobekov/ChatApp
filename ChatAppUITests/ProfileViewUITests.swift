//
//  ProfileViewUITests.swift
//  ChatAppUITests
//
//  Created by Эрмек Жоробеков on 11.05.2023.
//

import XCTest

final class ProfileViewUITests: XCTestCase {

    func testProfileScreenHasAllElements() {
        let app = XCUIApplication()
        app.launch()

        // Wait for the screen to load
        app.tabBars["Tab Bar"].buttons["My Profile"].tap()
        
        XCTAssertTrue(app.buttons["Add photo"].exists)
        XCTAssertTrue(app.images["profileImageView"].exists)
        XCTAssertTrue(app.staticTexts["nameLabel"].exists)
    }
}
