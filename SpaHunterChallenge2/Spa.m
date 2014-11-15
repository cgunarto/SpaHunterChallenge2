//
//  Spe.m
//  SpaHunterChallenge2
//
//  Created by CHRISTINA GUNARTO on 11/14/14.
//  Copyright (c) 2014 Christina Gunarto. All rights reserved.
//

#import "Spa.h"

@implementation Spa
@class Spa;

+ (NSArray *)spasFromArray:(NSArray *)mapItems
{
    NSMutableArray *spaArray =[@[]mutableCopy];
    for (MKMapItem *mapItem in mapItems)
    {
        Spa *spa = [[Spa alloc]init];
        spa.mapItem = mapItem;
        [spaArray addObject:spa];
    }
    return spaArray;
}

+ (void)searchForSpaNearMe: (CLLocation *)location withLatitudeDelta: (float)latDelta andLongitudeDelta: (float)longDelta andCompletion:(void(^)(NSArray *spaObjectsArray, NSError *error))complete
{
    MKLocalSearchRequest *request = [MKLocalSearchRequest new];
    request.naturalLanguageQuery = @"Spa";
    request.region = MKCoordinateRegionMake(location.coordinate, MKCoordinateSpanMake(0.1,0.1));

    MKLocalSearch *search = [[MKLocalSearch alloc] initWithRequest:request];
    [search startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error)
     {
         if (error)
         {
             complete (nil, error);
         }
         else
         {
             NSArray *spaObjectsArray = [Spa spasFromArray:response.mapItems];
             NSArray *spaObjectsWithDistArray = [Spa addDistanceInKmFromUserLocation:location andSpaObjectsArray:spaObjectsArray];

             //return the results ordered by closest to furthest away
             spaObjectsWithDistArray = [spaObjectsWithDistArray sortedArrayUsingComparator:^NSComparisonResult(Spa *spa1, Spa *spa2)
             {
                 if (spa1.distanceFromMeInKM < spa2.distanceFromMeInKM)
                 {
                     return (NSComparisonResult)NSOrderedAscending;
                 }
                 else if (spa1.distanceFromMeInKM > spa2.distanceFromMeInKM)
                 {
                     return (NSComparisonResult)NSOrderedDescending;
                 }
                 else
                 {
                     return (NSComparisonResult)NSOrderedSame;
                 }
             }];

             complete (spaObjectsWithDistArray, nil);
         }
     }];
}

+ (NSArray *)addDistanceInKmFromUserLocation: (CLLocation *)myLocation andSpaObjectsArray: (NSArray *)spaObjectsArray
{
    for (Spa *spa in spaObjectsArray)
    {
        CLLocation *spaItemLocation = spa.mapItem.placemark.location;
        CLLocationDistance distanceInM = [spaItemLocation distanceFromLocation:myLocation];

        double distanceInKM = distanceInM/1000;
        spa.distanceFromMeInKM = distanceInKM;
    }
    return spaObjectsArray;
}




@end
