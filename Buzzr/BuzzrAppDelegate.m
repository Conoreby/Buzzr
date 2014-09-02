//
//  BuzzrAppDelegate.m
//  Buzzr
//
//  Created by Conor Eby on 11/21/13.
//  Copyright (c) 2013 Conor Eby. All rights reserved.
//

#import "BuzzrAppDelegate.h"
#import <CoreData/CoreData.h>
#import "Alarm.h"
#import <MediaPlayer/MediaPlayer.h>
#import "TimeViewViewController.h"

@implementation BuzzrAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
	if (!self.managedObjectContext) [self useDocument];
    return YES;
}

- (void)useDocument
{
	NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
	url = [url URLByAppendingPathComponent:@"AlarmsDocument"];
	UIManagedDocument *document = [[UIManagedDocument alloc] initWithFileURL:url];
	
	if (![[NSFileManager defaultManager] fileExistsAtPath:[url path]]) {
		[document saveToURL:url forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success) {
			if (success) {
				self.managedObjectContext = document.managedObjectContext;
			}
			if (!success) NSLog(@"couldn't create document at %@", url);
		}];
	} else if (document.documentState == UIDocumentStateClosed) {
		[document openWithCompletionHandler:^(BOOL success) {
			if (success) {
				self.managedObjectContext = document.managedObjectContext;
			}
		}];
	} else {
		self.managedObjectContext = document.managedObjectContext;
	}
}

-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
	NSDictionary *alarmIdentifier = notification.userInfo;
	NSNumber *notificationID = [alarmIdentifier valueForKeyPath:@"notificationID"];
	NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Alarm"];
	request.predicate = [NSPredicate predicateWithFormat:@"notificationID = %@", notificationID];
	NSError *error;
	Alarm  *alarm = [[self.managedObjectContext executeFetchRequest:request error:&error] firstObject];
	MPMediaQuery *query = [MPMediaQuery songsQuery];
	[query addFilterPredicate:[MPMediaPropertyPredicate predicateWithValue:alarm.song forProperty:MPMediaEntityPropertyPersistentID]];
	MPMediaEntity *song = nil;
	if (alarm.song) {
		if ([query items]) {
			song = [[query items] firstObject];
		}
		if (song) {
			NSURL *songURl = [song valueForProperty:MPMediaItemPropertyAssetURL];
			self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:songURl error:nil];
			[self.player play];
		}
	
	}
	
	//Deactivate the alarm after it goes off
	alarm.enabled = [NSNumber numberWithBool:NO];
	
	self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
	UITabBarController *root = [storyboard instantiateInitialViewController];
	TimeViewViewController *timeView = [root.viewControllers firstObject];
	timeView.alarmTriggered = YES;
	timeView.vibrate = [alarm.vibrate boolValue];
	self.window.rootViewController = root;
	[self.window makeKeyAndVisible];
	
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
	// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
	// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
	// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
	// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
	// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
	// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
