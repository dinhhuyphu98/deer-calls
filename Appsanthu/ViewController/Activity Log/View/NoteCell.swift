//
//  NoteCell.swift
//  Appsanthu
//
//  Created by ĐINH HUY PHU on 04/08/2021.
//

import UIKit

class NoteCell: UITableViewCell, UITextViewDelegate {

    @IBOutlet weak var txtView: UITextView!
    var delegate: NoteCellDelegate!
    override func awakeFromNib() {
        super.awakeFromNib()
        txtView.delegate = self
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        delegate?.didEndEditing(text: textView.text)
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            txtView.resignFirstResponder()
            return false
        }
        return true
    }
    func setup(_ item: LogModel){
        txtView.text = item.note
    }
}
protocol NoteCellDelegate: class {
    func didEndEditing(text: String)
}
extension NoteCell {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        txtView.endEditing(true)
        return true
    }
}

