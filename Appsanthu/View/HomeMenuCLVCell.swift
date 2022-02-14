//
//  HomeMenuCLVCell.swift
//  Appsanthu
//
//  Created by devsenior on 06/07/2021.
//

import UIKit
import CarLensCollectionViewLayout

class HomeMenuCLVCell: CarLensCollectionViewCell {
    
    static let identifier = "HomeMenuCLVCell"
    
    var labelName: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 30)
        label.textAlignment = .center
        label.textColor = .white
        label.text = "CarLens"
        return label
    }()
    
    var imageCover: UIImageView = {
        var view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure(topView: labelName, cardView: imageCover)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//        cell.labelName.font = UIFont(name: "RobotoMono-VariableFont_wght.ttf", size: 25)
