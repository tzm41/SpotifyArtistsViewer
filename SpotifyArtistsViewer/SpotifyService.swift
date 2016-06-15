//
//  SpotifyService.swift
//  SpotifyArtistsViewer
//
//  Created by Colin Tan on 6/14/16.
//  Copyright © 2016 Intrepid Pursuits LLC. All rights reserved.
//

import Foundation

enum GetArtistResponse {
    case Success([SpotifyItem])
    case Failure(ErrorType)
}

class SpotifyService {
    static let sharedService = SpotifyService()

    private let session: NSURLSession = {
        let sessionConfig = NSURLSessionConfiguration.defaultSessionConfiguration()
        sessionConfig.HTTPAdditionalHeaders = [
            "Accept": "application/json"
        ]

        let session = NSURLSession(configuration: sessionConfig)
        return session
    }()

    func sendRequest(query: String, searchType: ItemType) {
        let basePath = "https://api.spotify.com/v1/search"
        let queryItems: [NSURLQueryItem] = [
            NSURLQueryItem(name: "q", value: query),
            NSURLQueryItem(name: "type", value: searchType.string)
        ]
        let urlComponents = NSURLComponents(string: basePath)
        urlComponents?.queryItems = queryItems

        guard let url = urlComponents?.URL else { return }

        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "GET"

        /* Start a new Task */
        let task = session.dataTaskWithRequest(request, completionHandler: { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            if (error == nil) {
                // Success
                let statusCode = (response as! NSHTTPURLResponse).statusCode
                print("URL Session Task Succeeded: HTTP \(statusCode)")
            }
            else {
                // Failure
                print("URL Session Task Failed: %@", error!.localizedDescription);
            }
        })
        task.resume()
    }

}