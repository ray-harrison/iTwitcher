    //
//  BirdInfoViewController.m
//  iTwitcher
//
//  Created by Ray Harrison on 2/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BirdInfoViewController.h"


@implementation BirdInfoViewController
@synthesize birdInfoView = _birdInfoView;
@synthesize speciesName=_speciesName;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
 - (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
 self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
 if (self) {
 // Custom initialization.
 }
 return self;
 }
 */

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	[super viewDidLoad];
	
	
//	CGRect webFrame = [[UIScreen mainScreen] applicationFrame];
	//webFrame.origin.y += kTopMargin + 5.0;	// leave from the URL input field and its label
//	webFrame.size.height -= 40.0;
//	self.birdInfoView = [[UIWebView alloc] initWithFrame:webFrame];
//	self.birdInfoView.backgroundColor = [UIColor whiteColor];
//	self.birdInfoView.scalesPageToFit = YES;
//	self.birdInfoView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
	
	
	
//	self.birdInfoView.delegate = self;
//	[self.view addSubview:self.birdInfoView];
    self.title = self.speciesName;
	NSLog(@"Bird Info View %@",[self title]);
	
	NSString *unescapedString = [[NSString alloc] initWithString:[self title]];
    
    if ([unescapedString isEqualToString:@"Merlin"]) {
        unescapedString = @"Merlin_(bird)";
    }
    
    if ([unescapedString isEqualToString:@"Redhead"]) {
        unescapedString = @"Redhead_(bird)";
    }
    
	unescapedString =  [unescapedString stringByReplacingOccurrencesOfString:@" " withString:@"_"];
	
	NSLog(@"Bird Info Mutable %@",[unescapedString stringByReplacingOccurrencesOfString:@" " withString:@"_"]);
	
    
	NSString *urlWikipedia = @"http://en.m.wikipedia.org/wiki/";
	NSString *urlAddress = [urlWikipedia stringByAppendingString:unescapedString];
	//NSString *urlAddress = @"http://www.wikipedia.org";
	NSLog(@"Wikipedia URL %@",urlAddress);
	
	
	//Create a URL object.
	NSURL *url = [NSURL URLWithString:urlAddress];
	
	//URL Requst Object
	NSURLRequest *requestObj = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:10];
	
	//Load the request in the UIWebView.
	[self.birdInfoView loadRequest:requestObj];
	
    //[super viewDidLoad];
	
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return YES;
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}


- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}




#pragma mark -
#pragma mark UIViewController delegate methods

- (void)viewWillAppear:(BOOL)animated
{
	self.birdInfoView.delegate = self;	// setup the delegate as the web view is shown
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.birdInfoView stopLoading];	// in case the web view is still loading its content
	self.birdInfoView.delegate = nil;	// disconnect the delegate as the webview is hidden
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}



// this helps dismiss the keyboard when the "Done" button is clicked
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[textField resignFirstResponder];
	[self.birdInfoView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[textField text]]]];
	
	return YES;
}


#pragma mark -
#pragma mark UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView
{
	// starting the load, show the activity indicator in the status bar
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
	// finished loading, hide the activity indicator in the status bar
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
	// load error, hide the activity indicator in the status bar
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	
	// report the error inside the webview
	NSString* errorString = [NSString stringWithFormat:
							 @"<html><center><font size=+5 color='red'>An error occurred:<br>%@</font></center></html>",
							 error.localizedDescription];
	[self.birdInfoView loadHTMLString:errorString baseURL:nil];
}



- (IBAction)done:(id)sender {
  
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
