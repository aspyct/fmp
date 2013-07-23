//
//  FPAppDelegate.m
//  fmp
//
//  Created by Antoine d Otreppe on 23/07/13.
//  Copyright (c) 2013 Aspyct. All rights reserved.
//

#import "FPAppDelegate.h"

#import "FPPasswordEncoder.h"

@interface FPAppDelegate ()

@property (weak) IBOutlet NSSecureTextField *masterPasswordField;
@property (weak) IBOutlet NSTextField *hostField;
@property (weak) IBOutlet NSSecureTextField *passwordField;
@property (weak) IBOutlet NSTextField *generatedPasswordField;
@property (weak) IBOutlet NSButton *clipboardCheckbox;
@property (weak) IBOutlet NSButton *exitCheckbox;

@end

@implementation FPAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    [self recoverPreferences];
    
    [[NSAppleEventManager sharedAppleEventManager] setEventHandler:self andSelector:@selector(handleAppleEvent:withReplyEvent:) forEventClass:kInternetEventClass andEventID:kAEGetURL];
    
    [self.hostField becomeFirstResponder];
}

- (void)handleAppleEvent:(NSAppleEventDescriptor *)event withReplyEvent:(NSAppleEventDescriptor *)replyEvent {
    NSString *urlString = [[event paramDescriptorForKeyword:keyDirectObject] stringValue];
    NSURL *url = [NSURL URLWithString:urlString];
    
    self.hostField.stringValue = url.host;
    [self.passwordField becomeFirstResponder];
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender {
    return YES;
}

- (IBAction)doGeneratePassword:(id)sender {
    if ([self allDataAvailable]) {
        NSString *generated = [self generatePasswordNow];
        self.generatedPasswordField.stringValue = generated;
        
        if (self.clipboardCheckbox.state == NSOnState) {
            NSPasteboard *pboard = [NSPasteboard generalPasteboard];
            [pboard clearContents];
            [pboard writeObjects:@[generated]];
            
            if (self.exitCheckbox.state == NSOnState) {
                [NSApp terminate:self];
            }
        }
    }
}

- (BOOL)allDataAvailable {
    return [self notNilNotEmpty:self.masterPasswordField.stringValue] &&
           [self notNilNotEmpty:self.passwordField.stringValue] &&
           [self notNilNotEmpty:self.hostField.stringValue];
}

- (BOOL)notNilNotEmpty:(NSString *)string {
    return !(string == nil || [string isEqualToString:@""]);
}

- (NSString *)generatePasswordNow {
    FPPasswordEncoder *encoder = [[FPPasswordEncoder alloc] init];
    return [encoder generateWithPassword:self.passwordField.stringValue
                                    host:self.hostField.stringValue
                                  master:self.masterPasswordField.stringValue];
}

- (void)savePreferences {
    [self saveClipboardPreferences];
    [self saveExitPreferences];
    [self saveMasterInKeychain];
}

- (void)recoverPreferences {
    if (![self preferencesExist]) {
        [self createPreferences];
    }
    
    [self recoverMasterFromKeychain];
    [self recoverExitPreferences];
    [self recoverClipboardPreferences];
    
    [self adjustCheckboxes];
}

#define FP_PREFERENCES_EXIST @"FP_PREFERENCES_EXIST"
- (BOOL)preferencesExist {
    return [[NSUserDefaults standardUserDefaults] boolForKey:FP_PREFERENCES_EXIST];
}

- (void)createPreferences {
    [self createClipboardPreferences];
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:FP_PREFERENCES_EXIST];
}
#undef FP_PREFERENCES_EXIST

#define FP_CLIPBOARD_PREFERENCES @"FP_CLIPBOARD_PREFERENCE"
- (void)createClipboardPreferences {
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:FP_CLIPBOARD_PREFERENCES];
}

- (void)saveClipboardPreferences {
    [[NSUserDefaults standardUserDefaults] setBool:(self.clipboardCheckbox.state == NSOnState) forKey:FP_CLIPBOARD_PREFERENCES];
}

- (void)recoverClipboardPreferences {
    if ([[NSUserDefaults standardUserDefaults] boolForKey:FP_CLIPBOARD_PREFERENCES]) {
        self.clipboardCheckbox.state = NSOnState;
    }
    else {
        self.clipboardCheckbox.state = NSOffState;
    }
}
#undef FP_CLIPBOARD_PREFERENCE

#define FP_EXIT_PREFERENCES @"FP_EXIT_PREFERENCES"
- (void)createExitPreferences {
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:FP_EXIT_PREFERENCES];
}

- (void)saveExitPreferences {
    [[NSUserDefaults standardUserDefaults] setBool:(self.exitCheckbox.state == NSOnState) forKey:FP_EXIT_PREFERENCES];
}

- (void)recoverExitPreferences {
    if ([[NSUserDefaults standardUserDefaults] boolForKey:FP_EXIT_PREFERENCES]) {
        self.exitCheckbox.state = NSOnState;
    }
    else {
        self.exitCheckbox.state = NSOffState;
    }
}
#undef FP_EXIT_PREFERENCES

- (void)saveMasterInKeychain {
    
}

- (void)recoverMasterFromKeychain {
    
}

- (IBAction)doChangeClipboardState:(id)sender {
    [self adjustCheckboxes];
    [self saveClipboardPreferences];
}

- (IBAction)doChangeExitState:(id)sender {
    [self saveExitPreferences];
}

- (void)adjustCheckboxes {
    self.exitCheckbox.enabled = self.clipboardCheckbox.state == NSOnState;
    
    if (self.clipboardCheckbox.state == NSOffState) {
        self.exitCheckbox.state = NSOffState;
    }
    else {
        [self recoverExitPreferences];
    }
}

@end
