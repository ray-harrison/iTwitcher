//
//  SpeciesObservation+Query.m
//  iTwitcher
//
//  Created by Raymond Harrison on 1/27/13.
//  Copyright (c) 2013 Raymond Harrison. All rights reserved.
//

#import "SpeciesObservation+Query.h"

@implementation SpeciesObservation (Query)
+(NSArray *) getObservationsInContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"SpeciesObservation"];
    
   // NSSortDescriptor *locationNameSortDescriptor =
   // [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
   // request.sortDescriptors = @[locationNameSortDescriptor];
    NSError *error = nil;
    NSArray *locationArray = [context executeFetchRequest:request error:&error];
    //NSLog(@"Fetch %@",request.debugDescription);
    return locationArray;
    
}
+(SpeciesObservation *)getObservationInContext:(NSManagedObjectContext *)context byLatitude:(NSNumber *)latitude andLongitude:(NSNumber *)longitude
{
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"SpeciesObservation"];
        request.predicate =
        [NSPredicate predicateWithFormat:@"latitude == %@ AND longitude == %@", latitude,longitude];
        
    NSError *error = nil;
    NSArray *observationArray = [context executeFetchRequest:request error:&error];
    return [observationArray objectAtIndex:0];
}
@end
