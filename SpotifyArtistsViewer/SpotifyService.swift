//
//  SpotifyService.swift
//  SpotifyArtistsViewer
//
//  Created by Colin Tan on 6/14/16.
//  Copyright © 2016 Intrepid Pursuits LLC. All rights reserved.
//

import Foundation

enum GetArtistResponse {
    case Success([Artist])
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

    func getArtistWithQuery(query: String, completion: (GetArtistResponse) -> Void) {
        let basePath = "https://api.spotify.com/v1/search"
        let queryItems: [NSURLQueryItem] = [
            NSURLQueryItem(name: "q", value: query),
            NSURLQueryItem(name: "type", value: "Artist")
        ]
        let urlComponents = NSURLComponents(string: basePath)
        urlComponents?.queryItems = queryItems

        guard let url = urlComponents?.URL else { return }

        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "GET"

        /* Start a new Task */
        let task = session.dataTaskWithRequest(request) { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            var result: GetArtistResponse
            
            if let error = error {
                result = GetArtistResponse.Failure(error)
            } else if let data = data {
                result = GetArtistResponse.Success(SpotifyItem.artistsFromJSON(data))
            } else {
                result = GetArtistResponse.Success([Artist]())
            }
            dispatch_async(dispatch_get_main_queue()) {
                completion(result)
            }
        }
        task.resume()
    }

}