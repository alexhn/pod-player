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
        
        var ret : [Episode] = [];
        
        for item in xml["rss"]["channel"]["item"].all {
            let episode = Episode()
            if let title = item["title"].element?.text {
                episode.title = title
            }
            if let htmlDescription = item["description"].element?.text {
                episode.htmlDescription = htmlDescription
            }
            if let audioURL = item["enclosure"].element?.attribute(by: "url")?.text {
                episode.audioURL = audioURL
            }
            if let pubDate = item["pubDate"].element?.text {
                print("pub date: \(pubDate)")
                if let date = Episode.formatter().date(from: pubDate) {
                    print("formatted date: \(date)")
                    episode.pubDate = date
                }
            }
            ret.append(episode)
            print(episode.pubDate)
        }
        
        return ret
    }
    
    
}
