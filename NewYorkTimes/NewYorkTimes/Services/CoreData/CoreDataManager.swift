//
//  CoreDataManager.swift
//  NewYorkTimes
//
//  Created by MacBook on 08.07.2023.
//

import Foundation
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "DataModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                print("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func addCategory(categorie: ResultNetwork) async {
        await persistentContainer.viewContext.perform {
            let categories = Categories(context: self.persistentContainer.viewContext)
            categories.name = categorie.displayName
            categories.encodedName = categorie.encodedName
            categories.newestPublishedDate = categorie.newestPublishedDate
            self.save()
        }
    }
    
    func fetchCategories() -> [Categories] {
        let request: NSFetchRequest<Categories> = Categories.fetchRequest()
        var fetchedCategories: [Categories] = []
        do {
            fetchedCategories = try persistentContainer.viewContext.fetch(request)
        } catch let error {
            print("Error fetching \(error)")
        }
        return fetchedCategories
    }
    
    func save () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch let error as NSError {
                print("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }
    
    func deleteCategory(categories: Categories?) {
        guard let categories = categories else { return }
        let books = fetchBooks(encodedName: categories.encodedName ?? "")
        let context = persistentContainer.viewContext
        context.delete(categories)
        save()
        
        books.forEach({ book in
            let context = persistentContainer.viewContext
            context.delete(book)
            save()
        })
    }
    
    
    func fetchBooks(encodedName: String) -> [Books] {
        let request: NSFetchRequest<Books> = Books.fetchRequest()
        request.predicate = NSPredicate(format: "encodedCategoryName = %@", encodedName)
        var fetchedBooks: [Books] = []
        do {
            fetchedBooks = try persistentContainer.viewContext.fetch(request)
        } catch let error {
            print("Error fetching \(error)")
        }
        return fetchedBooks
    }
    
    func addBooks(bookViewModel: BookCellViewModel, categoryEncodedName: String,  categories: [Categories]) {
        print(categoryEncodedName)
        let category = categories.first(where: {$0.encodedName == categoryEncodedName})
        let book = Books(context: persistentContainer.viewContext)
        book.title = bookViewModel.title
        book.author = bookViewModel.author
        book.rank = bookViewModel.rank
        book.descriptionBook = bookViewModel.description
        book.publisherBook = bookViewModel.publisher
        book.encodedCategoryName = categoryEncodedName
        book.amazonLink = bookViewModel.amazonBuyLink
        book.appleLink = bookViewModel.appleBuyLink
        book.imageURL = bookViewModel.imageData
        category?.addToBooks(book)
        save()
    }
}
