//
//  Spe.h
//  SpaHunterChallenge2
//
//  Created by CHRISTINA GUNARTO on 11/14/14.
//  Copyright (c) 2014 Christina Gunarto. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface Spa : NSObject
@property MKMapItem *mapItem;
@property float distanceFromMeInKM;

+ (NSArray *)spasFromArray:(NSArray *)mapItems;

+ (void)searchForSpaNearMe: (CLLocation *)location withLatitudeDelta: (float)latDelta andLongitudeDelta: (float)longDelta andCompletion:(void(^)(NSArray *spaObjectsArray, NSError *error))complete;

+ (NSArray *)addDistanceInKmFromUserLocation: (CLLocation *)myLocation andSpaObjectsArray: (NSArray *)spaObjectsArray;

@end
