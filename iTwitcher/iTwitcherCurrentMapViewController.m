//
//  iTwitcherCurrentMapViewController.m
//  iTwitcher
//
//  Created by Raymond Harrison on 1/27/13.
//  Copyright (c) 2013 Raymond Harrison. All rights reserved.
//

#import "iTwitcherCurrentMapViewController.h"
#import "iTwitcherObservationAnnotation.h"
#import "iTwitcherLocationAnnotation.h"
#import "iTwitcherLocationAnnotationView.h"
#import "SpeciesObservation.h"
#import "SpeciesObservation+Create.h"
#import "SpeciesObservation+Query.h"
#import "ObservationLocation+Create.h"
#import "ObservationLocation+Query.h"
#import "iTwitcherSpeciesViewController.h"
#import "ObservationGroup+Query.h"
#import "ObservationCollection+Query.h"
#import "MyObservationsCollectionViewController.h"
#define METERS_PER_MILE 1609.344

@interface iTwitcherCurrentMapViewController () {
    NSMutableArray *_locations;
    NSMutableArray *_annotations;
    
    iTwitcherObservationAnnotation *_droppedPin;
    iTwitcherObservationAnnotation *_currentAnnotation;
    SpeciesObservation *_currentObservation;
    ObservationLocation *_birdLocation;
    ObservationCollection *_birdCollection;
}

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLLocation *currentLocation;
@property (nonatomic) BOOL iAdBannerIsVisible;

//@property (nonatomic, retain) IBOutlet UIView *contentView;
@property (nonatomic, retain) id adBannerView;

@property (nonatomic) CLLocationCoordinate2D currentObservationCoordinate;



@end

@implementation iTwitcherCurrentMapViewController







- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self loadDocument];
    
    [self startLocationUpdates];

    
    UILongPressGestureRecognizer *longPressRecogniser = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    longPressRecogniser.minimumPressDuration = 1.0;
    [self.mapView addGestureRecognizer:longPressRecogniser];
    
    self.mapView.delegate = self;
 
    self.iAdBannerIsVisible=YES;
    self.iTwitcherAdView.delegate = self;

     //   [self.view bringSubviewToFront:self.instructionView];
    
}

-(void) viewDidAppear:(BOOL)animated
{
    NSLog(@"Vide Did Appear");
    [self zoomToCurrentLocation];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    BOOL firstTime = [prefs boolForKey:@"firstTimeStartup"];
    if (firstTime) {
     [self.view bringSubviewToFront:self.instructionView];
        [prefs setBool:NO forKey:@"firstTimeStartup"];
    }
    
}

- (void) viewWillAppear:(BOOL)animated
{
    if (_currentAnnotation) {
        [self.mapView selectAnnotation:_currentAnnotation animated:YES];
    }
}


