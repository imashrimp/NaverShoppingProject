//
//  LikeListViewController.swift
//  NaverShoppingList_2ndRecap
//
//  Created by 권현석 on 2023/09/09.
//

import UIKit
import SnapKit
import RealmSwift
import Kingfisher

//MARK: - 이 화면에도 저장한 데이터가 너무 많아지면 preFetch를 해야 할 거임. realm문서에 prefetch관련 내용이 있는지 찾아보자
class LikeListViewController: BaseViewController {
    
    let realm = try! Realm()

    var likeItemList: Results<ShoppingItem>? {
        didSet {
            print("렘 데이터 바뀜")
            collectionView.reloadData()
        }
    }
    
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
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        likeItemList = realm.objects(ShoppingItem.self).sorted(byKeyPath: "date", ascending: false)
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = ShoppingItemDetailViewController()
        guard let list = likeItemList else { return }
        
        let item = list[indexPath.row]
        
        //MARK: - 여기서 date에 Date()전달해도 문제없나...?
        vc.realmItem = ShoppingItem(productID: item.productID, mallName: item.mallName, title: item.title, lprice: item.lprice, image: item.image, date: Date())
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension LikeListViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let list = likeItemList else { return 0 }
        return list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ShoppingListCollectionViewCell.id, for: indexPath) as? ShoppingListCollectionViewCell,
              let itemList = likeItemList,
              let url = URL(string: itemList[indexPath.row].image) else {
            return UICollectionViewCell()
        }
        
        let item = itemList[indexPath.row]
        
        //MARK: - 여기도 캐싱이랑 prefetch를 취소할 수 있는 방법을 찾으면 아래처럼 구현해보자
//        DispatchQueue.global().async {
//            do {
//                let data = try Data(contentsOf: url)
//                DispatchQueue.main.async {
//                    cell.productImage.image = UIImage(data: data)
//                }
//
//            } catch {
//                cell.productImage.image = UIImage(systemName: "star")
//            }
//        }
        
        cell.productImage.kf.setImage(with: url)
        cell.likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        cell.likeButton.setImage(UIImage(systemName: "heart"), for: .highlighted)
        cell.mallNameLabel.text = item.mallName
        cell.titleLabel.text = item.title
        cell.lpriceLabel.text = item.lprice
        
        //MARK: - 여기서는 데이터가 지워져도 데이터의 값이 변하는걸 didSet에서 못 잡아냄 왜...?
        //여기서는 reloadData해줘야함. 주기가 끝나면 뷰컨과의 참조가 끊겨서 didSet을 통한 데이터 리로드를 할 수 없음.
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
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        likeItemList = realm.objects(ShoppingItem.self)
    }
    
}


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
