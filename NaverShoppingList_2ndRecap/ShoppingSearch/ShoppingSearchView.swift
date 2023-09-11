//
//  ShoppingSearchView.swift
//  NaverShoppingList_2ndRecap
//
//  Created by 권현석 on 2023/09/10.
//

import UIKit

class ShoppingSearchView: BaseView, CollectionViewFlowLayoutProtocol {
    
    let simSortButton = {
        let view = SortButton()
        view.setTitle("  정확도  ", for: .normal)
        view.setTitleColor(.white, for: .normal)
        view.backgroundColor = .black
        return view
    }()
    
    let dateSortButton = {
        let view = SortButton()
        view.setTitle("  날짜순  ", for: .normal)
        return view
    }()
    
    let dscSortButton = {
        let view = SortButton()
        view.setTitle(" 가격높은순 ", for: .normal)
        return view
    }()
    
    let ascSortButton = {
        let view = SortButton()
        view.setTitle(" 가격낮은순 ", for: .normal)
        return view
    }()
    
    lazy var collectionView = {
        let view = UICollectionView(frame: .zero,
                                    collectionViewLayout: collectionViewFlowLayout())
        view.register(ShoppingListCollectionViewCell.self,
                      forCellWithReuseIdentifier: ShoppingListCollectionViewCell.id)
        return view
    }()
    
    override func configure() {
        
        super.configure()
        [
        simSortButton,
        dateSortButton,
        ascSortButton,
        dscSortButton,
        collectionView
        ].forEach {
            addSubview($0)
        }
    }
    
    override func setConstraints() {
        simSortButton.snp.makeConstraints { make in
            make.leading.top.equalTo(self.safeAreaLayoutGuide).inset(8)
            make.height.equalTo(44)
        }
        
        dateSortButton.snp.makeConstraints { make in
            make.top.equalTo(simSortButton.snp.top)
            make.height.equalTo(44)
            make.leading.equalTo(simSortButton.snp.trailing).offset(16)
        }
        
        dscSortButton.snp.makeConstraints { make in
            make.top.equalTo(simSortButton.snp.top)
            make.height.equalTo(44)
            make.leading.equalTo(dateSortButton.snp.trailing).offset(16)
        }
        
        ascSortButton.snp.makeConstraints { make in
            make.top.equalTo(simSortButton.snp.top)
            make.height.equalTo(44)
            make.leading.equalTo(dscSortButton.snp.trailing).offset(16)
            make.trailing.lessThanOrEqualToSuperview().inset(8)
        }
        
        collectionView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(simSortButton.snp.bottom).offset(8)
            make.bottom.equalTo(self.safeAreaLayoutGuide)
        }
    }
    
    func collectionViewFlowLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        let space: CGFloat = 8
        let width = (UIScreen.main.bounds.width - (space * 3)) / 2
        let height = width + 100
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
