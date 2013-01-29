//
//  Species+Create.m
//  iTwitcher
//
//  Created by Raymond Harrison on 1/23/13.
//  Copyright (c) 2013 Raymond Harrison. All rights reserved.
//

#import "Species+Create.h"
#import "Subspecies.h"


@implementation Species (Create)


+ (void)buildSpecies:(NSManagedObjectContext *)context orderLatinName:(NSString *)orderLatinName familyLatinName:(NSString *)familyLatinName
   familyEnglishName:(NSString *)familyEnglishName genusLatinName:(NSString *)genusLatinName speciesEnglishName:(NSString *)speciesEnglishName
    speciesLatinName:(NSString *)speciesLatinName breedingRegions:(NSString *)breedingRegions breedingSubregions:(NSString *)breedingSubregions speciesXML:(SMXMLElement *)speciesXML
{
    Species *species = [NSEntityDescription insertNewObjectForEntityForName:@"Species" inManagedObjectContext:context];
    species.orderLatinName = orderLatinName;
    species.familyLatinName = familyLatinName;
    species.familyEnglishName = familyEnglishName;
    species.genusLatinName = genusLatinName;
    species.speciesEnglishName = speciesEnglishName;
    species.speciesLatinName = speciesLatinName;
    species.breedingRegion = breedingRegions;
    species.breedingSubregion = breedingSubregions;
    NSArray *subspeciesListXML = [speciesXML childrenNamed:@"subspecies"];
    
    for (SMXMLElement *subspeciesXML in subspeciesListXML ) {
        NSString *subspeciesLatinName = [subspeciesXML valueWithPath:@"latin_name"];
        NSString *breedingSubregion = [subspeciesXML valueWithPath:@"breeding_subregion"];
        Subspecies *subspecies = [NSEntityDescription insertNewObjectForEntityForName:@"Subspecies" inManagedObjectContext:context];
        subspecies.subspeciesLatinName = subspeciesLatinName;
        subspecies.breedingSubregion = breedingSubregion;
        [species addSubspeciesObject:subspecies];
    }
}

//Regions parsing: ","
//Subregion parsing grammar -
// Text string with separators ",","to","and" (replace with '|')
// Regular expression parse

+(void)createDatabaseWithManagedContext:(NSManagedObjectContext *)context andXMLDocument:(SMXMLDocument *)document
{
    SMXMLElement *ordersXML = [document.root childNamed:@"list"];
    
    for (SMXMLElement *orderXML in [ordersXML childrenNamed:@"order"]) {
       
        NSString *orderLatinName = [orderXML valueWithPath:@"latin_name"];
        NSArray *familiesXML = [orderXML childrenNamed:@"family"];
        for (SMXMLElement *familyXML in familiesXML) {
         
            NSString *familyLatinName = [familyXML valueWithPath:@"latin_name"];
            NSString *familyEnglishName = [familyXML valueWithPath:@"english_name"];
            
            NSArray *genusListXML = [familyXML childrenNamed:@"genus"];
            for (SMXMLElement *genusXML in genusListXML) {
                // Create the genus object
        
                // Get the species list for the genus
                NSString *genusLatinName = [genusXML valueWithPath:@"latin_name"];
                
                NSArray *speciesListXML = [genusXML childrenNamed:@"species"];
                for (SMXMLElement *speciesXML in speciesListXML) {
                    
                   //// Species *species = [[Species alloc] initWithContext:context smXMLElement:speciesXML];
                    NSString *speciesLatinName = [speciesXML valueWithPath:@"latin_name"];
                    NSString *speciesEnglishName = [speciesXML valueWithPath:@"english_name"];
                    NSString *breedingRegions = [speciesXML valueWithPath:@"breeding_regions"];
                    
                    NSString *breedingSubregions = [speciesXML valueWithPath:@"breeding_subregions"];
                    // We need the number of breeding regions to determine the number of "Species" records to create
                    
                    
                    NSArray *breedingRegionsArray = [breedingRegions componentsSeparatedByString:@","];
                    
                    if (breedingRegionsArray.count == 0) {
                        [self buildSpecies:context orderLatinName:orderLatinName familyLatinName:familyLatinName
                         familyEnglishName:familyEnglishName genusLatinName:genusLatinName speciesEnglishName:speciesEnglishName
                          speciesLatinName:speciesLatinName breedingRegions:breedingRegions breedingSubregions:breedingSubregions speciesXML:speciesXML];
                        [context save:nil];
                    }
                    
                    for (NSString *breedingRegion in breedingRegionsArray){
                        [self buildSpecies:context orderLatinName:orderLatinName familyLatinName:familyLatinName
                         familyEnglishName:familyEnglishName genusLatinName:genusLatinName speciesEnglishName:speciesEnglishName
                          speciesLatinName:speciesLatinName breedingRegions:breedingRegion breedingSubregions:breedingSubregions speciesXML:speciesXML];
                        
                    }
                    [context save:nil];
                    

                    
                    
                    
            } // Species
                
       
                
 
            
            
        } // Genus
        
        
    } // Family
        
  } // Order
    
   
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}









@end
