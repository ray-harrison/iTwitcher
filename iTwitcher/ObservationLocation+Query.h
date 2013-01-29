//
//  ObservationLocation+Query.h
//  iTwitcher
//
//  Created by Raymond Harrison on 1/27/13.
//  Copyright (c) 2013 Raymond Harrison. All rights reserved.
//

#import "ObservationLocation.h"

@interface ObservationLocation (Query)
+(NSArray *) searchLocationByName:(NSString *)name inContext:(NSManagedObjectContext *)context;
+(NSArray *) getLocationsInContext:(NSManagedObjectContext *)context;
+(NSArray *) getSpeciesObservationsInContext:(NSManagedObjectContext *)context;
+(NSSet *) getSpeciesObservationsForObservationLocation:(ObservationLocation *)observationLocation;
@end