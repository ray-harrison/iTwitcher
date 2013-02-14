//
//  ObservationCollection.h
//  iTwitcher
//
//  Created by Raymond Harrison on 2/6/13.
//  Copyright (c) 2013 Raymond Harrison. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ObservationGroup, ObservationLocation;

@interface ObservationCollection : NSManagedObject

@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *observationGroups;
@property (nonatomic, retain) ObservationLocation *observationLocation;
@end

@interface ObservationCollection (CoreDataGeneratedAccessors)

- (void)addObservationGroupsObject:(ObservationGroup *)value;
- (void)removeObservationGroupsObject:(ObservationGroup *)value;
- (void)addObservationGroups:(NSSet *)values;
- (void)removeObservationGroups:(NSSet *)values;

@end
