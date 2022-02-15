//
//  UIViewController+Alert.swift
//  Cryptt
//
//  Created by Oleh Zahoriansky on 15.02.2022.
//

import UIKit

extension UIViewController {
    public func showFailedAlert(message: String,
                                okAction: ((UIAlertAction) -> Void)? = nil,
                                cancelAction: ((UIAlertAction) -> Void)? = nil) {
        DispatchQueue.main.async { [weak self] in
            self?.showAlert(title: R.string.localizable.alertFailedTitle(),
                            message: message,
                            okAction: okAction,
                            cancelAction: cancelAction)
        }
    }
    
    internal func showAlert(title: String?,
                           message: String,
                           okAction: ((UIAlertAction) -> Void)? = nil,
                           cancelAction: ((UIAlertAction) -> Void)? = nil) {
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: .alert)
        let alertAction = UIAlertAction(title: R.string.localizable.alertOkAction(),
                                        style: .default,
                                        handler: okAction)
        if cancelAction != nil {
            let cancel = UIAlertAction(title: R.string.localizable.alertCancelAction(),
                                       style: .destructive,
                                       handler: cancelAction)
            alertController.addAction(cancel)
        }
        alertController.addAction(alertAction)
        
        present(alertController, animated: true, completion: nil)
    }
}
