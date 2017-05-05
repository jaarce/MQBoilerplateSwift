//
//  NSDate.swift
//  MQBoilerplateSwift
//
//  Created by Matt Quiros on 7/13/15.
//  Copyright © 2015 Matt Quiros. All rights reserved.
//

import Foundation

public extension Date {
    
    public func isSameDayAsDate(_ date: Date) -> Bool {
        let calendar = Calendar.current
        let components: NSCalendar.Unit = [.month, .day, .year]
        
        let thisDate = (calendar as NSCalendar).components(components, from: self)
        let otherDate = (calendar as NSCalendar).components(components, from: date)
        
        return thisDate.month == otherDate.month &&
            thisDate.day == otherDate.day &&
            thisDate.year == otherDate.year
    }
    
}
