//
//  JYFBUSERIDViewModal.m
//  JYGetUserID_Facebook_Twitter
//
//  Created by Jeffery on 2014/8/20.
//  Copyright (c) 2014年 Jeffery. All rights reserved.
//

#import "JYFBUSERIDViewModal.h"

@implementation JYFBUSERIDViewModal

-(id)init
{
    self = [super init];
    
    if (self) {
        
    }
    
    return self;
}

#pragma mark - FaceBook
-(RACCommand *)fbBtnCmd
{
    if (nil == _fbBtnCmd) {
        @weakify(self);
        _fbBtnCmd = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                
                // If the session state is any of the two "open" states when the button is clicked
                if (FBSession.activeSession.state == FBSessionStateOpen
                    || FBSession.activeSession.state == FBSessionStateOpenTokenExtended) {
                    
                    // Close the session and remove the access token from the cache
                    // The session state handler (in the app delegate) will be called automatically
                    [FBSession.activeSession closeAndClearTokenInformation];
                    
                    
                    self.session = nil;
                    self.state = FBSession.activeSession.state;
                    [subscriber sendNext:RACTuplePack(_session,@(_state))];
                    [subscriber sendCompleted];
                    // If the session state is not any of the two "open" states when the button is clicked
                } else {
                    // Open a session showing the user the login UI
                    // You must ALWAYS ask for public_profile permissions when opening a session
                    [FBSession openActiveSessionWithReadPermissions:@[@"public_profile"]
                                                       allowLoginUI:YES
                                                  completionHandler:
                     ^(FBSession *session, FBSessionState state, NSError *error) {
                         
                         @strongify(self);
                         self.session = session;
                         self.state = state;
                         
                         if (error) {
                             [subscriber sendError:error];
                         } else {
                             [subscriber sendNext:RACTuplePack(_session,@(_state))];
                             [subscriber sendCompleted];
                         }
                     }];
                }
                
                return [RACDisposable disposableWithBlock:^{

                }];
            }];
        }];
    }
    
    return _fbBtnCmd;
}

-(void)FaceBookOpenActiveSessionWithCompletionHandler:(FBSessionStateHandler)handler
{
    //    We first check if there's a cached token by examining the active session's state.
    //    If there is a cached token the session state will be FBSessionStateCreatedTokenLoaded.
    //    we can try opening the cached session using the
    //      FBSession openActiveSessionWithReadPermissions:allowLoginUI:completionHandler: method, with allowLoginUI: set to NO
    //    (this will prevent the login dialog from showing).
    //    The other arguments that need to be passed to this method are:
    //
    //        The permissions you're requesting.
    //        The completion handler, which will be called whenever there's a session state change.
    //
    //    When someone connects with an app using Facebook login, the app may access data they have saved on Facebook.
    //    This is done through asking for permissions. Reading data requires asking for read permissions.
    //    Apps also need publish permissions in order to post content on the user's behalf.
    //    If you want to know more about permissions, you can check out our permissions section.
    
    // Whenever a person opens the app, check for a cached session
    
    @weakify(self);
    if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded) {
        NSLog(@"Found a cached session");
        // If there's one, just open the session silently, without showing the user the login UI
        [FBSession openActiveSessionWithReadPermissions:@[@"public_profile"]
                                           allowLoginUI:NO
                                      completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {\
                                          @strongify(self);
                                          self.session = session;
                                          self.state = state;
                                          
                                          if (handler) {
                                              handler(_session,_state,error);
                                          }
                                      }];
        
    } else {
        // If there's no cached session, we will show a login button
        self.session = nil;
        self.state = FBSession.activeSession.state;
      
        if (handler) {
            handler(_session,_state,nil);
        }
        
//        UIButton *loginButton = [self.customLoginViewController loginButton];
//        [loginButton setTitle:@"Log in with Facebook" forState:UIControlStateNormal];
    }
}
@end
