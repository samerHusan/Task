//
//  NetworkManager.swift
//  Demo
//
//  Created by samer Mac on 02/06/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class NetworkManager: NSObject {
    
    static let shared = NetworkManager()
    private override init() {}
    
    func getMethodToFetchData( _ successBlock:@escaping ( _ response: JSON )->Void , errorBlock: @escaping (_ error: NSError) -> Void ){
         let imageUrl:String = "http://abaltamimi.com/apis/galleryCat.php"
        Alamofire.request(imageUrl, method: .get, encoding: JSONEncoding.default).responseJSON { response in
            
            Loader.shared.hideProgressView()
            /* print(response.data)
             print(response.description)
             print(response.result)
             print(response.response)
             print(response)*/
            switch response.result {
            case .success:
                if let value = response.result.value {
                    let json = JSON(value)
                    successBlock(json)
                }
            case .failure(let error):
                errorBlock(error as NSError)
            }
        }
        
    }
    
    
    
}

