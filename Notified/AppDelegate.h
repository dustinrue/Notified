//
//  AppDelegate.h
//  Notified
//
//  Created by Dustin Rue on 1/12/12.
//  Copyright (c) 2012. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>
{
    NSMutableArray *distributedNotifications;
    NSMutableArray *workspaceNotifications;
    NSDistributedNotificationCenter *dNotification;
    NSNotificationCenter *wNotification;
    NSInteger workspaceLoggerIsRunning;
    NSInteger distributedLoggerIsRunning;

}

@property (assign) IBOutlet NSWindow *window;
@property (readwrite) NSInteger workspaceLoggerIsRunning;
@property (readwrite) NSInteger distributedLoggerIsRunning;
@property (assign,atomic) IBOutlet NSTextView *workspaceLogView;
@property (assign,atomic) IBOutlet NSTextView *distributedLogView;



- (IBAction)toggleWorkspaceLogger:(id)sender;
- (IBAction)toggleDistributedLogger:(id)sender;

- (IBAction)clearWorkspaceLog:(id)sender;
- (IBAction)clearDistributedLog:(id)sender;

- (void)addDistribuedObserver:(NSDistributedNotificationCenter *)distributedNotificationCenter;
- (void)addWorkspaceObserver:(NSNotificationCenter *)notificationCenter;
- (void)removeDistributedObserver:(NSDistributedNotificationCenter *)distributedNotificationCenter;
- (void)removeWorkspaceObserver:(NSNotificationCenter *)notificationCenter;

@end
