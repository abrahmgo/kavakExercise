//
//  ViewController.swift
//  kavakExercise
//
//  Created by Andrés Abraham Bonilla Gómez on 12/2/19.
//  Copyright © 2019 Andrés Abraham Bonilla Gómez. All rights reserved.
//

import UIKit

class ViewController: UIViewController,  UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet var collectionView: UICollectionView!
    private var arrGnomes = [gnome]()
    let apiManagement = api(url: "https://raw.githubusercontent.com/rrafols/mobile_test/master/data.json")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }

    func initView()
    {
        collectionView.delegate = self
        collectionView.dataSource = self
        if let layout = collectionView?.collectionViewLayout as? customLayout {
            layout.delegate = self
        }
        apiManagement.downloadData { (status, info) in
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
    
    func cleanData(data:[String:Any])
    {
        if let info = data["Brastlewark"] as? [[String:Any]]
        {
            apiManagement.cleanGnomes(data: info) { (gnomes) in
                DispatchQueue.main.async {
                    self.arrGnomes = gnomes
                    self.collectionView.reloadData()
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return arrGnomes.count
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let identifier = "Cell"
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! gnomeCollectionViewCell
            cell.gnomeName.text = arrGnomes[indexPath.row].name
            return cell
        }
        
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            let VC1 = self.storyboard!.instantiateViewController(withIdentifier: "gnomeInfo") as! infoGnomeViewController
            VC1.infoGnome = arrGnomes[indexPath.row]
//            VC1.dataFavorite = arrFavoriteBanks[indexPath.row]
//            VC1.flagUse = 2
//            VC1.hero.isEnabled = true
//            VC1.view.hero.id = "Cell\(indexPath.row)"
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
