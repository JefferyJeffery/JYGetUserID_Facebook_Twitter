//
//  JYFBUSERIDViewController.m
//  JYGetUserID_Facebook_Twitter
//
//  Created by Jeffery on 2014/8/20.
//  Copyright (c) 2014年 Jeffery. All rights reserved.
//

#import "JYFBUSERIDViewController.h"

#import "JYFBUSERIDViewModal.h"

@interface JYFBUSERIDViewController ()
@property (nonatomic,strong) JYFBUSERIDViewModal *viewModal;
@property (weak, nonatomic) IBOutlet UIButton *fbBtn;
@property (weak, nonatomic) IBOutlet UILabel *userIDLbl;
@end

@implementation JYFBUSERIDViewController

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.viewModal = [[JYFBUSERIDViewModal alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [_viewModal FaceBookOpenActiveSessionWithCompletionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
        [self sessionStateChanged:session state:state error:error];
    }];
    
    [[[_viewModal.fbBtnCmd.executionSignals flatten] reduceEach:^id(FBSession *session, NSNumber *fbSessionState){
        [self sessionStateChanged:session state:(FBSessionState)fbSessionState.integerValue error:nil];
        return nil;
    }] subscribeError:^(NSError *error) {
        [self sessionStateChanged:nil state:0 error:error];
    }];
    
    self.fbBtn.rac_command = _viewModal.fbBtnCmd;
    
}

#pragma mark - private
// This method will handle ALL the session state changes in the app
- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState)state error:(NSError *)error
{
    // Handle errors
    if (error){
        NSLog(@"Error");
        NSString *alertText;
        NSString *alertTitle;
        // If the error requires people using an app to make an action outside of the app in order to recover
        if ([FBErrorUtility shouldNotifyUserForError:error] == YES){
            alertTitle = @"Something went wrong";
            alertText = [FBErrorUtility userMessageForError:error];
            [JYUtils showMessage:alertText withTitle:alertTitle];
        } else {
            
            // If the user cancelled login, do nothing
            if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
                NSLog(@"User cancelled login");
                
                // Handle session closures that happen outside of the app
            } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession){
                alertTitle = @"Session Error";
                alertText = @"Your current session is no longer valid. Please log in again.";
                [JYUtils showMessage:alertText withTitle:alertTitle];
                
                // For simplicity, here we just show a generic message for all other errors
                // You can learn how to handle other errors using our guide: https://developers.facebook.com/docs/ios/errors
            } else {
                //Get more error information from the error
                NSDictionary *errorInformation = [[[error.userInfo objectForKey:@"com.facebook.sdk:ParsedJSONResponseKey"] objectForKey:@"body"] objectForKey:@"error"];
                
                // Show the user an error message
                alertTitle = @"Something went wrong";
                alertText = [NSString stringWithFormat:@"Please retry. \n\n If the problem persists contact us and mention this error code: %@", [errorInformation objectForKey:@"message"]];
                [JYUtils showMessage:alertText withTitle:alertTitle];
            }
        }
        // Clear this token
        [FBSession.activeSession closeAndClearTokenInformation];
        // Show the user the logged-out UI
        [self userLoggedOut];
    } else {
        
        switch (state) {
            case FBSessionStateCreated:
            {
                // If the session is closed
                NSLog(@"Session Created");
                // Show the user the logged-out UI
                [self userLoggedOut];
            }
                break;
            case FBSessionStateOpen:
            {// If the session was opened successfully
                
                NSLog(@"Session opened");
                // Show the user the logged-in UI
                [self userLoggedIn];
                return;
            }
                break;
            case FBSessionStateClosed:
            case FBSessionStateClosedLoginFailed:
            {
                // If the session is closed
                NSLog(@"Session closed");
                // Show the user the logged-out UI
                [self userLoggedOut];
            }
                break;
            default:
                break;
        }
    }
}


// Show the user the logged-out UI
- (void)userLoggedOut
{
    // Set the button title as "Log in with Facebook"
    [self.fbBtn setTitle:@"Log in with Facebook" forState:UIControlStateNormal];
    
    // Confirm logout message
//    [JYUtils showMessage:@"You're now logged out" withTitle:@""];
}

// Show the user the logged-in UI
- (void)userLoggedIn
{
    // Set the button title as "Log out"
    [self.fbBtn setTitle:@"Log out" forState:UIControlStateNormal];
    
    if (FBSession.activeSession.isOpen) {
        
        [[FBRequest requestForMe] startWithCompletionHandler:
         ^(FBRequestConnection *connection,
           NSDictionary<FBGraphUser> *user,
           NSError *error) {
             if (!error) {
//                 NSString *firstName = user.first_name;
//                 NSString *lastName = user.last_name;
//                 NSString *facebookId = user.id;
//                 NSString *email = [user objectForKey:@"email"];
//                 NSString *imageUrl = [[NSString alloc] initWithFormat: @"http://graph.facebook.com/%@/picture?type=large", facebookId];
//                 
//                 NSLog(@"facebookId = %@",facebookId);
                 
                 self.userIDLbl.text = user.objectID;
             }
         }];
    }
    
    // Welcome message
//    [JYUtils showMessage:@"You're now logged in" withTitle:@"Welcome!"];
    
}
@end
