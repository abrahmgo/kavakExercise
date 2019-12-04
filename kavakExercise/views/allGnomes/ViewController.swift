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
    private var arrGnomes = [gnome]()
    private var arrGnomesFilter = [gnome]()

    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }

    func initView()
    {
        filterView.delegate = self
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
            }
        }
        else
        {
            
        }
        print(arrGnomesFilter.count)
    }
    
    func cleanData(data:[String:Any])
    {
        if let info = data["Brastlewark"] as? [[String:Any]]
        {
            api.shared.cleanGnomes(data: info) { (gnomes) in
                DispatchQueue.main.async {
                    self.arrGnomes = gnomes
                    self.collectionView.reloadData()
                    self.initValuesFilter()
                }
            }
        }
    }
    
    func initValuesFilter()
    {
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
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return arrGnomes.count
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let identifier = "Cell"
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! gnomeCollectionViewCell
            cell.addShadowToCard(color: .black)
            cell.gnomeName.text = arrGnomes[indexPath.row].name
            return cell
        }
        
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            let VC1 = self.storyboard!.instantiateViewController(withIdentifier: "gnomeInfo") as! infoGnomeViewController
            VC1.infoGnome = arrGnomes[indexPath.row]
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

}

extension ViewController: customLayoutDelegate
{
    func collectionView(
        _ collectionView: UICollectionView,
        heightForPhotoAtIndexPath indexPath:IndexPath) -> CGFloat {
        return 260.0
    }
}
