//
//  Extension.swift
//  Appsanthu
//
//  Created by ĐINH HUY PHU on 27/07/2021.
//

import Foundation
import AVKit
import CommonCrypto

let scale = UIScreen.main.bounds.height / 896
let scaleW = UIScreen.main.bounds.width / 414

//extension NSObject {
//    var className: String {
//        return String(describing: type(of: self))
//    }
//    class var className: String {
//        return String(describing: self)
//    }
//}
//
//extension UIView {
//    func showToast(message : String) {
//        guard let window = UIApplication.shared.keyWindow else {return}
//        let toastLbl = UILabel()
//        toastLbl.text = message
//        toastLbl.textAlignment = .center
//        toastLbl.font = UIFont.systemFont(ofSize: 18)
//        toastLbl.textColor = UIColor.black
//        toastLbl.backgroundColor = UIColor.white.withAlphaComponent(1.0)
//        toastLbl.numberOfLines = 0
//        let textSize = toastLbl.intrinsicContentSize
//        let labelHeight = ( textSize.width / window.frame.width ) * 30
//        let labelWidth = min(textSize.width, window.frame.width - 40)
//        let adjustedHeight = max(labelHeight, textSize.height + 20)
//
//        toastLbl.frame = CGRect(x: 20, y: (window.frame.height / 2 ) - adjustedHeight, width: labelWidth + 20, height: adjustedHeight)
//        toastLbl.center.x = window.center.x
//        toastLbl.layer.cornerRadius = 10
//        toastLbl.layer.masksToBounds = true
//
//        window.addSubview(toastLbl)
//
//        UIView.animate(withDuration: 4.0, animations: {
//            toastLbl.alpha = 0
//        }) { (_) in
//            toastLbl.removeFromSuperview()
//        }
//    }
//}
//extension UIView {
//    @IBInspectable var cornerRadius: CGFloat {
//        get { return layer.cornerRadius }
//        set {
//            layer.cornerRadius = newValue * scale
//            layer.masksToBounds = newValue > 0
//        }
//    }
//    func dropShadow(){
//        layer.borderWidth = 1 * scale
//        layer.borderColor = #colorLiteral(red: 1, green: 0.9411764706, blue: 0.5960784314, alpha: 1)
//        layer.shadowColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
//        layer.shadowOffset = CGSize(width: 0, height: 0)
//        layer.shadowOpacity = 0.5
//        layer.shadowRadius = 10
//        layer.masksToBounds = false
//    }
//    func undropShadow(){
//        layer.borderWidth = 0
//        layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
//        layer.shadowColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
//        layer.shadowOffset = CGSize(width: 0, height: 0)
//        layer.shadowOpacity = 0
//        layer.shadowRadius = 0
//    }
//}
//extension UIView {
//    func show_Spinner() {
//        let spinnerView = UIView.init(frame: self.bounds)
//        spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
//        let ai = UIActivityIndicatorView.init(style: .whiteLarge)
//        ai.startAnimating()
//        ai.center = spinnerView.center
//
//        DispatchQueue.main.async {
//            spinnerView.addSubview(ai)
//            spinnerView.tag = 100
//            self.addSubview(spinnerView)
//        }
//    }
//    func remove_Spinner() {
//        DispatchQueue.main.async {
//            for view in self.subviews{
//                if view.tag == 100 {
//                    view.removeFromSuperview()
//                }
//            }
//        }
//    }
//}
extension Double {
    func format(_ pattern: String) -> String {
        let formatter = NumberFormatter()
        formatter.positiveFormat = pattern
        return formatter.string(from: NSNumber(value: self))!
    }
    func format() -> String{
        let min = Int(self)/60
        let sec = Int(self) % 60
        let minstr = String(format: "%02d", min)
        let sectr = String(format: "%02d", sec)
        if minstr == "00" && sectr == "00" {
            return "00.01"
        }
        return minstr + ":" + sectr
    }
    
}

extension String {
    func sha1() -> String {
        let string = self + ".mp3a83oiumnx7234nqgf023cjb347hv18yvjhb28poaf89"
        let data = Data(string.utf8)
        var digest = [UInt8](repeating: 0, count:Int(CC_SHA1_DIGEST_LENGTH))
        data.withUnsafeBytes {
            _ = CC_SHA1($0.baseAddress, CC_LONG(data.count), &digest)
        }
        let hexBytes = digest.map { String(format: "%02hhx", $0) }
        return hexBytes.joined()
    }
}


//extension NSLayoutConstraint{
//    @IBInspectable var myConstain: Bool {
//        get { return true }
//        set {
//            let attribute = self.firstAttribute
//            if attribute == .top || attribute == .bottom {
//                self.constant = self.constant * scale
//            } else if attribute == .leading || attribute == .trailing {
//                self.constant = self.constant * scaleW
//            }
//        }
//    }
//}
//extension UILabel{
//    @IBInspectable var myAutoFontSize: Bool{
//        get{ true }
//        set {
//            self.font = self.font.withSize(self.font.pointSize * scale)
//        }
//    }
//}
//extension UITextView{
//    @IBInspectable var myAutoFontSize: Bool{
//        get{ true }
//        set {
//            self.font = self.font?.withSize(self.font!.pointSize * scale)
//        }
//    }
//}
