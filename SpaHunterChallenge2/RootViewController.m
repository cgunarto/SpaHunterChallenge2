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
#import "Spa.h"
#import "MapViewController.h"

#define kLatitudeDelta 1.0
#define kLongitudeDelta 1.0

@interface RootViewController () <CLLocationManagerDelegate, UITableViewDataSource, UITableViewDelegate, UITabBarControllerDelegate>
@property CLLocationManager *manager;
@property (strong, nonatomic) NSMutableArray *spaArray;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property double totalWalkingTime;
@property (weak, nonatomic) IBOutlet UILabel *minutesLabel;

@end

@implementation RootViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.manager = [[CLLocationManager alloc]init];
    [self.manager requestWhenInUseAuthorization];
    self.manager.delegate = self;
    self.tabBarController.delegate = self;
}

-(void)setSpaArray:(NSMutableArray *)spaArray
{
    _spaArray = spaArray;
    [self.tableView reloadData];
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
            [self findSpaNear:self.manager.location];
            break;
        }
    }
}

- (IBAction)onFindBlissButtonPressed:(UIButton *)sender
{
    [self.manager startUpdatingLocation];
}

- (IBAction)onCalcButtonPressed:(UIButton *)sender
{
    [self countWalkingTimePlusEatingTime:self.spaArray];
}

- (void)findSpaNear:(CLLocation *)location
{
    self.spaArray = [@[]mutableCopy];
   [Spa searchForSpaNearMe:location withLatitudeDelta:kLatitudeDelta andLongitudeDelta:kLongitudeDelta andCompletion:^(NSMutableArray *fourSpaObjectsArray, NSError *error)
    {
        if (error)
        {
            NSLog(@"error %@", error.localizedDescription);
        }
        else
        {
            self.spaArray = fourSpaObjectsArray;
        }
    }];
}

- (void)countWalkingTimePlusEatingTime: (NSMutableArray *)spaArray
{
    self.totalWalkingTime = 0;
    
    NSMutableArray *mapItemsForDistanceArray = [@[]mutableCopy];
    [mapItemsForDistanceArray insertObject:[MKMapItem mapItemForCurrentLocation] atIndex:0];

    for (Spa *spa in self.spaArray)
    {
        [mapItemsForDistanceArray addObject:spa.mapItem];
    }
    [mapItemsForDistanceArray addObject:[MKMapItem mapItemForCurrentLocation]];

    //Get directiontime
    MKDirectionsRequest *request = [MKDirectionsRequest new];
    request.transportType = MKDirectionsTransportTypeWalking;

    for (int i = 0; i < mapItemsForDistanceArray.count -1; i++)
    {
        request.source = mapItemsForDistanceArray[i];
        request.destination = mapItemsForDistanceArray[i+1];

        MKDirections *directions = [[MKDirections alloc]initWithRequest:request];

        [directions calculateETAWithCompletionHandler:^(MKETAResponse *response, NSError *error)
        {
            NSTimeInterval estimatedTravelTimeInSeconds = response.expectedTravelTime;
            self.totalWalkingTime = self.totalWalkingTime + estimatedTravelTimeInSeconds/ (double)60 + 50;
            self.minutesLabel.text = [NSString stringWithFormat:@"%.2f",self.totalWalkingTime];
        }];
    }

}

#pragma mark Table View Methods

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    Spa *spa = self.spaArray[indexPath.row];
    cell.textLabel.text = spa.mapItem.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2f", spa.distanceFromMeInKM];
    cell.imageView.image = [UIImage imageNamed:@"greenmark"];
    return cell;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.spaArray.count;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    UINavigationController *navController = (UINavigationController *)viewController;
    MapViewController *mapVC = navController.childViewControllers[0];
    mapVC.spaArray = self.spaArray;
    mapVC.selfLocation = self.manager.location;
}


@end
