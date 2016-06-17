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

enum GetAlbumResponse {
    case Success([Album])
    case Failure(ErrorType)
}

enum GetTrackResponse {
    case Success([Track])
    case Failure(ErrorType)
}

class SpotifyService {
    static let sharedService = SpotifyService()

    private let session: NSURLSession = {
        let sessionConfig = NSURLSessionConfiguration.defaultSessionConfiguration()
        sessionConfig.HTTPAdditionalHeaders = ["Accept": "application/json"]

        let session = NSURLSession(configuration: sessionConfig)
        return session
    }()

    func getArtistsWithQuery(query: String, completion: (GetArtistResponse) -> Void) {
        guard let request = requestFromQuery(query, type: "artists") else { return }

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

    func getAlbumsWithQuery(query: String, completion: (GetAlbumResponse) -> Void) {
        guard let request = requestFromQuery(query, type: "albums") else { return }
        
        let task = session.dataTaskWithRequest(request) { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            var result: GetAlbumResponse
            
            if let error = error {
                result = GetAlbumResponse.Failure(error)
            } else if let data = data {
                result = GetAlbumResponse.Success(SpotifyItem.albumsFromJSON(data))
            } else {
                result = GetAlbumResponse.Success([Album]())
            }
            dispatch_async(dispatch_get_main_queue()) {
                completion(result)
            }
        }
        task.resume()
    }
    
    func getTracksWithQuery(query: String, completion: (GetTrackResponse) -> Void) {
        guard let request = requestFromQuery(query, type: "tracks") else { return }
        
        let task = session.dataTaskWithRequest(request) { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            var result: GetTrackResponse
            
            if let error = error {
                result = GetTrackResponse.Failure(error)
            } else if let data = data {
                result = GetTrackResponse.Success(SpotifyItem.tracksFromJSON(data))
            } else {
                result = GetTrackResponse.Success([Track]())
            }
            dispatch_async(dispatch_get_main_queue()) {
                completion(result)
            }
        }
        task.resume()
    }

    private func requestFromQuery(query: String, type: String) -> NSMutableURLRequest? {
        let basePath = "https://api.spotify.com/v1/search"
        let queryItems: [NSURLQueryItem] = [
            NSURLQueryItem(name: "q", value: query),
            NSURLQueryItem(name: "type", value: type)
        ]
        
        let urlComponents = NSURLComponents(string: basePath)
        urlComponents?.queryItems = queryItems

        guard let url = urlComponents?.URL else { return nil }

        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "GET"

        return request
    }
}