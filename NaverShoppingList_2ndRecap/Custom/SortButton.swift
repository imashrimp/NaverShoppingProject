//
//  SortButton.swift
//  NaverShoppingList_2ndRecap
//
//  Created by 권현석 on 2023/09/08.
//

import UIKit

class SortButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 6
        layer.borderWidth = 2
        layer.borderColor = UIColor.gray.cgColor
        setTitleColor(.gray, for: .normal)
    }
    
    @available (*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
