//
//  infoGnomeViewController.swift
//  kavakExercise
//
//  Created by Andrés Bonilla on 12/3/19.
//  Copyright © 2019 Andrés Abraham Bonilla Gómez. All rights reserved.
//

import UIKit
import Hero

class infoGnomeViewController: UIViewController, segmentControlDelegate {

    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var profileImage: UIImageView!
    @IBOutlet var containerView: UIView!
    @IBOutlet var selector: segmentControl!
    @IBOutlet var favoriteButton: UIButton!
    
    private let context = coreDataManager.shared.persistentContainer.viewContext
    
    var infoGnome : gnome?
    var imageGnome : UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        // Do any additional setup after loading the view.
    }
    
    func initView()
    {
        self.hero.isEnabled = true
        self.navigationController?.hero.isEnabled = true
        
        selector.delegate = self
        selector.backgroundColor = UIColor(hexString: "#7A8E8F")
        selector.setButtonTitles(buttonTitles: ["Profile","Friends","Jobs"])
        if infoGnome != nil
        {
            setupView(index: 0)
            nameLabel.text = infoGnome!.name
        }
        if imageGnome != nil
        {
            profileImage.image = imageGnome!
        }
        let names = infoGnome!.name.split(separator: " ")
        api.shared.getGender(name: String(names[0]), lastName: String(names[1])) { (status, info) in
            self.cleanData(data: info)
        }
        
        if let result = coreDataManager.shared.searchRegister("Gnome", id: String(infoGnome!.id))
        {
            if result.count != 0
            {
                favoriteButton.isSelected = true
                favoriteButton.setBackgroundImage(UIImage(named: "favorite"), for: .normal)
            }
            else
            {
                favoriteButton.setBackgroundImage(UIImage(named: "nonFavorite"), for: .normal)
            }
        }
    }
    
    func changeToIndex(index: Int) {
        setupView(index: index)
    }
    
    func cleanData(data: NSDictionary)
    {
        var imageGender = ""
        if let gender = data["likelyGender"] as? String
        {
            imageGender = gender
        }
        else
        {
            imageGender = "other"
        }
        DispatchQueue.main.async {
            //self.profileImage.image = UIImage(named: imageGender)
        }
    }
    
    //function coredata
    
    @IBAction func addFavorite(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected
        {
            saveGnome()
            favoriteButton.setBackgroundImage(UIImage(named: "favorite"), for: .normal)
        }
        else
        {
            deleteGnome()
            favoriteButton.setBackgroundImage(UIImage(named: "nonFavorite"), for: .normal)
        }
    }
    
    func saveGnome()
    {
        var message = ""
        let gnomeSave = Gnome(entity: Gnome.entity(), insertInto: self.context)
        gnomeSave.age = Int16(infoGnome!.age)
        gnomeSave.name = infoGnome!.name
        gnomeSave.height = infoGnome!.height
        gnomeSave.id = Int16(infoGnome!.id)
        gnomeSave.hairColor = infoGnome!.hairColor
        gnomeSave.thumbnail = infoGnome!.thumbnail
        gnomeSave.weight = infoGnome!.weight
        gnomeSave.friends = infoGnome!.friends as NSObject
        gnomeSave.professions = infoGnome!.friends as NSObject
        if coreDataManager.shared.saveContext()
        {
            message = "you are making new friendships 😍"
        }
        else
        {
            message = "somethin is wrong 😩"
        }
        DispatchQueue.main.async {
            self.showAlertMessage(titleStr: "Gnome", messageStr: message)
        }
    }
    
    func deleteGnome()
    {
        var message = ""
        if coreDataManager.shared.deleteRegister("Gnome", id: String(infoGnome!.id))
        {
            message = "he doesn't want your friendship 🥶"
        }
        else
        {
            message = "somethin is wrong 😩"
        }
        DispatchQueue.main.async {
            self.showAlertMessage(titleStr: "Gnome", messageStr: message)
        }
    }
    
    //functions for info
    
    func setupView(index: Int)
    {
        switch index {
        case 0:
            remove(asChildViewController: friendGnomeView)
            remove(asChildViewController: professionGnomeView)
            add(asChildViewController: infoGnomeView)
        case 1:
            remove(asChildViewController: infoGnomeView)
            remove(asChildViewController: professionGnomeView)
            add(asChildViewController: friendGnomeView)
        case 2:
            remove(asChildViewController: friendGnomeView)
            remove(asChildViewController: infoGnomeView)
            add(asChildViewController: professionGnomeView)
        default:
            print("error")
        }
    }
    
    private func add(asChildViewController viewController: UIViewController) {
        
        // Add Child View Controller
        addChild(viewController)
        
        // Add Child View as Subview
        containerView.addSubview(viewController.view)
        
        // Configure Child View
        viewController.view.frame = containerView.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        // Notify Child View Controller
        viewController.didMove(toParent: self)
    }
    
    private func remove(asChildViewController viewController: UIViewController) {
        // Notify Child View Controller
        viewController.willMove(toParent: nil)
        
        // Remove Child View From Superview
        viewController.view.removeFromSuperview()
        
        // Notify Child View Controller
        viewController.removeFromParent()
    }
    
    private lazy var infoGnomeView: infoTableViewController = {
        // Load Storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        // Instantiate View Controller
        var viewController = storyboard.instantiateViewController(withIdentifier: "infoAboutGnome") as! infoTableViewController
        viewController.infoGnome = self.infoGnome!
        // Add View Controller as Child View Controller
        self.addChild(viewController)
        
        return viewController
    }()
    
    private lazy var professionGnomeView: professionsTableViewController = {
        // Load Storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        // Instantiate View Controller
        var viewController = storyboard.instantiateViewController(withIdentifier: "professionsGnome") as! professionsTableViewController
        viewController.infoGnome = self.infoGnome!
        // Add View Controller as Child View Controller
        self.addChild(viewController)
        
        return viewController
    }()

    private lazy var friendGnomeView: friendsTableViewController = {
        // Load Storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        // Instantiate View Controller
        var viewController = storyboard.instantiateViewController(withIdentifier: "gnomeFriends") as! friendsTableViewController
        viewController.infoGnome = self.infoGnome!
        // Add View Controller as Child View Controller
        self.addChild(viewController)
        
        return viewController
    }()
}
