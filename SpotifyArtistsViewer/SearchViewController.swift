//
//  SearchViewController.swift
//  SpotifyArtistsViewer
//
//  Created by Colin Tan on 6/14/16.
//  Copyright © 2016 Intrepid Pursuits LLC. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    // MARK: Properties
    private let searchController = UISearchController(searchResultsController: nil)
    
    @IBOutlet private weak var tableView: UITableView!
    
    private var artistSearchResult = [Artist]()
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableHeaderView = searchController.searchBar
        
//        SpotifyService.sharedService.sendRequest("Muse", searchType: ItemType.Artist)
    }
}

// MARK: UITableViewDelegate
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return artistSearchResult.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ArtistTabelViewCell", forIndexPath: indexPath)
        let item = artistSearchResult[indexPath.row]
        cell.textLabel?.text = item.name
        cell.imageView?.image = item.images.last?.imageContent
        return cell
    }
}

// MARK: UISearchResultsUpdating
extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        getSpotifyContentForQuery(searchController.searchBar.text!)
    }
    
    private func getSpotifyContentForQuery(query: String) {
        SpotifyService.sharedService.getArtistWithQuery(query) { response in
            switch response {
            case .Failure(let error):
                print("Error fecthing items: \(error)")
            case .Success(let returnedItems):
                self.artistSearchResult = returnedItems
                self.tableView.reloadData()
            }
        }
    }
}

// MARK: UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
    
}