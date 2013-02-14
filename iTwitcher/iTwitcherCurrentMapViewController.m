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
#define METERS_PER_MILE 1609.344

@interface iTwitcherCurrentMapViewController () {
    NSMutableArray *_locations;
    NSMutableArray *_annotations;
    
    iTwitcherObservationAnnotation *_droppedPin;
    SpeciesObservation *_currentObservation;
    ObservationLocation *_birdLocation;
    ObservationCollection *_birdCollection;
}

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLLocation *currentLocation;
@property (nonatomic) BOOL iAdBannerIsVisible;

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
}

-(void) viewDidAppear:(BOOL)animated
{
    NSLog(@"Vide Did Appear");
    [self zoomToCurrentLocation];
    
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
            // [rightButton addTarget:self action:@selector(myShowDetailsMethod:)
            // forControlEvents:UIControlEventTouchUpInside];
            pinView.rightCalloutAccessoryView = rightButton;
        }
        else
            pinView.annotation = annotation;
        
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
        
        
        
    } else return nil;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)aView
{
    // UIImage *image = [self.delegate mapViewController:self imageForAnnotation:aView.annotation];
    NSLog(@"Did select annotation view");
    [(UIImageView *)aView.leftCalloutAccessoryView setImage:nil];
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    
    if ([view.annotation isKindOfClass:[iTwitcherObservationAnnotation class]]) {
        NSLog(@"Annotation isKindOfClass iBirderObservationAnnotation");
        iTwitcherObservationAnnotation *observationAnnotation = view.annotation;
        self.currentObservationCoordinate = observationAnnotation.coordinate;
        
        _currentObservation =
        [SpeciesObservation getObservationInContext:[self.birdDatabase managedObjectContext]
                                         byLatitude:[NSNumber numberWithFloat:observationAnnotation.coordinate.latitude]
                                       andLongitude:[NSNumber numberWithFloat:observationAnnotation.coordinate.longitude]];
        
        _birdCollection = [ObservationCollection getObservationCollectionInContext:[self.birdDatabase managedObjectContext]
                                                                        byLatitude:[NSNumber numberWithFloat:observationAnnotation.coordinate.latitude]
                                                                      andLongitude:[NSNumber numberWithFloat:observationAnnotation.coordinate.longitude]];
        
        if (!_birdCollection) {
            _birdCollection = [[ObservationCollection alloc] initWithContext:[self.birdDatabase managedObjectContext] byName:@"New Collection"];
        }
        
        
       // [self performSegueWithIdentifier:@"AddBirds" sender:self];
        [self performSegueWithIdentifier:@"addCollectionAtLocation" sender:self];
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
    } else {
        // MapPlayAnnotation *annotation = (MapPlayAnnotation *)view.annotation;
    }
}


- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay {
	if([overlay isKindOfClass:[MKCircle class]]) {
		// Create the view for the radius overlay.
		MKCircleView *circleView = [[MKCircleView alloc] initWithOverlay:overlay];
		circleView.strokeColor = [UIColor greenColor];
		circleView.fillColor = [[UIColor greenColor] colorWithAlphaComponent:0.3];
		
		return circleView;
	}
	
	return nil;
}


