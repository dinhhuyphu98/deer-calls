//
//  LocationCell.swift
//  Appsanthu
//
//  Created by ĐINH HUY PHU on 04/08/2021.
//

import UIKit
import MapKit

class LocationCell: UITableViewCell, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    let location =  CLLocation()
    let locationManager = CLLocationManager()
    var item: LogModel!
    var delegate: LocationCellDelegate!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    func getCurrentLoction(){
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    func setup(_ item: LogModel){
        self.item = item
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: item.latitue, longitude: item.longtitue)
        mapView.addAnnotation(annotation)
        let region = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
        mapView.setRegion(region, animated: true)
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        let annotation = MKPointAnnotation()
        delegate?.didGetCurrentLocation(latitute: locValue.latitude, longtitute: locValue.longitude)
        annotation.coordinate = locValue
        mapView.addAnnotation(annotation)
        let region = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
        mapView.setRegion(region, animated: true)
    }
}

protocol LocationCellDelegate: class {
    func didGetCurrentLocation(latitute: Double, longtitute: Double)
}

