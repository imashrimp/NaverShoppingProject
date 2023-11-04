//
//  ShoppingSearchViewController.swift
//  NaverShoppingList_2ndRecap
//
//  Created by 권현석 on 2023/09/07.
//

import UIKit

final class ShoppingSearchViewController: BaseViewController {
    
    private var shoppingList: [Item] = [] {
        didSet {
            mainView.collectionView.reloadData()
        }
    }
    private var buttonArray: [UIButton] = []
    private var sortKeyword: String = SortQueryEnum.sim.rawValue
    private var currentPage: Int = 1
    private var displayCount: Int = 30
    private var lastPage: Int?
    private var totalDataCount: Int? {
        didSet {
            calculateLastPage()
        }
    }
    
    
    private let repository = ShoppingItemTableRepository()
    
    private let mainView = ShoppingSearchView()
    private let searchController = CustomSearchController(searchResultsController: nil)
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        repository.printRealmDocumentURL()
        //간짜장 2. notification observer 추가하고, 그 내부에서 특정 셀만 리로드 할 수 있도록
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mainView.collectionView.reloadData()
    }
    
    override func configure() {
        super.configure()
        
        navigationItem.searchController = searchController
        navigationItem.title = NavigationTitleEnum.searchShoppingList.rawValue
        
        searchController.searchBar.delegate = self
        
        mainView.collectionView.delegate = self
        mainView.collectionView.dataSource = self
        mainView.collectionView.prefetchDataSource = self
        
        [
            mainView.simSortButton,
            mainView.dateSortButton,
            mainView.ascSortButton,
            mainView.dscSortButton
        ].forEach {
            buttonArray.append($0)
            $0.addTarget(self, action: #selector(sortButtonTapped), for: .touchUpInside)
        }
        
    }
    
    @objc private func sortButtonTapped(_ sender: UIButton) {
        
        for (i, btn) in buttonArray.enumerated() {
            
            if btn == sender {
                setSortKeyword(buttonNumber: i)
                
                guard let text = searchController.searchBar.text else { return }
                
                APIManager.shared.callRequest(keyword: text,
                                              sort: sortKeyword,
                                              page: currentPage) { result in
                    
                    self.totalDataCount = result.total
                    self.shoppingList = result.items
                    self.shoppingList.append(contentsOf: result.items)
                }
                
                btn.backgroundColor = .black
                btn.setTitleColor(.white, for: .normal)
                
            } else {
                btn.backgroundColor = .white
                btn.setTitleColor(.black, for: .normal)
            }
        }
    }
    
    private func setSortKeyword(buttonNumber: Int) {
        switch buttonNumber {
        case 0:
            sortKeyword = SortQueryEnum.sim.rawValue
        case 1:
            sortKeyword = SortQueryEnum.date.rawValue
        case 2:
            sortKeyword = SortQueryEnum.asc.rawValue
        case 3:
            sortKeyword = SortQueryEnum.dsc.rawValue
        default:
            sortKeyword = SortQueryEnum.sim.rawValue
            print("ERROR")
        }
    }
        
    //MARK: - 매개변수 사용하고 반환값 사용하면 될 듯?
    private func calculateLastPage() {
        
        guard let total = totalDataCount else { return }
        
        if total % displayCount == 0 {
            lastPage = total / displayCount
        } else {
            lastPage = total / displayCount + 1
        }
    }
}

extension ShoppingSearchViewController: UISearchBarDelegate {
    
     func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        shoppingList = []
        
        guard let text = searchBar.text else { return }
        
        APIManager.shared.callRequest(keyword: text,
                                      sort: sortKeyword,
                                      page: currentPage) { result in
            
            self.totalDataCount = result.total
            self.shoppingList.append(contentsOf: result.items)

            self.mainView.collectionView.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        shoppingList = []
    }
}

extension ShoppingSearchViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = ShoppingItemDetailViewController()
        
        let item = shoppingList[indexPath.row]
        
        let trimedTitle = item.title.components(separatedBy: ["<", "b", ">", "/"]).joined()
        
        vc.selectedItem = Item(title: trimedTitle,
                               image: item.image,
                               lprice: item.lprice,
                               mallName: item.mallName,
                               productID: item.productID)
        
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension ShoppingSearchViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return shoppingList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ShoppingListCollectionViewCell.id,
                                                          for: indexPath) as? ShoppingListCollectionViewCell,
            let url = URL(string: shoppingList[indexPath.row].image) else {
            return UICollectionViewCell()
        }
        
        let item = shoppingList[indexPath.row]
        
        let savedItemList = repository.readSavedShopplinList()
        
        cell.showSearchedShoppingCellContents(repoShoppingList: savedItemList,
                                              searchedShoppingItem: item,
                                              imageURL: url)

        return cell
    }
}

extension ShoppingSearchViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        
        guard
            let text = searchController.searchBar.text,
            let endPage = lastPage else { return }
        
        for indexPath in indexPaths {
            
            if shoppingList.count - 1 == indexPath.row && currentPage < 1000 && currentPage < endPage {
                currentPage += 1
                APIManager.shared.callRequest(keyword: text,
                                              sort: sortKeyword,
                                              page: currentPage)
                { result in
                    self.shoppingList.append(contentsOf: result.items)
                    self.mainView.collectionView.reloadData()
                }
            }
        }
    }
}

