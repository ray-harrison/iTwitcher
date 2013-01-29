//
//  ObservationLocation+Create.m
//  iTwitcher
//
//  Created by Raymond Harrison on 1/27/13.
//  Copyright (c) 2013 Raymond Harrison. All rights reserved.
//

#import "ObservationLocation+Create.h"

@implementation ObservationLocation (Create)
-(id) initWithContext:(NSManagedObjectContext *)context
{
    ObservationLocation *observationLocation = [NSEntityDescription insertNewObjectForEntityForName:@"ObservationLocation" inManagedObjectContext:context];
    return observationLocation;
    
}
@end
