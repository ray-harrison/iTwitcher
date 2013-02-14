//
//  ObservationGroup+Query.h
//  iTwitcher
//
//  Created by Raymond Harrison on 2/5/13.
//  Copyright (c) 2013 Raymond Harrison. All rights reserved.
//

#import "ObservationGroup.h"

@interface ObservationGroup (Query)
-(id) initWithContext:(NSManagedObjectContext *)context byDate:(NSDate *)date;
+(ObservationGroup *)getObservationGroupWithContext:(NSManagedObjectContext *)context byDate:(NSDate *)date;
+(ObservationGroup *)getObservationGroupInContext:(NSManagedObjectContext *)context byLatitude:(NSNumber *)latitude andLongitude:(NSNumber *)longitude;
@end
