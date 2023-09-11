//
//  DetailWebView.swift
//  NaverShoppingList_2ndRecap
//
//  Created by 권현석 on 2023/09/11.
//

import UIKit
import WebKit
import SnapKit

class DetailWebView: BaseView {
    
    let webView = WKWebView()
    
    override func configure() {
        super.configure()
        addSubview(webView)
    }
    
    override func setConstraints() {
        webView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.verticalEdges.equalTo(self.safeAreaLayoutGuide)
        }
    }
    
    func showWebView(productID: String) {
        guard let url = URL(string: "https://msearch.shopping.naver.com/product/\(productID)") else { return }
        
        let myRequest = URLRequest(url: url)
        
        webView.load(myRequest)
    }
}
