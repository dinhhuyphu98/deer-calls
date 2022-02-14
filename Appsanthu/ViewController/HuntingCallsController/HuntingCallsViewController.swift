//
//  HuntingCallsViewController.swift
//  Appsanthu
//
//  Created by devsenior on 07/07/2021.
//

import UIKit

class HuntingCallsViewController: UIViewController {
    @IBOutlet weak var collectionViewMain:UICollectionView!
    
    var listData:[AnimalModel] = [AnimalModel]()
    
    func getHomeNimeManga(andCompletion completion:@escaping (_ moviesResponse: [AnimalModel], _ error: Error?) -> ()) {
        APIService.shared.GetMangaAll() { (response, error) in
            if let listData = response{
                for item in listData{
                    if item.image.count > 0{
                        self.listData.append(item)
                    }
                }
                DispatchQueue.main.async {
                    self.collectionViewMain.reloadData()
                }
            }
            completion(self.listData, error)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionViewMain.register(UINib(nibName: HuntingCallsCollectionViewCell.className, bundle: nil), forCellWithReuseIdentifier: HuntingCallsCollectionViewCell.className)
        self.getHomeNimeManga(){_,_ in
            self.listData.remove(at: 0)
        }
    }
    
    
    @IBAction func Backmain(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func Nextplaylists(_ sender: UIButton) {
//                let vc = self.storyboard?.instantiateViewController(withIdentifier: "HungtingplaylistsViewController") as! HungtingplaylistsViewController
//                vc.modalPresentationStyle = .fullScreen
//                self.present(vc, animated: true, completion: nil)
    }
    
}
//UICollectionViewDataSource
extension HuntingCallsViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "HungtingplaylistsViewController") as! HungtingplaylistsViewController
        vc.listData = listData[indexPath.row].mSound
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HuntingCallsCollectionViewCell.className, for: indexPath) as! HuntingCallsCollectionViewCell
        cell.NameHuningCalls.text =  listData[indexPath.row].animalName
        cell.desHuntingCalls.text =  listData[indexPath.row].Description
        cell.ImageHuntingCalls.image = UIImage.init(named: listData[indexPath.row].image)
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        
        return UICollectionReusableView()
    }
    
}

extension HuntingCallsViewController: UICollectionViewDelegateFlowLayout {
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
            return CGSize(width: UIScreen.main.bounds.width, height: 100)
        }
        return CGSize(width: UIScreen.main.bounds.width, height: 100)
    }
}

