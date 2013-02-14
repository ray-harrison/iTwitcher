//
//  iTwitcherObservationAnnotation.h
//  iTwitcher
//
//  Created by Raymond Harrison on 1/27/13.
//  Copyright (c) 2013 Raymond Harrison. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "SpeciesObservation.h"
#import "ObservationCollection+Query.h"
@interface iTwitcherObservationAnnotation : NSObject <MKAnnotation>

@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
-(iTwitcherObservationAnnotation *) annotationForObservation:(SpeciesObservation *) obs;
+(iTwitcherObservationAnnotation *) annotationForObservationCollection:(ObservationCollection *) obs;
@property (nonatomic, strong) SpeciesObservation *observation;
@property (nonatomic, strong) ObservationCollection *observationCollection;

- (id)initWithLocation:(CLLocationCoordinate2D)coord observation:(SpeciesObservation *)obs;
- (id)initWithLocation:(CLLocationCoordinate2D)coord observationCollection:(ObservationCollection *)obs;

@end
