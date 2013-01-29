//
//  Species+Query.m
//  iTwitcher
//
//  Created by Raymond Harrison on 1/26/13.
//  Copyright (c) 2013 Raymond Harrison. All rights reserved.
//

#import "Species+Query.h"

@implementation Species (Query)

+(NSFetchedResultsController *) newSearchFetchedResultsControllerWithSearch:(NSString *)searchText inManagedContext: (NSManagedObjectContext *) context
{
    
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Species"];
    
    NSPredicate *filterPredicate = [NSPredicate predicateWithFormat:@"breedingRegion == %@",@"NA"];
    
    
    
    
    NSPredicate *searchPredicate = [NSPredicate predicateWithFormat:@"speciesEnglishName CONTAINS[cd] %@",searchText];
    
    filterPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[filterPredicate, searchPredicate]];
    
    
    
  
    NSLog(@"Search Text %@",searchText);
    request.predicate = filterPredicate;
   
    
    // if no search text then just a generic controller for all species
    
    NSSortDescriptor *familyCommonNameSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"familyEnglishName" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)];
    NSSortDescriptor *speciesCommonNameSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"speciesEnglishName" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)];
    request.sortDescriptors = @[familyCommonNameSortDescriptor,speciesCommonNameSortDescriptor];
    
    //[request setFetchLimit:50];
    
    //[request setFetchBatchSize:25];
    //[request setPropertiesToFetch:@[@"genus.family.englishName",@"englishName"]];
    
    
    
    
    NSFetchedResultsController *searchFetchedResultsController =
    [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                        managedObjectContext:context
                                          sectionNameKeyPath:@"familyEnglishName"
     
                                                   cacheName:nil];
    
 
    
    
    
    return searchFetchedResultsController;
}


+(NSFetchedResultsController *) newFetchedResultsControllerInManagedContext: (NSManagedObjectContext *) context
{
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Species"];
    
    NSPredicate *filterPredicate = [NSPredicate predicateWithFormat:@"breedingRegion == %@",@"NA"];
    
   // NALog(@"Request Predicate %@",request);
    
    
    request.predicate = filterPredicate;
     NSLog(@"Request Predicate %@",request);
    // if no search text then just a generic controller for all species
    
    NSSortDescriptor *familyCommonNameSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"familyEnglishName" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)];
    NSSortDescriptor *speciesCommonNameSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"speciesEnglishName" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)];
    request.sortDescriptors = @[familyCommonNameSortDescriptor,speciesCommonNameSortDescriptor];
    

 

    

    
    NSFetchedResultsController *fetchedResultsController =
    [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                        managedObjectContext:context
                                          sectionNameKeyPath:@"familyEnglishName"
                                                   cacheName:@"speciesCache"];
    

    
    
    
    
    return fetchedResultsController;
}

@end
