//
//  Entry+CoreDataClass.swift
//  
//
//  Created by Borja Arias Drake on 12/07/2020.
//
//

import Foundation
import CoreData
import DateAndTime

@objc(Entry)
public class Entry: NSManagedObject {
    
    public var observableDate: Date? {
        get {
            return date
        }
        
        set {
            date = newValue
            if let theDate = date {
                self.day = NSNumber(integerLiteral: DateConversion.dayOfDateUsingCurrentCalendar(date: theDate))
                self.month = NSNumber(integerLiteral: DateConversion.monthOfDateUsingCurrentCalendar(date: theDate))
                
                self.year = NSNumber(integerLiteral: DateConversion.yearOfDateUsingCurrentCalendar(date: theDate))
                self.hour = NSNumber(integerLiteral: DateConversion.hourOfDateUsingCurrentCalendar(date: theDate))
                self.minute = NSNumber(integerLiteral: DateConversion.minuteOfDateUsingCurrentCalendar(date: theDate))
                self.second = NSNumber(integerLiteral: DateConversion.secondOfDateUsingCurrentCalendar(date: theDate))
                if let m = month, let y = year {
                    self.monthYear = "\(m.stringValue)/\(y.stringValue)"
                }

                if let d = day, let m = month, let y = year {
                    self.dayMonthYear = "\(d.stringValue)/\(m.stringValue)/\(y.stringValue)"
                    self.yearMonthDay = "\(y.stringValue)/\(m.stringValue)/\(d.stringValue)"
                }
            }
        }
    }
}
