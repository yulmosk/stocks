//
//  Currency.swift
//  Stocks
//
//  Created by Yulia Moskaleva on 09/05/2018.
//  Copyright © 2018 Yulia Moskaleva. All rights reserved.
//

import Foundation

//Structures for JSON mapping

struct Currency: Decodable {
    var name:String
    var volume:Int
    var price: Price
    
}

struct Price: Decodable {
    var amount: Double
}
