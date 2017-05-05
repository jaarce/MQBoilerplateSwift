//
//  MQFieldTextView.swift
//  MQBoilerplateSwift
//
//  Created by Matt Quiros on 7/16/15.
//  Copyright © 2015 Matt Quiros. All rights reserved.
//

import UIKit

open class MQFieldTextView: UITextView {
    
    open weak var field: MQField? {
        didSet {
            if let field = self.field,
                let value = field.value as? String {
                    self.text = value
                    return
            }
            
            self.text = nil
        }
    }
    
}

