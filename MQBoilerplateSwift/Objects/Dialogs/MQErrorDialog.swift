//
//  MQErrorDialog.swift
//  MQBoilerplateSwift
//
//  Created by Matt Quiros on 4/25/15.
//  Copyright (c) 2015 Matt Quiros. All rights reserved.
//

import UIKit

public final class MQErrorDialog {
    
    public class func showError(_ error: NSError, inPresenter presenter: UIViewController) {
        let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        let okButtonAction = UIAlertAction(title: "OK", style: .default) {_ in
            alertController.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(okButtonAction)
        
        presenter.present(alertController, animated: true, completion: nil)
    }
    
}