-(void)viewWillDisappear:(BOOL)animated
{
    [self.locationManager stopUpdatingLocation];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Load UI Managed Document
-(void)loadDocument
{
    NSURL *url = nil;
    if (!self.birdDatabase) {
        NSLog(@"Init Bird Datbase");
        
        url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
        url = [url URLByAppendingPathComponent:@"iBirderDatabase"];
        self.birdDatabase = [[UIManagedDocument alloc] initWithFileURL:url];
    }
}


- (void)setBirdDatabase:(UIManagedDocument *)birdDatabase
{
    
    if (_birdDatabase != birdDatabase) {
        _birdDatabase = birdDatabase;
        [self useDocument];
        
    }
}


#pragma mark - Location Delegate

-(CLLocation *)currentLocation
{
    NSLog(@"Getting current location");
    if (_currentLocation == nil) {
        _currentLocation = [self.locationManager location];
    }
    return _currentLocation;
    
}

-(CLLocationManager *)locationManager
{
    if (nil == _locationManager)
        _locationManager = [[CLLocationManager alloc] init];
    return _locationManager;
    
}

-(void)startLocationUpdates
{
    // Create the location manager if this object does not
    // already have one.
    NSLog(@"Start updating location");
  
    
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    // Set a movement threshold for new events.
    self.locationManager.distanceFilter = 100;
   // self.locationManager.pausesLocationUpdatesAutomatically = YES;
    [self.locationManager setActivityType:CLActivityTypeOther];
    [self.locationManager startUpdatingLocation];
}

- (void)startSignificantChangeUpdates
{
    // Create the location manager if this object does not
    // already have one.
    
    
    self.locationManager.delegate = self;
    [self.locationManager startMonitoringSignificantLocationChanges];
}

// Delegate method from the CLLocationManagerDelegate protocol.
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations {
    NSLog(@"didUpdateLocations");
    // If it's a relatively recent event, turn off updates to save power
    self.currentLocation = [locations lastObject];

    NSDate* eventDate = self.currentLocation.timestamp;
    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
    if (abs(howRecent) < 15.0) {
        // If the event is recent, do something with it.
        NSLog(@"latitude %+.6f, longitude %+.6f\n",
              self.currentLocation.coordinate.latitude,
              self.currentLocation.coordinate.longitude);
    }
}

-(void)locationManagerDidPauseLocationUpdates:(CLLocationManager *)manager
{
    NSLog(@"Did pause location updates");
}

#pragma mark - Map Delegate


- (MKAnnotationView*)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    NSLog(@"View For Annotation");
    
 //   if ([annotation isKindOfClass:[MKUserLocation class]])
 //   {
 //       return nil;
 //   }
    if ([annotation isKindOfClass:[iTwitcherObservationAnnotation class]]) {
        // iBirderObservationAnnotation *observationAnnotation =
        // (iBirderObservationAnnotation *)annotation;
        NSLog(@"Annotation is kindofclass iBirderObservationAnnotation");
        MKPinAnnotationView*    pinView = (MKPinAnnotationView*)[[self mapView]
                                                                 dequeueReusableAnnotationViewWithIdentifier:@"CustomPinAnnotationView"];
        
        if (!pinView)
        {
            // If an existing pin view was not available, create one.
            pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation
                                                      reuseIdentifier:@"CustomPinAnnotationView"];
            
            pinView.pinColor = MKPinAnnotationColorRed;
            
            pinView.animatesDrop = YES;
            pinView.canShowCallout = YES;
            pinView.draggable = YES;
            
            // Add a detail disclosure button to the callout.
            UIButton* rightButton = [UIButton buttonWithType:
                                     UIButtonTypeDetailDisclosure];
           //  [rightButton addTarget:self action:@selector(segueToObservationCollection:)
           // forControlEvents:UIControlEventTouchUpInside];
            pinView.rightCalloutAccessoryView = rightButton;
            [pinView.rightCalloutAccessoryView setTag:0];
          
            UIButton* leftButton = [UIButton buttonWithType:
                                    UIButtonTypeInfoDark];
            [leftButton setImage:[UIImage imageNamed:@"trashcan32x32.png"] forState:UIControlStateNormal];
            //  leftButton.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"trashcan.png"]]
            //[leftButton addTarget:self action:@selector(deleteObservation:) forControlEvents:UIControlEventTouchUpInside];
            pinView.leftCalloutAccessoryView = leftButton;
            [pinView.leftCalloutAccessoryView setTag:1];
            
           // [pinView.leftCalloutAccessoryView setImage:[UIImage imageNamed:@"RedCircle16x16.png"]];
            
        }
        else {
            pinView.annotation = annotation;

        }
        
        NSLog(@"Returning pinView");
        
        return pinView;
        
    } else if ([annotation isKindOfClass:[iTwitcherLocationAnnotation class]]) {

      
        
        NSLog(@"annotation isKindOfClass iBirderLocationAnnotation");
        
        iTwitcherLocationAnnotation *locationAnnotation = (iTwitcherLocationAnnotation *)annotation;
        
        iTwitcherLocationAnnotationView *locationAnnotationView =
        (iTwitcherLocationAnnotationView *)[[self mapView]
                                          dequeueReusableAnnotationViewWithIdentifier:locationAnnotation.title];
        
        if (!locationAnnotationView) {
            locationAnnotationView = [iTwitcherLocationAnnotationView initWithAnnotation:annotation map:[self mapView]];
            locationAnnotationView.mapView= self.mapView;
            
            locationAnnotationView.pinColor = MKPinAnnotationColorGreen;
            
        }
        
        
        
        
        locationAnnotationView.mapView=self.mapView;
        locationAnnotationView.theAnnotation = annotation;
        locationAnnotationView.annotation = annotation;
        locationAnnotationView.canShowCallout = YES;
        
        locationAnnotationView.draggable = YES;
        
        locationAnnotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        
        
        [locationAnnotationView updateRadiusOverlay];
        if (!locationAnnotationView) {
            NSLog(@"No location annotation view");
        }
        NSLog(@"Can Show Callout %d",locationAnnotationView.canShowCallout);
        return locationAnnotationView;
        
        
        
    } else {
        NSLog(@"View for Annotation Returning NULL!!!!");
     return nil;   
    }
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)aView
{
    // UIImage *image = [self.delegate mapViewController:self imageForAnnotation:aView.annotation];
    NSLog(@"Did select annotation view");
   // [(UIImageView *)aView.leftCalloutAccessoryView setImage:nil];
}




- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    
    if ([view.annotation isKindOfClass:[iTwitcherObservationAnnotation class]]) {
        NSLog(@"Annotation isKindOfClass iBirderObservationAnnotation - Callout Accessory Tapped");
        
        _currentAnnotation = (iTwitcherObservationAnnotation *) view.annotation;
        if ([control tag] == 0) { // Right button pressed
           
            iTwitcherObservationAnnotation *observationAnnotation = view.annotation;
            self.currentObservationCoordinate = observationAnnotation.coordinate;
            

            
            _birdCollection = [ObservationCollection getObservationCollectionInContext:[self.birdDatabase managedObjectContext]
                                                                            byLatitude:[NSNumber numberWithFloat:observationAnnotation.coordinate.latitude]
                                                                          andLongitude:[NSNumber numberWithFloat:observationAnnotation.coordinate.longitude]];
            
            if (!_birdCollection) {
                NSLog(@"No Bird Collection in calloutAccessoryControlTapped!");
                _birdCollection = [[ObservationCollection alloc] initWithContext:[self.birdDatabase managedObjectContext] byName:@"Observation"];
                
            }
            
            [self.mapView deselectAnnotation:_currentAnnotation animated:TRUE];
           [self performSegueWithIdentifier:@"addCollectionAtLocation" sender:self];
        }
        
        
        if([control tag] == 1) {
            iTwitcherObservationAnnotation *observationAnnotation = view.annotation;
            _birdCollection = [ObservationCollection getObservationCollectionInContext:[self.birdDatabase managedObjectContext]
                                                                            byLatitude:[NSNumber numberWithFloat:observationAnnotation.coordinate.latitude]
                                                                          andLongitude:[NSNumber numberWithFloat:observationAnnotation.coordinate.longitude]];
            [self deleteObservation:_birdCollection];
        }
        
      
    } else {
        
        
      //  iTwitcherLocationAnnotationView *locationAnnotationView =
      //  (iTwitcherLocationAnnotationView *)view;
      //  [locationAnnotationView removeRadiusOverlay];
        
      //  for (id currentAnnotation in self.mapView.annotations) {
      //      if ([currentAnnotation isKindOfClass:[iTwitcherLocationAnnotation class]]) {
      //          [self.mapView deselectAnnotation:currentAnnotation animated:YES];
      //      }
      //  }
        
        [self performSegueWithIdentifier:@"observationLocationDetail" sender:self];
    }
    
}




-(void) mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view didChangeDragState:(MKAnnotationViewDragState)newState fromOldState:(MKAnnotationViewDragState)oldState
{
    
    if ([view.annotation isKindOfClass:[iTwitcherLocationAnnotation class]]) {
        if (newState == MKAnnotationViewDragStateStarting) {
            _birdLocation = [self currentHotspotForObservation];
            // Get the annotation being moved and remove it from the list of annotations
            iTwitcherLocationAnnotationView *annotationView = (iTwitcherLocationAnnotationView *)view;
            [annotationView removeRadiusOverlay];
            
            iTwitcherLocationAnnotation *annotation = (iTwitcherLocationAnnotation *)view.annotation;
            
            annotation.region=nil;
            
            [_locations removeObject:annotation];
            
            
            
            
            
            
            
        }
        
        
        if (newState == MKAnnotationViewDragStateEnding) {
            
            
            iTwitcherLocationAnnotation *annotation = (iTwitcherLocationAnnotation *)view.annotation;
            iTwitcherLocationAnnotationView *annotationView = (iTwitcherLocationAnnotationView *)view;
            [annotationView updateRadiusOverlay];
            _birdLocation.centerLatitude = @(annotation.coordinate.latitude);
            _birdLocation.centerLongitude = @(annotation.coordinate.longitude);
            [[self.birdDatabase managedObjectContext] save:nil];
            
            [_locations addObject:annotation];
            
            
        }
    } else  if ([view.annotation isKindOfClass:[iTwitcherObservationAnnotation class]]){
        // MapPlayAnnotation *annotation = (MapPlayAnnotation *)view.annotation;
        
        
     
        
        if (newState == MKAnnotationViewDragStateStarting) {
           // [self.mapView removeAnnotation:view.annotation];
            [_annotations removeObject:view.annotation];
        }
        
        if (newState == MKAnnotationViewDragStateEnding) {
            
            iTwitcherObservationAnnotation *observationAnnotation = view.annotation;
            
            observationAnnotation.observationCollection.latitude =  [NSNumber numberWithFloat:observationAnnotation.coordinate.latitude];
            observationAnnotation.observationCollection.longitude = [NSNumber numberWithFloat:observationAnnotation.coordinate.longitude];
            [[self.birdDatabase managedObjectContext] save:nil];
            [_annotations addObject:observationAnnotation];
        
            
        }
        
    }
}


- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay {
	if([overlay isKindOfClass:[MKCircle class]]) {
		// Create the view for the radius overlay.
		MKCircleView *circleView = [[MKCircleView alloc] initWithOverlay:overlay];
		circleView.strokeColor = [UIColor greenColor];
		circleView.fillColor = [[UIColor greenColor] colorWithAlphaComponent:0.1];
		
		return circleView;
	}
	
	return nil;
}


#pragma mark - iTwitcherMapDetailsDelegate
-(void) didChooseMapType:(iTwitcherMapDetailsViewController *)controller selectedSegmentedIndex:(NSInteger)index
{
    
   
    if (index == 0) {
        self.mapView.mapType = MKMapTypeStandard;
        
    } else if (index == 2) {
        self.mapView.mapType = MKMapTypeHybrid;
    } else if (index == 1) {
        self.mapView.mapType = MKMapTypeSatellite;
    }
    [self.mapView reloadInputViews];
    [self zoomToCurrentLocation];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)handleSwipeGesture:(id)sender {
    NSLog(@"Swipe Gesture");
    [self.instructionView removeFromSuperview];
}

//- (void)handleSwipeGesture:(UIGestureRecognizer*)recogniser {
//    NSLog(@"Swipe Gesture");
//    [self.instructionView removeFromSuperview];
    
    
//}


// The Map View Controller maintains the annotations and displays any existing observations
// and passes down through the children view controllers

