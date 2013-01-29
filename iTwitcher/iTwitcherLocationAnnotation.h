//
//  iTwitcherLocationAnnotation.h
//  iTwitcher
//
//  Created by Raymond Harrison on 1/27/13.
//  Copyright (c) 2013 Raymond Harrison. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "ObservationLocation.h"
@interface iTwitcherLocationAnnotation : NSObject <MKAnnotation>

@property (nonatomic, readwrite, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic) float radius;
@property (nonatomic, retain) CLRegion *region;
- (id)initWithLocation:(CLLocationCoordinate2D)coord;
- (id)initWithLocation:(ObservationLocation *)location coordinate:(CLLocationCoordinate2D)coord radius:(float) radius;


- (iTwitcherLocationAnnotation *) annotationForLocation: (ObservationLocation *)location withRegion:(CLRegion *)region;
- (iTwitcherLocationAnnotation *) annotationForLocation: (ObservationLocation *)location;
@property (nonatomic, strong) ObservationLocation *location;

@end
