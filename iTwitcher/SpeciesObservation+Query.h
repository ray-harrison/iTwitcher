//
//  SpeciesObservation+Query.h
//  iTwitcher
//
//  Created by Raymond Harrison on 1/27/13.
//  Copyright (c) 2013 Raymond Harrison. All rights reserved.
//

#import "SpeciesObservation.h"

@interface SpeciesObservation (Query)
+(NSArray *) getObservationsInContext:(NSManagedObjectContext *)context;
+(SpeciesObservation *)getObservationInContext:(NSManagedObjectContext *)context byLatitude:(NSNumber *)latitude andLongitude:(NSNumber *)longitude;
+(NSArray *)speciesObservations:(NSManagedObjectContext *)context bySpeciesName:(NSString *)speciesName;
@end
