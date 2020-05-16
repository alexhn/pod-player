//
//  PodcastsViewController.swift
//  PodPlayer
//
//  Created by Aleksandr Nikiforov on 16.05.2020.
//  Copyright © 2020 Aleksandr Nikiforov. All rights reserved.
//

import Cocoa

class PodcastsViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate {

    @IBOutlet weak var podcastURLTextField: NSTextField!
    
    var podcasts : [Podcast] = []
    
    var episodesViewController : EpisodesViewController? = nil
    
    @IBOutlet weak var tableView: NSTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        podcastURLTextField.stringValue = "http://www.espn.com/espnradio/podcast/feeds/itunes/podCast?id=2406595"
        
        getPodcasts()
    }
    
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return podcasts.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let podcast = podcasts[row]
        let cell = (tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "podcastTableCell"), owner: self)
            as? NSTableCellView)
        
        if let title = podcast.title {
            cell?.textField?.stringValue = title
        } else {
            cell?.textField?.stringValue = "U"
        }
        return cell
    }
    
    func getPodcasts() {
         if let context = (NSApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
            
            let fetchy = Podcast.fetchRequest() as NSFetchRequest<Podcast>
            fetchy.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
            do {
                self.podcasts = try context.fetch(fetchy)
            } catch {}
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
         }
    }
    
    @IBAction func addPodcastClicked(_ sender: Any) {
        if let url = URL(string: podcastURLTextField.stringValue) {
            if let context = (NSApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
                URLSession.shared.dataTask(with: url) {(data:Data?,response:URLResponse?,error:Error?) in
                        if error != nil {
                            print(error!)
                        } else {
                            if data != nil {
                                DispatchQueue.main.async {
                                    let parser = Parser()
                                    let info = parser.getPodcastMetaData(data: data!)
                                    
                                    if !self.podcastExists(rssUrl: self.podcastURLTextField.stringValue) {
                                        let podcast = Podcast(context: context)
                                        podcast.imageURL = info.imageURL
                                        podcast.rssURL = url.absoluteString
                                        podcast.title = info.title
                                        (NSApplication.shared.delegate as? AppDelegate)?.saveAction(nil)
                                        self.getPodcasts()
                                    }
                                }
                            }
                        }
                }.resume()
            }
        }
            
        podcastURLTextField.stringValue = ""
        
        getPodcasts()
        
    }
    
    func podcastExists(rssUrl: String) -> Bool {
        if let context = (NSApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
           
           let fetchy = Podcast.fetchRequest() as NSFetchRequest<Podcast>
            fetchy.predicate = NSPredicate(format: "rssURL == %@", rssUrl)
           do {
              let matchingPodacsts = try context.fetch(fetchy)
              if matchingPodacsts.count >= 1 {
                  return true
              } else {
                return false
              }
           } catch {}
           
           DispatchQueue.main.async {
               self.tableView.reloadData()
           }
        }
        return false
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        if tableView.selectedRow >= 0 {
            let podcast = podcasts[tableView.selectedRow]
            episodesViewController?.podcast = podcast
            episodesViewController?.updateView()
        }
    }
    
}
