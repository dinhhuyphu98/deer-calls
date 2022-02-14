//
//  HungtingplaylistsViewController.swift
//  Appsanthu
//
//  Created by devsenior on 07/07/2021.
//

import UIKit

class HungtingplaylistsViewController: UIViewController {
    @IBOutlet weak var collectionViewList:UICollectionView!
    
    var listData:[MSoundModel] = [MSoundModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionViewList.register(UINib(nibName: HungtingplaylistsCLVCell.className, bundle: nil), forCellWithReuseIdentifier: HungtingplaylistsCLVCell.className)

        // Do any additional setup after loading the view.
    }
    
    @IBAction func Backbtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    

}
extension HungtingplaylistsViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listData.count
    }
     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HungtingplaylistsCLVCell.className, for: indexPath) as! HungtingplaylistsCLVCell
        
        cell.Name.text =   listData[indexPath.row].name
        let fileName = "https://github.com/dinhhuyphu98/Nhac/raw/main/" + listData[indexPath.row].soundFile.sha1() + ".mp3"
        cell.LinkPlay = fileName
        cell.Timelist.text = listData[indexPath.row].timeLength.format("00.00") + " sec"
        cell.labelOverallDuration.text = listData[indexPath.row].timeLength.format("00.00")
        
        
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        
        return UICollectionReusableView()
    }
}

extension HungtingplaylistsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if UIDevice.current.userInterfaceIdiom == .pad{
            return CGSize(width: UIScreen.main.bounds.width, height: 150)
        }
        return CGSize(width: UIScreen.main.bounds.width, height: 150)
    }
}
