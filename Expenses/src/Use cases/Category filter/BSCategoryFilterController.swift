//
//  BSCategoryFilterController.swift
//  Expenses
//
//  Created by Borja Arias Drake on 09/06/16.
//  Copyright © 2016 Borja Arias Drake. All rights reserved.
//

import Foundation

class BSCategoryFilterController: BSCategoryFilterControllerProtocol {
    
    private var dataProvider: BSCoreDataController
    
    public init(dataProvider: BSCoreDataController) {
        self.dataProvider = dataProvider
    }
    
    func allTags() -> [BSExpenseCategory] {
        return self.dataProvider.allTags()
    }

    func allTagsImages() -> [UIImage] {
        return self.dataProvider.allTagImages() as! [UIImage]
    }

}
