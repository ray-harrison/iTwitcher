//
//  ObservationGroup+Query.m
//  iTwitcher
//
//  Created by Raymond Harrison on 2/5/13.
//  Copyright (c) 2013 Raymond Harrison. All rights reserved.
//

#import "ObservationGroup+Query.h"

@implementation ObservationGroup (Query)
-(id) initWithContext:(NSManagedObjectContext *)context byDate:(NSDate *)date
{
    ObservationGroup *observationGroup = [NSEntityDescription insertNewObjectForEntityForName:@"ObservationGroup" inManagedObjectContext:context];
    observationGroup.date = date;
    return observationGroup;
}
+(ObservationGroup *)getObservationGroupWithContext:(NSManagedObjectContext *)context byDate:(NSDate *)date
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"ObservationGroup"];
    
    NSSortDescriptor *byNameSortDescriptor =
    [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES];
    request.sortDescriptors = @[byNameSortDescriptor];
    NSError *error = nil;
    
    NSArray *resultsArray = [context executeFetchRequest:request error:&error];
    if ([resultsArray count]>0) {
        return [resultsArray objectAtIndex:0];
    }
    
    return nil;
    
}

+(ObservationGroup *)getObservationGroupInContext:(NSManagedObjectContext *)context byLatitude:(NSNumber *)latitude andLongitude:(NSNumber *)longitude
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"ObservationGroup"];
    request.predicate =
    [NSPredicate predicateWithFormat:@"latitude == %@ AND longitude == %@", latitude,longitude];
    
    NSError *error = nil;
    NSArray *observationArray = [context executeFetchRequest:request error:&error];
    return [observationArray objectAtIndex:0];
}

@end
