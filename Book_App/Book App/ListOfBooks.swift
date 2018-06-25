//
//  ListOfBooks.swift
//  Book App
//
//  Created by Yasmine Ayad on 4/17/18.
//  Copyright © 2018 Yasmine Ayad. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase
import KeychainSwift
class HomeController: UITableViewController, UISearchResultsUpdating{
    let cellId = "cellId"
    var ref: DatabaseReference!
    var refHandle: UInt!
    var authorList = [Author]()
    var filteredAuthor = [Author]()
    var authorSectionTitles = [String]()
    var authorDictionary = [String: [String]]()
    let searchController = UISearchController(searchResultsController: nil)
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Authors"
        navigationController?.navigationBar.prefersLargeTitles = true
        //filteredAuthor = self.authorList

        tableView.register(AuthorCell.self, forCellReuseIdentifier: cellId)
        ref = Database.database().reference()
        fetchAuthors()

        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar

    }
    func someMethodIWantToCall(cell: UITableViewCell) {
        //        print("Inside of ViewController now...")
        
        // we're going to figure out which name we're clicking on
        
        guard let indexPathTapped = tableView.indexPath(for: cell) else { return }
        
        let authors = filteredAuthor[indexPathTapped.row]
        print(authors)
        
        let hasFavorited = authors.hasFavorited
        filteredAuthor[indexPathTapped.row].hasFavorited = !hasFavorited
        
        //        tableView.reloadRows(at: [indexPathTapped], with: .fade)
        
        cell.accessoryView?.tintColor = hasFavorited ? UIColor.lightGray : .red
    }
    func fetchAuthors(){
        /*ref.child("SERIES_NUM").observeSingleEvent(of: .value, with: { (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                
                for snap in snapshots
                {
                    let firUserId = child.childSnapshot(forPath: "userId").value! as! String
                    let receivePostSnapshot = child.childSnapshot(forPath: "receivePost")
                }
            }
        })*/
        refHandle = ref.child("SERIES_NUM").observe(DataEventType.childAdded, with: {
            (snapshot) in
            //if let dictionary = snapshot.key as? String{
                if let aa = snapshot.childSnapshot(forPath: "AUTHOR").value as? String{
                    let aut = Author(author: aa, hasFavorited: false)
                    self.authorList.append(aut)
                    DispatchQueue.main.async(execute:{
                        self.tableView.reloadData()
                    })
                }
                //print(aa.value)
                //}
                /*self.ref.child("SERIES_NUM").child(dictionary).child("AUTHOR").observe(DataEventType.childAdded, with: {
                    (snapshots) in
                    if let dic = snapshots.value as? String{
                        let aut = Author(author: dic, hasFavorited: false)
                        //aut.author = dictionary
                        //aut.hasFavorited = false
                        self.authorList.append(aut)
                        DispatchQueue.main.async(execute:{
                            self.tableView.reloadData()
                    })
                    }})}*/
                self.filteredAuthor = self.authorList
            })
            /*for au in self.authorList{
                //print("au in fetchauthors", au)
                let auKey = String((au.author?.prefix(1))!)
                print("auKey in fetchauthor:", au.author)
                if var auValues = self.authorDictionary[auKey] {
                    auValues.append(au.author!)
                    //print("auValue in fetchauthor:", auValues)
                    self.authorDictionary[auKey] = auValues
                    //print("authorDictionary in fetchauthor:", self.authorDictionary[auKey])
                } else {
                    self.authorDictionary[auKey] = [au.author] as? [String]
                }
            }
            self.authorSectionTitles = [String](self.authorDictionary.keys)
            self.authorSectionTitles = self.authorSectionTitles.sorted(by: { $0 < $1 })*/
      
        
        //return authorList
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        /*let auKey = authorSectionTitles[section]
        //print("auKey in rowinsection", auKey)
        if let auValues = authorDictionary[auKey] {
            //print("auKey in rowinsection in if", auKey)
            return auValues.count
        }
        
        return 0*/
        //return authorList.count
        return filteredAuthor.count
    }
    /*override func numberOfSections(in tableView: UITableView) -> Int {
        // 1
        //print("numberofsections", authorSectionTitles.count)
        return authorSectionTitles.count
    }*/
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let seriesController = SeriesController()
        seriesController.author = self.filteredAuthor[indexPath.row]
        //print(seriesController.fetchAuthors())
        navigationController?.pushViewController(seriesController, animated: true)
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! AuthorCell
        cell.link = self
        /*let auKey = authorSectionTitles[indexPath.section]
        if let auValues = authorDictionary[auKey] {
            //print("cell.text", auValues[indexPath.row])
            cell.textLabel?.text = auValues[indexPath.row]
        }*/
        //let name = self.authorList[indexPath.row].author
        let name = self.filteredAuthor[indexPath.row]
        cell.textLabel?.text = name.author
        cell.accessoryView?.tintColor = name.hasFavorited ? UIColor.red : .lightGray
        return cell
        
        
    }
    func updateSearchResults(for searchController: UISearchController) {
        // If we haven't typed anything into the search bar then do not filter the results
        print("searchController.searchBar.text!", searchController.searchBar.text!)
        if searchController.searchBar.text! == "" {
            filteredAuthor = authorList
        } else {
            // Filter the results
            filteredAuthor = authorList.filter { $0.author!.lowercased().contains(searchController.searchBar.text!.lowercased()) }
        }
        
        tableView.reloadData()
    }
    /*override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return authorSectionTitles[section]
    }
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return authorSectionTitles
    }*/
    /*override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let button = UIButton(type: .system)
        button.setTitle("Close", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .yellow
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        
        button.addTarget(self, action: #selector(handleExpandClose), for: .touchUpInside)
        
        button.tag = section
        
        return button
        
    }
    
    @objc func handleExpandClose(button: UIButton) {
        print("Trying to expand and close section...")
        
        let section = button.tag
        
        // we'll try to close the section first by deleting the rows
        var indexPaths = [IndexPath]()
        for row in authorList.indices {
            print(0, row)
            let indexPath = IndexPath(row: row, section: section)
            indexPaths.append(indexPath)
        }
        
        authorList.removeAll()
        tableView.deleteRows(at: indexPaths, with: .fade)
        
        /*if isExpanded {
            tableView.deleteRows(at: indexPaths, with: .fade)
        } else {
            tableView.insertRows(at: indexPaths, with: .fade)
        }*/
    }*/
    
    @IBAction func SignOut (_ sender: Any){
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        DataService().keyChain.delete("uid")
        dismiss(animated: true, completion: nil)
    }

}

