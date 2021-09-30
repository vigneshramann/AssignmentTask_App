//
//  SearchViewController.swift
//  AssignmentTask
//
//  Created by Vignesh on 29/09/21.
//

import UIKit
import GradientLoadingBar

enum MyError: Error, Equatable {
       case minCharterError(value: String)
       case maxCharterError(value: String)
       case invalidTextError(value: String)
    
    func associatedValue() -> String {
          switch self {
          case .minCharterError(let min):
              return min
          case .maxCharterError(let max):
              return max
          case .invalidTextError(let invalid):
              return invalid
          }
      }
}

class SearchViewController: UIViewController, UISearchBarDelegate {
  
    var isFirstSearchingDone = false
    var safeArea: UILayoutGuide!
    var loadingData = false
    var safeQuery = ""
    var viewModel = SearchViewModel()
    let refreshControl = UIRefreshControl()
    let allowedCharacters = CharacterSet(charactersIn: allowedChar).inverted
    private let gradientLoadingBar = GradientLoadingBar()
    
    lazy var repoTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SearchViewCell.self, forCellReuseIdentifier: searchCell)
        tableView.separatorStyle = .none
        return tableView
    }()
    
    lazy var searchBar: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = searchRepositories
        searchController.searchBar.sizeToFit()
        searchController.searchBar.searchBarStyle = .minimal
        searchController.searchBar.delegate = self
        return searchController
    }()
    
    lazy var placeHolderLbl: UILabel = {
        let label = UILabel()
        label.text = noSearchResult
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textColor = UIColor.systemGray4
        label.textAlignment = .center
        label.numberOfLines = 1
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        safeArea = view.layoutMarginsGuide
        self.title = search
        navigationController?.navigationBar.prefersLargeTitles = true
        self.view.backgroundColor = .white
        navigationItem.searchController = searchBar
        initViewModel()
        setupUI()
    }
 
}

extension SearchViewController {
    //MARK: Initial setup
    func initViewModel(){
        viewModel.reloadTableView = {
            DispatchQueue.main.async { self.reloadList() }
        }
        viewModel.showLoading = {
            self.gradientLoadingBar.fadeIn()
        }
        viewModel.hideLoading = {
            self.refreshControl.endRefreshing()
            self.gradientLoadingBar.fadeOut()
        }
     }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
        let query = searchBar.text ?? ""
        let safeQuery = query.replacingOccurrences(of: " ", with: "")
        self.searchTxtHandling(safeQuery)
    }
    
    @objc func refresh(_ sender: AnyObject) {
        self.viewModel.indexOfPageRequest = 1
        self.viewModel.items.removeAll()
        self.viewModel.searchApiCall(name:safeQuery)
    }
    
    private func reloadList() {
        isFirstSearchingDone = true
        if isFirstSearchingDone {
            placeHolderLbl.removeFromSuperview()
            setupTableView()
        }
        repoTableView.reloadData()
        refreshControl.endRefreshing()
    }
}

extension SearchViewController {
    
    //MARK: Search text validation
    func searchTxtHandling(_ text: String) {
        do {
            try errorHandling(text: text)
        }catch let error {
            let alert = UIAlertController(title: alertTxt, message: error as? String, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: ok, style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }

    //MARK: Search text validation
    func errorHandling(text: String) throws{
        let components = text.components(separatedBy: allowedCharacters)
        let filtered = components.joined(separator: "")
        if text.count <= 3 {
            throw MyError.minCharterError(value: minCharterError).associatedValue()
        }else if text.count >= 31 {
            throw  MyError.maxCharterError(value: maxCharterError).associatedValue()
        }else if text != filtered {
            throw MyError.invalidTextError(value: invalidTextError).associatedValue()
        }else {
            self.safeQuery = text
            self.viewModel.items.removeAll()
            self.viewModel.searchApiCall(name: self.safeQuery)
        }
    }

}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.items.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.viewModel.cellHeight
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: searchCell, for: indexPath) as?
                SearchViewCell else { return UITableViewCell() }
        cell.cellConfig(cell: cell)
            .set(self.viewModel.items[safe: indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = self.viewModel.items[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        let finalUrl = item.owner.htmlUrl.absoluteString + "/\(item.name)"
        let detailViewController = DetailViewController()
        detailViewController.finalUrl = finalUrl
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
}

extension SearchViewController {
    
    //MARK: Tableview Pagination
     func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        if offsetY > contentHeight - scrollView.frame.size.height {
            self.repoTableView.indicatorView().startAnimating()
            self.viewModel.loadingStatus = true
            self.viewModel.indexOfPageRequest += 1
            self.viewModel.searchApiCall(name: self.safeQuery)
        }
    }
}

extension SearchViewController {
    
    //MARK: TableviewConstraints setup
    func setupTableView() {
        view.addSubview(repoTableView)
        repoTableView.topAnchor.constraint(equalTo: safeArea.topAnchor).isActive = true
        repoTableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor).isActive = true
        repoTableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        repoTableView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
    }
    
    func setupUI() {
        refreshControl.attributedTitle = NSAttributedString(string: PTR)
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        repoTableView.addSubview(refreshControl)
        view.addSubview(placeHolderLbl)
        placeHolderLbl.topAnchor.constraint(equalTo: safeArea.topAnchor).isActive = true
        placeHolderLbl.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor).isActive = true
        placeHolderLbl.rightAnchor.constraint(equalTo: safeArea.rightAnchor).isActive = true
        placeHolderLbl.leftAnchor.constraint(equalTo: safeArea.leftAnchor).isActive = true
    }
    
}
