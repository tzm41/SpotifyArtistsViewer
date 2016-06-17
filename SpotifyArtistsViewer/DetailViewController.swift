//
//  DetailViewController.swift
//  SpotifyArtistsViewer
//
//  Created by Colin Tan on 6/16/16.
//  Copyright © 2016 Intrepid Pursuits LLC. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    
    var detailArtist: Artist? {
        didSet {
            configureView()
        }
    }
    
    var detailAlbum: Album? {
        didSet {
            configureView()
        }
    }
    
    var detailTrack: Track? {
        didSet {
            configureView()
        }
    }
    
    private func configureView() {
        if let artist = detailArtist {
            if let nameLabel = nameLabel, imageView = imageView {
                nameLabel.text = artist.name
                imageView.image = artist.images.first?.imageContent
                title = artist.name
            }
        } else if let album = detailAlbum {
            if let nameLabel = nameLabel, imageView = imageView {
                nameLabel.text = album.name
                imageView.image = album.images.first?.imageContent
                title = album.name
            }
        } else if let track = detailTrack {
            if let nameLabel = nameLabel {
                nameLabel.text = track.name
                title = track.name
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
}
