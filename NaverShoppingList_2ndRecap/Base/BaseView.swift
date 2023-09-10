//
//  BaseView.swift
//  NaverShoppingList_2ndRecap
//
//  Created by 권현석 on 2023/09/10.
//

import UIKit

class BaseView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
        setConstraints()
        
    }
    
    @available (*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
    
        backgroundColor = .white
        
    }
    
    func setConstraints() { }
    
}
