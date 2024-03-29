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

public final class CoreDataCategoryDataSource: CategoryDataSource, CoreDataDataSource {
    
    // MARK: - Observable properties
    @Published
    public var selectedCategory: ExpenseCategory?
    public var selectedCategoryPublished : Published<ExpenseCategory?> {_selectedCategory}
    public var selectedCategoryPublisher : Published<ExpenseCategory?>.Publisher {$selectedCategory}

    @Published
    public var allCategories: [ExpenseCategory]
    public var allCategoriesPublished : Published<[ExpenseCategory]> {_allCategories}
    public var allCategoriesPublisher : Published<[ExpenseCategory]>.Publisher {$allCategories}
    
    // MARK: - Private properties
    private(set) public var coreDataContext: NSManagedObjectContext
    
    // MARK: - Initializers
    
    public init(context: NSManagedObjectContext) {
        self.coreDataContext = context
        self.allCategories = []
        self.allTags { tags in
            self.allCategories = tags.map { coreDataTag in
                ExpenseCategory(name: coreDataTag.name,
                                iconName: coreDataTag.iconImageName,
                                color: coreDataTag.color)
            }
        }
    }
    
    // MARK: - Public API
    
    public func create(categories: [String], save: Bool) async throws {
        try await coreDataContext.perform {
            for name in categories {
                let description = NSEntityDescription.entity(forEntityName: "Tag", in: self.coreDataContext)
                let managedObject = NSManagedObject(entity: description!, insertInto: self.coreDataContext) as! Tag
                managedObject.name = name
                managedObject.iconImageName = "filter_food.png"
                managedObject.color = .black
            }

            if save {
                try self.coreDataContext.save()
                self.allTags { tags in
                    self.allCategories = tags.map { coreDataTag in
                        ExpenseCategory(name: coreDataTag.name,
                                        iconName: coreDataTag.iconImageName,
                                        color: coreDataTag.color)
                    }
                }
            }
        }
    }
    
    public func setIsAmountNegative(save: Bool) async throws {
        try await coreDataContext.perform {
            let entries = try self.coreDataContext.fetch(self.allEntriesRequest())
            for entry in entries {
                switch entry.value.compare(0) {
                    case .orderedAscending:
                        entry.isAmountNegative = true
                    case .orderedDescending:
                        entry.isAmountNegative = false
                    case .orderedSame:
                        // Shouldn't happen because validation should prevent negative values from being saved
                        throw CoreDataSourceError.generic
                }
            }
        }
    }
    
    public func category(for name: String) async throws -> ExpenseCategory {
        let tag = try await self.tag(forName: name)
        return ExpenseCategory(name: tag.name, iconName: tag.iconImageName, color: tag.color)
    }
    
    public func tag(forName name: String) async throws -> Tag {
        try await coreDataContext.perform {
            let fetchRequest = NSFetchRequest<Tag>(entityName: "Tag")
            fetchRequest.predicate = NSPredicate(format: "name LIKE %@", name)
            guard let last = try self.coreDataContext.fetch(fetchRequest).last else {
                throw CoreDataSourceError.generic
            }
            return last
        }
    }
    
    public func setToAllEnties(_ tagName: String, save: Bool) async throws {
        let tagToBeSet = try await self.tag(forName: tagName)
        try await coreDataContext.perform {
            let entries = try self.coreDataContext.fetch(self.allEntriesRequest())
            for entry in entries {
                entry.tag = tagToBeSet
            }

            if save {
                try self.coreDataContext.save()
            }
        }
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

    public func categories(forMonth month: Int?, inYear year: Int) async -> [ExpenseCategory] {
        await coreDataContext.perform {
            let baseRequest = self.baseRequest(context: self.coreDataContext)
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
                let results = try self.coreDataContext.fetch(baseRequest)
                for result in results {
                    if let tagDict = result as? [String: Any] {
                        let tag = try! self.coreDataContext.existingObject(with: tagDict["tag"] as! NSManagedObjectID)
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
    }
        
    public func expensesByCategory(forMonth month: Int?, inYear year: Int) async -> [PieChartSectionInfo] {
        await withCheckedContinuation { continuation in
            allTags { tags in
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
                }
                
                sections.sort { i1, i2 in
                    i1.percentage < i2.percentage
                }
                
                let r = sections.filter { section in
                    section.percentage > 0
                }
                
                continuation.resume(returning: r)
            }
        }
    }
}

// MARK: - Private
private extension CoreDataCategoryDataSource {
    
    func allEntriesRequest() -> NSFetchRequest<Entry> {
        let description = NSEntityDescription.entity(forEntityName: "Entry", in: self.coreDataContext)
        let request = Entry.entryFetchRequest()
        request.entity = description
        request.fetchBatchSize = 50
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        return request
    }
    
    func allTags(completion: @escaping ([Tag])->(Void)) {
        coreDataContext.perform() {
            let request = NSFetchRequest<Tag>(entityName: "Tag")
            request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
            let result = (try? self.coreDataContext.fetch(request)) ?? [Tag]()
            completion(result)
        }
    }

    func absoluteSumOfEntries(forCategoryName categoryName: String, fromMonth month: Int?, inYear year:Int) -> Double {
        let baseRequest = self.baseRequest(context: coreDataContext)
        var datePredicateString = "year = \(year)"
        if let m = month {
            datePredicateString.append(" AND month = \(m)")
        }
        
        let incomePredicate = NSPredicate(format: datePredicateString.appending(" AND tag.name LIKE '\(categoryName)' AND value > 0"))
        let expensesPredicate = NSPredicate(format: datePredicateString.appending(" AND tag.name LIKE '\(categoryName)' AND value < 0"))
        
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
        let results = try! coreDataContext.fetch(baseRequest)
        if let dict = results.first as? [String: Any] {
            income = (dict["monthlyCategoryAbsoluteSum"] as! Double)
        }
        
        baseRequest.predicate = expensesPredicate
        var expenses: Double? = nil
        let expensesResults = try! coreDataContext.fetch(baseRequest)
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