- (void)handleLongPress:(UIGestureRecognizer*)recogniser {
    // 1
    if (recogniser.state == UIGestureRecognizerStateBegan) {
        // 2
      
    
        CGPoint touchPoint = [recogniser locationInView:self.mapView];
        CLLocationCoordinate2D touchMapCoordinate = [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];

        
 
        
        if (![self observationInHotspot:touchMapCoordinate]) {
            // Create a basic ObservationLocation
           
           _birdLocation = [self defaultObservationLocation];
            
            CLLocationCoordinate2D observationLocationCoordinate = CLLocationCoordinate2DMake([_birdLocation.centerLatitude floatValue], [_birdLocation.centerLongitude floatValue]);
            iTwitcherLocationAnnotation *locationAnnotation = [[iTwitcherLocationAnnotation alloc] initWithLocation:_birdLocation coordinate:observationLocationCoordinate radius:[_birdLocation.radius floatValue]];
            
            
            
            
     
            
            
            [self.mapView addAnnotation:locationAnnotation];
            //[location addSpeciesObservationsObject:observation];
            
        } else {
            _birdLocation = [self hotspotForObservationCoordinate:touchMapCoordinate];
            
       
        }
        
        
        // format it
        //  NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
        //  [dateFormat setDateFormat:@"HH:mm:ss zzz"];
        
        // convert it to a string
        //  NSString *dateString = [dateFormat stringFromDate:date];
        
        // When a new Pin Annotation is created, we need to provide a new
        // observation collection. A collection can contain one or more observation
        // groups, which are 1 or species observed at a specific location.
        // For example at your backyard feeder, which occupies a specific location,
        // you might have finches, sparrows, flickers across across mulitiple dates
        // and it is these multiple dates which provide the "one or more" observation groups
  
        
     //   NSDate *date = [NSDate date];
     //   _currentObservation.date = date;
        
        
        
        _birdCollection = [ObservationCollection getObservationCollectionInContext:[self.birdDatabase managedObjectContext]
                                                                        byLatitude:@(touchMapCoordinate.latitude)
                                                                      andLongitude:@(touchMapCoordinate.longitude)];
        
        if (!_birdCollection) {
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
            [dateFormat setDateFormat:@"YYYY/MM/dd HH:mm:ss"];
            
            NSDate *date = [NSDate date];
            
            NSTimeZone *timeZone = [NSTimeZone localTimeZone];
            [dateFormat setTimeZone:timeZone];
            NSString *formattedDate = [dateFormat stringFromDate:date];
            
          
          
           // NSDate *date2 = [calendar date];
            _birdCollection = [[ObservationCollection alloc] initWithContext:[self.birdDatabase managedObjectContext] byName:[NSString stringWithFormat:@"Observation %@",formattedDate]];
            _birdCollection.latitude = @(touchMapCoordinate.latitude);
            _birdCollection.longitude = @(touchMapCoordinate.longitude);
        }
        
        // An initial observation group
        
        ObservationGroup *observationGroup = [[ObservationGroup alloc] initWithContext:[self.birdDatabase managedObjectContext] byDate:[NSDate date]];
        [_birdCollection addObservationGroupsObject:observationGroup];
        ObservationLocation *observationLocation = [self currentHotspotForObservation];
        NSLog(@"Observation Name %@",observationLocation.name);
        [_birdLocation addObservationCollectionsObject:_birdCollection];
        
        [[self.birdDatabase managedObjectContext] save:nil];
     // [self.birdDatabase saveToURL:<#(NSURL *)#> forSaveOperation:<#(UIDocumentSaveOperation)#> completionHandler:<#^(BOOL success)completionHandler#>]
        
        
        [self.birdDatabase saveToURL:self.birdDatabase.fileURL forSaveOperation:UIDocumentSaveForOverwriting completionHandler:^(BOOL success) {
            
            if (success) {
                
                NSLog(@"Document Saved");
            } else {
                NSLog(@"Could not save document");
            }
            
        }];
        
       // [_birdLocation addSpeciesObservationsObject:observation];
        _droppedPin = [iTwitcherObservationAnnotation annotationForObservationCollection:_birdCollection];
        _droppedPin.coordinate = touchMapCoordinate;
       
        // get the current date
        
        
        
        
        [_annotations addObject:_droppedPin];
        [self.mapView addAnnotation:_droppedPin];
        [self.mapView setCenterCoordinate:self.mapView.region.center animated:NO];
       // [self loadData];
 
    }
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    // We have two segues - one for the map specific details and one for a new observation collection
    if ([segue.identifier isEqualToString:@"mapDetails"]) {
      //  NSLog(@"MapDetails Chosen segue");
        iTwitcherMapDetailsViewController *viewController =
        segue.destinationViewController;
        viewController.mapDetailsDelegate = self;
        viewController.currentMapType=self.mapView.mapType;
    //    viewController.birdDatabase=self.birdDatabase;
        
    } else if ([segue.identifier isEqualToString:@"addCollectionAtLocation"]) {
        
        
        UINavigationController *navigationController = segue.destinationViewController;
       // We know that the relevant child is at object id=0;
        NSLog(@"Looking for objectAtIndex 0");
        MyObservationsCollectionViewController *observationMasterController = (MyObservationsCollectionViewController *)[navigationController.childViewControllers objectAtIndex:0];
        observationMasterController.observationMasterDelegate = self;
        observationMasterController.birdDatabase = self.birdDatabase;
        observationMasterController.location = self.currentObservationCoordinate;
        observationMasterController.observationCollection = _birdCollection;
        NSLog(@"%f %f",[_birdCollection.latitude floatValue],[_birdCollection.longitude floatValue]);
       
        
    }
}


- (void) zoomToCurrentLocation
{
   // NSLog(@"Zooming");
   // NSLog(@"latitude %+.6f, longitude %+.6f\n",
   //       self.currentLocation.coordinate.latitude,
   //     self.currentLocation.coordinate.longitude);
    //CLLocation *location = [self.locationManager location];
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(self.currentLocation.coordinate, 0.5*METERS_PER_MILE, 0.5*METERS_PER_MILE);
    // 3
    MKCoordinateRegion adjustedRegion = [self.mapView regionThatFits:viewRegion];
    // 4
    [self.mapView setRegion:adjustedRegion animated:YES];
    
}

