//
//  ObservationCollection+Query.m
//  iTwitcher
//
//  Created by Raymond Harrison on 2/5/13.
//  Copyright (c) 2013 Raymond Harrison. All rights reserved.
//

#import "ObservationCollection+Query.h"

@implementation ObservationCollection (Query)

-(id) initWithContext:(NSManagedObjectContext *)context byName:(NSString *)name
{
    ObservationCollection *observationCollection = [NSEntityDescription insertNewObjectForEntityForName:@"ObservationCollection" inManagedObjectContext:context];
    observationCollection.name=name;
    return observationCollection;
}

+(ObservationCollection *)getObservationCollectionInContext:(NSManagedObjectContext *)context byName:(NSString *)name
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"ObservationCollection"];
    request.predicate =
    [NSPredicate predicateWithFormat:@"name == %@", name];
    
    NSError *error = nil;
    NSArray *observationArray = [context executeFetchRequest:request error:&error];
    return [observationArray count]>0?[observationArray objectAtIndex:0]:nil;
}

+(ObservationCollection *)getObservationCollectionInContext:(NSManagedObjectContext *)context byLatitude:(NSNumber *)latitude andLongitude:(NSNumber *)longitude
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"ObservationCollection"];
    request.predicate =
    [NSPredicate predicateWithFormat:@"latitude == %@ AND longitude == %@", latitude,longitude];
    
    NSError *error = nil;
    NSArray *observationArray = [context executeFetchRequest:request error:&error];
    return [observationArray count]>0?[observationArray objectAtIndex:0]:nil;
}

+(NSArray *)getAllObservationCollectionsInContext:(NSManagedObjectContext *)context
{
  NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"ObservationCollection"];
  NSError *error = nil;
  NSArray *observationArray = [context executeFetchRequest:request error:&error];
  return observationArray;
}
@end
