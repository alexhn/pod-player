//
//  EpisodeCell.swift
//  PodPlayer
//
//  Created by Aleksandr Nikiforov on 17.05.2020.
//  Copyright © 2020 Aleksandr Nikiforov. All rights reserved.
//

import Cocoa
import WebKit

class EpisodeCell: NSTableCellView {

    @IBOutlet weak var titleLabel: NSTextField!
    
    @IBOutlet weak var dateLabel: NSTextField!
    
    @IBOutlet weak var descriptionWebView: WKWebView!
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
    }
      
}
