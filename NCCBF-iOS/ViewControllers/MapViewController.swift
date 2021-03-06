//
//  MapViewController.swift
//  NCCBF-iOS
//
//  Created by Keita Ito on 4/1/17.
//  Copyright © 2017 Keita Ito. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class MapViewController: UIViewController, MKMapViewDelegate, NSFetchedResultsControllerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    var context: NSManagedObjectContext?
    var fetchedResultsController: NSFetchedResultsController<Event>?
    
    let reuseIdentifier = "resueIdentifier"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeFetchedResultsController()
        do {
            try fetchedResultsController?.performFetch()
        } catch {
            print(error)
        }
        
        guard let sections = fetchedResultsController?.sections else { return }
        mapView.addAnnotations(EventLocationAnnotationFactory.createAnnotations(with: sections))
        
        setupUI()
        setupMapView()
        goToDefaultLocation()
    }
    
    // MARK: - MKMapViewDelegate
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier) else {
            let pinAnnotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
            let rightButton = UIButton(type: .detailDisclosure)
            rightButton.tintColor = .sakuraPink
            pinAnnotationView.rightCalloutAccessoryView = rightButton
            
            pinAnnotationView.canShowCallout = true
            pinAnnotationView.animatesDrop = true
            pinAnnotationView.pinTintColor = .sakuraPink
            
            return pinAnnotationView
        }
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let annotation = view.annotation as? EventLocationAnnotation else { return }
        showTableView(with: annotation)
    }
    
    // MARK: - Action Methods
    
    private func showTableView(with annotation: EventLocationAnnotation) {
        let eventListVC = EventListViewController(events: annotation.events, tableViewStyle: .grouped)
        eventListVC.title = annotation.title
        navigationController?.pushViewController(eventListVC, animated: true)
    }
    
    // MARK: - Private Methods
    
    private func initializeFetchedResultsController() {
        guard let context = context else { return }
        let request: NSFetchRequest<Event> = Event.fetchRequest()
        let idSort = NSSortDescriptor(key: "location", ascending: true)
        request.sortDescriptors = [idSort]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: "location", cacheName: nil)
        fetchedResultsController?.delegate = self
    }
    
    private func setupUI() {
        title = "Map"
    }
    private func setupMapView() {
        mapView.delegate = self
    }
    
    private func goToDefaultLocation() {
        mapView.setRegion(MKCoordinateRegion(center: defaultLocationCoordinate, span: MKCoordinateSpan(latitudeDelta: 0.008  , longitudeDelta: 0.008)), animated: true)
    }
}
