//
//  iTwitcherObservationAnnotation.m
//  iTwitcher
//
//  Created by Raymond Harrison on 1/27/13.
//  Copyright (c) 2013 Raymond Harrison. All rights reserved.
//

#import "iTwitcherObservationAnnotation.h"
#import "ObservationLocation.h"
#import "ObservationGroup.h"

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
    
    
    return [NSString stringWithFormat:@"Species: %d  Birds: %d", self.speciesCount,self.birdCount];
            
    
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

-(int)speciesCount
{
    int count = 0;
    NSSet *observationGroups = [self.observationCollection observationGroups];
    for (ObservationGroup *observationGroup in observationGroups) {
        count += [[observationGroup speciesObservations] count];
        
    }
    return count;
    
}
-(int)birdCount
{
    int count = 0;
   
    NSSet *observationGroups = [self.observationCollection observationGroups];
    for (ObservationGroup *observationGroup in observationGroups) {
        NSSet *speciesObservations = [observationGroup speciesObservations];
        for (SpeciesObservation *speciesObservation in speciesObservations) {
            count += [self speciesSum:speciesObservation];
        }
        
    }
    return count;
}
-(int)speciesSum:(SpeciesObservation *)speciesObservation
{
    int sum =  [speciesObservation.femaleAdult intValue]+  [speciesObservation.femaleJuvenile intValue] + [speciesObservation.femaleImmature intValue]+[speciesObservation.femaleAgeUnknown intValue]
    + [speciesObservation.maleAdult intValue] + [speciesObservation.maleJuvenile intValue] + [speciesObservation.maleImmature intValue] + [speciesObservation.maleAgeUnkown intValue]
    + [speciesObservation.sexUnknownAdult intValue] + [speciesObservation.sexUnknownJuvenile intValue] + [speciesObservation.sexUnknownImmature intValue] + [speciesObservation.sexUnknownAgeUnknown intValue];
    return sum;
    
}

@end
