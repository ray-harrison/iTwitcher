//
//  iTwitcherViewController.m
//  iTwitcher
//
//  Created by Raymond Harrison on 1/21/13.
//  Copyright (c) 2013 Raymond Harrison. All rights reserved.
//

#import "iTwitcherViewController.h"
#import "SMXMLDocument.h"
#import "Species+Create.h"
#import "iTwitcherCollectionViewCell.h"
#import "iTwitcherCurrentMapViewController.h"


@interface iTwitcherViewController ()

@end

@implementation iTwitcherViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    NSURL *url = nil;
    if (!self.birdDatabase) {
        NSLog(@"Init Bird Datbase");
       
        url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
        url = [url URLByAppendingPathComponent:@"iBirderDatabase"];
        self.birdDatabase = [[UIManagedDocument alloc] initWithFileURL:url];
    }
    
    self.collectionView.delegate=self;
    self.collectionView.dataSource=self;
}


- (void)setBirdDatabase:(UIManagedDocument *)birdDatabase
{
    
    if (_birdDatabase != birdDatabase) {
        _birdDatabase = birdDatabase;
        [self useDocument];
        
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UICollectionView delegate
-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // NSLog(@"Collection View Cell");
    iTwitcherCollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    //  [cell. setImage:[UIImage imageNamed:@"Icon.png"]];
    
    // [cell setImage:[UIImage imageNamed:@"User-Executive-Green-icon.png"]];
    //
    return cell;
    
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView*)collectionView {
    // _data is a class member variable that contains one array per section.
    return 1;
}

- (NSInteger)collectionView:(UICollectionView*)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return 4;
}


#pragma mark - UIManagedDocument 

#pragma mark - Document Creation and Population




- (void) populateDocument
{
   
    NSManagedObjectContext *context = [self birdDatabase].managedObjectContext;
    
    NSString *iocNamesXML = [[NSBundle mainBundle] pathForResource:@"ioc-names-3.1" ofType:@"xml"];
	NSData *data = [NSData dataWithContentsOfFile:iocNamesXML];
    NSError *error;
	SMXMLDocument *document = [SMXMLDocument documentWithData:data error:&error];
    // check for errors
    if (error) {
        NSLog(@"Error while parsing the document: %@", error);
        
    }
    
    [Species createDatabaseWithManagedContext:context andXMLDocument:document];
    
    
}



#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}



- (void)useDocument
{

    // First we need to see if the document exists at the file URL. This is done in viewDidLoad
    // (the setting of the URL). If the document does not exist at the URL, we move the already
    // created document to the file's URL and open it. If successful we call the "documentReady"
    // method.
    
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:[self.birdDatabase.fileURL path]]) {
        // does not exist on disk, so create it
        [self.birdDatabase saveToURL:self.birdDatabase.fileURL forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success) {
           
            if (success) {
               [self populateDocument];
                NSLog(@"Document Created");
            } else {
                NSLog(@"Could not open document");
            }
            
        }];
        

        
        
    } else if (self.birdDatabase.documentState == UIDocumentStateClosed) {
        // exists on disk, but we need to open it
        
        [self.birdDatabase openWithCompletionHandler:^(BOOL success) {
            if (success) {
                //[self populateDocument];
                NSLog(@"Document moved from state closed to open");
            } else {
                NSLog(@"Document State Closed could not open");
            }
            
            
        }];
    } else if (self.birdDatabase.documentState == UIDocumentStateNormal) {
        // already open and ready to use
        NSLog(@"Document state normal");
        
       //[self populateDocument];
    }
}



#pragma mark - Segues
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:@"currentMap"])
	{
        iTwitcherCurrentMapViewController *viewController = segue.destinationViewController;
       // viewController.birdDatabase = self.birdDatabase;
    }
    
}


- (IBAction)addDocument:(id)sender {
    [self useDocument];
}



@end
