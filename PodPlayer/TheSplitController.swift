//
//  TheSplitController.swift
//  PodPlayer
//
//  Created by Aleksandr Nikiforov on 17.05.2020.
//  Copyright © 2020 Aleksandr Nikiforov. All rights reserved.
//

import Cocoa

class TheSplitController: NSSplitViewController {

    @IBOutlet weak var podcastsItem: NSSplitViewItem!
    @IBOutlet weak var episodesItem: NSSplitViewItem!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        if let podcastsViewController = podcastsItem.viewController as? PodcastsViewController {
            if let episodesViewController = episodesItem.viewController as? EpisodesViewController {
                podcastsViewController.episodesViewController = episodesViewController
                episodesViewController.podcastsViewController = podcastsViewController
            }
        }
    }
    
}
