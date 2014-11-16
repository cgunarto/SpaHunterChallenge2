//
//  SpaPointAnnotation.m
//  SpaHunterChallenge2
//
//  Created by CHRISTINA GUNARTO on 11/16/14.
//  Copyright (c) 2014 Christina Gunarto. All rights reserved.
//

#import "SpaPointAnnotation.h"
#import "Spa.h"

@implementation SpaPointAnnotation

- (instancetype) initWithSpa:(Spa *)spa
{
    self = [super init];
    self.coordinate = spa.mapItem.placemark.coordinate;
    self.title = spa.mapItem.placemark.name;
    self.mapItem = spa.mapItem;
    return self;
}

@end
