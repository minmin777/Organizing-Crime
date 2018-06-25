//
//  Books.swift
//  Book App
//
//  Created by Yasmine Ayad on 6/24/18.
//  Copyright © 2018 Yasmine Ayad. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase
import KeychainSwift



class BooksController: UITableViewController{
    let cellId = "cellId"
    var ref: DatabaseReference!
    var refHandle: UInt!
    var booksList = [Book]()
    var author: Author!
    var series: Series!
    let box = BEMCheckBox(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = series.series! + " - Books"
        navigationController?.navigationBar.prefersLargeTitles = true
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        ref = Database.database().reference()
        //fetchAuthors()
        
        self.view.addSubview(box)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return booksList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        let name = self.booksList[indexPath.row].books
        //print(name!)
        cell.textLabel?.text = name
        return cell
        
        
    }
   /* func fetchAuthors(){
        //if let au = author.author as? String{
        //print(ref.child("Aames, Avery"))
        refHandle = ref.child("SERIES_NUM").child(author.author!).observe(DataEventType.childAdded, with: {
            (snapshot) in
            //print(snapshot.children.nextObject())
            if self.author.author == "Aames, Avery"{
                if let dictionary = snapshot.key as? String{
                    let aut = Series()
                    aut.series = dictionary
                    self.seriesList.append(aut)
                    DispatchQueue.main.async(execute:{
                        self.tableView.reloadData()
                    })
                }
            }else{
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
            }
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
    }*/
    
}
