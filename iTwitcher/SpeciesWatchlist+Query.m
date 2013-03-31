//
//  SpeciesWatchlist+Query.m
//  iTwitcher
//
//  Created by Raymond Harrison on 3/28/13.
//  Copyright (c) 2013 Raymond Harrison. All rights reserved.
//

#import "SpeciesWatchlist+Query.h"

@implementation SpeciesWatchlist (Query)
-(id) initWithContext:(NSManagedObjectContext *) context species:(Species *) species
{
  SpeciesWatchlist *speciesWatchlistItem = [NSEntityDescription insertNewObjectForEntityForName:@"SpeciesWatchlist" inManagedObjectContext:context];
    
    speciesWatchlistItem.species=species;
    
    speciesWatchlistItem.twitterCount = 0;
    speciesWatchlistItem.ebirdCount = 0;
    

  return speciesWatchlistItem;
}

+(NSArray *) querySpeciesWatchlistInContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"SpeciesWatchlist"];
    
    NSSortDescriptor *byNameSortDescriptor =
    [NSSortDescriptor sortDescriptorWithKey:@"species.speciesEnglishName" ascending:YES];
    request.sortDescriptors = @[byNameSortDescriptor];
    NSError *error = nil;
    
    NSArray *resultsArray = [context executeFetchRequest:request error:&error];
    return resultsArray;
}


@end
