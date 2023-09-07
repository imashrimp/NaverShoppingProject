//
//  BaseViewController.swift
//  NaverShoppingList_2ndRecap
//
//  Created by 권현석 on 2023/09/07.
//

import UIKit

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        setConstratints()
    }
    
    func configure() {
        //MARK: - 여기 바뀔 수 있음.
        view.backgroundColor = .white //이게 아니면 다크모드 일 수 있음.
    }
    
    func setConstratints() { }
}
