//
//  ViewController.swift
//  Word Finder
//
//  Created by Mark Brody on 3/5/16.
//  Copyright © 2016 Mark Brody. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    let maxResults = 10
    var wordfinder = WordFinder()
    var wordlist = [String]()
    var resultlist = [String]()
    var pasteBoard = UIPasteboard.generalPasteboard()

    

    override func viewDidLoad() {
        super.viewDidLoad()

        let path = NSBundle.mainBundle().pathForResource("words", ofType: "plist")!
        let dict = NSDictionary(contentsOfFile:path)
        
        wordlist = dict!["wordlist"] as! Array<String>
        
        for word in wordlist {
            wordfinder.train(word)
        }
        
        self.tableView.reloadData()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: table
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.searchDisplayController?.searchResultsTableView {
            if self.resultlist.count >= maxResults {
                return maxResults
            }
            else {
                return self.resultlist.count
            }
        }
        else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("cell")! as UITableViewCell
        let backgroundView = UIView()
        var word: String
        
        if tableView == self.searchDisplayController?.searchResultsTableView {
            word = self.resultlist[indexPath.row] as! String
        }
        else {
            word = self.wordlist[indexPath.row] as! String
        }
        
        backgroundView.backgroundColor = UIColor(red: 1, green: 205/255, blue: 0, alpha: 1)
        cell.selectedBackgroundView = backgroundView
        cell.textLabel!.text = word
        
        return cell
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        var word: String
        if tableView == self.searchDisplayController?.searchResultsTableView {
            word = self.resultlist[indexPath.row] as! String
        }
        else {
            word = self.wordlist[indexPath.row] as! String
        }
        
    }
    
    // MARK: search
    
    func filterContent(search: String) {
        self.resultlist = self.wordlist.filter() {
            $0.hasPrefix(search.lowercaseString)
        }
        
        if self.resultlist.count == 0 {
            let search = self.searchDisplayController!.searchBar.text!.lowercaseString
            let results = wordfinder.correct(search)
            
            for result in results! {
                resultlist += [result]
            }
        }
    }
    
    func searchDisplayController(controller: UISearchDisplayController, didLoadSearchResultsTableView tableView: UITableView) {
        tableView.rowHeight = 96
    }
    
    func searchDisplayController(controller: UISearchDisplayController, shouldReloadTableForSearchString searchString: String?) -> Bool {
        self.filterContent(searchString!)
        return true
    }
    
/*
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        if self.resultlist.count == 0 {
            let search = self.searchDisplayController!.searchBar.text!.lowercaseString
            let results = wordfinder.correct(search)
            
            for result in results! {
                resultlist += [result]
            }
            print(resultlist)
            self.tableView.reloadData()
        }
    }
*/
    
    // MARK: pasteboard
    
    func tableView(tableView: UITableView, shouldShowMenuForRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, canPerformAction action: Selector, forRowAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        if (action == Selector("copy:")) {
            return true
        }
        return false
    }
    
    func tableView(tableView: UITableView, performAction action: Selector, forRowAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        pasteBoard.string = cell!.textLabel?.text
    }

}

