//
//  ObservationBookmark+Query.m
//  iTwitcher
//
//  Created by Raymond Harrison on 1/30/13.
//  Copyright (c) 2013 Raymond Harrison. All rights reserved.
//

#import "ObservationBookmark+Query.h"

@implementation ObservationBookmark (Query)

-(id) initWithContext:(NSManagedObjectContext *)context
{
    ObservationBookmark *bookmark = [NSEntityDescription insertNewObjectForEntityForName:@"ObservationBookmark" inManagedObjectContext:context];
    return bookmark;
    
}

+(NSArray *) queryObservationBookmarksInContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"ObservationBookmark"];
    
    NSSortDescriptor *byNameSortDescriptor =
    [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    request.sortDescriptors = @[byNameSortDescriptor];
    NSError *error = nil;
    NSArray *resultsArray = [context executeFetchRequest:request error:&error];
    return resultsArray;
}



@end
