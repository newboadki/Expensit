//
//  BSDailyExpensesSummaryPresenterEventsProtocol.swift
//  Expenses
//
//  Created by Borja Arias Drake on 23/05/16.
//  Copyright © 2016 Borja Arias Drake. All rights reserved.
//

import Foundation


@objc protocol BSDailyExpensesSummaryPresenterEventsProtocol : BSAbstractExpensesSummaryPresenterEventsProtocol {
    
    /// User-readble representation of the title of a section.
    ///
    /// - Parameters:
    ///   - indexPath: Index.row represents the day of the month.
    ///   - sectionTitle: String formated date: "<month>/<year>"
    /// - Returns: User-readble representation of the title of a section.
    /// - Important: TODO: Need to encapsulate. This string needs to match the one created at BSShowAllEntriesPresenter.
    @objc(sectionNameForSelectedIndexPath:sectionTitle:)
    func sectionName(forSelected indexPath : IndexPath, sectionTitle: String) -> String
}