-(void) displayAnnotationsForLocation:(ObservationLocation *)observationLocation
{
 

     [[self.birdDatabase managedObjectContext] save:nil];
    
    CLLocationCoordinate2D observationLocationCoordinate = CLLocationCoordinate2DMake([observationLocation.centerLatitude floatValue], [observationLocation.centerLongitude floatValue]);
    iTwitcherLocationAnnotation *locationAnnotation = [[iTwitcherLocationAnnotation alloc] initWithLocation:observationLocation coordinate:observationLocationCoordinate radius:[observationLocation.radius floatValue]];
    
    
    
    
    
    
    
    [self.mapView addAnnotation:locationAnnotation];
    //[location addSpeciesObservationsObject:observation];
    
}

- (void)bannerViewDidLoadAd:(ADBannerView *)bannerView {
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
 //   int bannerHeight =[self getBannerHeight:orientation];
    if (!self.iAdBannerIsVisible)
    {
       
        self.iAdBannerIsVisible = YES;
        [self fixupAdView:orientation];
    } 
    
    
}

- (int)getBannerHeight:(UIInterfaceOrientation)orientation {
    if (UIInterfaceOrientationIsLandscape(orientation)) {
        return 32;
    } else {
        return 50;
    }
}

- (int)getBannerHeight {
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    return [self getBannerHeight:orientation];
}

- (void)bannerView:(ADBannerView *)bannerView didFailToReceiveAdWithError:(NSError *)error{
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    int bannerHeight =[self getBannerHeight:orientation];
    if (self.iAdBannerIsVisible)
    {
        [UIView beginAnimations:@"animateAdBannerOff" context:NULL];
        // Assumes the banner view is placed at the bottom of the screen.
        bannerView.frame = CGRectOffset(bannerView.frame, 0, bannerHeight);
        [UIView commitAnimations];
        self.iAdBannerIsVisible = NO;
    } 
}

- (void)fixupAdView:(UIInterfaceOrientation)toInterfaceOrientation {
    if (_adBannerView != nil) {
        if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation)) {
            [_adBannerView setCurrentContentSizeIdentifier:
             ADBannerContentSizeIdentifierLandscape];
        } else {
            [_adBannerView setCurrentContentSizeIdentifier:
             ADBannerContentSizeIdentifierPortrait];
        }
        [UIView beginAnimations:@"fixupViews" context:nil];
        if (self.iAdBannerIsVisible) {
            CGRect adBannerViewFrame = [_adBannerView frame];
            adBannerViewFrame.origin.x = 0;
            adBannerViewFrame.origin.y = 0;
            [_adBannerView setFrame:adBannerViewFrame];
            CGRect contentViewFrame = _mapView.frame;
            contentViewFrame.origin.y =
            [self getBannerHeight:toInterfaceOrientation];
            contentViewFrame.size.height = self.view.frame.size.height -
            [self getBannerHeight:toInterfaceOrientation];
            _mapView.frame = contentViewFrame;
        } else {
            CGRect adBannerViewFrame = [_adBannerView frame];
            adBannerViewFrame.origin.x = 0;
            adBannerViewFrame.origin.y =
            -[self getBannerHeight:toInterfaceOrientation];
            [_adBannerView setFrame:adBannerViewFrame];
            CGRect contentViewFrame = _mapView.frame;
            contentViewFrame.origin.y = 0;
            contentViewFrame.size.height = self.view.frame.size.height;
            _mapView.frame = contentViewFrame;
        }
        [UIView commitAnimations];
    }
}

-(void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
   [self fixupAdView:toInterfaceOrientation]; 
}



- (void)useDocument
{
    
    // First we need to see if the document exists at the file URL. This is done in viewDidLoad
    // (the setting of the URL). If the document does not exist at the URL, we move the already
    // created document to the file's URL and open it. If successful we call the "documentReady"
    // method.
    
    if (self.birdDatabase.documentState == UIDocumentStateClosed) {
        // exists on disk, but we need to open it
        
        [self.birdDatabase openWithCompletionHandler:^(BOOL success) {
            if (success) {
                //[self populateDocument];
                NSLog(@"Document moved from state closed to open");
                [self loadData];
            } else {
                NSLog(@"Document State Closed could not open");
            }
            
            
        }];
    } else if (self.birdDatabase.documentState == UIDocumentStateNormal) {
        // already open and ready to use
        NSLog(@"Document state normal");
        [self loadData];
        
        //[self populateDocument];
    }
}

