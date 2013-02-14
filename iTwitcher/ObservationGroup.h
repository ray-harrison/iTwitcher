//
//  ObservationGroup.h
//  iTwitcher
//
//  Created by Raymond Harrison on 2/6/13.
//  Copyright (c) 2013 Raymond Harrison. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ObservationCollection, SpeciesObservation;

@interface ObservationGroup : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) ObservationCollection *observationCollection;
@property (nonatomic, retain) NSSet *speciesObservations;
@end

@interface ObservationGroup (CoreDataGeneratedAccessors)

- (void)addSpeciesObservationsObject:(SpeciesObservation *)value;
- (void)removeSpeciesObservationsObject:(SpeciesObservation *)value;
- (void)addSpeciesObservations:(NSSet *)values;
- (void)removeSpeciesObservations:(NSSet *)values;

@end
