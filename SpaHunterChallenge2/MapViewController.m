//
//  MapViewController.m
//  SpaHunterChallenge2
//
//  Created by CHRISTINA GUNARTO on 11/15/14.
//  Copyright (c) 2014 Christina Gunarto. All rights reserved.
//

#import "MapViewController.h"
@import MapKit;
@import CoreLocation;
#import "Spa.h"

#define kLatitudeDelta 0.1
#define kLongitudeDelta 0.1

@interface MapViewController () <MKMapViewDelegate, CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property CLLocationManager *manager;
@property MKPointAnnotation *selfAnnotation;



@end

@implementation MapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
    self.manager = [[CLLocationManager alloc]init];
    [self.manager requestWhenInUseAuthorization];
    self.manager.delegate = self;
    [self.manager startUpdatingLocation];

    [super viewDidAppear:YES];
    [self setInitialViewToSelfLocation];
    [self addAnnotationWithSelfAndSpaArray];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    for (CLLocation *location in locations)
    {
        if (location.verticalAccuracy < 1000 && location.horizontalAccuracy < 1000)
        {
            NSLog (@"Location found...");
            [self.manager stopUpdatingLocation];
            break;
        }
    }
}


- (void)setInitialViewToSelfLocation
{
    CLLocationCoordinate2D center = self.manager.location.coordinate;
    MKCoordinateSpan coordinateSpan;
    coordinateSpan.latitudeDelta = kLatitudeDelta;
    coordinateSpan.longitudeDelta = kLongitudeDelta;

    MKCoordinateRegion region = MKCoordinateRegionMake(center, coordinateSpan);
    [self.mapView setRegion:region animated:YES];
}

- (void)addAnnotationWithSelfAndSpaArray
{
    self.selfAnnotation = [[MKPointAnnotation alloc]init];
    self.selfAnnotation.coordinate = self.manager.location.coordinate;
    self.selfAnnotation.title = @"Your location";
    [self.mapView addAnnotation:self.selfAnnotation];

    for (Spa *spa in self.spaArray)
    {
        MKPointAnnotation *annotation = [[MKPointAnnotation alloc]init];
        annotation.coordinate = spa.mapItem.placemark.location.coordinate;
        annotation.title = spa.mapItem.placemark.name;
        [self.mapView addAnnotation:annotation];
    }
}

- (void)addAnnotationForSpa
{
    for (Spa *spa in self.spaArray)
    {
        MKPointAnnotation *annotation = [[MKPointAnnotation alloc]init];
        annotation.coordinate = spa.mapItem.placemark.location.coordinate;
        annotation.title = spa.mapItem.placemark.name;
        [self.mapView addAnnotation:annotation];
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    //MKPinAnnotationView instead of MKAnnotation -- be careful
    MKPinAnnotationView *pin = [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:nil];
    pin.canShowCallout = YES;
    pin.rightCalloutAccessoryView =[UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    pin.pinColor = MKPinAnnotationColorRed;

    if (![annotation isEqual:self.selfAnnotation])
    {
        pin.image = [UIImage imageNamed:@"greenmark"];
    }

    return pin;
}



@end
