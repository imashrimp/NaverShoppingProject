//
//  CustomSearchController.swift
//  NaverShoppingList_2ndRecap
//
//  Created by 권현석 on 2023/09/11.
//

import UIKit

class CustomSearchController: UISearchController {
    
    override init(searchResultsController: UIViewController?) {
        super.init(searchResultsController: searchResultsController)
        searchBar.placeholder = "검색어를 입력해주세요"
        searchBar.setValue("취소", forKey: "cancelButtonText")
    }
    
    @available (*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
