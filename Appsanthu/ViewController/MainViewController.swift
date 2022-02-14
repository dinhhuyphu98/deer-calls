//
//  MainViewController.swift
//  Appsanthu
//
//  Created by devsenior on 05/07/2021.
//

import UIKit
import CarLensCollectionViewLayout

extension NSObject {
    func background(delay: Double = 0.0, background: (()->Void)? = nil, completion: (() -> Void)? = nil) {
        DispatchQueue.global(qos: .background).async {
            background?()
            if let completion = completion {
                DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
                    completion()
                })
            }
        }
    }
    var className: String {
        return String(describing: type(of: self))
    }
    class var className: String {
        return String(describing: self)
    }
}
//https://raw.githubusercontent.com/dinhhuyphu98/github-slideshow/dinhhuyphu98-patch-1/animal.json
class MainViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {
    @IBOutlet weak var collectionViewMain:UICollectionView!
    let listCategory = ["Hunting Calls", "Solunar Times", "Weather", "Activity Log"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionViewMain.register(HomeMenuCLVCell.self, forCellWithReuseIdentifier: HomeMenuCLVCell.identifier)
        collectionViewMain.showsHorizontalScrollIndicator = false
        collectionViewMain.collectionViewLayout = CarLensCollectionViewLayout()
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "HuntingCallsViewController") as! HuntingCallsViewController
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        }
        if indexPath.row == 1{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "SulonartimesViewController") as! SulonartimesViewController
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        }
        if indexPath.row == 2{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "WeatherViewController") as! WeatherViewController
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        }
        if indexPath.row == 3{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ActivityLogViewController") as! ActivityLogViewController
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeMenuCLVCell.identifier, for: indexPath) as? HomeMenuCLVCell else {
            return UICollectionViewCell()
        }
        cell.labelName.text = listCategory[indexPath.row]
        cell.labelName.textColor = #colorLiteral(red: 0.03921568627, green: 0.5019607843, blue: 0.6509803922, alpha: 1)
        cell.imageCover.image = UIImage.init(named: "main" + String(indexPath.row + 1))

        return cell
    }
}


