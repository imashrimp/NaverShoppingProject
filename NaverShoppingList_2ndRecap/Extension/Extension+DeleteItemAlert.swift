//
//  Extension+DeleteItemAlert.swift
//  NaverShoppingList_2ndRecap
//
//  Created by 권현석 on 2023/09/11.
//

import UIKit

extension UIViewController {
    
    func deleteAlert(completionHandler: @escaping () -> ()) {
        let alert = UIAlertController(title: "알림", message: "해당 항목을 목록에서 삭제하시겠습니까?", preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        let delete = UIAlertAction(title: "삭제", style: .default) { _ in
            completionHandler()
        }
        
        alert.addAction(cancel)
        alert.addAction(delete)
        
        present(alert, animated: true)
        
    }
    
}
