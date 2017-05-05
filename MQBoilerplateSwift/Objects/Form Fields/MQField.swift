//
//  MQField.swift
//  MQBoilerplateSwift
//
//  Created by Matt Quiros on 4/18/15.
//  Copyright (c) 2015 Matt Quiros. All rights reserved.
//

import Foundation

open class MQField {
    
    /**
    The name of this field.
    */
    open var name: String
    
    /**
    The label to use when the field is displayed, which may be different
    than the name. For example, a field named *Weight* might be displayed
    with a label *Weight (lbs.)*.
    */
    open var label: String
    
    /**
    The value of this field.
    */
    open var value: Any?
    
    open var keyboardType: UIKeyboardType
    open var autocapitalizationType: UITextAutocapitalizationType
    open var validCharacterSet: CharacterSet?
    open var secureTextEntry: Bool
    
    open var invalidCharacterSet: CharacterSet? {
        get {
            if let validCharacterSet = self.validCharacterSet {
                return validCharacterSet.inverted
            }
            return nil
        }
    }
    
    public init(name: String, label: String? = nil, value: Any? = nil,
        keyboardType: UIKeyboardType = .default,
        autocapitalizationType: UITextAutocapitalizationType = .words,
        validCharacterSet: CharacterSet? = nil,
        secureTextEntry: Bool = false) {
            self.name = name
            self.label = label ?? name
            self.value = value
            
            self.keyboardType = keyboardType
            self.autocapitalizationType = autocapitalizationType
            self.validCharacterSet = validCharacterSet
            self.secureTextEntry = secureTextEntry
    }
    
//    public convenience init(name: String) {
//        self.init(name: name, label: name, value: nil)
//    }
//    
//    public convenience init(name: String, value: Any?) {
//        self.init(name: name, label: name, value: value)
//    }
    
}
