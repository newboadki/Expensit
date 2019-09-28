//
//  BSBaseNavigationTransitionManager.swift
//  Expenses
//
//  Created by Borja Arias Drake on 04/06/16.
//  Copyright © 2016 Borja Arias Drake. All rights reserved.
//

import Foundation
import UIKit

@objc class BSBaseNavigationTransitionManager: NSObject
{
    var coreDataStackHelper : CoreDataStackHelper
    var coreDataController : BSCoreDataController
    var coreDataFetchController : BSCoreDataFetchController
    var categoryFilterTransitioningDelegate :BSModalSelectorViewTransitioningDelegate
    var containmentEventsDelegate: ContainmentEventsManager?
    
    @objc init(coreDataStackHelper : CoreDataStackHelper, coreDataController : BSCoreDataController, coreDataFetchController : BSCoreDataFetchController, containmentEventsDelegate: ContainmentEventsManager)
    {
        self.coreDataStackHelper = coreDataStackHelper
        self.coreDataController = coreDataController
        self.coreDataFetchController = coreDataFetchController
        self.categoryFilterTransitioningDelegate = BSModalSelectorViewTransitioningDelegate()
        self.containmentEventsDelegate = containmentEventsDelegate
        super.init()
    }
    
    @objc func configureAddEntryViewControllerWithSegue(_ segue : UIStoryboardSegue)
    {
        let entry = BSDisplayExpensesSummaryEntry(title: "", value: "", signOfAmount: .zero, date: DateTimeHelper.dateString(withFormat: DEFAULT_DATE_FORMAT, date: Date()), tag: "Other")
        let addEntryController = BSAddEntryController(entryToEdit:entry, coreDataFetchController: self.coreDataFetchController)
        let navigationController = segue.destination as! UINavigationController
        let cellActionsDataSource = BSStaticTableAddEntryFormCellActionDataSource(coreDataController: self.coreDataController, addEntryController: addEntryController, isEditing: false);
        let addEntryVC = navigationController.topViewController as! BSEntryDetailsFormViewController
        let appDelegate = UIApplication.shared.delegate as! BSAppDelegate

        addEntryVC.addEntryController = addEntryController
        addEntryVC.addEntryPresenter = BSAddEntryPresenter(addEntryController: addEntryVC.addEntryController!, userInterface:addEntryVC)
        addEntryVC.isEditingEntry = false;
        addEntryVC.cellActionDataSource = cellActionsDataSource;
        addEntryVC.appearanceDelegate = appDelegate.themeManager;
    }
    
    @objc func configureAddEntryViewControllerWithNavigationController(_ navigationController : UINavigationController)
    {
        let addEntryController = BSAddEntryController(entryToEdit:nil, coreDataFetchController: self.coreDataFetchController)
        let cellActionsDataSource = BSStaticTableAddEntryFormCellActionDataSource(coreDataController: self.coreDataController, addEntryController: addEntryController, isEditing: false);
        let addEntryVC = navigationController.topViewController as! BSEntryDetailsFormViewController
        let appDelegate = UIApplication.shared.delegate as! BSAppDelegate
        
        addEntryVC.addEntryController = addEntryController
        addEntryVC.addEntryPresenter = BSAddEntryPresenter(addEntryController: addEntryVC.addEntryController!, userInterface:addEntryVC)
        addEntryVC.isEditingEntry = false;
        addEntryVC.cellActionDataSource = cellActionsDataSource;
        addEntryVC.appearanceDelegate = appDelegate.themeManager;
    }
    
    
    // TODO: Creating the instance of categoryFilterViewTransitioningDelegate in this method does not work, there is a crash
    @objc func configureCategoryFilterViewControllerWithSegue(_ segue : UIStoryboardSegue, categoryFilterViewControllerDelegate: BSCategoryFilterDelegate, tagBeingFilterBy: AnyObject?, categoryFilterViewTransitioningDelegate: BSModalSelectorViewTransitioningDelegate)
    {
        
        let categoryFilterViewController = segue.destination as! BSCategoryFilterViewController
        let categoryFilterController = BSCategoryFilterController(dataProvider : self.coreDataController)
        categoryFilterViewController.categoryFilterPresenter = BSCategoryFilterPresenter(categoryFilterController: categoryFilterController)
        categoryFilterViewController.transitioningDelegate = categoryFilterViewTransitioningDelegate
        categoryFilterViewController.delegate = categoryFilterViewControllerDelegate
        categoryFilterViewController.selectedTag = tagBeingFilterBy
    }
}
