//
//  ShoppingItemTableRepository.swift
//  NaverShoppingList_2ndRecap
//
//  Created by 권현석 on 2023/09/10.
//

import Foundation
import RealmSwift

class ShoppingItemTableRepository {
    
    private let realm = try! Realm()
    
    //MARK: - 쇼핑목록
    
    //1. realmDB에 전체 저장된 데이터 가져오는 메서드
    func readSavedShopplinList() -> Results<ShoppingItem> {
        let result = realm.objects(ShoppingItem.self)
        return result
    }
    
    //2. 버튼 눌렸을 때 특정 객체를 DB에서 삭제하기 위한 메서드
    func deleteShoppingItem(savedItemList: Results<ShoppingItem>, searchedItemList: Item) {
        try! realm.write {
            let itemToDelete = savedItemList.where { $0.productID == searchedItemList.productID }
            realm.delete(itemToDelete)
        }
    }
    
    //3. api로 받아온 데이터를 realm에 저장
    func createShoppingItem(itemToSave: Item) {
        try! realm.write {
            let itemToSave = ShoppingItem(
                productID: itemToSave.productID,
                mallName: itemToSave.mallName,
                title: itemToSave.title,
                lprice: itemToSave.lprice,
                image: itemToSave.image,
                date: Date()
            )
            realm.add(itemToSave)
        }
    }
    
    //MARK: - 좋아요 리스트
    
    //1. 좋아요 리스트에서 아이템 가져올 때 최신 아이템이 상단으로 올라가게하는 메서드
    
    //2. 좋아요 리스트에서 검색 시 대소문자 구분 없이 데이터 가져오는 메서드(이것도 최근에 추가된게 상단에 올라오도록)
    
}