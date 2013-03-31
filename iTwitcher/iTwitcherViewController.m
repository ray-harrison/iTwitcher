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
#import "SpeciesListTableViewController.h"
#import "SpeciesListsTabBarController.h"
#import "CustomBadge.h"
#import <Twitter/Twitter.h>
#import <Social/Social.h>


@interface iTwitcherViewController () 
@property (nonatomic,strong) NSString *badgeValue;

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
        self.birdDatabase.persistentStoreOptions = [NSDictionary dictionaryWithObjectsAndKeys:
                                                    [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                                                    [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
        
    }
    
    self.collectionView.delegate=self;
    self.collectionView.dataSource=self;
   
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [self twitterCheck];
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
    iTwitcherCollectionViewCell *cell = nil;
    switch (indexPath.item) {
        case 0:
            NSLog(@"Item 0");
            cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"sightingsCell" forIndexPath:indexPath];
           // CALayer *layer = [cell layer];
           // layer.cornerRadius = 12;
            break;
        case 1:
            NSLog(@"Item 1");
            cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"watchesCell" forIndexPath:indexPath];
            break;
        case 2:
            NSLog(@"Item 2");
            cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"twitterCell" forIndexPath:indexPath];
            UIView *cellView = [cell viewWithTag:102];
            
            
            NSLog(@"Cell View width %f",cellView.frame.size.width);
            
            
            NSLog(@"Badge Value %@",self.badgeValue);
            if (self.badgeValue) {
              CustomBadge *customBadge3 = [CustomBadge customBadgeWithString:self.badgeValue
                                                           withStringColor:[UIColor whiteColor]
                                                            withInsetColor:[UIColor redColor]
                                                            withBadgeFrame:YES
                                                       withBadgeFrameColor:[UIColor whiteColor]
                                                                 withScale:1.0
                                                               withShining:YES];
           
              [cellView addSubview:customBadge3];
              
            
            }
            
       
            
            break;
            
            
    }
    
    CALayer *layer = [cell layer];
    layer.cornerRadius = 12;

    return cell;
    
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView*)collectionView {
    // _data is a class member variable that contains one array per section.
    return 1;
}

- (NSInteger)collectionView:(UICollectionView*)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return 3;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"indexPath section %d indexPath item %d",indexPath.section,indexPath.item);
    switch(indexPath.item) {
        case 0:
            [self performSegueWithIdentifier:@"currentMap" sender:self];
            break;
        case 1:
            [self performSegueWithIdentifier:@"myLists" sender:self];
            break;
    }

            
}


#pragma mark - UIManagedDocument 

#pragma mark - Document Creation and Population




- (void) populateDocument
{
  //  NSManagedObjectContext *backgroundContext = [[NSManagedObjectContext alloc] init];
   // [backgroundContext setPersistentStoreCoordinator:[self.birdDatabase.managedObjectContext persistentStoreCoordinator]];
   // dispatch_queue_t queryQueue = dispatch_queue_create("query queue", NULL);
    
    
   // UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
   // [spinner setCenter:self.view.center];
    
    
   
    
    //[self.view addSubview:spinner]; // spinner is not visible until started
    //[spinner startAnimating];
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
        [self.collectionView setUserInteractionEnabled:NO];
        
        UIView *container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 60)];
        [container setBackgroundColor:[UIColor blackColor]];
        UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
       
        UILabel *spinnerLabel = [[UILabel alloc] init];
        spinnerLabel.text = @"Loading data for first time, please wait!";
        spinnerLabel.textColor = [UIColor whiteColor];
        spinnerLabel.backgroundColor = [UIColor blackColor];
        spinnerLabel.font = [UIFont boldSystemFontOfSize:17];
        [container addSubview:spinnerLabel];
        spinnerLabel.frame = CGRectMake(0, 3, 300, 25);
        [container addSubview:spinner];
        spinner.frame = CGRectMake(150, 30, 30, 30);
        //[spinner addSubview:spinnerLabel];
        
        [self.view addSubview:container];
        container.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
        
        //[spinner setCenter:self.view.center];
       // [self.view addSubview:spinner]; // spinner is not visible until started
        [spinner startAnimating];
        
        
        
        [self.birdDatabase saveToURL:self.birdDatabase.fileURL forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success) {
           
            if (success) {
               [self populateDocument];
               [spinner stopAnimating];
                [container removeFromSuperview];
                NSLog(@"Document Created");
                NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
                [prefs setBool:YES forKey:@"firstTimeStartup"];
                [self.collectionView setUserInteractionEnabled:YES];
            } else {
                NSLog(@"Could not open document");
            }
            
        }];
        
    } else if (self.birdDatabase.documentState == UIDocumentStateClosed) {
        // exists on disk, but we need to open it
        [self.collectionView setUserInteractionEnabled:NO];
        [self.birdDatabase openWithCompletionHandler:^(BOOL success) {
            if (success) {
                //[self populateDocument];
                [self.collectionView setUserInteractionEnabled:YES];
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
        //iTwitcherCurrentMapViewController *viewController = segue.destinationViewController;
       // viewController.birdDatabase = self.birdDatabase;
    } else if ([segue.identifier isEqualToString:@"myLists"]) {
        
        //SpeciesListTableViewController *speciesListTableViewController = segue.destinationViewController;
        //speciesListTableViewController.birdDatabase = self.birdDatabase;
    }
    
}


- (IBAction)addDocument:(id)sender {
    [self useDocument];
}

-(void) addBadge:(NSString *)badgeNumber {
    self.badgeValue = badgeNumber;
   
    [self.collectionView reloadData];

    
}

-(void)twitterCheck
{
    TWRequest *postRequest = [[TWRequest alloc] initWithURL:[NSURL URLWithString:@"http://search.twitter.com/search.json?q=%40to:ibirder"] parameters:nil requestMethod:TWRequestMethodGET];
    
     __block int count = 0;
    //   NSLog(@"Reset");
    [postRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
        NSString *output;
        
        if ([urlResponse statusCode] == 200) {
            // Parse the responseData, which we asked to be in JSON format for this request, into an NSDictionary using NSJSONSerialization.
            NSError *jsonParsingError = nil;
            NSDictionary *publicTimeline = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&jsonParsingError];
            output = [NSString stringWithFormat:@"HTTP response status: %i\nPublic timeline:\n%@", [urlResponse statusCode], publicTimeline];
            NSArray *keys = [publicTimeline allKeys];
            NSLog(@"keys %@",keys);
            NSLog(@"Results %@",[publicTimeline objectForKey:@"results"]);
            NSArray *results = [publicTimeline objectForKey:@"results"];
            //int count = 0;
            for (NSDictionary *resultObject in results) {
                NSLog(@" Object %@",[resultObject class]);
                NSLog(@"Result Object Dictionary Keys %@",[resultObject allKeys]);
                NSLog(@"Text Result Value %@",[resultObject objectForKey:@"text"]);
                count++;
                if ([resultObject isKindOfClass:[NSString class]]) {
                    NSString *result = (NSString *)resultObject;
                    NSArray *textArray = [result componentsSeparatedByString:@"="];
                    NSLog(@"textArray 1 %@",textArray[1]);
                    count++;
                    NSLog(@"Incrementing");
                }
                
                
                
                
                
            }
          output = [NSString stringWithFormat:@"%d",count];


     
            
            
        }
        else {
           // output = [NSString stringWithFormat:@"HTTP response status: %i\n", [urlResponse statusCode]];
            output = nil;
        }
        
        [self performSelectorOnMainThread:@selector(addBadge:) withObject:output waitUntilDone:NO];
    }];
}

@end
