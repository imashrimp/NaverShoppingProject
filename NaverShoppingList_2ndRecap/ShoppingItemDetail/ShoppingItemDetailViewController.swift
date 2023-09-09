//
//  ShoppingItemDetailViewController.swift
//  NaverShoppingList_2ndRecap
//
//  Created by 권현석 on 2023/09/08.
//

//MARK: - 여기서도 이거 하나로 상세화면 두개 다 퉁 쳐야함?

import UIKit
import WebKit
import RealmSwift

//MARK: - 이 뷰컨으로 검색 화면이랑 리스트 화면에서 모두 상세화면 처리를 받아도 되는지 deinit을 써서 메모리에서 뷰컨 클래스가 해제되는지 확인해보자
//똑같은 쇼핑 아이템을 눌러서 상세화면을 띄워서 좋아요에 추가 삭제를 해도 반영이 되는지 오류는 없는지
//

class ShoppingItemDetailViewController: BaseViewController {
    
    //    var itemtID: String?
    //    var productTitle: String?
    var savedItemList: Results<ShoppingItem>?
    var realmItem: ShoppingItem?
    var buttonSystemImageName: String?
    
    let realm = try! Realm()
    let webView = WKWebView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showRightBarButtonImage()
    }
    
    override func configure() {
        super.configure()
        //MARK: - pk를 알고 한 객체만 불러오니까 objects가 아닌 objects로 렘에서 데이터 불러와서 한 객체로만 처리해보자
        //아마 변수에 ShoppingItem 타입의 프로퍼티를 옵셔널로 선언하고 그 값에다가 객체를 realm에서 읽어와 할당하면 될 듯
        savedItemList = realm.objects(ShoppingItem.self)

        navigationController?.navigationBar.tintColor = .black
        
        guard let item = realmItem else { return }
        
        navigationItem.title = item.title
        
        view.addSubview(webView)
        addWebView()
    }
    
    @objc
    func likeBarButtonTapped() {
        
        guard
            let likeItemList = savedItemList,
            let itemToSave = realmItem else {
            return
        }
        
        if likeItemList.contains(where: { $0.productID == itemToSave.productID }) {
            try! realm.write {
                let itemToRemove = realm.objects(ShoppingItem.self).where {
                    $0.productID == itemToSave.productID
                }
                realm.delete(itemToRemove)
            }
            navigationItem.rightBarButtonItem?.image = UIImage(systemName: "heart")
        } else {
            try! realm.write {
                realm.add(itemToSave)
            }
            navigationItem.rightBarButtonItem?.image = UIImage(systemName: "heart.fill")
        }
    }
    
    override func setConstratints() {
        webView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.verticalEdges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}


extension ShoppingItemDetailViewController {
    func showRightBarButtonImage() {
        
        guard
            let shoppingItem = savedItemList,
            let itemToSave = realmItem else { return }
        
        if shoppingItem.contains(where: { $0.productID == itemToSave.productID }) {
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "heart.fill"), style: .plain, target: self, action: #selector(likeBarButtonTapped))
        } else {
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "heart"), style: .plain, target: self, action: #selector(likeBarButtonTapped))
        }
    }
    
    func addWebView() {
        guard
            let itemToSave = realmItem,
            let url = URL(string: "https://msearch.shopping.naver.com/product/\(itemToSave.productID)") else {
            return
        }
        
        let myRequest = URLRequest(url: url)
        webView.load(myRequest)
    }
}
