//
//  WeatherViewController.swift
//  Appsanthu
//
//  Created by ĐINH HUY PHU on 30/07/2021.
//

import UIKit
import CoreLocation
class WeatherViewController: UIViewController , CLLocationManagerDelegate {
    
    @IBOutlet weak var collectionViewWeather:UICollectionView!
    
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblCurrentTemputure: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var lblSeason: UILabel!
    @IBOutlet weak var Back: UIButton!
    
    
    var currently = TodayModel()
    var daily = [DailyModel]()
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var timezone = ""
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(refresh), name: Notification.Name("setup"), object: nil)
        collectionViewWeather.dataSource = self
        collectionViewWeather.delegate = self
        collectionViewWeather.register(UINib(nibName: "WeatherCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "WeatherCollectionViewCell")
    }
    
    @objc func refresh(){
        collectionViewWeather.reloadData()
        requestWeatherForLocation()
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupLocation()
    }
    func setupLocation() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    var city = ""
    var country = ""
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if !locations.isEmpty, currentLocation == nil  {
            currentLocation = locations.first
            locationManager.stopUpdatingLocation()
            requestWeatherForLocation()
        }
        fetchCityAndCountry(from: currentLocation!) { city, country, error in
            guard let city = city, let country = country, error == nil else { return }
            self.city = city
            self.country = country
            self.lblLocation.text! = self.getHour(Date(timeIntervalSince1970: TimeInterval(self.currently.time))).format() + ", " + self.city + ", " + self.country
        }
    }
    func fetchCityAndCountry(from location: CLLocation, completion: @escaping (_ city: String?, _ country:  String?, _ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            completion(placemarks?.first?.locality,
                       placemarks?.first?.country,
                       error)
        }
    }
    func requestWeatherForLocation() {
        
        guard let currentLocation = currentLocation else {
            return
        }
        let lng = currentLocation.coordinate.longitude
        let lat = currentLocation.coordinate.latitude
        APIService.shared.GetFullAPI(lat.description, lng.description) { (current, listDay, timezone, error) in
            if let temp = current as? TodayModel {self.currently = temp}
            if let temp = timezone as? String {self.timezone = temp}
            if let temp = listDay as? [DailyModel] {
                self.daily = temp
                self.daily.remove(at: 0)
                self.lblCurrentTemputure.text = Int(self.currently.temperature.formatUnit()).description + "°C"
                self.lblDate.text = self.getDate(Date(timeIntervalSince1970: TimeInterval(self.currently.time)))
                self.lblLocation.text = self.getHour(Date(timeIntervalSince1970: TimeInterval(self.currently.time))).format() + ", " + self.city + ", " + self.country
                if let image = UIImage(named: self.currently.icon) { self.imgIcon.image = image}
                self.lblSeason.text = self.currently.icon.replacingOccurrences(of: "-", with: " ")
                self.collectionViewWeather.reloadData()
            }
        }
    }
    func getDayOfDate(_ date: Date?) -> String{
        guard let inputDate = date else {
            return ""
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        return formatter.string(from: inputDate)
    }
    func getDate(_ date: Date?) -> String{
        guard let inputDate = date else {
            return ""
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, d MMM YYYY"
        return formatter.string(from: inputDate)
    }
    func getHour(_ date: Date?) -> String{
        guard let inputDate = date else {
            return ""
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: inputDate)
    }
    
    @IBAction func Backmain(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
extension WeatherViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WeatherCollectionViewCell.className, for: indexPath) as! WeatherCollectionViewCell
        if daily.count > indexPath.row{
            let item = daily[indexPath.row]
            let avg = (item.temperatureLow + item.temperatureHigh) / 2.0
            var day = getDayOfDate(Date(timeIntervalSince1970: Double(item.time)))
            day = day.uppercased()
            cell.lblT.text = String(Array(day)[0])
            cell.lblU.text = String(Array(day)[1])
            cell.lblE.text = String(Array(day)[2])
            cell.lblTempurature.text = Int(avg.formatUnit()).description + "°C"
            cell.lblName.text = item.icon.replacingOccurrences(of: "-", with: " ")
            if let image = UIImage(named: item.icon){ cell.imgIcon.image = image}
        }
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        
        return UICollectionReusableView()
    }
    
}
extension WeatherViewController: UICollectionViewDelegateFlowLayout {
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





