//
//  Species+Create.h
//  iTwitcher
//
//  Created by Raymond Harrison on 1/23/13.
//  Copyright (c) 2013 Raymond Harrison. All rights reserved.
//

#import "Species.h"
#import "SMXMLDocument.h"
@interface Species (Create)

+(void)createDatabaseWithManagedContext:(NSManagedObjectContext *)context andXMLDocument:(SMXMLDocument *)document;

@end
