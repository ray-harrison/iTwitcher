//
//  Species+Query.h
//  iTwitcher
//
//  Created by Raymond Harrison on 1/26/13.
//  Copyright (c) 2013 Raymond Harrison. All rights reserved.
//

#import "Species.h"

@interface Species (Query)
+(NSFetchedResultsController *) newSearchFetchedResultsControllerWithSearch:(NSString *)searchText inManagedContext: (NSManagedObjectContext *) context;
+(NSFetchedResultsController *) newFetchedResultsControllerInManagedContext: (NSManagedObjectContext *) context;
+(Species *)speciesInContext:(NSManagedObjectContext *) context byName:(NSString *)name;

@end
