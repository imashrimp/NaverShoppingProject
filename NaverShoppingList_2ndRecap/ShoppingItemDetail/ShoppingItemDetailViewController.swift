//
//  ShoppingItemDetailViewController.swift
//  NaverShoppingList_2ndRecap
//
//  Created by 권현석 on 2023/09/08.
//

//MARK: - 여기서도 이거 하나로 상세화면 두개 다 퉁 쳐야함?

import UIKit

class ShoppingItemDetailViewController: BaseViewController {
    
    
    //화면을 전환해서 값 전달 받아야하는데 객체 필요없고, productID, title 넘겨서, 웹 뷰 띄우기
    //우측 상단 버튼의 하트 이미지는 cellForAt이랑 같은 로직으로 이미지 설정하면 될 듯.
    //그리고 버튼 눌렀을 때 저장 및 해제 그리고 이미지 변경 로직도 cellForRowAt이랑 같음.
    
    override func configure() {
        super.configure()
        view.backgroundColor = .red
    }
    
}
