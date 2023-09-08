//
//  ShoppingSearchViewController.swift
//  NaverShoppingList_2ndRecap
//
//  Created by 권현석 on 2023/09/07.
//

import UIKit

class ShoppingSearchViewController: BaseViewController {
    
//    var shoppingList: NaverShopping?
    var searchedShoppingList: [Item] = []
    var sortKeyword: String = "sim"
    var currentPage: Int = 1
    var lastPage: Int?
    var totalDataCount: Int? {
        didSet {
            calculateLastPage()
            print("========")
            print(totalDataCount)
        }
    }
    var displayCount: Int = 30
    
    lazy var searchController = {
        let view = UISearchController(searchResultsController: nil)
        view.searchBar.placeholder = "검색어를 입력해주세요"
        view.searchBar.delegate = self
        return view
    }()
    
    //MARK: - 버튼을 컬렉션 뷰로 바꿔서 하면 select 효과를 볼 수 있지 않을까? api 호출 값 전달은 클로저나 델리게이트 쓰고
    let simSortButton = {
        let view = SortButton()
        view.setTitle(" 정확도 ", for: .normal)
        return view
    }()
    
    let dateSortButton = {
        let view = SortButton()
        view.setTitle(" 날짜순 ", for: .normal)
        return view
    }()
    
    let ascSortButton = {
        let view = SortButton()
        view.setTitle(" 가격높은순 ", for: .normal)
        return view
    }()
    
    let dscSortButton = {
        let view = SortButton()
        view.setTitle(" 가격낮은순 ", for: .normal)
        return view
    }()
    
    lazy var collectionView = {
        let view = UICollectionView(frame: .zero,
                                    collectionViewLayout: collectionViewFlowLayout())
        view.register(ShoppingListCollectionViewCell.self,
                      forCellWithReuseIdentifier: ShoppingListCollectionViewCell.id)
        view.delegate = self
        view.dataSource = self
        view.prefetchDataSource = self
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configure() {
        super.configure()
        
        [collectionView,
         simSortButton,
         dateSortButton,
         ascSortButton,
         dscSortButton].forEach {
            view.addSubview($0)
        }
        
        navigationItem.searchController = searchController
        navigationItem.title = "쇼핑 검색"
        
        simSortButton.addTarget(self, action: #selector(simSortButtonTapped), for: .touchUpInside)
        dateSortButton.addTarget(self, action: #selector(dateSortButtonTapped), for: .touchUpInside)
        ascSortButton.addTarget(self, action: #selector(ascSortButtonTapped), for: .touchUpInside)
        dscSortButton.addTarget(self, action: #selector(dscSortButtonTapped), for: .touchUpInside)
        
    }
    
    @objc func simSortButtonTapped() {
        
        sortKeyword = SortEnum.sim.rawValue
        
        guard let text = searchController.searchBar.text else { return }
        
        APIManager.shared.callRequest(keyword: text, sort: sortKeyword, page: currentPage) { result in

            self.totalDataCount = result.total
            self.searchedShoppingList.append(contentsOf: result.items)
            self.collectionView.reloadData()
        }
    }
    
    @objc func dateSortButtonTapped() {
        sortKeyword = SortEnum.date.rawValue
        
        guard let text = searchController.searchBar.text else { return }
        
        APIManager.shared.callRequest(keyword: text, sort: sortKeyword, page: currentPage) { result in
            self.totalDataCount = result.total
            self.searchedShoppingList.append(contentsOf: result.items)
            self.collectionView.reloadData()
        }
    }
    
    @objc func ascSortButtonTapped() {
        sortKeyword = SortEnum.asc.rawValue
        
        guard let text = searchController.searchBar.text else { return }
        
        APIManager.shared.callRequest(keyword: text, sort: sortKeyword, page: currentPage) { result in
            self.totalDataCount = result.total
            self.searchedShoppingList.append(contentsOf: result.items)
            self.collectionView.reloadData()
        }
    }
    
    @objc func dscSortButtonTapped() {
        sortKeyword = SortEnum.dsc.rawValue
        
        guard let text = searchController.searchBar.text else { return }
        
        APIManager.shared.callRequest(keyword: text, sort: sortKeyword, page: currentPage) { result in
            self.totalDataCount = result.total
            self.searchedShoppingList.append(contentsOf: result.items)
            self.collectionView.reloadData()
        }
    }
    
    override func setConstratints() {
        super.setConstratints()
        
        simSortButton.snp.makeConstraints { make in
            make.leading.top.equalTo(view.safeAreaLayoutGuide).inset(8)
            make.height.equalTo(44)
        }
        
        dateSortButton.snp.makeConstraints { make in
            make.top.equalTo(simSortButton.snp.top)
            make.height.equalTo(44)
            make.leading.equalTo(simSortButton.snp.trailing).offset(16)
        }
        
        ascSortButton.snp.makeConstraints { make in
            make.top.equalTo(simSortButton.snp.top)
            make.height.equalTo(44)
            make.leading.equalTo(dateSortButton.snp.trailing).offset(16)
        }
        
        dscSortButton.snp.makeConstraints { make in
            make.top.equalTo(simSortButton.snp.top)
            make.height.equalTo(44)
            make.leading.equalTo(ascSortButton.snp.trailing).offset(16)
            make.trailing.lessThanOrEqualToSuperview().inset(8)
        }
        
        collectionView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(simSortButton.snp.bottom).offset(8)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
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
    
    func calculateLastPage() {
        
        guard
            let total = totalDataCount else { return }
        
        if total % displayCount == 0 {
            lastPage = total / displayCount
        } else {
            lastPage = total / displayCount + 1
        }
        print("마지막 페이지 값 계산했음!!!!")
    }
}

extension ShoppingSearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searchedShoppingList = []
        
        guard let text = searchBar.text else { return }
        
        APIManager.shared.callRequest(keyword: text, sort: sortKeyword, page: currentPage) { result in

            self.totalDataCount = result.total
            self.searchedShoppingList.append(contentsOf: result.items)
            
            self.collectionView.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchedShoppingList = []
        collectionView.reloadData()
    }
}

extension ShoppingSearchViewController: UICollectionViewDelegate {
    
    
}

extension ShoppingSearchViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return searchedShoppingList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ShoppingListCollectionViewCell.id,
                for: indexPath
            )
                as? ShoppingListCollectionViewCell,
            let url = URL(string: searchedShoppingList[indexPath.row].image) else {
            return UICollectionViewCell()
        }
        
        let item = searchedShoppingList[indexPath.row]
        
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

extension ShoppingSearchViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        
        guard
            let text = searchController.searchBar.text,
            let endPage = lastPage else { return }
        
        for indexPath in indexPaths {
            //MARK: - page 범위를 잘 잡아야함 => 일반적인 검색어는 start의 값이 1000을 넘길 수 있지만, 특수한 검색어의 경우 값이 1000이 안될 수 있음 그런 경우 page값을 제한할 수식을 api 호출 데이터인 total과 display값을 사용해 start 값을 제한함
            if searchedShoppingList.count - 1 == indexPath.row && currentPage < 1000 && currentPage < endPage {
                currentPage += 1
                APIManager.shared.callRequest(keyword: text, sort: sortKeyword, page: currentPage) { result in
                    self.searchedShoppingList.append(contentsOf: result.items)
                    self.collectionView.reloadData()
                }
            }
        }
    }
}
