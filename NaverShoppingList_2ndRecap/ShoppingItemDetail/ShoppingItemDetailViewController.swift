//
//  ShoppingItemDetailViewController.swift
//  NaverShoppingList_2ndRecap
//
//  Created by 권현석 on 2023/09/08.
//

import UIKit
import WebKit
import RealmSwift

final class ShoppingItemDetailViewController: BaseViewController {
    
    private var savedItemList: Results<ShoppingItem>?
    var selectedItem: Item?
    
    private let mainVC = DetailWebView()
    private let repository = ShoppingItemTableRepository()
    
    override func loadView() {
        self.view = mainVC
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showRightBarButtonImage()
    }
    
    override func configure() {
        super.configure()
        
        savedItemList = repository.readSavedShopplinList()
        
        navigationController?.navigationBar.tintColor = .black
        
        guard let item = selectedItem else { return }
        
        navigationItem.title = item.title
        mainVC.showWebView(productID: item.productID)
        
    }
    
    @objc private
    func likeBarButtonTapped() {
        
        guard let likeItemList = savedItemList,
              let item = selectedItem else { return }
        
        if likeItemList.contains(where: { $0.productID == item.productID }) {
            
            deleteAlert {
                self.repository.deleteShoppingItem(savedItemList: likeItemList, searchedItemList: item)
                self.navigationItem.rightBarButtonItem?.image = UIImage(systemName: ButtonImageName.shared.heartNone)
            }
        } else {
            repository.createShoppingItem(itemToSave: item)
            navigationItem.rightBarButtonItem?.image = UIImage(systemName: ButtonImageName.shared.heartSelected)
        }
    }
    
    private func showRightBarButtonImage() {
        
        guard let shoppingItem = savedItemList,
              let item = selectedItem else { return }
        
        if shoppingItem.contains(where: { $0.productID == item.productID }) {
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: ButtonImageName.shared.heartSelected), style: .plain, target: self, action: #selector(likeBarButtonTapped))
        } else {
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: ButtonImageName.shared.heartNone), style: .plain, target: self, action: #selector(likeBarButtonTapped))
        }
    }
}
