//
//  ShoppingListCollectionViewCell.swift
//  NaverShoppingList_2ndRecap
//
//  Created by 권현석 on 2023/09/07.
//

import UIKit
import SnapKit
import RealmSwift
import Kingfisher


class ShoppingListCollectionViewCell: UICollectionViewCell {
    
    let numberFormatter: NumberFormatter = NumberFormatter()
    
    var completionHandler: (() -> ())?
    let repository = ShoppingItemTableRepository()
    
    let productImage = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.layer.cornerRadius = 15
        return view
    }()
    
    let likeButton = {
        let view = UIButton()
        view.backgroundColor = .white
        view.tintColor = .black
        return view
    }()
    
    let mallNameLabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 18)
        view.textAlignment = .left
        view.textColor = .lightGray
        return view
    }()
    
    let titleLabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 18)
        view.textAlignment = .left
        view.textColor = .black
        view.numberOfLines = 2
        return view
    }()
    
    let lpriceLabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 18, weight: .bold)
        view.textAlignment = .left
        view.textColor = .black
        return view
    }()
        
    @objc func likeButtonTapped() {
         completionHandler?()
    }
    
    func showSearchedShoppingCellContents(repoShoppingList: Results<ShoppingItem>, searchedShoppingItem: Item, imageURL: URL) {

        if repoShoppingList.contains(where: { $0.productID == searchedShoppingItem.productID }) {
            likeButton.setImage(UIImage(systemName: ButtonImageName.shared.heartSelected),
                                for: .normal)
        } else {
            likeButton.setImage(UIImage(systemName: ButtonImageName.shared.heartNone),
                                for: .normal)
        }

        let trimedTitle = searchedShoppingItem.title.components(separatedBy: ["<", "b", ">", "/"]).joined()

        mallNameLabel.text = searchedShoppingItem.mallName
        titleLabel.text = trimedTitle
        
        numberFormatter.numberStyle = .decimal
        
        guard let lPriceInt = Int(searchedShoppingItem.lprice), let result: String = numberFormatter.string(for: lPriceInt) else { return }
                
        lpriceLabel.text = result + "원"
        productImage.kf.setImage(with: imageURL)

        completionHandler = { [weak self] in
            
            if repoShoppingList.contains(where: { $0.productID == searchedShoppingItem.productID }) {

                self?.repository.deleteShoppingItem(savedItemList: repoShoppingList, searchedItemList: searchedShoppingItem)

                self?.likeButton.setImage(UIImage(systemName: ButtonImageName.shared.heartNone), for: .normal)
            } else {
                self?.repository.createShoppingItem(itemToSave: searchedShoppingItem)

                self?.likeButton.setImage(UIImage(systemName: ButtonImageName.shared.heartSelected), for: .normal)
            }
        }
    }
    
    func showLikeListCellContents(imageURL: URL, savedItem: Results<ShoppingItem>, index: Int) {
        productImage.kf.setImage(with: imageURL)
        likeButton.setImage(UIImage(systemName: ButtonImageName.shared.heartSelected), for: .normal)
        likeButton.setImage(UIImage(systemName: ButtonImageName.shared.heartNone), for: .highlighted)
        mallNameLabel.text = savedItem[index].mallName
        titleLabel.text = savedItem[index].title
 
        numberFormatter.numberStyle = .decimal
        
        guard let lPriceInt = Int(savedItem[index].lprice), let result: String = numberFormatter.string(for: lPriceInt) else { return }
        
        lpriceLabel.text = result + "원"
        
        completionHandler = { [weak self] in
            self?.repository.deleteLikeItem(savedItemList: savedItem,
                                            savedItem: savedItem[index])
        }
    }
    
    private func configure() {
        contentView.backgroundColor = .white
        [
        productImage,
        likeButton,
        mallNameLabel,
        titleLabel,
        lpriceLabel
        ].forEach {
            contentView.addSubview($0)
        }
        
        likeButton.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
    }
    
    private func setConstraints() {
        productImage.snp.makeConstraints { make in
            make.horizontalEdges.top.equalToSuperview().inset(4)
            make.height.equalTo(productImage.snp.width)
        }
        
        likeButton.snp.makeConstraints { make in
            make.bottom.trailing.equalTo(productImage).inset(8)
            make.size.equalTo(44)
        }
        
        mallNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(productImage.snp.leading).offset(4)
            make.trailing.equalTo(productImage.snp.trailing).inset(4)
            make.top.equalTo(productImage.snp.bottom).offset(6)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(productImage.snp.leading).offset(4)
            make.trailing.equalTo(productImage.snp.trailing).inset(4)
            make.top.equalTo(mallNameLabel.snp.bottom).offset(6)
        }
        
        lpriceLabel.snp.makeConstraints { make in
            make.leading.equalTo(productImage.snp.leading).offset(4)
            make.trailing.equalTo(productImage.snp.trailing).inset(4)
            make.top.equalTo(titleLabel.snp.bottom).offset(6)
            make.bottom.equalToSuperview().inset(4)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        setConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        likeButton.layer.cornerRadius = 22
    }
}
