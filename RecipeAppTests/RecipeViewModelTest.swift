//
//  RecipeViewModelTest.swift
//  RecipeAppTests
//
//  Created by Tushar  Jadhav on 2019-01-17.
//  Copyright © 2019 Shital  Jadhav. All rights reserved.
//

import XCTest
@testable import RecipeApp

class RecipeViewModelTest: XCTestCase {
    
    var viewModel : RecipeViewModel!
    fileprivate var service : MockNetworkServiceClient!

    override func setUp() {
        super.setUp()
        self.service = MockNetworkServiceClient()
        self.viewModel = RecipeViewModel(service: service!)
        
        self.service.result = RecipeResponseModel(count: 30, recipes:
            [Recipe(publisher: "Closet Cooking", recipeName: "Jalapeno Popper Grilled Cheese Sandwich", recipeId:"35382" , recipeViewUrl:"http://www.closetcooking.com/2011/04/jalapeno-popper-grilled-cheese-sandwich.html" , recipeImageUrl:"http://static.food2fork.com/Jalapeno2BPopper2BGrilled2BCheese2BSandwich2B12B500fd186186.jpg" , recipeInstructionUrl:"http://food2fork.com/view/35382" , socialRank:100.0 , publisherUrl: "http://closetcooking.com", ingredients: nil)])
    }
    
    override func tearDown() {
        self.viewModel = nil
        self.service = nil
        super.tearDown()
    }
    
    func callFetchRecipes() {
        // expected completion to succeed
        viewModel.fetchRecipes { result in
            switch result {
            case .failure(_) :
                XCTAssert(false, "ViewModel should be able to fetch recipes")
            default:
                break
            }
        }
    }
    
    func testFetchRecipes_WithNoError() {
        
        // giving a service mocking recipes
        service.shouldReturnError = false
        callFetchRecipes()
    }
    
    func testFetchRecipes_Pagination() {
        
        // giving a service mocking recipes
        service.shouldReturnError = false
        
        XCTAssertTrue(viewModel.currentCount == 0)
        XCTAssert(viewModel.currentPage == 1, "Page count is 1")
        
        callFetchRecipes()
        XCTAssertTrue(viewModel.currentCount > 0)
        
        XCTAssert(viewModel.currentPage == 2, "Page count is 2")
        callFetchRecipes()
    }
    
    
    func testFetchRecipes_WithError() {
        
        // giving a service mocking error during fetching Recipes
        service.shouldReturnError = true
        
        // expected completion to fail
        viewModel.fetchRecipes { result in
            switch result {
            case .failure(_) :
                XCTAssert(true, "ViewModel should not be able to fetch recipes")
            default:
                break
            }
        }
    }
    
    func testSearchRecipes() {
        
        viewModel.searchRecipeText = "Chicken"
        service.shouldReturnError = false

        // expected completion to succeed
        viewModel.fetchRecipes { result in
            switch result {
            case .failure(_) :
                XCTAssert(false, "ViewModel should be able to fetch search recipes")
                XCTAssert(self.viewModel.searchTotalCount > 0, "Page count is 1")
            default:
                break
            }
        }
    }
}

fileprivate class MockNetworkServiceClient : RecipeServiceProtocol {
    
    
    var shouldReturnError = false
    
   /* var result = RecipeResponseModel(count: 30, recipes:
    [Recipe(publisher: "Closet Cooking", recipeName: "Jalapeno Popper Grilled Cheese Sandwich", recipeId:"35382" , recipeViewUrl:"http://www.closetcooking.com/2011/04/jalapeno-popper-grilled-cheese-sandwich.html" , recipeImageUrl:"http://static.food2fork.com/Jalapeno2BPopper2BGrilled2BCheese2BSandwich2B12B500fd186186.jpg" , recipeInstructionUrl:"http://food2fork.com/view/35382" , socialRank:100.0 , publisherUrl: "http://closetcooking.com", ingredients: nil)])*/
    
    var result : Decodable!
    
    func fetchData<T: Decodable>(apiName: String, parameters: [String : String]?, genericType: T.Type, completion: @escaping (Result<T, DataResponseError>) -> Void) {
        
        if !shouldReturnError {
           // let result : Result<T,DataResponseError> =
            completion(Result.success(result as! T))
        }
        else {
            completion(Result.failure(DataResponseError.custom("No data")))
        }
        
    }

}
