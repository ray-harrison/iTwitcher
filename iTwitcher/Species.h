//
//  Species.h
//  iTwitcher
//
//  Created by Raymond Harrison on 3/28/13.
//  Copyright (c) 2013 Raymond Harrison. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SpeciesObservation, SpeciesWatchlist, Subspecies;

@interface Species : NSManagedObject

@property (nonatomic, retain) NSString * breedingRegion;
@property (nonatomic, retain) NSString * breedingSubregion;
@property (nonatomic, retain) NSString * familyEnglishName;
@property (nonatomic, retain) NSString * familyLatinName;
@property (nonatomic, retain) NSString * genusLatinName;
@property (nonatomic, retain) NSString * orderLatinName;
@property (nonatomic, retain) NSString * speciesEnglishName;
@property (nonatomic, retain) NSString * speciesLatinName;
@property (nonatomic, retain) NSString * subspeciesBreedingSubregion;
@property (nonatomic, retain) NSString * subspeciesLatinName;
@property (nonatomic, retain) NSSet *speciesObservations;
@property (nonatomic, retain) NSSet *subspecies;
@property (nonatomic, retain) SpeciesWatchlist *watchList;
@end

@interface Species (CoreDataGeneratedAccessors)

- (void)addSpeciesObservationsObject:(SpeciesObservation *)value;
- (void)removeSpeciesObservationsObject:(SpeciesObservation *)value;
- (void)addSpeciesObservations:(NSSet *)values;
- (void)removeSpeciesObservations:(NSSet *)values;

- (void)addSubspeciesObject:(Subspecies *)value;
- (void)removeSubspeciesObject:(Subspecies *)value;
- (void)addSubspecies:(NSSet *)values;
- (void)removeSubspecies:(NSSet *)values;

@end
