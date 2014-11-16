//
//  DirectionViewController.m
//  SpaHunterChallenge2
//
//  Created by CHRISTINA GUNARTO on 11/15/14.
//  Copyright (c) 2014 Christina Gunarto. All rights reserved.
//

#import "DirectionViewController.h"
#import "SpaPointAnnotation.h"
@import MapKit;
@import CoreLocation;

#define kLatitudeDelta 0.02
#define kLongitudeDelta 0.02

@interface DirectionViewController () <MKMapViewDelegate, CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property CLLocationManager *manager;

@end

@implementation DirectionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.manager = [[CLLocationManager alloc]init];
    [self.manager requestWhenInUseAuthorization];
    self.manager.delegate = self;

    [self.manager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    for (CLLocation *location in locations)
    {
        if (location.verticalAccuracy < 1000 && location.horizontalAccuracy < 1000)
        {
            NSLog (@"Location found...");
            [self.manager stopUpdatingLocation];
            [self setInitialViewToSelfLocation];
            [self showDirection];
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

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
    if ([overlay isKindOfClass:[MKPolyline class]]) {
        MKPolyline *route = overlay;
        MKPolylineRenderer *routeRenderer = [[MKPolylineRenderer alloc] initWithPolyline:route];
        routeRenderer.strokeColor = [UIColor blueColor];
        routeRenderer.lineWidth = 2;
        return routeRenderer;
    }
    else return nil;
}

- (void)showDirection
{
    MKDirectionsRequest *request = [MKDirectionsRequest new];
    request.source = [MKMapItem mapItemForCurrentLocation];
    request.destination = self.chosenSpaAnnotation.mapItem;
    request.transportType = MKDirectionsTransportTypeWalking;

    MKDirections *directions = [[MKDirections alloc]initWithRequest:request];

    [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, id error)
     {
         NSArray *routes = response.routes;
         MKRoute *route = routes.firstObject;

         [self.mapView addOverlay:route.polyline level:MKOverlayLevelAboveRoads];

         int x = 1;
         NSMutableString *directionsString = [NSMutableString string];

         for (MKRouteStep *step in route.steps)
         {
             [directionsString appendFormat:@"%d: %@\n", x, step.instructions];
             x++;

             NSLog (@"%@", step.instructions);
         }
     }];
}

































@end
