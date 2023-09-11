//
//  LikeListViewController.swift
//  NaverShoppingList_2ndRecap
//
//  Created by 권현석 on 2023/09/09.
//

import UIKit
import RealmSwift
import Kingfisher

//MARK: - 이 화면에도 저장한 데이터가 너무 많아지면 preFetch를 해야 할 거임. realm문서에 prefetch관련 내용이 있는지 찾아보자
class LikeListViewController: BaseViewController {
    
    let realm = try! Realm()
    let repository = ShoppingItemTableRepository()
    
    //MARK: - 여기가 shoppingListVC랑 뭐가 다른지 보자
    var likeItemList: Results<ShoppingItem>? {
        didSet {
            mainVC.collectionView.reloadData()
        }
    }
    
    private let mainVC = LikeListView()
    let searchController = CustomSearchController(searchResultsController: nil)
    
    override func loadView() {
        self.view = mainVC
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mainVC.collectionView.reloadData()
    }
    
    override func configure() {
        super.configure()
        
        searchController.searchBar.delegate = self
        
        mainVC.collectionView.delegate = self
        mainVC.collectionView.dataSource = self
        
        likeItemList = repository.sortLikeItemListByDate()
        
        navigationItem.searchController = searchController
        navigationItem.title = NavigationTitleEnum.likeList.rawValue
        
    }
}

extension LikeListViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = ShoppingItemDetailViewController()
        guard let list = likeItemList else { return }
        
        let item = list[indexPath.row]
        
        vc.selectedItem = Item(title: item.title,
                               image: item.image,
                               lprice: item.lprice,
                               mallName: item.mallName,
                               productID: item.productID)
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension LikeListViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let list = likeItemList else { return 0 }
        return list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ShoppingListCollectionViewCell.id, for: indexPath) as? ShoppingListCollectionViewCell,
            let itemList = likeItemList,
            let url = URL(string: itemList[indexPath.row].image) else {
            return UICollectionViewCell()
        }
        
        let item = itemList[indexPath.row]
        
        cell.showLikeListCellContents(imageURL: url,
                                      savedItem: itemList,
                                      index: indexPath.row)
        
        cell.completionHandler = { [weak self] in
            
            self?.deleteAlert {
                self?.repository.deleteLikeItem(savedItemList: itemList, savedItem: item)
                //MARK: - 컬렉션뷰 리로드를 여기서 안 하려면 Realm의 notification token으로 처리를 해줘야함.
                collectionView.reloadData()
            }
        }
        return cell
    }
}

extension LikeListViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.isEmpty {
            likeItemList = repository.sortLikeItemListByDate()
        } else {
            likeItemList = repository.filterLikeItems(keyword: searchText)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        likeItemList = repository.sortLikeItemListByDate()
    }
}
