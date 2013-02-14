//
//  SpeciesBookmark+Query.h
//  iTwitcher
//
//  Created by Raymond Harrison on 1/30/13.
//  Copyright (c) 2013 Raymond Harrison. All rights reserved.
//

#import "SpeciesBookmark.h"

@interface SpeciesBookmark (Query)
-(id) initWithContext:(NSManagedObjectContext *)context;
+(NSArray *) querySpeciesBookmarksInContext:(NSManagedObjectContext *)context;

@end
