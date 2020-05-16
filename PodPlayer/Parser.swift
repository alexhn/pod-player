import Foundation

class Parser {

    func getPodcastMetaData(data: Data) -> (title: String?, imageURL: String?) {
        let xml = SWXMLHash.parse(data)
        
        let title = xml["rss"]["channel"]["title"].element?.text
        let imageURL = xml["rss"]["channel"]["itunes:image"].element?.attribute(by: "href")?.text

        return (title, imageURL)
    
    }
    
    func getEpisodes(data: Data) -> [Episode] {
        
        let xml = SWXMLHash.parse(data)
        
        for item in xml["rss"]["channel"]["item"].all {
            let episode = Episode()
            if let title = item["title"].element?.text {
                episode.title = title
            }
            if let htmlDescription = item["description"].element?.text {
                episode.htmlDescription = htmlDescription
            }
            if let audioURL = item["link"].element?.text {
                episode.audioURL = audioURL
            }
        }
        
        return []
    }
    
}
