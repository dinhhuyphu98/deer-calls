//
//  SaveActivityLogViewController.swift
//  Appsanthu
//
//  Created by ĐINH HUY PHU on 04/08/2021.
//

import UIKit
import CoreLocation
import Photos
enum Section: Int {
    case location = 0
    case photo = 1
    case note = 2
}
class SaveActivityLogViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var tableView:UITableView!
    var item = LogModel()
    var isCurrentLocation = false
    var isLocationOnMap = false
    var imagePicker = UIImagePickerController()
    var vSpinner: UIView!
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var onComplete: (()-> Void)?
    @IBOutlet weak var btnDone: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "LocationCell", bundle: nil), forCellReuseIdentifier: "LocationCell")
//        tableView.register(UINib(nibName: "TimeCell", bundle: nil), forCellReuseIdentifier: "TimeCell")
//        tableView.register(UINib(nibName: "SolunarWeatherCell", bundle: nil), forCellReuseIdentifier: "SolunarWeatherCell")
        tableView.register(UINib(nibName: "PhotoCell", bundle: nil), forCellReuseIdentifier: "PhotoCell")
//        tableView.register(UINib(nibName: "CallsUsedCell", bundle: nil), forCellReuseIdentifier: "CallsUsedCell")
//        tableView.register(UINib(nibName: "PlaylistLogCell", bundle: nil), forCellReuseIdentifier: "PlaylistLogCell")
        tableView.register(UINib(nibName: "NoteCell", bundle: nil), forCellReuseIdentifier: "NoteCell")

        // Do any additional setup after loading the view.
    }
    @objc func didSelectBtnBack(_ sender: UIButton){
        dismiss(animated: true, completion: nil)
        NotificationCenter.default.post(name: Notification.Name("stopAudio"), object: nil)
        if isLocationOnMap{
            onComplete?()
        }
    }
        @IBAction func didSelectBtnDone(_ sender: Any) {
        JsonService.shared.writeOjectToJson(item: item)
        dismiss(animated: true, completion: nil)
        NotificationCenter.default.post(name: Notification.Name("stopAudio"), object: nil)
        if isLocationOnMap{
            onComplete?()
            print("OK")
        }
    }
    func setupLocation() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    @IBAction func Back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    var currently: TodayModel!
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if !locations.isEmpty, currentLocation == nil  {
            currentLocation = locations.first
            locationManager.stopUpdatingLocation()
            guard let currentLocation = currentLocation else {
                return
            }
        }
    }
    func getDateForAPI(_ date: Date?) -> String{
        guard let inputDate = date else {
            return ""
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYYMMdd"
        return formatter.string(from: inputDate)
    }
    func getTimeZone() -> String{
        var localTimeZoneAbbreviation: String { return TimeZone.current.abbreviation() ?? "" }
        let strs = localTimeZoneAbbreviation.split(separator: "+")
        if strs.count == 2{
            return String(strs[1])
        }
        let str2s = localTimeZoneAbbreviation.split(separator: "-")
        if str2s.count == 2 {
            return "-" + str2s[1]
        }
        return ""
    }
    func getDayOfDate(_ date: Date?) -> String{
        guard let inputDate = date else {
            return ""
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, d MMM YYYY"
        return formatter.string(from: inputDate)
    }
    func getHourOfDate(_ date: Date?) -> String{
        guard let inputDate = date else {
            return ""
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm:ss a"
        return formatter.string(from: inputDate)
    }
}
extension SaveActivityLogViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = Section(rawValue: indexPath.section) else {
            return UITableViewCell()
        }
        switch section {
        
        case .location:
            let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell") as! LocationCell
            cell.delegate = self
            if isCurrentLocation{
                cell.getCurrentLoction()
            } else{
                cell.setup(item)
            }
            return cell
        case .photo:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoCell") as! PhotoCell
            cell.listImage = item.listImage
            cell.delegate = self
            cell.btnAdd.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didSelectViewAdd(_:))))
            return cell
        case .note:
            let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCell") as! NoteCell
            cell.delegate = self
            cell.setup(item)
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let section = Section(rawValue: indexPath.section) else {
            return 0
        }
        switch section {
        case .location:
            return 300 * scale
        case .photo:
            return 190 * scale
        case .note:
            return 227 * scale
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let section = Section(rawValue: indexPath.section) else {
            return
        }
        switch section {
        case .location:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
            vc.modalPresentationStyle = .fullScreen
            vc.isPushedBy = isCurrentLocation ? .byCurrentLoctionOnLogVC : .byLogVC
            vc.item = item
            self.present(vc, animated: true, completion: nil)
            break
        case .photo:
            break
        case .note:
            break
        }
    }
    
}
extension SaveActivityLogViewController: PhotoCellDelegate{
    func didDelete(_ cell: PhotoCell) {
        self.item.listImage = cell.listImage
    }
}
extension SaveActivityLogViewController: NoteCellDelegate{
    func didEndEditing(text: String) {
        item.note = text
    }
}
extension SaveActivityLogViewController: LocationCellDelegate{
    func didGetCurrentLocation(latitute: Double, longtitute: Double) {
        item.latitue = latitute
        item.longtitue = longtitute
    }
}
extension SaveActivityLogViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    @objc func didSelectViewAdd(_ sender: UITapGestureRecognizer){
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let imageURL = info[UIImagePickerController.InfoKey.imageURL] as? URL {
            guard let cell = tableView.cellForRow(at: IndexPath(row: 0, section: Section.photo.rawValue)) as? PhotoCell else{return}
            let url = copyImage(imageURL)
            cell.addNewPhoto(url)
            self.item.listImage = cell.listImage
        }
        picker.dismiss(animated: true, completion: nil)
    }
    func copyImage(_ url: URL) -> URL {
        var newURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        newURL.appendPathComponent(url.lastPathComponent)
        do {
            try FileManager.default.copyItem(atPath: url.path, toPath: newURL.path)
        } catch{
            
        }
        return newURL
    }
}
