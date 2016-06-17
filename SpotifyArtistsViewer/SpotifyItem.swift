//
//  Artist.swift
//  SpotifyArtistsViewer
//
//  Created by Colin Tan on 6/14/16.
//  Copyright © 2016 Intrepid Pursuits LLC. All rights reserved.
//

import UIKit

struct SpotifyItem {
    static func artistsFromJSON(jsonData: NSData) -> [Artist] {
        do {
            let jsonSerializationResult = try NSJSONSerialization.JSONObjectWithData(jsonData, options: []) as! NSDictionary

            var results = [Artist]()

            guard let rootEntry = jsonSerializationResult["artists"] as? NSDictionary else { return [Artist]() }

            if let itemEntries = rootEntry["items"] as? NSArray {
                for artistJSON in itemEntries {
                    guard let artistDictionary = artistJSON as? NSDictionary else { continue }
                    if let artist = Artist(json: artistDictionary) {
                        results.append(artist)
                    }
                }
            }
            return results
        } catch _ {
            print("Error")
        }
        return [Artist]()
    }

    static func albumsFromJSON(jsonData: NSData) -> [Album] {
        do {
            let jsonSerializationResult = try NSJSONSerialization.JSONObjectWithData(jsonData, options: []) as! NSDictionary

            var results = [Album]()

            guard let rootEntry = jsonSerializationResult["albums"] as? NSDictionary else { return [Album]() }

            if let itemEntries = rootEntry["items"] as? NSArray {
                for albumJSON in itemEntries {
                    guard let albumDictionary = albumJSON as? NSDictionary else { continue }
                    if let album = Album(json: albumDictionary) {
                        results.append(album)
                    }
                }
            }
            return results
        } catch _ {
            print("Error")
        }
        return [Album]()
    }
    
    static func tracksFromJSON(jsonData: NSData) -> [Track] {
        do {
            let jsonSerializationResult = try NSJSONSerialization.JSONObjectWithData(jsonData, options: []) as! NSDictionary
            
            var results = [Track]()
            
            guard let rootEntry = jsonSerializationResult["tracks"] as? NSDictionary else { return [Track]() }
            
            if let itemEntries = rootEntry["items"] as? NSArray {
                for trackJSON in itemEntries {
                    guard let trackDictionary = trackJSON as? NSDictionary else { continue }
                    if let Track = Track(json: trackDictionary) {
                        results.append(Track)
                    }
                }
            }
            return results
        } catch _ {
            print("Error")
        }
        return [Track]()
    }
}

class Artist {
    let name: String
    let images: [Image]
    let url: NSURL

    init?(json: NSDictionary) {
        var images = [Image]()

        if let name = json["name"] as? String {
            self.name = name
        } else { return nil }

        if let urls = json["external_urls"] as? NSDictionary {
            url = NSURL(string: urls["spotify"] as? String ?? "")!
        } else { return nil }

        if let imageURLs = json["images"] as? NSArray {
            for imageJSON in imageURLs {
                guard let image = Image(json: imageJSON as! NSDictionary) else { return nil }
                images.append(image)
            }
        }
        self.images = images
    }
}

class Album {
    let name: String
    let images: [Image]
    let url: NSURL

    init?(json: NSDictionary) {
        var images = [Image]()

        if let name = json["name"] as? String {
            self.name = name
        } else { return nil }

        if let urls = json["external_urls"] as? NSDictionary {
            url = NSURL(string: urls["spotify"] as? String ?? "")!
        } else { return nil }

        if let imageURLs = json["images"] as? NSArray {
            for imageJSON in imageURLs {
                guard let image = Image(json: imageJSON as! NSDictionary) else { return nil }
                images.append(image)
            }
        }
        self.images = images
    }
}

class Track {
    let name: String
    let url: NSURL

    init?(json: NSDictionary) {
        if let name = json["name"] as? String {
            self.name = name
        } else { return nil }
        
        if let urls = json["external_urls"] as? NSDictionary {
            url = NSURL(string: urls["spotify"] as? String ?? "")!
        } else { return nil }
    }
}