//
//  MQFieldCollection.swift
//  MQBoilerplateSwift
//
//  Created by Matt Quiros on 7/9/15.
//  Copyright © 2015 Matt Quiros. All rights reserved.
//

import Foundation

open class MQFieldCollection<T: MQDataModel> {
    
    open var fields: [MQField]
    open var count: Int {
        return self.fields.count
    }
    
    public init(model: T) {
        self.fields = model.editableFields()
    }
    
    /**
    Returns only the first field that matches the supplied field name, or `nil` if none.
    */
    open subscript(fieldName: String) -> MQField? {
        let matches = self.fields.filter { $0.name == fieldName }
        if let firstMatch = matches.first {
            return firstMatch
        }
        return nil
    }
    
    /**
    Returns the field at a given index.
    */
    open subscript(index: Int) -> MQField {
        if index > 0 && index < self.fields.count {
            return self.fields[index]
        }
        fatalError("Index out of bounds: \(index)")
    }
    
    /**
    Returns a JSON representation of the field collection which can be used
    as the HTTP body of a URL request. You must override this method to define the JSON object.
    */
    open func toJSON() -> [String : AnyObject] {
        fatalError("Unimplemented: \(#function)")
    }
    
}
