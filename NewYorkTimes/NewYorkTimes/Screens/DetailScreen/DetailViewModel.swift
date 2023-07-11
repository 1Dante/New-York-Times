//
//  DetailViewModel.swift
//  NewYorkTimes
//
//  Created by MacBook on 07.07.2023.
//

import Foundation
import Kingfisher

struct BookCellViewModel {
    let rank: String
    let title: String
    let description: String
    let publisher: String
    let author: String
    let imageURL: String
    let amazonBuyLink: String
    let appleBuyLink: String
    var isImageDownloaded: Bool = false
    var imageData: Data?
}

class DetailViewModel {
    
    var title: String!
    var books: [BookCellViewModel] = []
    var reloadData: ( @MainActor (Bool)->Void) = {_ in }
    
    init(category: CategoriesViewModelCell) {
        Task {
            await fetchBookLists(with: category.encodedTitle)
        }
        title = category.title
    }
    
    func fetchBookLists(with encodedName: String) async {
        do {
            let data = try await NetworkManager.shared.fetchData(type: LiveData<ResultNetwork>.self,
                                                                 endpoint: .bookLists(encodedName: encodedName))
            let sortedBooks = data.results.books?.sorted(by: {$0.rank < $1.rank})
            sortedBooks?.forEach({ item in
                var amazonLink = ""
                var appleLink = ""
                if item.buyLinks.count > 2 {
                    amazonLink = item.buyLinks[0].url
                    appleLink = item.buyLinks[1].url
                }
                
                self.books.append(BookCellViewModel(rank: String(item.rank),
                                                    title: item.title,
                                                    description: item.description,
                                                    publisher: item.publisher,
                                                    author: item.author,
                                                    imageURL: item.imageURL,
                                                    amazonBuyLink: amazonLink,
                                                    appleBuyLink: appleLink,
                                                    imageData: nil))
            })
            
            await reloadData(true)
            
            let fetchedBooks = CoreDataManager.shared.fetchBooks(encodedName: encodedName)
            let fetchedCategories = CoreDataManager.shared.fetchCategories()
            if fetchedBooks.isEmpty {
                for var item in books {
                    guard let url = URL(string: item.imageURL) else { return }
                    let resource = KF.ImageResource(downloadURL: url)
                    KingfisherManager.shared.retrieveImage(with: resource, options: nil, progressBlock: nil) { result in
                        switch result {
                        case .success(let value):
                            item.imageData = value.data()
                            CoreDataManager.shared.addBooks(bookViewModel: item, categoryEncodedName: encodedName, categories: fetchedCategories)
                        case .failure(let error):
                            print("Error: \(error)")
                        }
                    }
                }
                
            }
            await reloadData(true)
        } catch let error {
            print(error)
            let fetchedBooks = CoreDataManager.shared.fetchBooks(encodedName: encodedName)
            if !fetchedBooks.isEmpty {
                fetchedBooks.forEach({ item in
                    self.books.append(BookCellViewModel(rank: item.rank ?? "",
                                                        title: item.title ?? "",
                                                        description: item.descriptionBook ?? "",
                                                        publisher: item.publisherBook ?? "",
                                                        author: item.author ?? "",
                                                        imageURL: "",
                                                        amazonBuyLink: item.amazonLink ?? "",
                                                        appleBuyLink: item.appleLink ?? "",
                                                        isImageDownloaded: true,
                                                        imageData: item.imageURL))
                })
                await reloadData(true)
            } else {
                await reloadData(false)
            }
        }
    }
}
