//
//  ViewController.swift
//  kavakExercise
//
//  Created by Andrés Abraham Bonilla Gómez on 12/2/19.
//  Copyright © 2019 Andrés Abraham Bonilla Gómez. All rights reserved.
//

import UIKit
import Hero

class ViewController: UIViewController,  UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate, dataFiler {
    
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet weak var filterView: filter!
    @IBOutlet var filterButton: UIButton!
    @IBOutlet var searchBar: UISearchBar!
    
    private let context = coreDataManager.shared.persistentContainer.viewContext
    private var arrGnomes = [gnome]()
    private var arrGnomesFilter = [gnome]()
    private var localArrGnomes = [Gnome]()
    private var arrGnomesFilterSearchbar = [gnome]()
    private var enableFilter = false
    private var arrImages = [String:UIImage]()
    
    var useFlag = 1
    var dispatchGroup = DispatchGroup()
    var searchActive : Bool = false

    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }

    func initView()
    {
        self.navigationController?.hero.isEnabled = true
        self.navigationController?.navigationBar.isTranslucent = false
        navigationItem.title = "Citizens"
        filterButton.backgroundColor = UIColor(hexString: "#7A8E8F")
        filterView.delegate = self
        filterView.alpha = 0
        collectionView.delegate = self
        collectionView.dataSource = self
        searchBar.delegate =  self
        if let layout = collectionView?.collectionViewLayout as? customLayout {
            layout.delegate = self
        }
        if useFlag == 2
        {
            checkLocalData()
        }
        else
        {
            utilActivityIndicator.shared.showLoader(view: navigationController!.view)
            api.shared.downloadData { (status, info) in
                if status != 200
                {
                    DispatchQueue.main.async {
                        utilActivityIndicator.shared.hideLoader(view: self.navigationController!.view)
                        self.showAlertMessage(titleStr: "Gnome", messageStr: "The city didn't allow you entry. 😱 \(status)")
                    }
                }
                else
                {
                    DispatchQueue.main.async {
                        utilActivityIndicator.shared.hideLoader(view: self.navigationController!.view)
                        self.cleanData(data: info)
                    }
                }
            }
        }
    }
    
    func checkLocalData()
    {
        do{
            localArrGnomes = try context.fetch(Gnome.fetchRequest())
            if localArrGnomes.count != 0
            {
                for data in localArrGnomes
                {
                    if let arrayFriends = data.friends as! NSArray as? [String], let arrayProfessions = data.professions as! NSArray as? [String]
                    {
                        let gnomeLocal = gnome(id: Int(data.id), name: data.name!, thumbnail: data.thumbnail!, age: Int(data.age), weight: data.weight, height: data.height, hairColor: data.hairColor!, professions: arrayProfessions, friends: arrayFriends)
                        arrGnomes.append(gnomeLocal)
                    }
                }
                DispatchQueue.main.async {
                    self.downloadImages()
                    self.collectionView.reloadData()
                }
            }
            
        }catch let error as NSError{
            self.showAlertMessage(titleStr: "Gnome", messageStr: "we can't recover your family 😓. \(error)")
            print("error \(error) \(error.userInfo)")
        }
    }
    
    func infoFilter(_ data: [String : Any]) {
        cleanFilterData(data: data)
    }
    
    func defaultFilter(_ flag: Bool) {
        disappearFilter()
    }
    
    func cleanFilterData(data: [String:Any]){
        if data.count != 0
        {
            var flag = false
            for (key,value) in data{
                if key == "hairColor"
                {
                    let hair = value as! String
                    if flag
                    {
                        self.arrGnomesFilter = arrGnomesFilter.filter({ (gnome) -> Bool in
                            gnome.hairColor == hair
                        })
                    }
                    else
                    {
                        self.arrGnomesFilter = arrGnomes.filter({ (gnome) -> Bool in
                            gnome.hairColor == hair
                        })
                    }
                    flag = true
                }
                else if key == "profession"
                {
                    let profession = value as! String
                    if flag
                    {
                        self.arrGnomesFilter = arrGnomesFilter.filter({ (gnome) -> Bool in
                            gnome.professions.contains(profession)
                        })
                    }
                    else
                    {
                        self.arrGnomesFilter = arrGnomes.filter({ (gnome) -> Bool in
                            gnome.professions.contains(profession)
                        })
                    }
                    flag = true
                }
                else if key == "age"
                {
                    let age = value as! Int
                    if flag
                    {
                        self.arrGnomesFilter = arrGnomesFilter.filter({ (gnome) -> Bool in
                            gnome.age <= age
                        })
                    }
                    else
                    {
                        self.arrGnomesFilter = arrGnomes.filter({ (gnome) -> Bool in
                            gnome.age <= age
                        })
                    }
                    flag = true
                }
                
                else if key == "weight"
                {
                    let weight = value as! Float
                    if flag
                    {
                        self.arrGnomesFilter = arrGnomesFilter.filter({ (gnome) -> Bool in
                            gnome.weight <= Double(weight)
                        })
                    }
                    else
                    {
                        self.arrGnomesFilter = arrGnomes.filter({ (gnome) -> Bool in
                            gnome.weight <= Double(weight)
                        })
                    }
                    flag = true
                }
                else if key == "height"
                {
                    let height = value as! Float
                    if flag
                    {
                        self.arrGnomesFilter = arrGnomesFilter.filter({ (gnome) -> Bool in
                            gnome.height <= Double(height)
                        })
                    }
                    else
                    {
                        self.arrGnomesFilter = arrGnomes.filter({ (gnome) -> Bool in
                            gnome.height <= Double(height)
                        })
                    }
                    flag = true
                }
            }
        }
        if arrGnomesFilter.count == 0
        {
            self.showAlertMessage(titleStr: "Gnomes", messageStr: "Nobody is perfect, try again 🤬")
        }
        else
        {
            collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
            disappearFilter()
            showDataFilter()
        }
    }
    
    
    func cleanData(data:[String:Any])
    {
        if let info = data["Brastlewark"] as? [[String:Any]]
        {
            if info.count != 0
            {
                api.shared.cleanGnomes(data: info) { (gnomes) in
                    DispatchQueue.main.async {
                        self.arrGnomes = gnomes
                        self.downloadImages()
                        self.collectionView.reloadData()
                        self.initValuesFilter()
                    }
                }
            }
            else
            {
                self.showAlertMessage(titleStr: "Gnomes", messageStr: "The town is abandoned 😱")
            }
        }
    }
    
    func initValuesFilter()
    {
        let age = self.arrGnomes.map { $0.age }
        //let reduce = profession.reduce([], +)
        self.filterView.minimumValueAge = Double(age.min()!)
        self.filterView.maximumValueAge = Double(age.max()!)
        
        let height = self.arrGnomes.map { $0.height }
        //let reduce = profession.reduce([], +)
        self.filterView.minimumValueHeight = height.min()!
        self.filterView.maximumValueHeight = height.max()!
        
        let weight = self.arrGnomes.map { $0.weight }
        //let reduce = profession.reduce([], +)
        self.filterView.minimumValueWeight = weight.min()!
        self.filterView.maximumValueWeight = weight.max()!
        //                    let unique = Array(Set(profession))
        //                    print(unique)
        
        let professions = self.arrGnomes.map { $0.professions }
        let reduceProfession = professions.reduce([], +)
        self.filterView.optionsProfessions = reduceProfession
        
        let hairColor = self.arrGnomes.map( {$0.hairColor })
        let reduceHair = Array(Set(hairColor))
        self.filterView.optionsHairColor = reduceHair
    }
    
    func downloadImages()
    {
        let images = self.arrGnomes.map( {$0.thumbnail} )
        let reduceImages = Array(Set(images))
        if reduceImages.count != 0
        {
            for urlImage in reduceImages
            {
                dispatchGroup.enter()
                let imageDownloaded = UIImage()
                imageDownloaded.downloaded(from: urlImage) { (image, urlImage2) in
                    DispatchQueue.main.async {
                        self.arrImages[urlImage2] = image
                        self.dispatchGroup.leave()
                    }
                }
            }
            dispatchGroup.notify(queue: .main) {
                self.collectionView.reloadData()
            }
        }
    }
    
    @IBAction func showFilter(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected
        {
            appearsFilter()
        }
        else
        {
            disappearFilter()
        }
    }
    
    func appearsFilter()
    {
        collectionView.isUserInteractionEnabled = false
        //filterView.isHidden = false
        filterView.isUserInteractionEnabled = true
        searchBar.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        searchBar.isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.5) {
            self.collectionView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
            self.filterView.alpha = 1
        }
    }
    
    func disappearFilter()
    {
        //filterButton.isSelected = true
        collectionView.isUserInteractionEnabled = true
        //filterView.isHidden = true
        filterView.isUserInteractionEnabled = false
        searchBar.backgroundColor = UIColor.black.withAlphaComponent(0)
        searchBar.isUserInteractionEnabled = true
        UIView.animate(withDuration: 0.5) {
            self.collectionView.backgroundColor = UIColor.black.withAlphaComponent(0)
            self.filterView.alpha = 0
        }
    }
    
    func showDataFilter()
    {
        filterButton.isSelected = false
        enableFilter = true
        if let layout = self.collectionView.collectionViewLayout as? customLayout {
            layout.reloadData()
        }
        
        collectionView.collectionViewLayout.invalidateLayout()
        collectionView.reloadData()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if enableFilter
        {
            if searchActive
            {
                return arrGnomesFilterSearchbar.count
            }
            else
            {
                return arrGnomesFilter.count
            }
        }
        else
        {
            if searchActive
            {
                return arrGnomesFilterSearchbar.count
            }
            else
            {
                return arrGnomes.count
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifier = "Cell"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! gnomeCollectionViewCell
        cell.addShadowToCard(color: .black)
        if enableFilter
        {
            if searchActive
            {
                if arrGnomesFilterSearchbar.count != 0
                {
                    if arrImages.count != 0
                    {
                        if let image = arrImages[arrGnomesFilterSearchbar[indexPath.row].thumbnail]
                        {
                            cell.gnomeImage.image = image
                        }
                    }
                    cell.gnomeName.text = arrGnomesFilterSearchbar[indexPath.row].name
                }
            }
            else
            {
                if arrImages.count != 0
                {
                    if let image = arrImages[arrGnomesFilter[indexPath.row].thumbnail]
                    {
                        cell.gnomeImage.image = image
                    }
                }
                cell.gnomeName.text = arrGnomesFilter[indexPath.row].name
            }
        }
        else
        {
            if searchActive
            {
                if arrImages.count != 0
                {
                    if let image = arrImages[arrGnomesFilterSearchbar[indexPath.row].thumbnail]
                    {
                        cell.gnomeImage.image = image
                    }
                }
                cell.gnomeName.text = arrGnomesFilterSearchbar[indexPath.row].name
            }
            else
            {
                if arrImages.count != 0
                {
                    if let image = arrImages[arrGnomes[indexPath.row].thumbnail]
                    {
                        cell.gnomeImage.image = image
                    }
                }
                cell.gnomeName.text = arrGnomes[indexPath.row].name
            }
        }
        cell.gnomeImage.hero.id = "image\(indexPath.row)"
        cell.hero.id = "Cell\(indexPath.row)"
        cell.gnomeName.hero.id = "name\(indexPath.row)"
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let VC1 = self.storyboard!.instantiateViewController(withIdentifier: "gnomeInfo") as! infoGnomeViewController
        if enableFilter
        {
            if searchActive
            {
                if arrGnomesFilterSearchbar.count != 0
                {
                    if arrImages.count != 0
                    {
                        if let image = arrImages[arrGnomesFilterSearchbar[indexPath.row].thumbnail]
                        {
                            VC1.imageGnome = image
                        }
                    }
                    VC1.infoGnome = arrGnomesFilterSearchbar[indexPath.row]
                }
            }
            else
            {
                if arrImages.count != 0
                {
                    if let image = arrImages[arrGnomesFilter[indexPath.row].thumbnail]
                    {
                        VC1.imageGnome = image
                    }
                }
                VC1.infoGnome = arrGnomesFilter[indexPath.row]
            }
            
        }
        else
        {
            if searchActive
            {
                if arrImages.count != 0
                {
                    if let image = arrImages[arrGnomesFilterSearchbar[indexPath.row].thumbnail]
                    {
                        VC1.imageGnome = image
                    }
                }
                VC1.infoGnome = arrGnomesFilterSearchbar[indexPath.row]
            }
            else
            {
                if arrImages.count != 0
                {
                    if let image = arrImages[arrGnomes[indexPath.row].thumbnail]
                    {
                        VC1.imageGnome = image
                    }
                }
                VC1.infoGnome = arrGnomes[indexPath.row]
            }
        }
        
        VC1.hero.isEnabled = true
        VC1.view.hero.id = "Cell\(indexPath.row)"
        VC1.profileImage.hero.id = "image\(indexPath.row)"
        VC1.nameLabel.hero.id = "name\(indexPath.row)"
        self.navigationController?.hero.modalAnimationType = .auto
        self.navigationController?.pushViewController(VC1, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, targetContentOffsetForProposedContentOffset proposedContentOffset: CGPoint) -> CGPoint {
        return CGPoint(x: 0, y: -30)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.collectionViewLayout.invalidateLayout()
    }

    
    // functions search bar
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false
        self.view.endEditing(true)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
        collectionView.reloadData()
        self.view.endEditing(true)
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
        self.view.endEditing(true)
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if enableFilter
        {
            arrGnomesFilterSearchbar = arrGnomesFilter.filter({ (flinkerFiltered) -> Bool in
                return (flinkerFiltered.name.lowercased().contains(searchText.lowercased()))
            })
        }
        else
        {
            arrGnomesFilterSearchbar = arrGnomes.filter({ (flinkerFiltered) -> Bool in
                return (flinkerFiltered.name.lowercased().contains(searchText.lowercased()))
            })
        }
        print(arrGnomesFilterSearchbar.count)
        if(arrGnomesFilterSearchbar.count == 0){
            searchActive = false;
        } else {
            searchActive = true;
        }
        self.collectionView.reloadData()
    }
}

extension ViewController: customLayoutDelegate
{
    func collectionView(
        _ collectionView: UICollectionView,
        heightForPhotoAtIndexPath indexPath:IndexPath) -> CGFloat {
        return 260.0
    }
}
