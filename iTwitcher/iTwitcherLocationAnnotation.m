//
//  iTwitcherLocationAnnotation.m
//  iTwitcher
//
//  Created by Raymond Harrison on 1/27/13.
//  Copyright (c) 2013 Raymond Harrison. All rights reserved.
//

#import "iTwitcherLocationAnnotation.h"

@implementation iTwitcherLocationAnnotation

- (iTwitcherLocationAnnotation *) annotationForLocation: (ObservationLocation *)location withRegion:(CLRegion *)region
{
    iTwitcherLocationAnnotation *locationAnnotation = [[iTwitcherLocationAnnotation alloc] init];
    locationAnnotation.location = location;
    return locationAnnotation;
}

- (iTwitcherLocationAnnotation *) annotationForLocation: (ObservationLocation *)location
{
    iTwitcherLocationAnnotation *locationAnnotation = [[iTwitcherLocationAnnotation alloc] init];
    locationAnnotation.location = location;
    
    return locationAnnotation;
}

- (id)initWithLocation:(CLLocationCoordinate2D)coord {
    self = [super init];
    if (self) {
        _coordinate = coord;
    }
    return self;
}

- (id)initWithLocation: (ObservationLocation *)location coordinate: (CLLocationCoordinate2D)coord radius:(float)radius{
    self = [super init];
    if (self) {
        _coordinate = coord;
        _radius = radius;
        
        // set up region
        _region = [[CLRegion alloc] initCircularRegionWithCenter:coord
                                                          radius:_radius
                                                      identifier:[self title]];
        _location = location;
        
        
    }
    return self;
}

#pragma mark - MKAnnotation

-(NSString *)title
{
    return self.location.name;
}

-(NSString *)subtitle
{
    return self.location.locationDescription;
    
}




@end
