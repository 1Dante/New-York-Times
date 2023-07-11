//
//  MainViewModel.swift
//  NewYorkTimes
//
//  Created by MacBook on 07.07.2023.
//

import Foundation

struct CategoriesViewModelCell {
    let title: String
    let publishedDate: String
    let encodedTitle: String
}


class MainViewModel {
    
    var categories: [CategoriesViewModelCell] = []
    var reloadData: ( @MainActor (Bool)->Void) = { _ in }
    
    init() {
        Task {
            await fetchCategories()
        }
    }
    
    func fetchCategories() async {
        do {
            let data = try await NetworkManager.shared.fetchData(type: LiveData<[ResultNetwork]>.self, endpoint: .lists)
            let _categories = CoreDataManager.shared.fetchCategories()
            data.results.forEach { item in
                self.categories.append(CategoriesViewModelCell(title: item.displayName,
                                                               publishedDate: item.newestPublishedDate ?? "",
                                                               encodedTitle: item.encodedName))
                Task {
                    if _categories.contains(where: { $0.encodedName == item.encodedName && Date.getDate(str: $0.newestPublishedDate ?? "") <  Date.getDate(str: item.newestPublishedDate ?? "") }) {
                        CoreDataManager.shared.deleteCategory(categories: _categories.first(where: { $0.encodedName == item.encodedName } ))
                        await CoreDataManager.shared.addCategory(categorie: item)
                    } else if !_categories.contains(where: { $0.encodedName == item.encodedName }) {
                        //add item if not exist
                        await CoreDataManager.shared.addCategory(categorie: item)
                    }
                }
            }
            await reloadData(true)
        } catch let error {
            let _categories = CoreDataManager.shared.fetchCategories()
            if !_categories.isEmpty {
                _categories.forEach { category in
                    self.categories.append(CategoriesViewModelCell(title: category.name ?? "",
                                                                   publishedDate: category.newestPublishedDate ?? "",
                                                                   encodedTitle: category.encodedName ?? ""))
                }
                await reloadData(true)
            } else {
                await reloadData(false)
            }
        }
    }
}
