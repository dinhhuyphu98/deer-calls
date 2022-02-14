//
//  MapViewController.swift
//  Appsanthu
//
//  Created by ĐINH HUY PHU on 04/08/2021.
//

import UIKit
import MapKit
import CoreLocation
enum IsPushedBy{
    case byLogVC
    case byCurrentLoctionOnLogVC
    case byLocationOnMap
}
class MapViewController: UIViewController, CLLocationManagerDelegate{
    var locationManager = CLLocationManager()
    var isPushedBy: IsPushedBy = .byLocationOnMap
    var item: LogModel!
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var txfView: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txfView.addTarget(self, action: #selector(textViewDidChanged(_:)), for: .editingChanged)
        txfView.font = txfView.font?.withSize(16 * scale)
    }
    @objc func textViewDidChanged(_ textfield: UITextField){
        let name = textfield.text
        APIService.shared.GetLocation(name!) { (data, error) in
            if let data = data as? LocationModel{
                let annotation = MKPointAnnotation()
                annotation.coordinate = CLLocationCoordinate2D(latitude: Double(data.lat) ?? 0, longitude: Double(data.lng) ?? 0)
                self.mapView.addAnnotation(annotation)
                let region = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
                self.mapView.setRegion(region, animated: true)
            }
        }
    }
    @IBAction func Back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        switch isPushedBy {
        case .byLogVC:
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: item.latitue, longitude: item.longtitue)
            mapView.addAnnotation(annotation)
            let region = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
            mapView.setRegion(region, animated: true)
        case .byCurrentLoctionOnLogVC:
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        case .byLocationOnMap:
            let singleTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapMap( _:)))
            singleTap.numberOfTapsRequired = 1
            singleTap.numberOfTouchesRequired = 1
            mapView.addGestureRecognizer(singleTap)
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        let annotation = MKPointAnnotation()
        annotation.coordinate = locValue
        if isPushedBy == .byLocationOnMap{
            
        } else{
            mapView.addAnnotation(annotation)
        }
        let region = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
        mapView.setRegion(region, animated: true)
    }
    @objc func didSelectBtnBack(_ sender: UIButton){
        dismiss(animated: true, completion: nil)
    }
    @objc func didTapMap(_ sender: UITapGestureRecognizer) {
        let tapPoint: CGPoint = sender.location(in: mapView)
        let touchMapCoordinate: CLLocationCoordinate2D = mapView.convert(tapPoint, toCoordinateFrom: mapView)
        
        if mapView.annotations.count != 0 {
            mapView.removeAnnotations(mapView.annotations)
        }
        let annotation = MKPointAnnotation()
        annotation.coordinate = touchMapCoordinate
        mapView.addAnnotation(annotation)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "SaveActivityLogViewController") as! SaveActivityLogViewController
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .fullScreen
            vc.item = LogModel(longtitue: annotation.coordinate.longitude, latitue: annotation.coordinate.latitude)
            vc.isLocationOnMap = true
            self.present(vc, animated: true, completion: nil)
            DispatchQueue.main.async {
                vc.onComplete = {[weak self] in
                    self?.dismiss(animated: true, completion: nil)
                }
            }
        })
    }
}
extension MapViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        textField.endEditing(true)
        return true
    }
}
