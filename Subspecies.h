//
//  Subspecies.h
//  iTwitcher
//
//  Created by Raymond Harrison on 2/6/13.
//  Copyright (c) 2013 Raymond Harrison. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Species, SpeciesObservation;

@interface Subspecies : NSManagedObject

@property (nonatomic, retain) NSString * breedingSubregion;
@property (nonatomic, retain) NSString * subspeciesLatinName;
@property (nonatomic, retain) Species *species;
@property (nonatomic, retain) NSSet *speciesObservations;
@end

@interface Subspecies (CoreDataGeneratedAccessors)

- (void)addSpeciesObservationsObject:(SpeciesObservation *)value;
- (void)removeSpeciesObservationsObject:(SpeciesObservation *)value;
- (void)addSpeciesObservations:(NSSet *)values;
- (void)removeSpeciesObservations:(NSSet *)values;

@end
