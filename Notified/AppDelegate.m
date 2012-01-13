//
//  AppDelegate.m
//  Notified
//
//  Created by Dustin Rue on 1/12/12.
//  Copyright (c) 2012. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize workspaceLoggerIsRunning;
@synthesize distributedLoggerIsRunning;
@synthesize workspaceLogView;
@synthesize distributedLogView;




- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    distributedNotifications = [[NSMutableArray alloc] initWithCapacity:0];
    workspaceNotifications   = [[NSMutableArray alloc] initWithCapacity:0];
    
    dNotification = [NSDistributedNotificationCenter defaultCenter];
    wNotification = [NSNotificationCenter defaultCenter];
    [[self workspaceLogView] setContinuousSpellCheckingEnabled:NO];
    [[self distributedLogView] setContinuousSpellCheckingEnabled:NO];
    


}



-(void)didReceiveDistributedNotification:(NSNotification *)notification
{
    if (![self distributedLoggerIsRunning] ) 
        return;
    
    NSTextStorage *distributedLoggerTextStorage = [[self distributedLogView] textStorage];
    NSAttributedString *tmp = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n",[notification name]]];

    [distributedLoggerTextStorage beginEditing];
    [distributedLoggerTextStorage appendAttributedString:tmp];
    [distributedLoggerTextStorage setFont:[NSFont fontWithName:@"Monaco" size:11]];
    [distributedLoggerTextStorage endEditing];

}

-(void)didReceiveWorkspaceNotification:(NSNotification *)notification
{

    if (![self workspaceLoggerIsRunning])
        return;
    
    NSTextStorage *workspaceLoggerTextStorage   = [[self workspaceLogView] textStorage];
    NSAttributedString *tmp = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n",[notification name]]];

    // avoid spamming the display
    if ([[notification name] isEqualToString:@"NSTextStorageDidProcessEditingNotification"] ||
        [[notification name] isEqualToString:@"NSTextStorageWillProcessEditingNotification"] ||
        [[notification name] isEqualToString:@"NSTextViewDidChangeTypingAttributesNotification"] ||
        [[notification name] isEqualToString:@"NSTextViewDidChangeSelectionNotification"] ||
        [[notification name] isEqualToString:@"NSTextViewFrameDidChangeSelectionNotification"] ||
        [[notification name] isEqualToString:@"NSWindowDidUpdateNotification"] ||
        [[notification name] isEqualToString:@"NSApplicationDidUpdateNotification"] ||
        [[notification name] isEqualToString:@"NSMenuDidAddItemNotification"] ||
        [[notification name] isEqualToString:@"NSMenuDidRemoveItemNotification"] ||
        [[notification name] isEqualToString:@"NSMenuDidChangeItemNotification"] ||
        [[notification name] isEqualToString:@"NSApplicationWillUpdateNotification"] ||
        [[notification name] isEqualToString:@"_NSThreadDidStartNotification"] ||
        [[notification name] isEqualToString:@"NSThreadWillExitNotification"])
        return;

    [workspaceLoggerTextStorage beginEditing];
    [workspaceLoggerTextStorage appendAttributedString:tmp];
    [workspaceLoggerTextStorage setFont:[NSFont fontWithName:@"Monaco" size:11]];
    [workspaceLoggerTextStorage endEditing];

    
}

- (IBAction)toggleWorkspaceLogger:(id)sender {
    if ([self workspaceLoggerIsRunning]) {
        [self setWorkspaceLoggerIsRunning:0];
        [self removeWorkspaceObserver:wNotification];
        [sender setTitle:@"Start"];
    }
    else {
        [self setWorkspaceLoggerIsRunning:1];
        [self addWorkspaceObserver:wNotification];
        [sender setTitle:@"Stop"];
    }
 
}



- (IBAction)toggleDistributedLogger:(id)sender {
    if ([self distributedLoggerIsRunning]) {
        [self setDistributedLoggerIsRunning:0];
        [self removeDistributedObserver:dNotification];
        [sender setTitle:@"Start"];
    }
    else {
        [self setDistributedLoggerIsRunning:1];
        [self addDistribuedObserver:dNotification];
        [sender setTitle:@"Stop"];
    }
}

- (void)addDistribuedObserver:(NSDistributedNotificationCenter *)distributedNotificationCenter
{
    [distributedNotificationCenter addObserver:self selector:@selector(didReceiveDistributedNotification:) name:nil object:nil];
}

- (void)addWorkspaceObserver:(NSNotificationCenter *)notificationCenter
{
    [notificationCenter addObserver:self  selector:@selector(didReceiveWorkspaceNotification:) name:nil object:nil];
}

- (void)removeDistributedObserver:(NSDistributedNotificationCenter *)distributedNotificationCenter
{
    [distributedNotificationCenter removeObserver:self name:nil object:nil];
}

- (void)removeWorkspaceObserver:(NSNotificationCenter *)notificationCenter
{
    [notificationCenter removeObserver:self name:nil object:nil];
}

- (IBAction)clearDistributedLog:(id)sender {
    NSTextStorage *textStorage = [distributedLogView textStorage];
    
    [self removeDistributedObserver:dNotification];
    [textStorage beginEditing];
    [textStorage replaceCharactersInRange:NSMakeRange(0,[textStorage length]) withString:@""];
    [textStorage endEditing];
    [self addDistribuedObserver:dNotification];
}

- (IBAction)clearWorkspaceLog:(id)sender {
    NSTextStorage *textStorage = [workspaceLogView textStorage];
    [self removeWorkspaceObserver:wNotification];
    [textStorage beginEditing];
    [textStorage replaceCharactersInRange:NSMakeRange(0, [textStorage length]) withString:@""];
    [textStorage endEditing];
    [self addWorkspaceObserver:wNotification];
}
@end
