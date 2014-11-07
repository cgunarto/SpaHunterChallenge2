//
//  ViewController.m
//  SpaHunterChallenge2
//
//  Created by CHRISTINA GUNARTO on 11/7/14.
//  Copyright (c) 2014 Christina Gunarto. All rights reserved.
//

#import "RootViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface RootViewController () <CLLocationManagerDelegate, UITableViewDataSource, UITableViewDelegate>
@property CLLocationManager *manager;
@property NSArray *pizzaMapItemArray;

@end

@implementation RootViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.manager = [[CLLocationManager alloc]init];
    [self.manager requestWhenInUseAuthorization];
    self.manager.delegate = self;
}

//display an alert if there is an error
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{

    if (error)
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"NETWORK ERROR"
                                                                       message:error.localizedDescription
                                                                preferredStyle:UIAlertControllerStyleAlert];

        UIAlertAction *okButton = [UIAlertAction actionWithTitle:@"OK"
                                                           style:UIAlertActionStyleDefault
                                                         handler:nil];
        [alert addAction:okButton];
        [self presentViewController:alert
                           animated:YES
                         completion:nil];
    }
}

// stop updating location at a certain accuracy level
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

//TODO: CHANGE THIS TO FINDSPANEAR
//- (void)findJailNear:(CLLocation *)location
//{
//    MKLocalSearchRequest *request = [MKLocalSearchRequest new];
//    request.naturalLanguageQuery = @"prison";
//    request.region = MKCoordinateRegionMake(location.coordinate, MKCoordinateSpanMake(1,1));
//
//    MKLocalSearch *search = [[MKLocalSearch alloc] initWithRequest:request];
//    [search startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error)
//     {
//         NSArray *mapItems = response.mapItems;
//         MKMapItem *mapItem = mapItems.firstObject;
//
//         self.textView.text = [NSString stringWithFormat:@"You should go to %@", mapItem.name];
//         [self getDirectionsTo:mapItem];
//     }];
//}

#pragma mark Table View Methods

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.pizzaMapItemArray.count;
}

@end