#pragma mark - Observation Location
-(ObservationLocation *)defaultObservationLocation
{

    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
   // CLLocation *location = [self.locationManager location];
    
    
    
    CLLocationCoordinate2D centre = [self.mapView centerCoordinate];
    //CLLocation *location = CLLocationCoordinate2DMake(centre.latitude, centre.longitude);
    CLLocation *location = [[CLLocation alloc] initWithLatitude:centre.latitude longitude:centre.longitude];
    
    __block ObservationLocation *observationLocation = [[ObservationLocation alloc] initWithContext:[self.birdDatabase managedObjectContext] name:@"My New Location"];
    observationLocation.radius = [NSNumber numberWithInt:500];
    observationLocation.centerLatitude = [NSNumber numberWithFloat:centre.latitude];
    observationLocation.centerLongitude = [NSNumber numberWithFloat:centre.longitude];
    
    [[self.birdDatabase managedObjectContext] save:nil];
    __weak iTwitcherCurrentMapViewController *weakSelf = self;
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        NSLog(@"reverseGeocodeLocation:completionHandler: Completion Handler called!");
        if (error){
            NSLog(@"Geocode failed with error: %@", error);
            
            return;
        }
               
       
       
        
        for (CLPlacemark *placemark in placemarks) {
        
            NSDictionary *addressDictionary = [placemark addressDictionary];
       

            NSString *tempName = [addressDictionary objectForKey:@"SubLocality"] != nil?[addressDictionary objectForKey:@"SubLocality"]:[addressDictionary objectForKey:@"Locality"];
            
           
            observationLocation.name = tempName;
            

        }
        [[weakSelf.birdDatabase managedObjectContext] save:nil];
        [weakSelf displayAnnotationsForLocation:observationLocation];
        
    }];
   
    return observationLocation;
}

-(void) deleteObservationLocation:(ObservationLocation *)observationLocation
{
    [[self.birdDatabase managedObjectContext] deleteObject:observationLocation];
    [[self.birdDatabase managedObjectContext] save:nil];
    
    
}

-(void) deleteSpeciesObservation:(SpeciesObservation *)speciesObservation
{
    [[self.birdDatabase managedObjectContext] deleteObject:speciesObservation];
    [[self.birdDatabase managedObjectContext] save:nil];
    
    
}

-(void) deleteAllSpeciesObservations
{
    NSArray *observations = [SpeciesObservation getObservationsInContext:[self.birdDatabase managedObjectContext]];
    for (SpeciesObservation *speciesObservation in observations) {
        [self deleteSpeciesObservation:speciesObservation];
    }
}

-(void) deleteAllObservationLocations
{
    NSArray *locations = [ObservationLocation getLocationsInContext:[self.birdDatabase managedObjectContext] ];
    for (ObservationLocation *observationLocation in locations) {
       [[self.birdDatabase managedObjectContext] deleteObject:observationLocation]; 
    }
   
    [[self.birdDatabase managedObjectContext] save:nil];
    
    
}

-(void)updateObservationLocation:(ObservationLocation *)observationLocation
{
    [[self.birdDatabase managedObjectContext] save:nil];
    
}
-(void)updateSpeciesObservation
{
   [[self.birdDatabase managedObjectContext] save:nil]; 
}

-(void) deleteObservationCollection:(ObservationCollection *)observationCollection
{
    if (observationCollection) {
      for (ObservationGroup *observationGroup in observationCollection.observationGroups) {
        for (SpeciesObservation *speciesObservation in observationGroup.speciesObservations) {
            speciesObservation.species = nil;
            [[self.birdDatabase managedObjectContext] deleteObject:speciesObservation];
        }
          [[self.birdDatabase managedObjectContext] deleteObject:observationGroup];
       }
       [[self.birdDatabase managedObjectContext] deleteObject:observationCollection];
       [self.mapView removeAnnotation:_currentAnnotation];
       NSError *error = nil;
       [[self.birdDatabase managedObjectContext] save:&error];
        if (error) {
            NSLog(@"[%@ %@] %@ (%@)", NSStringFromClass([self class]), NSStringFromSelector(_cmd), [error localizedDescription], [error localizedFailureReason]);
        }
    }
}

-(BOOL) observationInHotspot:(CLLocationCoordinate2D) coordinate
{
    NSArray *locations = [ObservationLocation getLocationsInContext:[self.birdDatabase managedObjectContext] ];
    
    for (ObservationLocation *observationLocation in locations) {
        // Create a region Object from an observation Location;
        CLLocationCoordinate2D coord =
                  CLLocationCoordinate2DMake([observationLocation.centerLatitude floatValue], [observationLocation.centerLongitude floatValue]);
        CLRegion *newRegion = [[CLRegion alloc] initCircularRegionWithCenter:coord
                                                                      radius:[observationLocation.radius floatValue]
                                                                  identifier:[NSString stringWithFormat:@"%@", observationLocation.name]];
        if ([newRegion containsCoordinate:coordinate]) {
            newRegion = nil;
            return true;
        }
        newRegion = nil;
    }
    
    
    
    return false;
}

