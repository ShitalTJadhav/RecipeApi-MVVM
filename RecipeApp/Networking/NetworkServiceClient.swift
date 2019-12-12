//
//  NetworkServiceClient.swift
//  RecipeApp
//
//  Created by Tushar  Jadhav on 2019-01-17.
//  Copyright © 2019 Shital  Jadhav. All rights reserved.
//

import Foundation

protocol RecipeServiceProtocol : class {
    
    func fetchData<T: Decodable>(apiName: String, parameters:[String:String]?, genericType: T.Type, completion: @escaping (Result<T, DataResponseError>) -> Void)
    
}

class NetworkServiceClient : RecipeServiceProtocol {
  
  
  private lazy var baseURL: URL = {
    return URL(string: "https://www.food2fork.com/api/")!
  }()
  
  private lazy var apiKey: String = {
    return ""
  }()
  
  private init(){}
  
  public static let shared = NetworkServiceClient()
  
  private var newParameters = [String:String]()
  
  
  func fetchData<T: Decodable>(apiName: String, parameters:[String:String]?, genericType: T.Type, completion: @escaping (Result<T, DataResponseError>) -> Void) {
    
    var urlRequest = URLRequest(url: baseURL.appendingPathComponent(apiName))
    urlRequest.httpMethod = "POST"
    
    if parameters != nil {
      newParameters = ["key": "\(apiKey)"].merging(parameters!, uniquingKeysWith: +)
    } else {
      newParameters = ["key": "\(apiKey)"]
    }
    
    let encodedURLRequest = urlRequest.encode(with: newParameters)
    
    // Check internet connection
    if let reachability = Reachability(), !reachability.isReachable {
      urlRequest.cachePolicy = .returnCacheDataDontLoad
    }
    
    URLSession.shared.dataTask(with: encodedURLRequest) { (data, resp, err) in
      
      if let err = err {
        print("Failed to fetch data:", err)
        completion(Result.failure(DataResponseError.network))
        return
      }
      
      guard let data = data else {
        completion(Result.failure(DataResponseError.custom("Failed to fetch data")))
        return
      }
      
      //
      guard let decodedResponse = try? JSONDecoder().decode(T.self, from: data) else {
        //completion(Result.failure(DataResponseError.decoding))
        completion(Result.failure(DataResponseError.custom("Please login to the https://www.food2fork.com/api/add site and create API KEY")))
        return
      }
      
      completion(Result.success(decodedResponse))
      
    }.resume()
  }
  
}
