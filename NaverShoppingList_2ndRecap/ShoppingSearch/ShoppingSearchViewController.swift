//
//  ShoppingSearchViewController.swift
//  NaverShoppingList_2ndRecap
//
//  Created by 권현석 on 2023/09/07.
//

//MARK: - 스크롤을 내린 상태에서 다른 검색어로 검색을 하면 화면이 최상단으로 안 감.

import UIKit
import RealmSwift
import Kingfisher

class ShoppingSearchViewController: BaseViewController {
    
    let realm = try! Realm()
    var shoppingList: [Item] = [] {
        didSet {
            mainView.collectionView.reloadData()
        }
    }
    var sortKeyword: String = "sim"
    var currentPage: Int = 1
    var lastPage: Int?
    var totalDataCount: Int? {
        didSet {
            calculateLastPage()
        }
    }
    var displayCount: Int = 30
    
    let mainView = ShoppingSearchView()
    let repository = ShoppingItemTableRepository()
    
    lazy var searchController = {
        let view = UISearchController(searchResultsController: nil)
        view.searchBar.placeholder = "검색어를 입력해주세요"
        view.searchBar.delegate = self
        return view
    }()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(realm.configuration.fileURL)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mainView.collectionView.reloadData()
    }
    
    override func configure() {
        super.configure()
        
        navigationItem.searchController = searchController
        navigationItem.title = "쇼핑 검색"
        
        mainView.collectionView.delegate = self
        mainView.collectionView.dataSource = self
        mainView.collectionView.prefetchDataSource = self
        
        mainView.simSortButton.addTarget(self, action: #selector(simSortButtonTapped), for: .touchUpInside)
        mainView.dateSortButton.addTarget(self, action: #selector(dateSortButtonTapped), for: .touchUpInside)
        mainView.ascSortButton.addTarget(self, action: #selector(ascSortButtonTapped), for: .touchUpInside)
        mainView.dscSortButton.addTarget(self, action: #selector(dscSortButtonTapped), for: .touchUpInside)
        
    }
    
    //MARK: - 버튼을 통한 api호출이 실패가 뜸
    //가능하면 sortKeyword의 값이 이전과 다르면 api호출을 하고 아니면 안 하도록 만들어보자
    
    @objc func simSortButtonTapped() {
        
        sortKeyword = SortEnum.sim.rawValue
        
        guard let text = searchController.searchBar.text else { return }
        print(text)
        APIManager.shared.callRequest(keyword: text, sort: sortKeyword, page: currentPage) { result in
            
            self.totalDataCount = result.total
            self.shoppingList.append(contentsOf: result.items)
        }
    }
    
    @objc func dateSortButtonTapped() {
        sortKeyword = SortEnum.date.rawValue
        
        guard let text = searchController.searchBar.text else { return }
        print(text)
        APIManager.shared.callRequest(keyword: text, sort: sortKeyword, page: currentPage) { result in
            self.totalDataCount = result.total
            self.shoppingList.append(contentsOf: result.items)
        }
    }
    
    @objc func ascSortButtonTapped() {
        sortKeyword = SortEnum.asc.rawValue
        
        guard let text = searchController.searchBar.text else { return }
        print(text)
        APIManager.shared.callRequest(keyword: text, sort: sortKeyword, page: currentPage) { result in
            self.totalDataCount = result.total
            self.shoppingList.append(contentsOf: result.items)
        }
    }
    
    @objc func dscSortButtonTapped() {
        sortKeyword = SortEnum.dsc.rawValue
        
        guard let text = searchController.searchBar.text else { return }
        print(text)
        APIManager.shared.callRequest(keyword: text, sort: sortKeyword, page: currentPage) { result in
            self.totalDataCount = result.total
            self.shoppingList.append(contentsOf: result.items)
        }
    }
        
    func calculateLastPage() {
        
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
        
        APIManager.shared.callRequest(keyword: text, sort: sortKeyword, page: currentPage) { result in
            
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
        //MARK: - 이거 값 전달 할 때 title값 다듬어보기
        let item = shoppingList[indexPath.row]
        //MARK: - 여기서 date에 Date()전달해도 문제없나...?
        vc.realmItem = ShoppingItem(productID: item.productID, mallName: item.mallName, title: item.title, lprice: item.lprice, image: item.image, date: Date())
        
        print(item.mallName)
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension ShoppingSearchViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return shoppingList.count
    }
    
    //MARK: - 셀 컨텐츠 나타내는 메서드는 셀이 갖고있을 수 있게하기
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ShoppingListCollectionViewCell.id,
                                                          for: indexPath) as? ShoppingListCollectionViewCell,
            let url = URL(string: shoppingList[indexPath.row].image) else {
            return UICollectionViewCell()
        }
        
        let item = shoppingList[indexPath.row]
        
        let savedItemList = repository.readSavedShopplinList()
        
        //MARK: - 이건 좀 아쉬운 듯 셀이 그려질 때마다 realm에서 데이터 가져오니까 cellForRowAt 빼면 좋을 듯?
        cell.showCellContents(searchedShoppingItem: item, repoShoppingItem: savedItemList, imageURL: url)

        return cell
    }
}

extension ShoppingSearchViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        
        guard
            let text = searchController.searchBar.text,
            let endPage = lastPage else { return }
        
        for indexPath in indexPaths {
            
            //MARK: - 이태리물소송아지가죽주황색소파로 검색하면 셀 수가 홀수로 떨어져야 하는데 페이지 수랑 다 괜찮은데 셀이 짝수로 떨어짐
            //MARK: - prepareForReuse랑 cancelPreFetching 써보자
            if shoppingList.count - 1 == indexPath.row && currentPage < 1000 && currentPage < endPage {
                currentPage += 1
                APIManager.shared.callRequest(keyword: text, sort: sortKeyword, page: currentPage) { result in
                    self.shoppingList.append(contentsOf: result.items)
                    self.mainView.collectionView.reloadData()
                }
            }
        }
    }
}

