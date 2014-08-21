//
//  AppDelegate.m
//  JYGetUserID_Facebook_Twitter
//
//  Created by Jeffery on 2014/8/20.
//  Copyright (c) 2014年 Jeffery. All rights reserved.
//

#import "AppDelegate.h"
#import "JYMainViewController.h"
#import "JYTiwterUSERIDViewController.h"

@interface AppDelegate()

@end


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = [[JYMainViewController alloc] init];
    [self.window makeKeyAndVisible];
    
    return YES;
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
    
    [self FaceBookHandleDidBecomeActive];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

// During the Facebook login flow, your app passes control to the Facebook iOS app or Facebook in a mobile browser.
// After authentication, your app will be called back with the session information.
// Override application:openURL:sourceApplication:annotation to call the FBsession object that handles the incoming URL
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    if ([[url scheme] isEqualToString:@"myapp"] == NO) {
        return [self FaceBookHandleOpenURL:url];
    } else {
        
        NSMutableDictionary *md = [NSMutableDictionary dictionary];
        
        NSArray *queryComponents = [[url query] componentsSeparatedByString:@"&"];
        
        for(NSString *s in queryComponents) {
            NSArray *pair = [s componentsSeparatedByString:@"="];
            if([pair count] != 2) continue;
            
            NSString *key = pair[0];
            NSString *value = pair[1];
            
            md[key] = value;
        }
        
//        NSString *token = md[@"oauth_token"];
        NSString *verifier = md[@"oauth_verifier"];
        
        [[TWitterSession twitterWithOAuth] postAccessTokenRequestWithPIN:verifier successBlock:^(NSString *oauthToken, NSString *oauthTokenSecret, NSString *userID, NSString *screenName) {
            NSLog(@"-- screenName: %@", screenName);
            NSLog(@"-- userID: %@", userID);
            
            [TWitterSession sharedManager].oauthToken = oauthToken;
            [TWitterSession sharedManager].oauthTokenSecret = oauthTokenSecret;
            [TWitterSession sharedManager].userID = userID;
            [TWitterSession sharedManager].screenName = screenName;
            
            [[NSNotificationCenter defaultCenter] postNotificationName:JYTwitterUserIDViewOAuthSccuessNotification object:[TWitterSession sharedManager]];
            
        } errorBlock:^(NSError *error) {
            NSLog(@"-- %@", [error localizedDescription]);
        }];
        
        
        return YES;
    }
}

#pragma mark - FaceBook
// During the Facebook login flow, your app passes control to the Facebook iOS app or Facebook in a mobile browser.
// After authentication, your app will be called back with the session information.
// Override application:openURL:sourceApplication:annotation to call the FBsession object that handles the incoming URL
- (BOOL)FaceBookHandleOpenURL:(NSURL *)url
{
    return [FBSession.activeSession handleOpenURL:url];
}

- (void)FaceBookHandleDidBecomeActive
{
    
    // Handle the user leaving the app while the Facebook login dialog is being shown
    // For example: when the user presses the iOS "home" button while the login dialog is active
    [FBAppCall handleDidBecomeActive];
}

@end
