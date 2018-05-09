//
//  CurrencyService.swift
//  Stocks
//
//  Created by Yulia Moskaleva on 09/05/2018.
//  Copyright © 2018 Yulia Moskaleva. All rights reserved.
//

import Foundation
import Alamofire
import CodableAlamofire



class CurrencyService{
    static let sharedInstance = CurrencyService()
    init(){}
    
    struct Constant {
        static let phisixStock = "http://phisix-api3.appspot.com/stocks.json"
    }
    
    func getCurrencyInfo(completionHandler: @escaping ([Currency]?, String?) -> ()){
        
        let decoder = JSONDecoder()
        Alamofire.request(Constant.phisixStock).responseDecodableObject(keyPath: "stock", decoder: decoder) { (response: DataResponse<[Currency]>) in

            switch response.result {
            case .success(let value):
                completionHandler(value, nil)
            case.failure(let error):
                if let err = error as? URLError, err.code == .notConnectedToInternet {
                    completionHandler(nil, "Check your internet connection")
                } else {
                    if let data = response.data {
                        let errorInfo = String(data: data, encoding: .utf8)
                        print("Stock error: \( String(describing: errorInfo))");
                        completionHandler(nil, "Some stock eror occurred")
                    }
                }
            }
        }
    }
    
    
}
