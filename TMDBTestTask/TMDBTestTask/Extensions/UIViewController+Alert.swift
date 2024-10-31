//
//  Untitled.swift
//  TMDBTestTask
//
//  Created by Serhii Molodets on 31.10.2024.
//

import UIKit

extension UIViewController {
    func showAlert(title: String? = nil, _ message: String, handler: (() -> Void)? = nil) {
        guard UIApplication.shared.applicationState == .active else { return }
        let alert = UIAlertController(title: title ?? "", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
            handler?()
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
