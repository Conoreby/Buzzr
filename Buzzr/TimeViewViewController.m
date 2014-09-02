//
//  TimeViewViewController.m
//  Buzzr
//
//  Created by Conor Eby on 11/23/13.
//  Copyright (c) 2013 Conor Eby. All rights reserved.
//

#import "TimeViewViewController.h"
#import "TimeView.h"
#import "BuzzrAppDelegate.h"

@interface TimeViewViewController ()
@property (weak, nonatomic) IBOutlet TimeView *timeViewer;
@property (weak, nonatomic) IBOutlet UILabel *weatherLabel;
@property (weak, nonatomic) IBOutlet UIImageView *weatherIcon;
@property (strong, nonatomic) CLLocationManager *locationManager;
@end

@implementation TimeViewViewController
- (IBAction)touchedRefresh:(id)sender {
	[self setCurrentWeather];
}

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
	// Do any additional setup after loading the view, typically from a nib.
	
	NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
	[dateFormat setDateFormat:@"hh:mm"];
	NSDate* currentDate = [NSDate date];
	self.timeViewer.time = [dateFormat stringFromDate:currentDate];
	
	[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateTime) userInfo:nil repeats:YES];
	
	self.locationManager = [[CLLocationManager alloc] init];
	self.locationManager.distanceFilter = kCLDistanceFilterNone;
	self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
	[self.locationManager startUpdatingLocation];
	}


-(void)updateTime{
	NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
	[dateFormat setDateFormat:@"hh:mm"];
	NSDate* currentDate = [NSDate date];
	self.timeViewer.time = [dateFormat stringFromDate:currentDate];
}



-(void) setCurrentWeather
{
	NSURL *weatherUrl = [WeatherFetcher URLforWeatherAtLatitude:self.locationManager.location.coordinate.latitude atLongitude:self.locationManager.location.coordinate.longitude];
    // create a (non-main) queue to do fetch on
    dispatch_queue_t weatherQ = dispatch_queue_create("weather fetcher", NULL);
    // put a block to do the fetch onto that queue
    dispatch_async(weatherQ, ^{
        // fetch the JSON data from WorldWeatherOnline
        NSData *jsonResults = [NSData dataWithContentsOfURL:weatherUrl];
        // convert it to a Property List (NSArray and NSDictionary)
        NSDictionary *propertyListResults = [NSJSONSerialization JSONObjectWithData:jsonResults
                                                                            options:0
                                                                              error:NULL];
		
		NSString *currentWeatherText = [NSString stringWithFormat:@"Temperature: %@F\n%@", [[propertyListResults valueForKeyPath:WEATHER_RESULTS_CURRENT_TEMPERATURE_F] firstObject], [[[propertyListResults valueForKeyPath:WEATHER_RESULTS_CURRENT_CONDITION] firstObject] firstObject]];
		dispatch_async(dispatch_get_main_queue(), ^{ self.weatherLabel.text = currentWeatherText; });
		
		
		NSURL *iconURL = [WeatherFetcher URLforCurrentWeatherIcon:propertyListResults];
		[self setCurrentWeatherIconWithURL: iconURL];
	});
}

- (void)setCurrentWeatherIconWithURL:(NSURL *) iconURL
{
	self.weatherIcon.image = nil;
	
	if (iconURL) {
		NSURLRequest *request = [NSURLRequest requestWithURL:iconURL];
        
        // another configuration option is backgroundSessionConfiguration (multitasking API required though)
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration ephemeralSessionConfiguration];
        
        // create the session without specifying a queue to run completion handler on (thus, not main queue)
        // we also don't specify a delegate (since completion handler is all we need)
        NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
		
        NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request
														completionHandler:^(NSURL *localfile, NSURLResponse *response, NSError *error) {
															// this handler is not executing on the main queue, so we can't do UI directly here
															if (!error) {
																if ([request.URL isEqual:iconURL]) {
																	// UIImage is an exception to the "can't do UI here"
																	UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:localfile]];
																	// but calling "self.image =" is definitely not an exception to that!
																	// so we must dispatch this back to the main queue
																	dispatch_async(dispatch_get_main_queue(), ^{ self.weatherIcon.image = image; });
																}
															}
														}];
        [task resume]; // don't forget that all NSURLSession tasks start out suspended!

	}
}

- (void)viewDidAppear:(BOOL)animated
{
	//Update the current weather
	[self setCurrentWeather];
	
	if (self.alarmTriggered) {
		UIAlertView *alarmAlert = [[UIAlertView alloc] initWithTitle:@"Alarm" message:@"Press dismiss to stop alarm" delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil];
		[alarmAlert show];
		
		
		//Animation taken from StackOverflow http://stackoverflow.com/questions/7023904/iphone-wobbly-animation-on-uiimageview
		CABasicAnimation* anim = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
		[anim setToValue:[NSNumber numberWithFloat:0.0f]];
		[anim setFromValue:[NSNumber numberWithDouble:M_PI/16]]; // rotation angle
		[anim setDuration:0.1];
		[anim setRepeatCount:NSUIntegerMax];
		[anim setAutoreverses:YES];
		[self.timeViewer.layer addAnimation:anim forKey:@"iconShake"];
		//** End of block
		
		[NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(makeVibrate) userInfo:nil repeats:YES];
	}
}


-(void)makeVibrate
{
	if (self.vibrate) {
		AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
	} else {
		
	}
}


- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == 0) {
		BuzzrAppDelegate *appD = (BuzzrAppDelegate *)[[UIApplication sharedApplication] delegate];
		[appD.player stop];
		[self.timeViewer.layer removeAllAnimations];
		self.alarmTriggered = NO;
		[self setCurrentWeather];
		self.vibrate = NO;
	}
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
