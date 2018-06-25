//
//  APIClient.swift
//  CloudApp
//
//  Created by Vinh The on 1/3/17.
//  Copyright © 2017 Vinh The. All rights reserved.
//

import Foundation
import Alamofire

typealias SuccessHandler = (Any?) -> Void
typealias FailedHandler = (Any?) -> Void

enum ConnectionError : Int{
  case success = 200
  case authenticationFailed = 401
  case wrongRequestData = 422
  case serverError = 500
  case servicesUnavailable = 503
  
  var description : String {
    switch self {
    case .success:
      return "Success Request"
    case .authenticationFailed:
      return "Forbidden – Digest authentication failed"
    case .wrongRequestData:
      return "Unprocessable Entity – Wrong request data"
    case .serverError:
      return "Internal Server Error – We had a problem with our server, and we are already taking care of it. Try again later."
    case .servicesUnavailable:
      return "Service Unavailable – Service Unavailable – We’re temporarially offline for maintenance. Please try again later."
    }
    
  }
		
}

enum APIClient : URLConvertible {
  
  private static let BaseURL = "https://my.cl.ly/v3/"
  private static let BaseURLDelete = "http://my.cl.ly/items/"
  case authenticate
  case getAllItems
  case getSpecificItems(String)
  case updateItem(itemSlug : String)
  case deleteItem(itemSlug : String)
  case uploadItem
  case nextPage(String)
  
		func asURL() throws -> URL {
      switch self {
      case .authenticate:
        return URL(string: APIClient.BaseURL)!
      case .getAllItems:
        return URL(string: "http://my.cl.ly/items")!
      case let .deleteItem(itemSlug):
        return URL(string: APIClient.BaseURLDelete + "" + itemSlug)!
      case let .updateItem(itemSlug):
        return URL(string: APIClient.BaseURL + "items/" + itemSlug)!
      case .uploadItem:
        return URL(string: APIClient.BaseURL + "items")! //http://my.cl.ly/items/new
      case let .nextPage(nextPage):
        return URL(string: nextPage)!
      default:
        return URL(string: APIClient.BaseURL)!
      }
  }
  
}

class Router {
  
  static let shared : Router = Router()
  
  private init(){}
  
  static let sessionManager : SessionManager = {
    
    let configuration = URLSessionConfiguration.background(withIdentifier: "mybackground")
    configuration.httpShouldSetCookies = false
    configuration.timeoutIntervalForRequest = 40
    configuration.httpAdditionalHeaders = ["Accept":"application/json", "Content-Type":"application/json"]
    
    let manager = Alamofire.SessionManager(configuration: configuration)
    
    return manager
  
  }()
  
  private func requestAfterLogin(url : APIClient,method : HTTPMethod, parameters : Parameters?) -> DataRequest{
    
      let newSavedUser = UserDefaults.standard.dictionary(forKey: "UserInformation")
    
      return Router.sessionManager.request(url, method: method, parameters : parameters).authenticate(user: newSavedUser!["email"]! as! String, password: newSavedUser!["password"]! as! String, persistence: .none)
  
    
    
  }

  func authenticate(email : String, password : String, success : @escaping SuccessHandler) {
    
    Router.sessionManager.request(APIClient.authenticate).authenticate(user: email, password: password, persistence: .none).responseJSON{ response in
      
      success(response.response?.statusCode)
      
    }
    
  }
  
  func getItem(success : @escaping SuccessHandler, failed : @escaping FailedHandler) {
    
    requestAfterLogin(url: .getAllItems, method: .get, parameters: nil).responseJSON { (response) in
      
      if response.response?.statusCode == 200 {
        
        success(response.result.value)
        
      }else{
      
        failed(response.response?.statusCode)
        
      }
      
    }
    
  }
  
  func getItemNextPage(url : String, success : @escaping SuccessHandler, failed : @escaping FailedHandler) {
    
    requestAfterLogin(url: .nextPage(url), method: .get, parameters: nil).responseJSON { (response) in
      
      if response.response?.statusCode == 200 {
        
        success(response.result.value)
        
      }else{
        
        failed(response.response?.statusCode)
        
      }
      
    }
    
  }

  
  func uploadItem(parameter : Parameters,success : @escaping SuccessHandler, failed : @escaping FailedHandler) {
    
    requestAfterLogin(url: .uploadItem, method: .post, parameters: parameter).responseJSON { (response) in
      
      if response.response?.statusCode == 201 {
        
        success(response.result.value)
        
      }else{
        
        failed(response.response?.statusCode)
        
      }
      
    }
    
  }
  
  func deleteItem(id : String , success : @escaping SuccessHandler, failed : @escaping FailedHandler) {
    requestAfterLogin(url: .deleteItem(itemSlug: id), method: .delete, parameters: nil).response { (response) in
      
      if response.response?.statusCode == 200 {
        
        success(response)
        
      }else{
        
        failed(response.response?.statusCode)
        
      }

      
    }
    
  }
  
  func updateItemName(id : String, parameter : [String : Any], success : @escaping SuccessHandler, failed : @escaping FailedHandler ) {
    
    requestAfterLogin(url: .updateItem(itemSlug: id), method: .put, parameters: parameter).responseJSON { (response) in
      
      if response.response?.statusCode == 200 {
        
        success(response.result.value)
        
      }else{
        
        failed(response.response?.statusCode)
        
      }
    }
    
  }
  
  

}

