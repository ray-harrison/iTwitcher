//
//  ObservationLocation+Query.m
//  iTwitcher
//
//  Created by Raymond Harrison on 1/27/13.
//  Copyright (c) 2013 Raymond Harrison. All rights reserved.
//

#import "ObservationLocation+Query.h"
#import "ObservationCollection.h"
#import "ObservationGroup.h"
#import "SpeciesObservation.h"
#import "Species.h"

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

+(NSArray *) searchLocationByName:(NSString *)name inContext:(NSManagedObjectContext *)context bySpeciesName:(NSString *)speciesName;
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"ObservationLocation"];
    request.predicate = [NSPredicate predicateWithFormat:@"name == %@", name];
    NSSortDescriptor *locationNameSortDescriptor =
    [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    request.sortDescriptors = @[locationNameSortDescriptor];
    NSError *error = nil;
    NSArray *locationArray = [context executeFetchRequest:request error:&error];
    int count = 0;
    for (ObservationLocation *observationLocation in locationArray) {
        for (ObservationCollection *observationCollection in observationLocation.observationCollections) {
            for (ObservationGroup *observationGroup in observationCollection.observationGroups) {
                for (SpeciesObservation *speciesObservation in observationGroup.speciesObservations) {
                    if ([speciesObservation.species.speciesEnglishName isEqualToString:speciesName])
                        count++;
                }
            }
            
        }
    }
    NSLog(@"SearchLocationByName Count %d",count);
    
    
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
   // NSLog(@"Fetch %@",request.debugDescription);
    return locationArray;
    
}

+(NSArray *) getSpeciesObservationsInContext:(NSManagedObjectContext *)context
{
    return nil;
}
+(NSSet *) getObservationCollectionsForObservationLocation:(ObservationLocation *)observationLocation
{
    return observationLocation.observationCollections;
    
}

+(NSSet *) getSpeciesObservationsForObservationLocation:(ObservationLocation *)observationLocation
{
    return nil;
}

+(NSArray *) queryObservationLocations:(NSManagedObjectContext *)context bySpeciesName:(NSString *)speciesEnglishName
{
 NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"ObservationLocation"];
 //NSPredicate *filterPredicate = [NSPredicate predicateWithFormat:@"ANY observationCollections.observationGroups.speciesObservations.species.speciesEnglishName == %@",speciesEnglishName];
 //request.predicate = filterPredicate;
 NSError *error = nil;
 NSArray *locationArray = [context executeFetchRequest:request error:&error];
 int count = 0;
    NSMutableArray *locations = [[NSMutableArray alloc] initWithCapacity:1];
 for (ObservationLocation *observationLocation in locationArray) {
        for (ObservationCollection *observationCollection in observationLocation.observationCollections) {
            for (ObservationGroup *observationGroup in observationCollection.observationGroups) {
                for (SpeciesObservation *speciesObservation in observationGroup.speciesObservations) {
                    if ([speciesObservation.species.speciesEnglishName isEqualToString:speciesEnglishName]) {
                        [locations addObject:observationLocation];
                        count++;
                    }
                }
            }
            
        }
    }
    if (count == 0) {
        locations = nil;
    }
 
 return locations;
}
@end
