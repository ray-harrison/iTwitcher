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
    
    NSPredicate *filterPredicate = [NSPredicate predicateWithFormat:@"breedingRegion == %@ and subspeciesLatinName == nil",@"NA"];
    
    
    
    
    NSPredicate *searchPredicate = [NSPredicate predicateWithFormat:@"speciesEnglishName CONTAINS[cd] %@",searchText];
    
    filterPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[filterPredicate, searchPredicate]];
    
    
    
  
    NSLog(@"Search Text %@",searchText);
    request.predicate = filterPredicate;
   
    
    // if no search text then just a generic controller for all species
    
    NSSortDescriptor *familyCommonNameSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"familyEnglishName" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)];
    NSSortDescriptor *speciesCommonNameSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"speciesEnglishName" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)];
    request.sortDescriptors = @[familyCommonNameSortDescriptor,speciesCommonNameSortDescriptor];
    
    if ([searchText length] < 2) {
      [request setFetchLimit:10];
    }//[request setFetchLimit:25];
    
    //[request setFetchBatchSize:25];
    //[request setPropertiesToFetch:@[@"genus.family.englishName",@"englishName"]];
    
    request.includesSubentities = YES;
    
    
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
    
    NSPredicate *filterPredicate = [NSPredicate predicateWithFormat:@"breedingRegion == %@ and subspeciesLatinName == nil",@"NA"];
    
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
                                                   cacheName:nil];
    

    
    
    
    
    return fetchedResultsController;
}
+(Species *) speciesInContext:(NSManagedObjectContext *)context byName:(NSString *)name
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Species"];
    NSPredicate *searchPredicate = [NSPredicate predicateWithFormat:@"speciesEnglishName == %@",name];
    request.predicate = searchPredicate;
    NSError *error = nil;
    NSArray *speciesArray = [context executeFetchRequest:request error:&error];
    return [speciesArray objectAtIndex:0];
}

+(NSArray *) speciesWithObservationsWeek:(NSManagedObjectContext *) context
{
    NSTimeInterval secondsPerDay = 24 * 60 * 60;
    NSDate *today = [NSDate date];
    NSDate *week = [today dateByAddingTimeInterval:-14*secondsPerDay];
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Species"];
   // NSPredicate *filterPredicate = [NSPredicate predicateWithFormat:@"speciesObservations.@count >0 AND ANY speciesObservations.date >=%@",week];
    NSPredicate *filterPredicate = [NSPredicate predicateWithFormat:@"SUBQUERY(speciesObservations, $s, $s.date > %@).@count>0",week];
    request.predicate = filterPredicate;
    NSLog(@"Request %@",request);
    NSError *error = nil;
    NSArray *queryResults = [context executeFetchRequest:request error:&error];
    
    
    
    return queryResults;
    
    
    
}

+(NSArray *) speciesWithObservations:(NSManagedObjectContext *) context
{
    NSTimeInterval secondsPerDay = 24 * 60 * 60;
    NSDate *today = [self dateWithLocalTimeZone];
    NSDate *day = [today dateByAddingTimeInterval:-secondsPerDay];
    
    
    NSLog(@"Date %@",today);
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Species"];
   // NSPredicate *filterPredicate = [NSPredicate predicateWithFormat:@"speciesObservations.@count >0 AND ANY speciesObservations.date >=%@",day];
        NSPredicate *filterPredicate = [NSPredicate predicateWithFormat:@"SUBQUERY(speciesObservations, $s, $s.date > %@).@count>0",day];
    request.predicate = filterPredicate;
    NSLog(@"Request day %@",request);
    NSError *error = nil;
    NSArray *queryResults = [context executeFetchRequest:request error:&error];
   
    NSLog(@"Results %@",queryResults);
    
    return queryResults;
    
    
    
}

+(NSDate *) dateWithLocalTimeZone
{
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDate *date = [NSDate date];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    [gregorian setTimeZone:[NSTimeZone localTimeZone]];
    NSDateComponents *comps = [gregorian components:unitFlags fromDate:date];
    NSDate *dateReturn = [gregorian dateFromComponents:comps];
    return dateReturn;
}



@end
