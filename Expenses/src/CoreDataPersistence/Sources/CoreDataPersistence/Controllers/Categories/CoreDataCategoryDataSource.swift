//
//  CoreDataCategoryDataSource.swift
//  Expensit
//
//  Created by Borja Arias Drake on 04/06/2020.
//  Copyright © 2020 Borja Arias Drake. All rights reserved.
//

import Foundation
import Combine
import CoreExpenses
import CoreData
import UIKit

public class CoreDataCategoryDataSource: CategoryDataSource, CoreDataDataSource {
        
    @Published public var selectedCategory: ExpenseCategory?
    public var selectedCategoryPublished : Published<ExpenseCategory?> {_selectedCategory}
    public var selectedCategoryPublisher : Published<ExpenseCategory?>.Publisher {$selectedCategory}
    
    private var context: NSManagedObjectContext
    
    public init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    public func allCategories() -> [ExpenseCategory] {
        allTags().map { coreDataTag in
            ExpenseCategory(name: coreDataTag.name,
                            iconName: coreDataTag.iconImageName,
                            color: coreDataTag.color)
        }
    }
    
    public func create(categories: [String]) -> Result<Bool, Error> {
        for name in categories {
            let description = NSEntityDescription.entity(forEntityName: "Tag", in: context)
            let managedObject = NSManagedObject(entity: description!, insertInto: context) as! Tag
            managedObject.name = name
            managedObject.iconImageName = "filter_food.png"
            managedObject.color = .black
        }
        return .success(true)
    }
    
    public func category(for name: String) -> ExpenseCategory {
        let tag = self.tag(forName: name)
        return ExpenseCategory(name: tag.name, iconName: tag.iconImageName, color: tag.color)
    }
    
    public func tag(forName name: String) -> Tag {
        let fetchRequest = NSFetchRequest<Tag>(entityName: "Tag")//Tag.tagFetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name LIKE %@", name)
        return try! self.context.fetch(fetchRequest).last!
    }

    
    public func set(selectedCategory: ExpenseCategory?) {
        self.selectedCategory = selectedCategory
    }
    
    public func sortedCategoriesByPercentage(fromCategories categories: [ExpenseCategory], sections: [PieChartSectionInfo]) -> [ExpenseCategory]
    {
        var results = [ExpenseCategory]()

        for section in sections.reversed() {
            let filteredArray = categories.filter() { $0.name == section.name }
            if let category = filteredArray.first {
                results.append(category)
            }
        }
        return results
    }

    public func categories(forMonth month: Int?, inYear year: Int) -> [ExpenseCategory] {
        let baseRequest = self.baseRequest(context: context)
        var datePredicateString = "year = \(year)"
        if let m = month {
            datePredicateString.append(" AND month = \(m)")
        }
        baseRequest.predicate = NSPredicate(format: datePredicateString)
        
        if let propertiesByName = baseRequest.entity?.propertiesByName {
            if let tagDescription = propertiesByName["tag"] {
                baseRequest.propertiesToFetch = [tagDescription]
                baseRequest.returnsDistinctResults = true
                baseRequest.resultType = .dictionaryResultType
            }
        }
        
        do {
            var tags = [Tag]()
            let results = try context.fetch(baseRequest)
            for result in results {
                if let tagDict = result as? [String: Any] {
                    let tag = try! context.existingObject(with: tagDict["tag"] as! NSManagedObjectID)
                    tags.append(tag as! Tag)
                }
            }
            return tags.map({ tag in
                return ExpenseCategory(name: tag.name, iconName: tag.iconImageName, color: tag.color)
            })
        } catch {
            return [ExpenseCategory]()
        }
    }
        
    public func expensesByCategory(forMonth month: Int?, inYear year: Int) -> [PieChartSectionInfo] {
        let tags = self.allTags()
        var absoluteAmountPerTag = Array<Double>(repeating: 0, count: tags.count)
        
        for (index, tag) in tags.enumerated() {
            let absoluteAmount = self.absoluteSumOfEntries(forCategoryName: tag.name, fromMonth: month, inYear: year)
            absoluteAmountPerTag[index] = absoluteAmount
        }
        
        let total = absoluteAmountPerTag.reduce(0) { result, next in
            result + next
        }
        
        var percentageSum = 0.0
        var sections = [PieChartSectionInfo]()
        for (index, amount) in absoluteAmountPerTag.enumerated() {
            let tag = tags[index]
            let info = PieChartSectionInfo(name:tag.name,
                                           percentage:(amount / total),
                                           color:tag.color)
            percentageSum += Double(info.percentage)
            sections.append(info)
                    
            sections.sort { i1, i2 in
                i1.percentage < i2.percentage
            }
            
            let r = sections.filter { section in
                section.percentage > 0
            }
            
            return r
        }
        
        return [PieChartSectionInfo]()
    }

    
    private func allTags() -> [Tag] {
        let request = NSFetchRequest<Tag>(entityName: "Tag")//Tag.tagFetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        do {
            return try context.fetch(request) as! [Tag]
        } catch {
            return [Tag]()
        }        
    }

    private func absoluteSumOfEntries(forCategoryName categoryName: String, fromMonth month: Int?, inYear year:Int) -> Double {
        let baseRequest = self.baseRequest(context: context)
        var datePredicateString = "year = \(year)"
        if let m = month {
            datePredicateString.append(" AND month = \(m)")
        }
        
        
        let incomePredicate = NSPredicate(format: datePredicateString.appending(" AND tag.name LIKE \(categoryName) AND value > 0"))
        let expensesPredicate = NSPredicate(format: datePredicateString.appending(" AND tag.name LIKE \(categoryName) AND value < 0"))
        
        baseRequest.predicate = incomePredicate
        let keyPathExpression = NSExpression(forKeyPath: "value")
        let sumExpression = NSExpression(forFunction: "sum:", arguments: [keyPathExpression])
        let absoluteSumExpressionDescription = NSExpressionDescription()
        absoluteSumExpressionDescription.name = "monthlyCategoryAbsoluteSum"
        absoluteSumExpressionDescription.expression = sumExpression
        absoluteSumExpressionDescription.expressionResultType = .decimalAttributeType
        
        baseRequest.propertiesToFetch = [absoluteSumExpressionDescription]
        baseRequest.resultType = .dictionaryResultType
        
        var income: Double? = nil
        let results = try! context.fetch(baseRequest)
        if let dict = results.first as? [String: Any] {
            income = (dict["monthlyCategoryAbsoluteSum"] as! Double)
        }
        
        baseRequest.predicate = expensesPredicate
        var expenses: Double? = nil
        let expensesResults = try! context.fetch(baseRequest)
        if let dict = expensesResults.first as? [String: Any] {
            expenses = (dict["monthlyCategoryAbsoluteSum"] as! Double)
        }
        
        if let i = income, let e = expenses {
            return i + fabs(e)
        } else {
            return 0
        }
    }
}