//
//  RecipeAppUITests.swift
//  RecipeAppUITests
//
//  Created by Tushar  Jadhav on 2019-12-12.
//  Copyright © 2019 Shital  Jadhav. All rights reserved.
//

import XCTest

class RecipeAppUITests: XCTestCase {

    let app = XCUIApplication()

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testTableScrolling() {
        
        let tableView = app.tables["RecipeListTableViewIdentifier"]
        _ = tableView.waitForExistence(timeout: 3.0)

        //Check list table exits
        XCTAssert(tableView.exists)
        
//        let indicatorView = app.otherElements["RecipeList_IndicatioView"]
//        XCTAssert(indicatorView.exists)
        
        //Check scroll
        tableView.swipeUp()
        tableView.swipeUp()
    }
    
    func testSearchRecipeFunction()  {
        
        let searchRecipeByNameSearchField = app.otherElements["Search_Recipe"].searchFields["Search recipe by name"]
        searchRecipeByNameSearchField.tap()
        
        let searchText = "Chicken"
        searchRecipeByNameSearchField.typeText(searchText)
        
        //Check type text is visible in search bar
        let searchBarValue = searchRecipeByNameSearchField.value as! String
        XCTAssertEqual(searchBarValue, searchText)

        //Tap keyboard search button
        let searchButton = app/*@START_MENU_TOKEN@*/.keyboards.buttons["Search"]/*[[".keyboards.buttons[\"Search\"]",".buttons[\"Search\"]"],[[[-1,1],[-1,0]]],[1]]@END_MENU_TOKEN@*/
        searchButton.tap()
        sleep(2)
        
       // searchRecipeByNameSearchField.buttons["Clear text"].tap()
       // XCTAssert(searchRecipeByNameSearchField.s == "Chicken")

        searchRecipeByNameSearchField.tap()
        app.buttons["Cancel"].tap()
        
        //Check search bar placeholder is set
        XCTAssertEqual(searchRecipeByNameSearchField.placeholderValue, "Search recipe by name")
    }
    
    
    func testGoToRecipeDetail() {

        //Test Current view title
        XCTAssert(app.navigationBars["Food2Fork"].exists)

        let tableView = app.tables["RecipeListTableViewIdentifier"]
        _ = tableView.waitForExistence(timeout: 3.0)

        //Check list table exits
        XCTAssert(tableView.exists)
        
        //Check table count is not 0
        XCTAssert(tableView.cells.count > 0)
        
        //Get first cell of table view
        let tableCell = tableView.cells.element(boundBy: 0)
        
        let cell = tableView.cells.containing(.cell, identifier: "RecipeTableViewCell_0")
         let cellLabelText = cell.staticTexts["RecipeName_0"].label
       // let cellLabelText = cell.staticTexts.element(boundBy: 0).label
        XCTAssertNotNil(cellLabelText)
        
        //Click on cell
        tableCell.tap()
        
        //Check recipe detail view is visible
        XCTAssert(app.navigationBars[(cellLabelText)].exists)
        sleep(1)
        
        //Get detail table view
        let recipedetailsTable = app.tables["RecipeDetailsTableViewIdentifier"]
        _ = recipedetailsTable.waitForExistence(timeout: 3.0)
        
        XCTAssert(recipedetailsTable.exists)
        
        //Detail view title
        let navTitle = cellLabelText
        XCTAssertNotNil(navTitle)
        
        //Check View Instruction webview view is visible
        recipedetailsTable.buttons["ViewInstructionButton"].tap()
        XCTAssert(app.navigationBars[("Recipe View")].exists)
        app.navigationBars["Recipe View"].buttons[navTitle].tap()
        XCTAssert(app.navigationBars[navTitle].exists)
        
        //Check View Original webview view is visible
        recipedetailsTable.buttons["ViewOriginalButton"].tap()
        XCTAssert(app.navigationBars[("Recipe View")].exists)
        app.navigationBars["Recipe View"].buttons[navTitle].tap()
        
        //Check recipe detail view is visible
        XCTAssert(app.navigationBars[navTitle].exists)
        
        //Check recipe list view is visible
        app.navigationBars[navTitle].buttons["Food2Fork"].tap()
        XCTAssert(app.navigationBars[("Food2Fork")].exists)
        
    }
}
