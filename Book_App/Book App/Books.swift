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
import M13Checkbox
import BEMCheckBox


class BookCell: UITableViewCell{
    //var present: UILabel!
    var link: BooksController?
    var checkBox: BEMCheckBox! = BEMCheckBox(frame: CGRect(x: 30, y: 0, width: 25, height: 25))
    var checkbox: BEMCheckBox! = BEMCheckBox(frame: CGRect(x: 60, y: 0, width: 25, height: 25))
    var name: UILabel = UILabel(frame: CGRect(x:100, y:0, width: 500, height: 25))


    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        /*checkBox.onAnimationType = .fill
        checkBox.animationDuration = 0.3
        contentView.backgroundColor = UIColor.clear
        checkBox.onTintColor = UIColor.blue
        checkBox.onFillColor = UIColor.blue
        checkBox.tintColor = UIColor.blue*/
        self.contentView.addSubview(checkBox)
        self.contentView.addSubview(checkbox)
        self.contentView.addSubview(name)
    }
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    /*@objc private func handleMarkAsFavorite() {
        //        print("Marking as favorite")
        link?.someMethodIWantToCall(cell: self)
    }*/
    override func layoutSubviews() {
        super.layoutSubviews()
        
        name = UILabel(frame: CGRect(x:100, y:0, width: 25, height: 25))
        //checkBox = BEMCheckBox(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        

        
    }

    /*override func awakeFromNib() {
        super.awakeFromNib()
        checkBox.onAnimationType = .fill
        checkBox.animationDuration = 0.3
        contentView.backgroundColor = UIColor.clear
        checkBox.onTintColor = UIColor.blue
        checkBox.onFillColor = UIColor.blue
        checkBox.tintColor = UIColor.blue
        contentView.addSubview(checkBox)
        contentView.addSubview(name)
    }*/

    /*var link: BooksController?
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        //backgroundColor = .red
        let box = BEMCheckBox(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        box.onAnimationType = .fill
        box.animationDuration = 0.3
     
        box.onTintColor = UIColor.blue
        box.onFillColor = UIColor.blue
        box.tintColor = UIColor.blue
        /*starButton.setImage(#imageLiteral(resourceName: "fav_star"), for: .normal)
        starButton.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        starButton.tintColor = .red
        starButton.addTarget(self, action: #selector(handleMarkAsFavorite), for: .touchUpInside)*/
        accessoryView = box
    }
    @objc private func handleMarkAsFavorite() {
        //        print("Marking as favorite")
        link?.someMethodIWantToCall(cell: self)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }*/
    /*
    override func awakeFromNib() {
        super.awakeFromNib()
        checkBox.onAnimationType = .fill
        checkBox.animationDuration = 0.3
        contentView.backgroundColor = UIColor.clear
        checkBox.onTintColor = UIColor.blue
        checkBox.onFillColor = UIColor.blue
        checkBox.tintColor = UIColor.blue
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }*/
}

class BooksController: UITableViewController{
    let cellId = "cellId"
    var ref: DatabaseReference!
    var refHandle: UInt!
    let cellReuseIdendifier = "cell"
    //var booksList = [[Book()]]
    //var booksList = Array(repeating:[Book](), count:3)
    var booksList = [Book]()
    var filreredbooks = [Book]()
    var des =  String()
    var included = String()
    var author: Author!
    var series: Series!
    //let box = BEMCheckBox(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
    //let checkbox = M13Checkbox(frame: CGRect(x: 0.0, y: 0.0, width: 40.0, height: 40.0))

    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()

        fetchBooks()
        navigationItem.title = series.series! + " - Books"
        navigationController?.navigationBar.prefersLargeTitles = true
        tableView.register(BookCell.self, forCellReuseIdentifier: "BookCell")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        tableView.delegate = self
        //view.addSubview(checkbox)
        //tableView.register(box, forCellReuseIdentifier: cellId)
        //fetchAuthors()
        
