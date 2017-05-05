//
//  MQNoResultsView.swift
//  MQBoilerplateSwift
//
//  Created by Matt Quiros on 5/1/15.
//  Copyright (c) 2015 Matt Quiros. All rights reserved.
//

import UIKit

public protocol MQNoResultsViewDelegate {
    
    func noResultsViewDidTapRetry(_ noResultsView: MQNoResultsView)
    
}

open class MQNoResultsView: UIView {
    
    open var text: String?
    open var delegate: MQNoResultsViewDelegate?
    
}
