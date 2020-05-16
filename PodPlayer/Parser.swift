import Foundation

class Parser {

    func getPodcastMetaData(data: Data) -> (title: String?, imageURL: String?) {
        let xml = SWXMLHash.parse(data)
        
        let title = xml["rss"]["channel"]["title"].element?.text
        let imageURL = xml["rss"]["channel"]["itunes:image"].element?.attribute(by: "href")?.text

        print(imageURL)
        
        return (title, imageURL)
    
    }
}
