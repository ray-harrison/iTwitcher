//
//  SpeciesWatchlist.h
//  iTwitcher
//
//  Created by Raymond Harrison on 3/28/13.
//  Copyright (c) 2013 Raymond Harrison. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Species, SpeciesWatchlistDetail;

@interface SpeciesWatchlist : NSManagedObject

@property (nonatomic, retain) NSNumber * twitterCount;
@property (nonatomic, retain) NSNumber * ebirdCount;
@property (nonatomic, retain) Species *species;
@property (nonatomic, retain) NSSet *details;
@end

@interface SpeciesWatchlist (CoreDataGeneratedAccessors)

- (void)addDetailsObject:(SpeciesWatchlistDetail *)value;
- (void)removeDetailsObject:(SpeciesWatchlistDetail *)value;
- (void)addDetails:(NSSet *)values;
- (void)removeDetails:(NSSet *)values;

@end
