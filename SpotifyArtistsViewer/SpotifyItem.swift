//
//  Artist.swift
//  SpotifyArtistsViewer
//
//  Created by Colin Tan on 6/14/16.
//  Copyright © 2016 Intrepid Pursuits LLC. All rights reserved.
//

import UIKit

enum ItemType {
    case Artist
    case Album
    case Track
    
    var string: String {
        switch self {
        case .Artist:
            return "Artist"
        case .Album:
            return "Album"
        case .Track:
            return "Track"
        }
    }
}

struct SpotifyItem {
    var name: String
    var type: ItemType
    
    var url: NSURL
    
    var imageWidth: Int
    var imageHeight: Int
    var imageURL: NSURL
    
    var image: UIImage? {
        if let imageData = NSData(contentsOfURL: imageURL) {
            return UIImage(data: imageData)
        } else {
            return nil
        }
    }
}