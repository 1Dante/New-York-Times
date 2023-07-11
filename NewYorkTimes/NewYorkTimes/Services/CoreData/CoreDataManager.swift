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
        print("remove cat:\(categories.name)")
        let books = fetchBooks(encodedName: categories.encodedName ?? "")
        let context = persistentContainer.viewContext
        context.delete(categories)
        save()
        
        books.forEach({ book in
            print(book.title)
            let context = persistentContainer.viewContext
            context.delete(book)
            save()
        })
    }
    
    
    func fetchBooks(encodedName: String) -> [Books] {
        print(encodedName)
     let request: NSFetchRequest<Books> = Books.fetchRequest()
      request.predicate = NSPredicate(format: "encodedCategoryName = %@", encodedName)
      var fetchedBooks: [Books] = []
      do {
          fetchedBooks = try persistentContainer.viewContext.fetch(request)
      } catch let error {
         print("Error fetching \(error)")
      }
        print("count of books ater fatching: \((fetchedBooks.count))")
      return fetchedBooks
    }
    
    func addBooks(books: [BookCellViewModel], categoryEncodedName: String) {
     let categories = fetchCategories()
        print(categoryEncodedName)
        var category = categories.first(where: {$0.encodedName == categoryEncodedName})
        books.forEach({ item in
            let book = Books(context: persistentContainer.viewContext)
            print("is present book: \(book.title)")
            book.title = item.title
            book.author = item.author
            book.rank = item.rank
            book.descriptionBook = item.description
            book.publisherBook = item.publisher
            book.encodedCategoryName = categoryEncodedName
            book.amazonLink = item.amazonBuyLink
            book.appleLink = item.appleBuyLink
          //  let imageURL: String
            category?.addToBooks(book)
            print("save book")
            save()
        })
    }
}
