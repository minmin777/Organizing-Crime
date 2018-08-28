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
/*class TabController: UITabBarController{

    override func viewDidLoad() {
        
        self.title = "Authors"
        let downloadViewController = HomeController()
        downloadViewController.tabBarItem = UITabBarItem(title: "Series", image: nil, selectedImage:nil)
        
        let viewControllerList = [ downloadViewController, downloadViewController]
        viewControllers = viewControllerList
    }
}*/

class AuthorCell: UITableViewCell{
    var link: HomeController?
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        //backgroundColor = .red
        let starButton = UIButton(type: .system)
        starButton.setImage(#imageLiteral(resourceName: "fav_star"), for: .normal)
        starButton.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        starButton.tintColor = .red
        starButton.addTarget(self, action: #selector(handleMarkAsFavorite), for: .touchUpInside)
        accessoryView = starButton
    }
    @objc private func handleMarkAsFavorite() {
        //        print("Marking as favorite")
        link?.someMethodIWantToCall(cell: self)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
class HomeController: UITableViewController, UISearchResultsUpdating{
    let cellId = "cellId"
    var ref: DatabaseReference!
    var refHandle: UInt!
    var authorList = [Author]()
    var filteredAuthor = [Author]()
    var authorSectionTitles = [String]()
    var authorDictionary = [String: [String]]()
    let searchController = UISearchController(searchResultsController: nil)
    var showIndexPaths = false
    @objc func handleShowFavorites() {
        print("Attemping reload animation of indexPaths...")
        
        weak var tableViewController: UITableView!
        // build all the indexPaths we want to reload
        
        //        for index in twoDimensionalArray[0].indices {
        //            let indexPath = IndexPath(row: index, section: 0)
        //            indexPathsToReload.append(indexPath)
        //        }
        
        showIndexPaths = !showIndexPaths
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return filteredAuthor.count
            
        }
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! AuthorCell
            cell.link = self
            /*let auKey = authorSectionTitles[indexPath.section]
             if let auValues = authorDictionary[auKey] {
             //print("cell.text", auValues[indexPath.row])
             cell.textLabel?.text = auValues[indexPath.row]
             }*/
            
            //let name = self.authorList[indexPath.row].author
            
            let name = filteredAuthor[indexPath.row]
            print(name.author! + " " + " in button")
            print(name.hasFavorited)
            if name.hasFavorited{
                cell.textLabel?.text = name.author
                cell.accessoryView?.tintColor = UIColor.red
            }
            
            return cell
            
            
        }
        print(filteredAuthor)
        tableViewController.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Favorited", style: .plain, target: self, action: #selector(handleShowFavorites))
        navigationItem.title = "Authors"
        navigationController?.navigationBar.prefersLargeTitles = true
        //filteredAuthor = self.authorList
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        fetchAuthors()
        checkIfUserIsLoggedIn()
        tableView.register(AuthorCell.self, forCellReuseIdentifier: cellId)
        ref = Database.database().reference()


        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar

    }
    @objc func handleLogout() {
        

        
        do {
            try Auth.auth().signOut()
        } catch let logoutError {
            print(logoutError)
        }
        /*DispatchQueue.main.async{
            self.tableView.reloadData()
        }*/
       /*let loginController = LoginController()
        //let _ = navigationController?.popViewController(animated: true)

        present(loginController, animated: true, completion: nil)*/
        //self.navigationController?.popViewController(animated: false)
        /*let seriesController = HomeController()
        //self.dismiss(animated: true, completion: nil)
        
        self.navigationController?.pushViewController(seriesController, animated: false)*/
        //let loginController = LoginController()
        //loginController.messagesController = self
        self.navigationController?.popViewController(animated: true)
        //self.navigationController?.popViewController(animated: true)
        //self.navigationController?.popToRootViewController(animated: true)



    }
    func checkIfUserIsLoggedIn() {
        if Auth.auth().currentUser?.uid == nil {
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        }else{
            //fetchAuthors()
            DispatchQueue.main.async(execute:{
                self.tableView.reloadData()
            })
        }
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
        let uid = Auth.auth().currentUser?.uid
        let thisUsersAuthRef = self.ref.child("users").child(uid!).child("Favorited")
        let authref = thisUsersAuthRef.childByAutoId().child("favorite")
        authref.setValue(authors.author)
        cell.accessoryView?.tintColor = hasFavorited ? UIColor.lightGray : .red
    }
    /*func updatefavorites(){
        for var i in filteredAuthor{
        let uid = Auth.auth().currentUser?.uid
        print(uid)
        refHandle = ref.child("users").child(uid!).child("Favorited").observe(DataEventType.childAdded, with: {
            (snapshot) in
            //if snapshot.hasChild("Favorited"){
            //print(snapshot.childSnapshot(forPath: "Favorited").childSnapshot(forPath: "favorite").value)
            //if let dictionary = snapshot.key as? String{
            if let aa = snapshot.childSnapshot(forPath: "favorite").value as? String{
                print("aa " + aa)
                print(i.author)
                if aa == i.author{
                    print("in first if")
                    //color = "red"
                    //cell.accessoryView?.tintColor = UIColor.red
                    i.hasFavorited = true
                }
                else{
                    print("in else")
                    //color = "lightGray"
                    //cell.accessoryView?.tintColor = UIColor.lightGray
                    i.hasFavorited = false;
                }
                DispatchQueue.main.async(execute:{
                    self.tableView.reloadData()
                })
            }
            
            //}else{
            //color = "lightGray"
            //cell.accessoryView?.tintColor = UIColor.lightGray
            //}
            
        })
        }
    }*/
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

        let uid = Auth.auth().currentUser?.uid
        var fav: [String] = []
        
        if uid != nil {
            print(uid)
            let ref = Database.database().reference()
            ref.child("users").child(uid!).child("Favorited").observe(DataEventType.childAdded, with: {
            (snapshots) in
            //if snapshot.hasChild("Favorited"){
            //print(snapshot.childSnapshot(forPath: "Favorited").childSnapshot(forPath: "favorite").value)
            //if let dictionary = snapshot.key as? String{
            
            if let aa = snapshots.childSnapshot(forPath: "favorite").value as? String{
                fav.append(aa)
            }})}
        DispatchQueue.main.async(execute:{
            self.tableView.reloadData()
        })
        print("regular fav", fav)
        let ref = Database.database().reference()
        refHandle = ref.child("SERIES_NUM").observe(DataEventType.childAdded, with: {
            (snapshot) in
            //if let dictionary = snapshot.key as? String{

                if let aa = snapshot.childSnapshot(forPath: "AUTHOR").value as? String{
                    if fav.contains(aa){
                        let aut = Author(author: aa, hasFavorited: true)
                        self.authorList.append(aut)
                    }else{
                        let aut = Author(author: aa, hasFavorited: false)
                        self.authorList.append(aut)
                    }
                    
                    
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
        let name = self.filteredAuthor[indexPath.row].author
        

       /* if color == "red"{
            cell.accessoryView?.tintColor = UIColor.red
        }else{
            cell.accessoryView?.tintColor = UIColor.lightGray
        }*/
        let uid = Auth.auth().currentUser?.uid

        /*ref.child("users").child(uid!).child("Favorited").observe(DataEventType.childAdded, with: {
            (snapshots) in
            //if snapshot.hasChild("Favorited"){
            //print(snapshot.childSnapshot(forPath: "Favorited").childSnapshot(forPath: "favorite").value)
            //if let dictionary = snapshot.key as? String{
            
            for aa in snapshots.children.allObjects as! [DataSnapshot]{
                /*if !self.filteredAuthor[indexPath.row].hasFavorited && aa == name{
                    snapshots.removeValue { error in
                        if error != nil {
                            print("error \(error)")
                        }
                    }
                }*/
                print(aa.value)
                print(name)
                let aaa = aa.value as? String
                print(!self.filteredAuthor[indexPath.row].hasFavorited)
                if !self.filteredAuthor[indexPath.row].hasFavorited && aaa == name{
                    aa.ref.child(aa.key).parent?.removeValue()
                }
            }})*/
        print("self.filteredAuthor[indexPath.row]:", self.filteredAuthor[indexPath.row])
        cell.textLabel?.text = name
        cell.accessoryView?.tintColor = self.filteredAuthor[indexPath.row].hasFavorited ? UIColor.red : .lightGray
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
        fetchSeries()
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
    func fetchSeries(){
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
