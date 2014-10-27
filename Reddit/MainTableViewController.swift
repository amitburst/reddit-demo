//
//  MainTableViewController.swift
//  Reddit
//
//  Created by Amit Burstein on 10/26/14.
//  Copyright (c) 2014 Amit Burstein. All rights reserved.
//

import UIKit

class MainTableViewController : UITableViewController, UITableViewDataSource, UITableViewDelegate {
    
    let postCellIdentifier = "PostCell" // table cell identifier
    let showBrowserIdentifier = "ShowBrowser" // segue to browser view identifier
    let endpoint = "https://reddit.com/r/aww/top.json" // endpoint to fetch from
    var posts: [(title: String, url: String, score: Int)] = [] // data to fill table with
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // fetch posts when the view loads
        fetchPosts()
    }
    
    func fetchPosts() {
        // make http request
        let url = NSURL(string: endpoint)
        let queue = NSOperationQueue()
        let request = NSURLRequest(URL: url!)
        
        NSURLConnection.sendAsynchronousRequest(request, queue: queue, completionHandler: { (_, data, error) in
            // clear posts array
            self.posts = []
            
            // unwrap json and add to posts array
            var json = NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers, error: nil) as NSDictionary
            if let children = json["data"]?["children"] as? Array<NSDictionary> {
                for child in children {
                    let title = child["data"]?["title"] as? String
                    let url = child["data"]?["url"] as? String
                    let score = child["data"]?["score"] as? Int
                    self.posts.append(title: title!, url: url!, score: score!)
                }
            }
            
            // reload table view in main thread
            dispatch_async(dispatch_get_main_queue(), {
                self.tableView.reloadData()
            })
        })
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // reuse cell
        let cell = tableView.dequeueReusableCellWithIdentifier(postCellIdentifier) as UITableViewCell
        
        // set cell labels
        let post = posts[indexPath.row]
        cell.textLabel.text = post.title
        cell.detailTextLabel?.text = "\(post.score) points"
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // set properties in browser view controller before segue
        if segue.identifier == showBrowserIdentifier {
            let browserViewController = segue.destinationViewController as BrowserViewController
            let post = posts[tableView.indexPathForSelectedRow()!.row]
            browserViewController.postTitle = post.title
            browserViewController.postUrl = post.url
        }
    }
    
}