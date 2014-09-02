//
//  AddAlarmViewController.h
//  Buzzr
//
//  Created by Conor Eby on 11/24/13.
//  Copyright (c) 2013 Conor Eby. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "Alarm+Create.h"

@interface AddAlarmViewController : UIViewController <MPMediaPickerControllerDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIDatePicker *alarmTime;
@property (weak, nonatomic) IBOutlet UISwitch *vibrateEnableSwitch;
@property (strong, nonatomic) NSString *labelText;
@property (strong, nonatomic) MPMediaItem *chosenSong;
@property (weak, nonatomic) IBOutlet UILabel *chosenSongLabel;
@property (weak, nonatomic) IBOutlet UITextField *labelTextField;

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

- (NSDate *) getAlarmId;

@end
