//
//  ShoppingListCollectionViewCell.swift
//  NaverShoppingList_2ndRecap
//
//  Created by 권현석 on 2023/09/07.
//

import UIKit
import SnapKit

final
class ShoppingListCollectionViewCell: UICollectionViewCell {
    
    let label = {
        let view = UILabel()
        view.text = "이거 됩니까?"
        view.textAlignment = .center
        return view
    }()
    
    private func configure() {
        contentView.backgroundColor = .yellow
        contentView.addSubview(label)
    }
    
    private func setConstraints() {
        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        setConstraints()
    }
    
    @available(*, unavailable) //MARK: - 이게 여기서 되는게 맞았나...? 아니였던거 같은데...?
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
