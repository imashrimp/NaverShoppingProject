//
//  ShoppingItemRealmModel.swift
//  NaverShoppingList_2ndRecap
//
//  Created by 권현석 on 2023/09/08.
//

import Foundation
import RealmSwift

class ShoppingItem: Object {
    
    //MARK: - 이미지는 정해보자
    @Persisted(primaryKey: true) var productID: String
    @Persisted var mallName: String
    @Persisted var title: String
    @Persisted var lprice: String
    
    convenience init(productID: String,
                     mallName: String,
                     title: String,
                     lprice: String) {
        self.init()
        self.productID = productID
        self.mallName = mallName
        self.title = title
        self.lprice = lprice
    }

}
