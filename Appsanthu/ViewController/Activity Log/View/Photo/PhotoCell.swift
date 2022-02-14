//
//  PhotoCell.swift
//  Appsanthu
//
//  Created by ĐINH HUY PHU on 04/08/2021.
//



import UIKit

class PhotoCell: UITableViewCell{
    
    @IBOutlet weak var collectionVIew: UICollectionView!
    var imagePicker = UIImagePickerController()
    @IBOutlet weak var btnAdd: UIButton!
    var listImage: [String] = []
    var delegate: PhotoCellDelegate!
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionVIew.delegate = self
        collectionVIew.dataSource = self
        collectionVIew.register(UINib(nibName: "ImageCell", bundle: nil), forCellWithReuseIdentifier: "ImageCell")
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 90 * scaleW, height: 90 * scale)
        layout.scrollDirection = .horizontal
        collectionVIew.collectionViewLayout = layout
    }
    func addNewPhoto(_ withURL: URL){
        listImage.append(withURL.lastPathComponent)
        collectionVIew.reloadData()
    }
}
extension PhotoCell: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listImage.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! ImageCell
        let documentURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let imageURL = documentURL.appendingPathComponent(listImage[indexPath.row])
        if let image = UIImage(contentsOfFile: imageURL.path){
            cell.imageView.image = image
        }
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(didDelete(_:)))
        longPress.minimumPressDuration = 2
        cell.addGestureRecognizer(longPress)
        return cell
    }
    @objc func didDelete(_ sender: UILongPressGestureRecognizer){
        if let cell = sender.view as? ImageCell {
            if let index = collectionVIew.indexPath(for: cell){
                listImage.remove(at: index.row)
                collectionVIew.reloadData()
                delegate?.didDelete(self)
            }
        }
    }
}

protocol PhotoCellDelegate: class {
    func didDelete(_ cell: PhotoCell)
}

