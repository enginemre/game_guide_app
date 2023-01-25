//
//  NetworkManager.swift
//  game_guide_app
//
//  Created by Emre Muhammet Engin on 18.01.2023.
//

import Foundation
import Alamofire

class NetworkManager{
    static let shared = NetworkManager()
    
    
    func request<T : Codable>(type: T.Type,url:String ,parameters : Parameters?, method : HTTPMethod, completion : @escaping ((Result<T,ErrorTypes>) -> ())){
        AF.request(url, method: method, parameters: parameters).responseDecodable(of: T.self, completionHandler: { (res) in
            switch res.result {
            case .success(let data) :
                completion(.success(data))
            case .failure(_) :
                completion(.failure(ErrorTypes.generalError))
            }
        })
    }
}
