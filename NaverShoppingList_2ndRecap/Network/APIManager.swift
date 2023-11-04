//
//  APIManager.swift
//  NaverShoppingList_2ndRecap
//
//  Created by 권현석 on 2023/09/07.
//

import Foundation
import Alamofire

class APIManager {
    
    static let shared = APIManager()
    
    private init() { }
    
    func callRequest(keyword: String, sort: String, page: Int, completionHandler: @escaping (NaverShopping) -> ()) {
        
        let text = "\(keyword)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let sort = "\(sort)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let url = "https://openapi.naver.com/v1/search/shop.json?query=\(text)&display=30&sort=\(sort)&start=\(page)"
        
        let header: HTTPHeaders = [
            APIHeader.id: APIkey.clientID,
            APIHeader.secret: APIkey.clienSecret
        ]
        
        //MARK: - 상태코드 처리
        AF.request(url, method: .get, headers: header).validate()
            .responseDecodable(of: NaverShopping.self) { response in
                let result = response.result
                switch result {
                case .success(let success):
                    completionHandler(success)
                case .failure(let error):
                    //MARK: - 여기 수정
                    print(error)
                }
            }
    }
}
