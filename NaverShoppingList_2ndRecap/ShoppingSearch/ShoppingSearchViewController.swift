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
            collectionView.reloadData()
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
        print(realm.configuration.fileURL)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
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
    
    //MARK: - 버튼을 통한 api호출이 실패가 뜸
    //가능하면 sortKeyword의 값이 이전과 다르면 api호출을 하고 아니면 안 하도록 만들어보자
    
    @objc func simSortButtonTapped() {
        
        sortKeyword = SortEnum.sim.rawValue
        
        guard let text = searchController.searchBar.text else { return }
        
        APIManager.shared.callRequest(keyword: text, sort: sortKeyword, page: currentPage) { result in
            
            self.totalDataCount = result.total
            self.shoppingList.append(contentsOf: result.items)
        }
    }
    
    @objc func dateSortButtonTapped() {
        sortKeyword = SortEnum.date.rawValue
        
        guard let text = searchController.searchBar.text else { return }
        
        APIManager.shared.callRequest(keyword: text, sort: sortKeyword, page: currentPage) { result in
            self.totalDataCount = result.total
            self.shoppingList.append(contentsOf: result.items)
        }
    }
    
    @objc func ascSortButtonTapped() {
        sortKeyword = SortEnum.asc.rawValue
        
        guard let text = searchController.searchBar.text else { return }
        
        APIManager.shared.callRequest(keyword: text, sort: sortKeyword, page: currentPage) { result in
            self.totalDataCount = result.total
            self.shoppingList.append(contentsOf: result.items)
        }
    }
    
    @objc func dscSortButtonTapped() {
        sortKeyword = SortEnum.dsc.rawValue
        
        guard let text = searchController.searchBar.text else { return }
        
        APIManager.shared.callRequest(keyword: text, sort: sortKeyword, page: currentPage) { result in
            self.totalDataCount = result.total
            self.shoppingList.append(contentsOf: result.items)
        }
    }
    
    override func setConstratints() {
        
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
            
            self.collectionView.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        shoppingList = []
    }
}

extension ShoppingSearchViewController: UICollectionViewDelegate {
//
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
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ShoppingListCollectionViewCell.id,
                                                          for: indexPath) as? ShoppingListCollectionViewCell,
            let url = URL(string: shoppingList[indexPath.row].image) else {
            return UICollectionViewCell()
        }
        
        let item = shoppingList[indexPath.row]
        
        //상품 이미지 로직 => 킹피셔 없이 쓰려면 뭐가 필요하고 필요한걸 어디서 어떻게 써야할까?
//        DispatchQueue.global().async {
//            do {
//                let data = try Data(contentsOf: url)
////                DispatchQueue.main.async {
////                    cell.productImage.image = UIImage(data: data)
////                }
//                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//                    cell.productImage.image = UIImage(data: data)
//                    print("**IMAGE", item.title)
//                }
//            } catch {
//                DispatchQueue.main.async {
//                    cell.productImage.image = UIImage(systemName: "questionmark.app.fill")
//                }
//            }
//        }
        
        
        //버튼 이미지 로직 => Results<ShoppingItem>타입의 매개변수를 받아 메서드를 하나 뺄 수 있을 듯 => realm method로 빼면 될 듯 현재 뷰컨 또는 뷰가 realm이 필요없도록
        let savedItemList = realm.objects(ShoppingItem.self)

        if savedItemList.contains(where: { $0.productID == item.productID }) {
            cell.likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        } else {
            cell.likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
        }


        //셀의 버튼 누르면 저장 및 삭제 그리고 버튼 이미지 변경 로직
        cell.completionHandler = { [weak self] in

            if savedItemList.contains(where: { $0.productID == item.productID }) {


                try! self?.realm.write{
                    let itemToRemove = savedItemList.where { $0.productID == item.productID }
                    self?.realm.delete(itemToRemove)
                }
                cell.likeButton.setImage(UIImage(systemName: "heart"), for: .normal)

            } else {

                try! self?.realm.write {
                    let itemToSave = ShoppingItem(productID: item.productID, mallName: item.mallName, title: item.title, lprice: item.lprice, image: item.image,  date: Date())
                    self?.realm.add(itemToSave)
                }

                cell.likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            }
        }

        cell.mallNameLabel.text = item.mallName
        cell.titleLabel.text = item.title
        cell.lpriceLabel.text = item.lprice
        cell.productImage.kf.setImage(with: url)
        
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
                    self.collectionView.reloadData()
                }
            }
        }
    }
}

