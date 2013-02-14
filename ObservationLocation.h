//
//  ObservationLocation.h
//  iTwitcher
//
//  Created by Raymond Harrison on 2/6/13.
//  Copyright (c) 2013 Raymond Harrison. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ObservationCollection;

@interface ObservationLocation : NSManagedObject

@property (nonatomic, retain) NSNumber * centerLatitude;
@property (nonatomic, retain) NSNumber * centerLongitude;
@property (nonatomic, retain) NSNumber * hotspot;
@property (nonatomic, retain) NSString * locationDescription;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * radius;
@property (nonatomic, retain) NSSet *observationCollections;
@end

@interface ObservationLocation (CoreDataGeneratedAccessors)

- (void)addObservationCollectionsObject:(ObservationCollection *)value;
- (void)removeObservationCollectionsObject:(ObservationCollection *)value;
- (void)addObservationCollections:(NSSet *)values;
- (void)removeObservationCollections:(NSSet *)values;

@end
