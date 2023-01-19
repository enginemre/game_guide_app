//
//  NetworkHelper.swift
//  game_guide_app
//
//  Created by Emre Muhammet Engin on 18.01.2023.
//

import Foundation
import Alamofire


enum ErrorTypes : String, Error  {
    case invalidData = "Invalid Data"
    case invalidError = "Invalid Error"
    case generalError = "An error happened"
}

enum Paths : String{
    case games = "games"
}

class NetworkHelper {
   static let shared = NetworkHelper()
    
    var parameters: Parameters = [
            "key": "31237d14e73249e09e41a415bb925985"
    ]
    
    var baseUrl = "https://api.rawg.io/api/"
}
