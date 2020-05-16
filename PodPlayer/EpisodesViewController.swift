//
//  EpisodesViewController.swift
//  PodPlayer
//
//  Created by Aleksandr Nikiforov on 17.05.2020.
//  Copyright © 2020 Aleksandr Nikiforov. All rights reserved.
//

import Cocoa

class EpisodesViewController: NSViewController {
    
    @IBOutlet weak var podcastTitleLabel: NSTextField!
    
    @IBOutlet weak var imageView: NSImageView!
    
    @IBOutlet weak var pauseButton: NSButton!
    
    @IBOutlet weak var tableView: NSTableView!
    
    var podcast : Podcast? = nil
    var podcastsViewController: PodcastsViewController? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func updateView() {
        if podcast?.title != nil {
            podcastTitleLabel.stringValue = podcast!.title!
        } else {
            podcastTitleLabel.stringValue = ""
        }
        
        if podcast?.imageURL != nil {
            let image = NSImage(byReferencing: URL(string: podcast!.imageURL!)!)
            imageView.image = image
        } else {
            imageView.image = nil
        }
        
        pauseButton.isHidden = true
        
        getEpisodes()
        
    }
    
    func getEpisodes() {
        if podcast?.rssURL != nil {
            
            let url = URL(string: podcast!.rssURL!)!
            
            URLSession.shared.dataTask(with: url) {(data:Data?,response:URLResponse?,error:Error?) in
                if error != nil {
                    print(error!)
                } else {
                    if data != nil {
                        let parser = Parser()
                        parser.getEpisodes(data: data!)
                        
                    }
                }
            }.resume()
            
        }
    }
    
    @IBAction func pauseButtonClicked(_ sender: Any) {
        
    }
    
    @IBAction func deleteButtonClicked(_ sender: Any) {
        if podcast != nil {
            if let context = (NSApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
                context.delete(podcast!)
                (NSApplication.shared.delegate as? AppDelegate)?.saveAction(nil)
                podcastsViewController?.getPodcasts()
                podcast = nil
                
                updateView()
            }
        }
    }
    
}
