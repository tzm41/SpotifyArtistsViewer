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
    private var albumSearchResult = [Album]()
    private var trackSearchResult = [Track]()

    private var searchScope: ItemType = .Artist

    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.scopeButtonTitles = ["Artist", "Album", "Track"]
        searchController.searchBar.delegate = self
        definesPresentationContext = true

        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableHeaderView = searchController.searchBar

        searchScope = .Artist
    }

    // MARK: Segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let controller = (segue.destinationViewController as! UINavigationController).topViewController as! DetailViewController
                controller.displayType = searchScope
                switch searchScope {
                case .Artist:
                    let artist = artistSearchResult[indexPath.row]
                    controller.detailArtist = artist
                case .Album:
                    let album = albumSearchResult[indexPath.row]
                    controller.detailAlbum = album
                case .Track:
                    let track = trackSearchResult[indexPath.row]
                    controller.detailTrack = track
                }

            }
        }
    }
}

// MARK: UITableViewDelegate
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch searchScope {
        case .Artist:
            return artistSearchResult.count
        case .Album:
            return albumSearchResult.count
        case .Track:
            return trackSearchResult.count
        }
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ItemTableViewCell", forIndexPath: indexPath)
        switch searchScope {
        case .Artist:
            let item = artistSearchResult[indexPath.row]
            cell.textLabel?.text = item.name
            cell.imageView?.image = item.images.last?.imageContent
            cell.imageView?.layer.cornerRadius = 10
            cell.imageView?.layer.masksToBounds = true
        case .Album:
            let item = albumSearchResult[indexPath.row]
            cell.textLabel?.text = item.name
            cell.imageView?.image = item.images.last?.imageContent
            cell.imageView?.layer.cornerRadius = 10
            cell.imageView?.layer.masksToBounds = true
        case .Track:
            let item = trackSearchResult[indexPath.row]
            cell.textLabel?.text = item.name
            cell.imageView?.image = nil
        }
        return cell
    }
}

// MARK: UISearchResultsUpdating
extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        getSpotifyContentForQuery(searchController.searchBar.text!)
    }

    private func getSpotifyContentForQuery(query: String) {
        switch searchScope {
        case .Artist:
            SpotifyService.sharedService.getArtistsWithQuery(query) { response in
                switch response {
                case .Failure(let error):
                    print("Error fecthing items: \(error)")
                case .Success(let returnedItems):
                    self.artistSearchResult = returnedItems
                    self.tableView.reloadData()
                }
            }
        case .Album:
            SpotifyService.sharedService.getAlbumsWithQuery(query) { response in
                switch response {
                case .Failure(let error):
                    print("Error fecthing items: \(error)")
                case .Success(let returnedItems):
                    self.albumSearchResult = returnedItems
                    self.tableView.reloadData()
                }
            }
        case .Track:
            SpotifyService.sharedService.getTracksWithQuery(query) { response in
                switch response {
                case .Failure(let error):
                    print("Error fecthing items: \(error)")
                case .Success(let returnedItems):
                    self.trackSearchResult = returnedItems
                    self.tableView.reloadData()
                }
            }
        }
    }
}

// MARK: UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
    func searchBar(searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        switch searchBar.scopeButtonTitles![selectedScope] {
        case "Artist":
            searchScope = .Artist
        case "Album":
            searchScope = .Album
        case "Track":
            searchScope = .Track
        default:
            break
        }
        updateSearchResultsForSearchController(searchController)
    }
}