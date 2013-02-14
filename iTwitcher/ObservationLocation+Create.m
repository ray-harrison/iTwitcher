//
//  ObservationLocation+Create.m
//  iTwitcher
//
//  Created by Raymond Harrison on 1/27/13.
//  Copyright (c) 2013 Raymond Harrison. All rights reserved.
//

#import "ObservationLocation+Create.h"
#import "ObservationLocation+Query.h"

@implementation ObservationLocation (Create)
-(id) initWithContext:(NSManagedObjectContext *)context
{
    
    ObservationLocation *observationLocation = [NSEntityDescription insertNewObjectForEntityForName:@"ObservationLocation" inManagedObjectContext:context];
    return observationLocation;
    
}

-(id) initWithContext:(NSManagedObjectContext *)context name:(NSString *)name
{
    NSLog(@"Looking for Observation Location By Name %@",name);
    NSArray *existingLocations = [ObservationLocation searchLocationByName:name inContext:context];
    if (existingLocations.count > 0) {
        return (ObservationLocation *)[existingLocations objectAtIndex:0];
    }
    ObservationLocation *observationLocation = [NSEntityDescription insertNewObjectForEntityForName:@"ObservationLocation" inManagedObjectContext:context];
    return observationLocation;
    
}
@end
