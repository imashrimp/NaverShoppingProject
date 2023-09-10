//
//  ShoppingListCollectionViewCell.swift
//  NaverShoppingList_2ndRecap
//
//  Created by 권현석 on 2023/09/07.
//

import UIKit
import SnapKit


class ShoppingListCollectionViewCell: UICollectionViewCell {
    
    var completionHandler: (() -> ())?
    
    let productImage = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.layer.cornerRadius = 15 //MARK: - 이거 바뀔 수 있음
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
        view.font = .systemFont(ofSize: 13)
        view.textAlignment = .left
        view.textColor = .lightGray
        return view
    }()
    
    let titleLabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 14)
        view.textAlignment = .left
        view.textColor = .black
        view.numberOfLines = 2
        return view
    }()
    
    let lpriceLabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 15, weight: .bold)
        view.textAlignment = .left
        view.textColor = .black
        return view
    }()
    
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
    
    @objc
    func likeButtonTapped() {
        print(#function)
        completionHandler?()
    }
    
    private func setConstraints() {
        productImage.snp.makeConstraints { make in
            make.horizontalEdges.top.equalToSuperview().inset(4)
            make.height.equalTo(productImage.snp.width)
        }
        
        likeButton.snp.makeConstraints { make in
            make.bottom.trailing.equalTo(productImage).inset(8)
            make.size.equalTo(44) //MARK: - 사이즈 조정 가능
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
    

//    override func prepareForReuse() {
//        super.prepareForReuse()
//        productImage.image = nil
//        likeButton.imageView?.image = nil
//        mallNameLabel.text = nil
//        titleLabel.text = nil
//        lpriceLabel.text = nil
//    }
    
    @available(*, unavailable) //MARK: - 이게 여기서 되는게 맞았나...? 아니였던거 같은데...?
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        likeButton.layer.cornerRadius = 22
    }
}
