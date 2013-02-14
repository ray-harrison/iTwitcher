//
//  iTwitcherObservationAnnotation.m
//  iTwitcher
//
//  Created by Raymond Harrison on 1/27/13.
//  Copyright (c) 2013 Raymond Harrison. All rights reserved.
//

#import "iTwitcherObservationAnnotation.h"
#import "ObservationLocation.h"

@implementation iTwitcherObservationAnnotation
-(iTwitcherObservationAnnotation *) annotationForObservation:(SpeciesObservation *) obs
{
    CLLocationCoordinate2D touchMapCoordinate = CLLocationCoordinate2DMake([obs.latitude floatValue], [obs.longitude floatValue]);
    iTwitcherObservationAnnotation *annotation = [[iTwitcherObservationAnnotation alloc] initWithLocation:touchMapCoordinate observation:obs];
    // self = [[iBirderObservationAnnotation alloc] initWithLocation:touchMapCoordinate];
    self.observation = obs;
    
    //self = annotation;
    return annotation;
}


+(iTwitcherObservationAnnotation *) annotationForObservationCollection:(ObservationCollection *) obs
{
    CLLocationCoordinate2D touchMapCoordinate = CLLocationCoordinate2DMake([obs.latitude floatValue], [obs.longitude floatValue]);
    iTwitcherObservationAnnotation *annotation = [[iTwitcherObservationAnnotation alloc] initWithLocation:touchMapCoordinate observationCollection:obs];
    // self = [[iBirderObservationAnnotation alloc] initWithLocation:touchMapCoordinate];
   // self.observationCollection = obs;
    
    //self = annotation;
    return annotation;
}

-(NSString *) title
{
    
    
    return [NSString stringWithFormat:@"%@",
            self.observationCollection.name];
    
}


-(NSString *) subtitle
{
    return [NSString stringWithFormat:@"%@",
            self.observation.date];
    
}

- (id)initWithLocation:(CLLocationCoordinate2D)coord observation:(SpeciesObservation *)obs{
    self = [super init];
    if (self) {
        self.coordinate = coord;
        self.observation = obs;
    }
    return self;
}

- (id)initWithLocation:(CLLocationCoordinate2D)coord observationCollection:(ObservationCollection *)obs{
    self = [super init];
    if (self) {
        self.coordinate = coord;
        self.observationCollection = obs;
    }
    return self;
}

@end
