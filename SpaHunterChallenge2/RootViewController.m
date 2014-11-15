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
#define kLatitudeDelta 1.0
#define kLongitudeDelta 1.0

@interface RootViewController () <CLLocationManagerDelegate, UITableViewDataSource, UITableViewDelegate>
@property CLLocationManager *manager;
@property (strong, nonatomic) NSMutableArray *spaArray;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation RootViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.manager = [[CLLocationManager alloc]init];
    [self.manager requestWhenInUseAuthorization];
    self.manager.delegate = self;
    [self.manager startUpdatingLocation];
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

- (void)findSpaNear:(CLLocation *)location
{
    self.spaArray = [@[]mutableCopy];
   [Spa searchForSpaNearMe:location withLatitudeDelta:kLatitudeDelta andLongitudeDelta:kLongitudeDelta andCompletion:^(NSArray *spaObjectsArray, NSError *error)
    {
        if (error)
        {
            NSLog(@"error %@", error.localizedDescription);
        }
        else
        {
            if (spaObjectsArray.count > 4)
            {
                for (int i = 0; i < 4; i++)
                {
                    self.spaArray[i] = spaObjectsArray[i];
                }
                [self.tableView reloadData];
            }
            else
            {
                self.spaArray = [@[spaObjectsArray]mutableCopy];
            }
        }
    }];
}

#pragma mark Table View Methods

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    Spa *spa = self.spaArray[indexPath.row];
    cell.textLabel.text = spa.mapItem.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%f", spa.distanceFromMeInKM];
    return cell;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.spaArray.count;
}

@end
