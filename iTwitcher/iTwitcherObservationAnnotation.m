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

-(NSString *) title
{
    
    
    return [NSString stringWithFormat:@"%@ (%3.5f, %3.5f)",
            self.observation.observationLocation.name,  [self.observation.latitude floatValue], [self.observation.longitude floatValue]];
    
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

@end
