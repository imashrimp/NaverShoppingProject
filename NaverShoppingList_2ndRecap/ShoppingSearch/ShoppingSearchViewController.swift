//
//  ShoppingSearchViewController.swift
//  NaverShoppingList_2ndRecap
//
//  Created by 권현석 on 2023/09/07.
//

import UIKit

class ShoppingSearchViewController: BaseViewController {
    
    var shoppingList: NaverShopping?
    
    lazy var collectionView = {
        let view = UICollectionView(frame: .zero,
                                    collectionViewLayout: collectionViewFlowLayout())
        view.register(ShoppingListCollectionViewCell.self,
                      forCellWithReuseIdentifier: ShoppingListCollectionViewCell.id)
        view.delegate = self
        view.dataSource = self
        return view
    }()
    
    lazy var searchController = {
        let view = UISearchController(searchResultsController: nil)
        view.searchBar.placeholder = "검색어를 입력해주세요"
        view.searchBar.delegate = self
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configure() {
        super.configure()
        view.addSubview(collectionView)
        navigationItem.searchController = searchController
        navigationItem.title = "쇼핑 검색"
        navigationItem.hidesSearchBarWhenScrolling = true
    }
    
    override func setConstratints() {
        super.setConstratints()
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func collectionViewFlowLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        let space: CGFloat = 8
        let width = (UIScreen.main.bounds.width - (space * 3)) / 2
        let height = UIScreen.main.bounds.height / 3
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 8
        layout.sectionInset = UIEdgeInsets(top: 8,
                                           left: 8,
                                           bottom: 8,
                                           right: 8)
        layout.itemSize = CGSize(width: width, height: height)
        
        return layout
    }
}

extension ShoppingSearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        shoppingList = nil
        
        guard let text = searchBar.text else { return }
        
        APIManager.shared.callRequest(keyword: text) { result in
            self.shoppingList = result
            self.collectionView.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        shoppingList = nil //MARK: - 이래도 에러가 안 터지나...?
        collectionView.reloadData()
    }
}

extension ShoppingSearchViewController: UICollectionViewDelegate {
    
}

extension ShoppingSearchViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        guard let myshoppingList = shoppingList else { return 0 }
        
        return myshoppingList.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ShoppingListCollectionViewCell.id,
                for: indexPath
            )
                as? ShoppingListCollectionViewCell,
            let myShoppingList = shoppingList,
            let url = URL(string: myShoppingList.items[indexPath.row].image) else {
            return UICollectionViewCell()
        }
        
        let item = myShoppingList.items[indexPath.row]
        
        cell.mallNameLabel.text = item.mallName
        cell.titleLabel.text = item.title
        cell.lpriceLabel.text = item.lprice
        
        DispatchQueue.global().async {
            do {
                let data = try Data(contentsOf: url)
                DispatchQueue.main.async {
                    cell.productImage.image = UIImage(data: data)
                }
            } catch {
                DispatchQueue.main.async {
                    cell.productImage.image = UIImage(systemName: "questionmark.app.fill")
                }
            }
        }
        return cell
    }
}
