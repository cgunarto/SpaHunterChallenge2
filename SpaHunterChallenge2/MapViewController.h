//
//  MapViewController.h
//  SpaHunterChallenge2
//
//  Created by CHRISTINA GUNARTO on 11/15/14.
//  Copyright (c) 2014 Christina Gunarto. All rights reserved.
//

#import <UIKit/UIKit.h>
@import MapKit;

@interface MapViewController : UIViewController
@property (strong, nonatomic) NSArray *spaArray;
@property (strong, nonatomic) CLLocation *selfLocation;

@end
