//
//  SpeciesObservation.h
//  iTwitcher
//
//  Created by Raymond Harrison on 1/27/13.
//  Copyright (c) 2013 Raymond Harrison. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ObservationLocation, Photograph, Species;

@interface SpeciesObservation : NSManagedObject

@property (nonatomic, retain) NSString * behavior;
@property (nonatomic, retain) NSString * breedingCode;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSNumber * ebirdVerified;
@property (nonatomic, retain) NSNumber * femaleAdult;
@property (nonatomic, retain) NSNumber * femaleAgeUnknown;
@property (nonatomic, retain) NSNumber * femaleImmature;
@property (nonatomic, retain) NSNumber * femaleJuvenile;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSNumber * maleAdult;
@property (nonatomic, retain) NSNumber * maleAgeUnkown;
@property (nonatomic, retain) NSNumber * maleImmature;
@property (nonatomic, retain) NSNumber * maleJuvenile;
@property (nonatomic, retain) NSNumber * oiledNotSick;
@property (nonatomic, retain) NSNumber * oiledObviouslySick;
@property (nonatomic, retain) NSNumber * oiledUnknownIfSick;
@property (nonatomic, retain) NSNumber * sexUnknownAdult;
@property (nonatomic, retain) NSNumber * sexUnknownAgeUnknown;
@property (nonatomic, retain) NSNumber * sexUnknownImmature;
@property (nonatomic, retain) NSNumber * sexUnknownJuvenile;
@property (nonatomic, retain) ObservationLocation *observationLocation;
@property (nonatomic, retain) NSSet *photos;
@property (nonatomic, retain) Species *species;
@end

@interface SpeciesObservation (CoreDataGeneratedAccessors)

- (void)addPhotosObject:(Photograph *)value;
- (void)removePhotosObject:(Photograph *)value;
- (void)addPhotos:(NSSet *)values;
- (void)removePhotos:(NSSet *)values;

@end
