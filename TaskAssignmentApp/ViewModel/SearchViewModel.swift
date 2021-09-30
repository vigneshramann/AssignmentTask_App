//
//  SearchViewModel.swift
//  AssignmentTask
//
//  Created by Vignesh on 29/09/21.
//

import UIKit

class SearchViewModel {
    
    var cellHeight: CGFloat = 165.0
    var items = [Items]()
    var showLoading: (()->())?
    var hideLoading: (()->())?
    var reloadTableView: (()->())?
    
    var indexOfPageRequest = 1
    var loadingStatus = false

    func searchApiCall(name: String) {
        showLoading?()
        
        let urlString = "https://api.github.com/search/repositories?q=\(name)&page=\(indexOfPageRequest)&per_page=20"
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                if let jsonItems = try? decoder.decode(SearchItems.self, from: data) {
                    self.hideLoading?()
                    self.items.append(contentsOf: jsonItems.items)
                    reloadTableView?()
                } else {
                    reloadTableView?()
                    self.hideLoading?()
                }
            }
        }
    }
}
