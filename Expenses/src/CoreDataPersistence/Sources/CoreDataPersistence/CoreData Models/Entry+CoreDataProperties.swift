//
//  Entry+CoreDataProperties.swift
//  
//
//  Created by Borja Arias Drake on 12/07/2020.
//
//

import Foundation
import CoreData


extension Entry {

    @nonobjc public class func entryFetchRequest() -> NSFetchRequest<Entry> {
        return NSFetchRequest<Entry>(entityName: "Entry")
    }

    @NSManaged public var date: Date?
    @NSManaged public var day: NSNumber?
    @NSManaged public var dayMonthYear: String?
    @NSManaged public var desc: String?
    @NSManaged public var hour: NSNumber?
    @NSManaged public var isAmountNegative: NSNumber
    @NSManaged public var minute: NSNumber?
    @NSManaged public var month: NSNumber?
    @NSManaged public var monthYear: String?
    @NSManaged public var second: NSNumber?
    @NSManaged public var value: NSDecimalNumber
    @NSManaged public var valueInBaseCurrency: NSDecimalNumber
    @NSManaged public var year: NSNumber?
    @NSManaged public var yearMonthDay: String?
    @NSManaged public var tag: Tag?
    @NSManaged public var currencyCode: String
    @NSManaged public var exchangeRateToBaseCurrency: NSDecimalNumber
    @NSManaged public var isExchangeRateUpToDate: Bool
}
