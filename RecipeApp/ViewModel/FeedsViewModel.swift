//
//  FeedsViewModel.swift
//  FeedDemo
//
//  Created by Tushar  Jadhav on 2019-03-02.
//  Copyright © 2019 Shital  Jadhav. All rights reserved.
//

import Foundation

protocol UserDetailsDelegate {
    
    func updateTableRowWithUserDetails(index : Int)
}

class FeedsViewModel {
    
    weak var service :RecipesService?
    var feeds : [ActivityFeed] = []
    var delegate : UserDetailsDelegate!
    var oldestDate : String = ""
    var fromDate : String = ""
    var toDate : String = ""

    var isLastPage = false

    private var isFetchInProgress = false
    
    init(service : RecipesService?) {
        self.service = service
        
        toDate = self.getCurrentDate()
        fromDate = self.getEalierDateFrom(dateStr: toDate)
    }
    
    var currentCount: Int {
        return feeds.count
    }
    
    func recipe(at index: Int) -> ActivityFeed {
        return feeds[index]
    }
    
    
    func fetchActivityFeeds(_ completion: @escaping (Result<Bool, DataResponseError>) -> Void) {
        
        guard let _ = service else {
            completion(Result.failure(DataResponseError.custom("Missing service")))
            return
        }
        
        guard !isFetchInProgress else {
            return
        }
        print("From Date : ",fromDate)
        print("to Date : ",toDate)

        isFetchInProgress = true
        
        self.service?.fetchFeeds(fromDate: fromDate, toDate: toDate, completion: { [weak self] feeds in
            
            self?.isFetchInProgress = false
            
            self?.oldestDate = feeds?.oldest ?? ""
            self?.feeds.append(contentsOf: feeds?.activities ?? [])

            //Get next fetch date
            self?.getNextFetchDate()
            
            DispatchQueue.main.async {
                
                 completion(Result.success(true))
            }
            //            print("Feeds : ", feeds)
        })
        
    }
    
    func getNextFetchDate() {
        
        //
        toDate = fromDate
        fromDate = self.getEalierDateFrom(dateStr: toDate)
    }
    
    func fetchFeedUserDetails(userId: Int, index : Int, completion: @escaping (Result<Bool, DataResponseError>) -> Void) {
        
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        
        let completionOperation = BlockOperation {
            // do something
        }
        
        // for (index, model) in self.feeds.enumerated() {
        print("Item \(index): \(index)")
        
        let operation = BlockOperation(block: {
            if Thread.isMainThread {
                print("Operation run on main thread")
            }
            let feed = self.feeds[index] as ActivityFeed
            
            self.service?.fetchUser(userId:String(userId), completion: {[weak self] user in
                feed.postUser = user
                // self?.dataSource?.data.value = [feed]
//                DispatchQueue.main.async {
//                    self?.delegate?.updateTableRowWithUserDetails(index: index)
//                }
            })
            // operation.identifier = String(index)
        })
        completionOperation.addDependency(operation)
        queue.addOperation(operation)
        
        OperationQueue.main.addOperation(completionOperation)
        
        completionOperation.completionBlock = {
            
            print("completionOperation completed")
            completion(Result.success(true))

        }
    }
    
    func fetchFeedUserFrom(of elementIndex : Int) {
        
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 4
        
        let completionOperation = BlockOperation {
            // do something
        }
        
        for index in elementIndex..<self.feeds.count {
        
       // for (index, model) in self.feeds.enumerated() {
            print("Item \(index): \(index)")
            
            let operation = BlockOperation(block: {
                if Thread.isMainThread {
                    print("Operation run on main thread")
                }
                let feed = self.feeds[index] as ActivityFeed
            self.service?.fetchUser(userId:String(feed.userId), completion: {[weak self] user in
                feed.postUser = user
                // self?.dataSource?.data.value = [feed]
                DispatchQueue.main.async {
                    self?.delegate?.updateTableRowWithUserDetails(index: index)
                }
            })
                // operation.identifier = String(index)
            })
            completionOperation.addDependency(operation)
            queue.addOperation(operation)
        }
        
        OperationQueue.main.addOperation(completionOperation)
        
        completionOperation.completionBlock = {
            
            print("completionOperation completed")
            
        }
    }
    
    
    func fetchRecipes(_ completion: @escaping (Result<Bool, DataResponseError>) -> Void) {
        
        guard let service = service else {
            completion(Result.failure(DataResponseError.custom("Missing service")))
            return
        }
        
        guard !isFetchInProgress else {
            return
        }
        
        service.fetchFeeds(fromDate: "2019-02-25T00:00:00+00:00", toDate: "2019-02-28T00:00:00+00:00",completion: { [weak self] feeds in
            
            self?.feeds = feeds?.activities ?? []
            
            //            let operationQueue: O"perationQueue = OperationQueue()
            //            operationQueue.maxConcurrentOperationCount = 1
            
            for model in feeds?.activities ?? [] {
                let feed = model as ActivityFeed
                service.fetchUser(userId:String(feed.userId), completion: {[weak self] user in
                    feed.postUser = user
                })
            }
            
            DispatchQueue.main.async {
                completion(Result.success(true))
            }
            
        })
        
        
        /*    var paramater = ["page": String(self.currentPage)]
         
         if let searchRecipe = searchRecipeText {
         paramater["q"] = searchRecipe
         }
         
         
         service.fetchData(apiName: "search", parameters: paramater, genericType: RecipeResponseModel.self) {[weak self] result  in
         
         switch result {
         
         case .failure(let error):
         DispatchQueue.main.async {
         self?.isFetchInProgress = false
         completion(Result.failure(error))
         }
         case .success(let response):
         
         self?.isFetchInProgress = false
         
         if (self?.searchRecipeText) != nil {
         self?.filteredRecipes.append(contentsOf: response.recipes)
         }
         else {
         self?.currentPage += 1
         self?.recipes.append(contentsOf: response.recipes)
         
         //Check last page and set flag true
         if response.count < 1 {
         self?.isLastPage = true
         }
         }
         
         DispatchQueue.main.async {
         completion(Result.success(true))
         }
         }
         }
         */
    }
    
    fileprivate func isLoadingCell(for index: Int) -> Bool {
        return index == self.currentCount - 1 && !self.isLastPage
    }
    
    func loadMoreFeed(at index: Int) -> Bool {
        // more items to fetch - search last cell
        
        if isLoadingCell(for: index) {
            return true
        }
        return false
    }
    
    func getCurrentDate() -> String
    {
        let formatter = DateFormatter()
        //formatter.dateFormat = "yyyy/MM/dd hh:mm a"
        // formatter.dateFormat = "dd-MM-yyyy hh:mm a"
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        let currentDateTime = Date()
        let result:String = formatter.string(from: currentDateTime)
        
        return result
    }
    
    func getEalierDateFrom(dateStr : String) -> String
    {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        
        guard let toDate = formatter.date(from: dateStr) else {
            return dateStr
        }
        
        let resultDate = Calendar.current.date(byAdding: .day, value: -14, to: toDate)
        
        if let resultDate = resultDate {
            return formatter.string(from: resultDate)
        }
        return dateStr
    }
    
    func getFeedPostDate(dateStr: String) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let date = dateFormatter.date(from: dateStr)
        dateFormatter.dateFormat = "dd MMM yyyy"
        return dateFormatter.string(from: date!)
    }
}
