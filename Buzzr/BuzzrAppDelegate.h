//
//  BuzzrAppDelegate.h
//  Buzzr
//
//  Created by Conor Eby on 11/21/13.
//  Copyright (c) 2013 Conor Eby. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface BuzzrAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) AVAudioPlayer *player;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@end
