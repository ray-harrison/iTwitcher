//
//  ObservationCollection+Query.h
//  iTwitcher
//
//  Created by Raymond Harrison on 2/5/13.
//  Copyright (c) 2013 Raymond Harrison. All rights reserved.
//


#import "ObservationCollection.h"
@interface ObservationCollection (Query)

-(id) initWithContext:(NSManagedObjectContext *)context byName:(NSString *)name;
+(ObservationCollection *)getObservationCollectionInContext:(NSManagedObjectContext *)context byName:(NSString *)name;
+(ObservationCollection *)getObservationCollectionInContext:(NSManagedObjectContext *)context byLatitude:(NSNumber *)latitude andLongitude:(NSNumber *)longitude;

@end
