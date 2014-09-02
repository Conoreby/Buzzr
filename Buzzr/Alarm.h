//
//  Alarm.h
//  Buzzr
//
//  Created by Conor Eby on 11/25/13.
//  Copyright (c) 2013 Conor Eby. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Alarm : NSManagedObject

@property (nonatomic, retain) NSDate * alarmid;
@property (nonatomic, retain) NSString * label;
@property (nonatomic, retain) NSNumber * playSong;
@property (nonatomic, retain) NSString * song;
@property (nonatomic, retain) NSDate * time;
@property (nonatomic, retain) NSNumber * vibrate;
@property (nonatomic, retain) NSNumber * enabled;
@property (nonatomic, retain) NSNumber * notificationID;

@end
