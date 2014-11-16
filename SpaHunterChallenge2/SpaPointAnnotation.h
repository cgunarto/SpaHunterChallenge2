//
//  SpaPointAnnotation.h
//  SpaHunterChallenge2
//
//  Created by CHRISTINA GUNARTO on 11/16/14.
//  Copyright (c) 2014 Christina Gunarto. All rights reserved.
//

#import <MapKit/MapKit.h>
@class Spa;

@interface SpaPointAnnotation : MKPointAnnotation
@property MKMapItem *mapItem;

- (instancetype) initWithSpa:(Spa *)spa;

@end
