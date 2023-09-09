//
//  LikeListViewController.swift
//  NaverShoppingList_2ndRecap
//
//  Created by 권현석 on 2023/09/09.
//

import UIKit
import SnapKit
import RealmSwift

class LikeListViewController: BaseViewController {

    //검색 기능 구현하기 => Result<ShoppingItme>타입이면서 해당 검색어를 title값에 포함하는 데이터를 컬렉션 뷰에 나타내기
    //셀에 이미지 띄우기 => document에 저장해서 해당 파일 로드해오는 방식으로 해보자
    
    let realm = try! Realm()
    
    //여기서 뭔가 할 수 있을거 같은데 아니면 내가 지금 didSet과 willSet 그리고 뷰컨 생명주기 호출 타이밍을 정확하게 몰라서 그런듯.
    var likeItemList: Results<ShoppingItem>? /*{
        willSet {
            print("바뀔 예정")
        }
        
        didSet {
            print("값 바뀜")
            collectionView.reloadData()
        }
    }*/
    
    lazy var searchController = {
        let view = UISearchController(searchResultsController: nil)
        view.searchBar.placeholder = "검색어를 입력해주세요"
        view.searchBar.delegate = self
        return view
    }()
    
    lazy var collectionView = {
        let view = UICollectionView(frame: .zero,
                                    collectionViewLayout: collectionViewFlowLayout())
        view.register(ShoppingListCollectionViewCell.self,
                      forCellWithReuseIdentifier: ShoppingListCollectionViewCell.id)
        view.delegate = self
        view.dataSource = self
//        view.prefetchDataSource = self
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        likeItemList = try realm.objects(ShoppingItem.self).sorted(byKeyPath: "date", ascending: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
    }
    
    override func configure() {
        super.configure()
        
        view.addSubview(collectionView)
        
        navigationItem.searchController = searchController
        navigationItem.title = "좋아요 목록"
    }
    
    override func setConstratints() {
        collectionView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.verticalEdges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

extension LikeListViewController: UICollectionViewDelegate {
    
}

extension LikeListViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let list = likeItemList else { return 0 }
        return list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ShoppingListCollectionViewCell.id, for: indexPath) as? ShoppingListCollectionViewCell,
        let itemList = likeItemList else { return UICollectionViewCell() }
        
        let item = itemList[indexPath.row]
        
        cell.productImage.image = UIImage(systemName: "star")
        cell.likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        cell.likeButton.setImage(UIImage(systemName: "heart"), for: .highlighted)
        cell.mallNameLabel.text = item.mallName
        cell.titleLabel.text = item.title
        cell.lpriceLabel.text = item.lprice
        
        cell.completionHandler = { [weak self] in
            try! self?.realm.write {
                let itemToRemove = itemList.where { $0.productID == item.productID }
                self?.realm.delete(itemToRemove)
            }
            collectionView.reloadData()
        }
        
        
        return cell
    }
}

extension LikeListViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.isEmpty {
            likeItemList = realm.objects(ShoppingItem.self)
        } else {
            likeItemList = realm.objects(ShoppingItem.self).where{
                $0.title.contains(searchText)
            }
        }
        collectionView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        likeItemList = realm.objects(ShoppingItem.self)
        collectionView.reloadData()
    }
    
}

// 뷰컨 configure
extension LikeListViewController {
    
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