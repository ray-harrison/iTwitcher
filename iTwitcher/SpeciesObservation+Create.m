//
//  SpeciesObservation+Create.m
//  iTwitcher
//
//  Created by Raymond Harrison on 1/27/13.
//  Copyright (c) 2013 Raymond Harrison. All rights reserved.
//

#import "SpeciesObservation+Create.h"

@implementation SpeciesObservation (Create)
-(id) initWithContext:(NSManagedObjectContext *)context
{
    SpeciesObservation *observation = [NSEntityDescription insertNewObjectForEntityForName:@"SpeciesObservation" inManagedObjectContext:context];
    return observation;
    
}

@end
