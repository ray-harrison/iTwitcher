//
//  SpeciesBookmark+Query.m
//  iTwitcher
//
//  Created by Raymond Harrison on 1/30/13.
//  Copyright (c) 2013 Raymond Harrison. All rights reserved.
//

#import "SpeciesBookmark+Query.h"

@implementation SpeciesBookmark (Query)

-(id) initWithContext:(NSManagedObjectContext *)context
{
    SpeciesBookmark *bookmark = [NSEntityDescription insertNewObjectForEntityForName:@"SpeciesBookmark" inManagedObjectContext:context];
    return bookmark;
    
}

+(NSArray *) querySpeciesBookmarksInContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"SpeciesBookmark"];
   
    NSSortDescriptor *byNameSortDescriptor =
    [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    request.sortDescriptors = @[byNameSortDescriptor];
    NSError *error = nil;
    
    NSArray *resultsArray = [context executeFetchRequest:request error:&error];
    return resultsArray;
}

@end
