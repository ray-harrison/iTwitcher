//
//  ObservationLocation.h
//  iTwitcher
//
//  Created by Raymond Harrison on 1/23/13.
//  Copyright (c) 2013 Raymond Harrison. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SpeciesObservation;

@interface ObservationLocation : NSManagedObject

@property (nonatomic, retain) NSNumber * centerLatitude;
@property (nonatomic, retain) NSNumber * centerLongitude;
@property (nonatomic, retain) NSNumber * hotspot;
@property (nonatomic, retain) NSString * locationDescription;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * radius;
@property (nonatomic, retain) NSSet *speciesObservations;
@end

@interface ObservationLocation (CoreDataGeneratedAccessors)

- (void)addSpeciesObservationsObject:(SpeciesObservation *)value;
- (void)removeSpeciesObservationsObject:(SpeciesObservation *)value;
- (void)addSpeciesObservations:(NSSet *)values;
- (void)removeSpeciesObservations:(NSSet *)values;

@end
