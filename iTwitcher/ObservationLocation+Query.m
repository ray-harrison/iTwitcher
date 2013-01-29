//
//  ObservationLocation+Query.m
//  iTwitcher
//
//  Created by Raymond Harrison on 1/27/13.
//  Copyright (c) 2013 Raymond Harrison. All rights reserved.
//

#import "ObservationLocation+Query.h"

@implementation ObservationLocation (Query)
+(NSArray *) searchLocationByName:(NSString *)name inContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"ObservationLocation"];
    request.predicate = [NSPredicate predicateWithFormat:@"name contains[cd] %@", name];
    NSSortDescriptor *locationNameSortDescriptor =
    [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    request.sortDescriptors = @[locationNameSortDescriptor];
    NSError *error = nil;
    NSArray *locationArray = [context executeFetchRequest:request error:&error];
    return locationArray;
}
+(NSArray *) getLocationsInContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"ObservationLocation"];
    
    NSSortDescriptor *locationNameSortDescriptor =
    [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    request.sortDescriptors = @[locationNameSortDescriptor];
    NSError *error = nil;
    NSArray *locationArray = [context executeFetchRequest:request error:&error];
    NSLog(@"Fetch %@",request.debugDescription);
    return locationArray;
    
}
+(NSSet *) getSpeciesObservationsForObservationLocation:(ObservationLocation *)observationLocation
{
    return observationLocation.speciesObservations;
    
}
@end