        //self.view.addSubview(box)
        //tableView.register(UINib(nibName: "BookCell", bundle: nil), forCellReuseIdentifier: "BookCell")

    }
    func someMethodIWantToCall(cell: UITableViewCell) {
        //        print("Inside of ViewController now...")
        
        // we're going to figure out which name we're clicking on
        
        guard let indexPathTapped = tableView.indexPath(for: cell) else { return }
        
        let authors = booksList[indexPathTapped.row]
        print("in some method i want to call: ", authors)
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookCell", for: indexPathTapped) as! BookCell
        let uid = Auth.auth().currentUser?.uid
        let thisUsersAuthRef = self.ref.child("users").child(uid!).child("Checked").child(author.author!).child(series.series!).child(self.booksList[indexPathTapped.row].books!)
        let authref = thisUsersAuthRef.child("favorite1")
        let authref2 = thisUsersAuthRef.child("favorite2")
        let hasFavotired1 = authors.hasFavorited1
        let hasFavorited2 = authors.hasFavorited2
        booksList[indexPathTapped.row].hasFavorited1 = !hasFavotired1
        booksList[indexPathTapped.row].hasFavorited2 = !hasFavorited2
        authref.setValue(self.booksList[indexPathTapped.row].hasFavorited1)
        authref2.setValue(self.booksList[indexPathTapped.row].hasFavorited2)
        //let hasFavorited = authors.hasChecked
        //booksList[indexPathTapped.row].hasChecked = !hasFavorited
        //cell.checkBox.delegate = self
        //cell.checkBox.tag = indexPath.row
        //        tableView.reloadRows(at: [indexPathTapped], with: .fade)
        //cell.checkBox.on = self.booksList[indexPathTapped.row].hasChecked
        //cell.accessoryView?.on = self.booksList[indexPathTapped.row].hasChecked
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 2
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //print("here2")
        print("booklist.count", filreredbooks)
        //let numberOfRowsAtSection: [Int] = [1, 1, booksList[2].count]
        var rows: Int = 0
        //print("here3")
        if section == 0{
            rows = 1
        }else{
            //rows = booksList.count
            rows = filreredbooks.count
        }
        /*if section < numberOfRowsAtSection.count {
            rows = numberOfRowsAtSection[section]
        }*/
        //print("here4")
        return rows
        //return booksList[section].numbooks
    }
    /*override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("bookslist len", booksList.count)
        return booksList.count
    }*/
    
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section{
        case 0:
            return "Description"
        case 1:
            return "Books"
        default:
            return "Section"
        }
        
        
        //return "Section \(section)"
    }
    func fetchBooks(){
        let uid = Auth.auth().currentUser?.uid
        var fav1: [String] = []
        var fav2: [String] = []
        
        if uid != nil {
            print(uid)
            let ref = Database.database().reference()
            ref.child("SERIES_NUM").child(author.author!).child(series.series!).observe(DataEventType.childAdded, with: {
                (snapshot) in
                if snapshot.key != "series"{
                    for rest in snapshot.children.allObjects as! [DataSnapshot]{
                        
                        if rest.key == "I_TITLE"{ //rest.value
                        ref.child("users").child(uid!).child("Checked").child(self.author.author!).child(self.series.series!).child(rest.value as! String).observe(DataEventType.childAdded, with: {
                                (snapshots) in
                                //if snapshot.hasChild("Favorited"){
                                //print(snapshot.childSnapshot(forPath: "Favorited").childSnapshot(forPath: "favorite").value)
                                //if let dictionary = snapshot.key as? String{
                            guard let fav11 = snapshots.childSnapshot(forPath: "favorite1").value else {return}
                            guard let fav22 = snapshots.childSnapshot(forPath: "favorite2").value else {return}
                            print("This is fav11", fav11)
                            
                            if(fav11 != nil){
                                print("rest.value", rest.value as! String)
                                fav1.append(rest.value as! String)
                            }
                            /*if (snapshots.childSnapshot(forPath: "favorite1").value == nil){
                                
                            }else{
                                if(snapshots.childSnapshot(forPath: "favorite1").value as! Bool == true){
                                    fav1.append(rest.value as! String)
                                }
                            }*/
                            if(fav22 != nil){
                                fav2.append(rest.value as! String)
                            }
                            /*if (snapshots.childSnapshot(forPath: "favorite1").value == nil){
                                
                            }else{
                                if snapshots.childSnapshot(forPath: "favorite2").value as! Bool == true{
                                fav2.append(rest.value as! String)
                                }
                            }*/
                            
                        })
                        }
                        //print("books in snapshot", rest.value)
                    }}})
        }
        DispatchQueue.main.async(execute:{
            self.tableView.reloadData()
        })
        refHandle = ref.child("SERIES_NUM").child(author.author!).child(series.series!).observe(DataEventType.childAdded, with: {
        (snapshot) in
            if snapshot.key != "series"{
                
                if snapshot.key == "description"{
                    self.des = snapshot.value as! String
                    DispatchQueue.main.async(execute:{
                        self.tableView.reloadData()
                    })
                }
                else if snapshot.key == "INCLUDED"{
                    self.included = snapshot.value as! String
                    /*print("included snapshot.value", snapshot.value)
                    boo.included = snapshot.value as! String
                    self.booksList[1].append(boo)*/
                    DispatchQueue.main.async(execute:{
                        self.tableView.reloadData()
                    })
                }else{
                    for rest in snapshot.children.allObjects as! [DataSnapshot]{
                       
                        if rest.key == "I_TITLE"{
                            print("fav1!!", fav1)
                            print(fav2)
                            let fa1 = fav1.contains(rest.value as! String) ? true : false
                            let fa2 = fav2.contains(rest.value as! String) ? true : false
                            let boo = Book(books: rest.value as! String, hasFavorited1: fa1, hasFavorited2: fa2)
                            //boo.books = rest.value as? String
                            //boo.numbooks = boo.numbooks + 1
                            self.booksList.append(boo)
                        }
                        //print("books in snapshot", rest.value)
                    }
                    DispatchQueue.main.async(execute:{
                        self.tableView.reloadData()
                    })
                }
                //print("boo", boo)
                //self.booksList.append(boo)
                self.filreredbooks = self.booksList

            }
        })
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 60
        } else {
            return UITableViewAutomaticDimension
        }
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //let cell = tableView.dequeueReusableCell(withIdentifier: "BookCell", for: indexPath) as! BookCell
        //let cells = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        print("indexpath.row", indexPath.row)

        //if let isOn = booksList[indexPath.row].hasChecked {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
            cell.textLabel?.text = des
            return cell
        } else{
            /*if self.booksList[indexPath.row].hasChecked {
                cell.checkBox.on = true
            } else {
                cell.checkBox.on = false
            }*/
            let cell = tableView.dequeueReusableCell(withIdentifier: "BookCell", for: indexPath) as! BookCell
            let uid = Auth.auth().currentUser?.uid
            let thisUsersAuthRef = self.ref.child("users").child(uid!).child("Checked").child(author.author!).child(series.series!).child(self.booksList[indexPath.row].books!)
            let authref = thisUsersAuthRef.child("favorite1")
            let authref2 = thisUsersAuthRef.child("favorite2")
            /*let hasFavotired1 = booksList[indexPath.row].hasFavorited1
            let hasFavorited2 = booksList[indexPath.row].hasFavorited2
            print("hasFavorited2:", hasFavorited2)
            print("hasFavorited1:", hasFavotired1)
            booksList[indexPath.row].hasFavorited1 = hasFavotired1
            booksList[indexPath.row].hasFavorited2 = hasFavorited2
            authref.setValue(self.booksList[indexPath.row].hasFavorited1)
            authref2.setValue(self.booksList[indexPath.row].hasFavorited2)*/
            
            cell.checkBox.delegate = self
            cell.checkbox.delegate = self
            cell.checkBox.tag = indexPath.row
            cell.checkbox.tag = indexPath.row
            cell.checkBox.boxType = .square
            cell.checkbox.boxType = .square
            if self.filreredbooks[indexPath.row].hasFavorited1 {
                cell.checkBox.on = true
            } else {
                cell.checkBox.on = false
            }
            if self.filreredbooks[indexPath.row].hasFavorited2 {
                cell.checkbox.on = true
            } else {
                cell.checkbox.on = false
            }
            //print("booksList[indexPath.row]: ", booksList[indexPath.row])
            let hasFavotired1 = cell.checkBox.on
            let hasFavorited2 = cell.checkbox.on
            print("hasFavorited2:", hasFavorited2)
            print("hasFavorited1:", hasFavotired1)
            filreredbooks[indexPath.row].hasFavorited1 = !hasFavotired1
            filreredbooks[indexPath.row].hasFavorited2 = !hasFavorited2
            authref.setValue(self.filreredbooks[indexPath.row].hasFavorited1)
            authref2.setValue(self.filreredbooks[indexPath.row].hasFavorited2)
            /**/
            let names = self.filreredbooks[indexPath.row].books
            cell.name.text = names
            //cell.checkBox.isUserInteractionEnabled = false
            //cell.checkBox.on = self.booksList[indexPath.row].hasChecked
            //cell.accessoryView?.box.on = self.choices[indexPath.row]
            return cell
        }
        
        /*} else {
            cell.checkBox.on = false*/
        //}
        //cell.checkBox.isUserInteractionEnabled = false
        //cell.checkBox.on = self.booksList[indexPath.row].hasChecked
        /*if indexPath.section == 0 {
            cell.textLabel?.text = "description: " + des
        } else if indexPath.section == 1 {
            cell.textLabel?.text = "included: " + included
        }else{
            
            let name = self.booksList[indexPath.row].books
            cell.textLabel?.text = name
            cell.checkBox.isUserInteractionEnabled = false
            cell.checkBox.on = self.booksList[indexPath.row].hasChecked
            //cell.accessoryView?.box.on = self.choices[indexPath.row]
            
        }*/

         
         //return cell
        
        
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let cells = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
            cells.textLabel?.text = "description: " + des
        } else{
            if let cell = tableView.cellForRow(at: indexPath) as? BookCell {
                
                
                
                /*if self.booksList[indexPath.row].hasChecked {
                 cell.checkBox.on = true
                 } else {
                 cell.checkBox.on = false
                 }*/
                self.booksList[indexPath.row].hasFavorited1 = !(cell.checkBox?.on)!
                self.booksList[indexPath.row].hasFavorited2 = !(cell.checkbox?.on)!
                //self.booksList[indexPath.row].hasFavorited1 = !(cell.checkBox?.on)
                cell.checkBox?.setOn(!cell.checkBox.on, animated: true)
                cell.checkbox?.setOn(!cell.checkbox.on, animated: true)
                let uid = Auth.auth().currentUser?.uid
                let thisUsersAuthRef = self.ref.child("users").child(uid!).child("Checked").child(author.author!).child(series.series!).child(self.booksList[indexPath.row].books!)
                let authref = thisUsersAuthRef.child("favorite1")
                let authref2 = thisUsersAuthRef.child("favorite2")
                authref.setValue(self.booksList[indexPath.row].hasFavorited1)
                authref2.setValue(self.booksList[indexPath.row].hasFavorited2)
                print("booksList[indexPath.row]: ", booksList[indexPath.row])
                //cell.accessoryView?.box.on = self.choices[indexPath.row]
                
            }
        }
    }
    }
    

extension BooksController : BEMCheckBoxDelegate {
    func didTap(_ checkBox: BEMCheckBox, _ checkbox: BEMCheckBox) {
        booksList[checkBox.tag].hasFavorited1 = checkBox.on
    }
}