-(ObservationLocation *) hotspotForObservationCoordinate:(CLLocationCoordinate2D) coordinate
{
    NSArray *locations = [ObservationLocation getLocationsInContext:[self.birdDatabase managedObjectContext] ];
    
    for (ObservationLocation *observationLocation in locations) {
        // Create a region Object from an observation Location;
        CLLocationCoordinate2D coord =
        CLLocationCoordinate2DMake([observationLocation.centerLatitude floatValue], [observationLocation.centerLongitude floatValue]);
        CLRegion *newRegion = [[CLRegion alloc] initCircularRegionWithCenter:coord
                                                                      radius:[observationLocation.radius floatValue]
                                                                  identifier:[NSString stringWithFormat:@"%@", observationLocation.name]];
        
        if ([newRegion containsCoordinate:coordinate]) {
            newRegion = nil;
            return observationLocation;
        }
        newRegion = nil;
    }
    
    
    
    return nil;
}


-(ObservationLocation *) currentHotspotForObservation
{
    NSArray *locations = [ObservationLocation getLocationsInContext:[self.birdDatabase managedObjectContext] ];
    CLLocationCoordinate2D coordinate = [self currentLocation].coordinate;
    for (ObservationLocation *observationLocation in locations) {
        // Create a region Object from an observation Location;
        CLLocationCoordinate2D coord =
        CLLocationCoordinate2DMake([observationLocation.centerLatitude floatValue], [observationLocation.centerLongitude floatValue]);
        CLRegion *newRegion = [[CLRegion alloc] initCircularRegionWithCenter:coord
                                                                      radius:[observationLocation.radius floatValue]
                                                                  identifier:[NSString stringWithFormat:@"%@", observationLocation.name]];
        
        if ([newRegion containsCoordinate:coordinate]) {
            newRegion = nil;
            return observationLocation;
        }
        newRegion = nil;
    }
    
    
    
    return nil;
}


#pragma mark - Load Data
- (void)loadData {
    
    
   // [self deleteAllObservationLocations];
   // [self deleteAllSpeciesObservations];
    
    NSArray *locationData = [ObservationLocation getLocationsInContext:[self birdDatabase].managedObjectContext ];
    
    NSUInteger locationCount = locationData.count;
    
   
    
   
    
    
    _locations = [[NSMutableArray alloc] initWithCapacity:locationCount];
    
    
    for (ObservationLocation *loc in locationData) {
        
        
        
        
        // iBirderLocationAnnotation *locAnnotation = [[iBirderLocationAnnotation alloc] annotationForLocation:loc];
        CLLocationCoordinate2D touchMapCoordinate = CLLocationCoordinate2DMake([loc.centerLatitude floatValue], [loc.centerLongitude floatValue]);
        iTwitcherLocationAnnotation *locationAnnotation = [[iTwitcherLocationAnnotation alloc] initWithLocation:loc coordinate:touchMapCoordinate radius:[loc.radius floatValue]];
        
        //[self.mapView addAnnotation:locationAnnotation];
        [_locations addObject:locationAnnotation];
        
        for (ObservationCollection *observationCollection in loc.observationCollections) {
           
            iTwitcherObservationAnnotation *observationAnnotation = [iTwitcherObservationAnnotation annotationForObservationCollection:observationCollection];
            
            [self.mapView addAnnotation:observationAnnotation];
        }
  
        
        
        
        
    }
    
    [self.mapView addAnnotations:_locations];
    
}

- (IBAction)currentLocation:(id)sender {
    [self zoomToCurrentLocation];
}

-(void) didCancel:(iTwitcherSpeciesObservationMasterViewController *)controller
{
 [self dismissViewControllerAnimated:YES completion:nil];   
}

-(void) didCreateObservationCollection:(iTwitcherSpeciesObservationMasterViewController *)controller observationCollection:(ObservationCollection *)observationCollection
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void) deleteObservation:(ObservationCollection *)observationCollection
{
    NSLog(@"Delete Observation Pressed");
    [self deleteObservationCollection:observationCollection];
}



@end
