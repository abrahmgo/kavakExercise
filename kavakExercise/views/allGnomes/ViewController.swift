//
//  ViewController.swift
//  kavakExercise
//
//  Created by Andrés Abraham Bonilla Gómez on 12/2/19.
//  Copyright © 2019 Andrés Abraham Bonilla Gómez. All rights reserved.
//

import UIKit
import Hero

class ViewController: UIViewController,  UICollectionViewDataSource, UICollectionViewDelegate, dataFiler {
    
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet weak var filterView: filter!
    @IBOutlet var filterButton: UIButton!
    @IBOutlet var searchBar: UISearchBar!
    
    private var arrGnomes = [gnome]()
    private var arrGnomesFilter = [gnome]()
    private var enableFilter = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }

    func initView()
    {
        self.navigationController?.navigationBar.isTranslucent = false
        navigationItem.title = "Citizens"
        filterButton.backgroundColor = .lightGray
        filterView.delegate = self
        filterView.alpha = 0
        collectionView.delegate = self
        collectionView.dataSource = self
        if let layout = collectionView?.collectionViewLayout as? customLayout {
            layout.delegate = self
        }
        api.shared.downloadData { (status, info) in
            if status != 200
            {
                print("algo salio mal")
            }
            else
            {
                self.cleanData(data: info)
            }
        }
    }
    
    func infoFilter(_ data: [String : Any]) {
        cleanFilterData(data: data)
    }
    
    func defaultFilter(_ flag: Bool) {
        print(flag)
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
            self.showAlertMessage(titleStr: "Gnomes", messageStr: "Without results")
        }
        else
        {
            collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
            print(arrGnomesFilter.count)
            disappearFilter()
            showDataFilter()
        }
    }
    
    
    func cleanData(data:[String:Any])
    {
        if let info = data["Brastlewark"] as? [[String:Any]]
        {
            api.shared.cleanGnomes(data: info) { (gnomes) in
                DispatchQueue.main.async {
                    self.arrGnomes = gnomes
                    print(self.arrGnomes.count)
                    self.collectionView.reloadData()
                    self.initValuesFilter()
                }
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
                return arrGnomesFilter.count
            }
            else
            {
                return arrGnomes.count
            }
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let identifier = "Cell"
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! gnomeCollectionViewCell
            cell.addShadowToCard(color: .black)
            if enableFilter
            {
                cell.gnomeName.text = arrGnomesFilter[indexPath.row].name
            }
            else
            {
                cell.gnomeName.text = arrGnomes[indexPath.row].name
            }
            return cell
        }
        
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            let VC1 = self.storyboard!.instantiateViewController(withIdentifier: "gnomeInfo") as! infoGnomeViewController
            if enableFilter
            {
                VC1.infoGnome = arrGnomesFilter[indexPath.row]
            }
            else
            {
                VC1.infoGnome = arrGnomes[indexPath.row]
            }
//            VC1.dataFavorite = arrFavoriteBanks[indexPath.row]
//            VC1.flagUse = 2
            VC1.hero.isEnabled = true
            VC1.view.hero.id = "Cell\(indexPath.row)"
            self.navigationController?.pushViewController(VC1, animated: true)
    //        self.navigationController?.popViewController(animated: true)
        }
        
        func collectionView(_ collectionView: UICollectionView, targetContentOffsetForProposedContentOffset proposedContentOffset: CGPoint) -> CGPoint {
            return CGPoint(x: 0, y: -30)
        }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.collectionViewLayout.invalidateLayout()
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
