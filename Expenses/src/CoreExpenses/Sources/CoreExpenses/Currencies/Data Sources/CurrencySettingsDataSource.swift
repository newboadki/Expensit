//
//  CurrencySettingsDataSource.swift
//  Expensit
//
//  Created by Borja Arias Drake on 19.11.2020..
//  Copyright © 2020 Borja Arias Drake. All rights reserved.
//

import Foundation

public protocol CurrencySettingsDataSource {
    var currentCurrencyCode: String {get}
    var previousCurrencyCode: String {get set}
}
