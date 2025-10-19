//
//  GitHubDemoUITests.swift
//  GitHubDemoUITests
//
//  Created by Prajakta Aher on 15/10/25.
//

import XCTest
import UIUtilities

final class UserListPage {
    private let app: XCUIApplication!
    
    init(app: XCUIApplication!) {
        self.app = app
    }
    
    var navigationBar: XCUIElement {
        app.navigationBars["Users List"]
    }

    var contentView: XCUIElement {
        app.otherElements[UsersListAccessibilityIdentifiers.content.rawValue]
    }
}

final class GitHubDemoUITests: XCTestCase {
    var page: UserListPage!

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        let app = XCUIApplication()
        app.launchArguments = ["UITesting"]
        page = UserListPage(app: app)
        app.launch()
    }

    override func tearDown() {
        page = nil
        super.tearDown()
    }

    // MARK: - Navigation to Detail View Tests

    @MainActor
    func testListView() async throws {
        XCTAssertTrue(page.contentView.waitForExistence(timeout: 5), "User list should appear")

        XCTAssertTrue(
            page.navigationBar.exists,
            "Should be on list view"
        )
    }
}
