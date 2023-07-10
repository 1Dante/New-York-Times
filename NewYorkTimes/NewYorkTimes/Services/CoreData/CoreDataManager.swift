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
           fatalError("Unresolved error \(error), \(error.userInfo)")
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
//        let categories = Categories(context: persistentContainer.viewContext)
//        categories.name = categorie.displayName
//        categories.encodedName = categorie.encodedName
//        categories.newestPublishedDate = categorie.newestPublishedDate
//        save()
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
             fatalError("Unresolved error \(error), \(error.userInfo)")
         }
       }
     }

    func deleteCategory(categories: Categories?) {
        guard let categories = categories else { return }
            let context = persistentContainer.viewContext
            context.delete(categories)
            save()
    }
    
    
    func fetchBooks(encodedName: String) -> [Books] {
      let request: NSFetchRequest<Books> = Books.fetchRequest()
      request.predicate = NSPredicate(format: "encodedName = %@", encodedName)
      var fetchedBooks: [Books] = []
      do {
          fetchedBooks = try persistentContainer.viewContext.fetch(request)
      } catch let error {
         print("Error fetching \(error)")
      }
      return fetchedBooks
    }
    
    func addBooks(books: [BookCellViewModel], categoryEncodedName: String) {
      let book = Books(context: persistentContainer.viewContext)
     let categories = fetchCategories()
        var category = categories.first(where: {$0.encodedName == categoryEncodedName})
        books.forEach({ item in
            book.title = item.title
            book.author = item.author
            book.rank = item.rank
            book.descriptionBook = item.description
            book.publisherBook = item.publisher
            book.encodedCategoryName = categoryEncodedName
          //  let imageURL: String
           // let amazonBuyLink: String
            //let appleBuyLink: String
            category?.addToBooks(book)
            print("save book")
            save()
        })
    }
}