#pragma mark - iTwitcherMapDetailsDelegate
-(void) didChooseMapType:(iTwitcherMapDetailsViewController *)controller selectedSegmentedIndex:(NSInteger)index
{
    
    NSLog(@"Did Choose Map Type");
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


// The Map View Controller maintains the annotations and displays any existing observations
// and passes down through the children view controllers

- (void)handleLongPress:(UIGestureRecognizer*)recogniser {
    // 1
    if (recogniser.state == UIGestureRecognizerStateBegan) {
        // 2
      
    
        CGPoint touchPoint = [recogniser locationInView:self.mapView];
        CLLocationCoordinate2D touchMapCoordinate = [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];

        
        SpeciesObservation *observation = [[SpeciesObservation alloc] initWithContext:_birdDatabase.managedObjectContext];
        observation.latitude = @(touchMapCoordinate.latitude);
        observation.longitude = @(touchMapCoordinate.longitude);
        
        NSDate *date = [NSDate date];
        observation.date = date;
        
        if (![self observationInHotspot:touchMapCoordinate]) {
            // Create a basic ObservationLocation
            NSLog(@"Setting Default Bird Location");
           _birdLocation = [self defaultObservationLocation];
            NSLog(@"Set Default Bird Location");
            CLLocationCoordinate2D observationLocationCoordinate = CLLocationCoordinate2DMake([_birdLocation.centerLatitude floatValue], [_birdLocation.centerLongitude floatValue]);
            iTwitcherLocationAnnotation *locationAnnotation = [[iTwitcherLocationAnnotation alloc] initWithLocation:_birdLocation coordinate:observationLocationCoordinate radius:[_birdLocation.radius floatValue]];
            
            
            
            
     
            
            
            [self.mapView addAnnotation:locationAnnotation];
            //[location addSpeciesObservationsObject:observation];
            
        } else {
            _birdLocation = [self hotspotForObservationCoordinate:touchMapCoordinate];
         //   [_birdLocation addSpeciesObservationsObject:observation];
            CLLocationCoordinate2D observationLocationCoordinate = CLLocationCoordinate2DMake([_birdLocation.centerLatitude floatValue], [_birdLocation.centerLongitude floatValue]);
            iTwitcherLocationAnnotation *locationAnnotation = [[iTwitcherLocationAnnotation alloc] initWithLocation:_birdLocation coordinate:observationLocationCoordinate radius:[_birdLocation.radius floatValue]];
            [self.mapView addAnnotation:locationAnnotation];
        }
        
        
        // format it
        //  NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
        //  [dateFormat setDateFormat:@"HH:mm:ss zzz"];
        
        // convert it to a string
        //  NSString *dateString = [dateFormat stringFromDate:date];
        
        
       
        
       // [_birdLocation addSpeciesObservationsObject:observation];
        _droppedPin = [[iTwitcherObservationAnnotation alloc] annotationForObservation:observation];
        _droppedPin.coordinate = touchMapCoordinate;
       
        // get the current date
        
        
        
        
        [_annotations addObject:_droppedPin];
        [self.mapView addAnnotation:_droppedPin];
        [self.mapView setCenterCoordinate:self.mapView.region.center animated:NO];
        [self loadData];
 
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
        iTwitcherSpeciesObservationMasterViewController *observationMasterController = (iTwitcherSpeciesObservationMasterViewController *)[navigationController.childViewControllers objectAtIndex:0];
        observationMasterController.observationMasterDelegate = self;
        observationMasterController.birdDatabase = self.birdDatabase;
        observationMasterController.location = self.currentObservationCoordinate;
        observationMasterController.observationCollection = _birdCollection;
        
       
        
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
    if (!self.iAdBannerIsVisible)
    {
        [UIView beginAnimations:@"animateAdBannerOn" context:NULL];
        // Assumes the banner view is just off the bottom of the screen.
        bannerView.frame = CGRectOffset(bannerView.frame, 0, -bannerView.frame.size.height);
        [UIView commitAnimations];
        self.iAdBannerIsVisible = YES;
    }
    
    
}

- (void)bannerView:(ADBannerView *)bannerView didFailToReceiveAdWithError:(NSError *)error{
    if (self.iAdBannerIsVisible)
    {
        [UIView beginAnimations:@"animateAdBannerOff" context:NULL];
        // Assumes the banner view is placed at the bottom of the screen.
        bannerView.frame = CGRectOffset(bannerView.frame, 0, bannerView.frame.size.height);
        [UIView commitAnimations];
        self.iAdBannerIsVisible = NO;
    }
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
    CLLocation *location = [self.locationManager location];
    
    __block ObservationLocation *observationLocation = [[ObservationLocation alloc] initWithContext:[self.birdDatabase managedObjectContext] name:@"My New Location"];
    observationLocation.radius = [NSNumber numberWithInt:500];
    observationLocation.centerLatitude = [NSNumber numberWithFloat:location.coordinate.latitude];
    observationLocation.centerLongitude = [NSNumber numberWithFloat:location.coordinate.longitude];
    
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
@end
