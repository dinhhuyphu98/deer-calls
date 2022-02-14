//
//  SulonartimesViewController.swift
//  Appsanthu
//
//  Created by ĐINH HUY PHU on 19/07/2021.
//

import UIKit
import FSCalendar
class SulonartimesViewController: UIViewController , FSCalendarDelegate {
    @IBOutlet weak var lblDay: UILabel!
    @IBOutlet weak var lblMajor1: UILabel!
    @IBOutlet weak var lblMajor2: UILabel!
    @IBOutlet weak var lblMinor1: UILabel!
    @IBOutlet weak var lblMinor2: UILabel!
    @IBOutlet weak var calenar: FSCalendar!
    @IBOutlet weak var progressBar: UIProgressView!
    var lat = 0.0
    var lng = 0.0
    var timeZone = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(refresh), name: Notification.Name("setup"), object: nil)
        calenar.delegate = self
        lblDay.text = "    " + getDate(calenar.today)
        setup(lat: lat.description, lng: lng.description, day: getDateForAPI(calenar.today), timeZone: timeZone)
    }
    
    @IBAction func Backmain(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func refresh(){
        setup(lat: lat.description, lng: lng.description, day: getDateForAPI(calenar.today), timeZone: timeZone)
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func setup(lat: String, lng: String, day: String, timeZone: String){
        
        APIService.shared.GetSoluarAPI(lat, lng, day, timeZone){ (data, error) in
            if let data = data as? SolunarModel{
                self.lblMajor1.text = data.major1Start.format() + " until " + data.major1Stop.format()
                self.lblMajor2.text = data.major2Start.format() + " until " + data.major2Stop.format()
                self.lblMinor1.text = data.minor1Start.format() + " until " + data.minor1Stop.format()
                self.lblMinor2.text = data.minor2Start.format() + " until " + data.minor2Stop.format()
                self.progressBar.setRating(data.dayRating)
                
            }
        }
    }
    func getDate(_ date: Date?) -> String{
        guard let inputDate = date else {
            return ""
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, d MMM YYYY"
        return formatter.string(from: inputDate)
    }
    func getDateForAPI(_ date: Date?) -> String{
        guard let inputDate = date else {
            return ""
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYYMMdd"
        return formatter.string(from: inputDate)
    }
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        lblDay.text = "    " + getDate(date)
        setup(lat: lat.description, lng: lng.description, day: getDateForAPI(date), timeZone: timeZone)
    }
}
extension UIProgressView{
    func setRating(_ rate: Int){
        switch rate {
        case 0:
            self.setProgress(0.01, animated: true)
            self.progressImage = #imageLiteral(resourceName: "1_progress")
            self.trackImage = #imageLiteral(resourceName: "0")
            break
        case 1:
            self.setProgress(0.2, animated: true)
            self.progressImage = #imageLiteral(resourceName: "1_progress")
            self.trackImage = #imageLiteral(resourceName: "1")
            break
        case 2:
            self.setProgress(0.4, animated: true)
            self.progressImage = #imageLiteral(resourceName: "2_progress")
            self.trackImage = #imageLiteral(resourceName: "0")
            break
        case 3:
            self.setProgress(0.6, animated: true)
            self.progressImage = #imageLiteral(resourceName: "3")
            break
        case 4:
            self.setProgress(0.8, animated: true)
            self.progressImage = #imageLiteral(resourceName: "4")
            break
        case 5:
            self.setProgress(1.0, animated: true)
            self.progressImage = #imageLiteral(resourceName: "5")
            break
        default:
            break
        }
    }
}