class SeriesController: UITableViewController{
    let cellId = "cellId"
    var ref: DatabaseReference!
    var refHandle: UInt!
    var seriesList = [Series]()
    var author: Author!
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = author.author! + " - Series"
        navigationController?.navigationBar.prefersLargeTitles = true
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        ref = Database.database().reference()
        fetchAuthors()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return seriesList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        let name = self.seriesList[indexPath.row].series
        //print(name!)
        cell.textLabel?.text = name
        return cell
        
        
    }
    func fetchAuthors(){
        //if let au = author.author as? String{
        //print(ref.child("Aames, Avery"))
        refHandle = ref.child("SERIES_NUM").child(author.author!).observe(DataEventType.childAdded, with: {
            (snapshot) in
            //print(snapshot.children.nextObject())

            //if let dictionary = snapshot.value as? String{
                if let dictionary = snapshot.key as? String{
                    if dictionary != "AUTHOR"{
                        if let aa = snapshot.childSnapshot(forPath: "series").value as? String{
                            print(snapshot.childSnapshot(forPath: "series"))
                            let aut = Series()
                            aut.series = aa
                            self.seriesList.append(aut)
                            DispatchQueue.main.async(execute:{
                                self.tableView.reloadData()
                            })
                        }}}
                /*let enumerator = snapshot.children
                while let rest = enumerator.nextObject() as? DataSnapshot {
                    print("where")
                    if rest.key != "AUTHOR"{
                        print("am")
                        if let dictionary = rest.key as? String{
                            print(dictionary)
                            if let aa = rest.childSnapshot(forPath: "series").value as? String{
                                print("wtf")
                                print(aa)
                                let aut = Series()
                                aut.series = aa
                                self.seriesList.append(aut)
                                DispatchQueue.main.async(execute:{
                                    self.tableView.reloadData()
                                })
                            }}}*/
                    /*if let dictionary = rest.key as? String{
                        print(dictionary)
                        let aut = Series()
                        aut.series = dictionary
                        self.seriesList.append(aut)
                        DispatchQueue.main.async(execute:{
                            self.tableView.reloadData()
                        })
                }*/
                /*print(dictionary)
                let aut = Series()
                aut.series = dictionary
                self.seriesList.append(aut)
                DispatchQueue.main.async(execute:{
                    self.tableView.reloadData()
                })*/
                
            
        //}
        })
    //}
    //else{
     //   print("Error in fetchAuthors() for series")
   // }
//}
}
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let bookController = BooksController()
        bookController.series = self.seriesList[indexPath.row]
        bookController.author = self.author
        //print(seriesController.fetchAuthors())
        navigationController?.pushViewController(bookController, animated: true)
    }

}
