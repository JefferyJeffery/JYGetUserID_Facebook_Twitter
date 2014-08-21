//
//  JYTiwterUSERIDViewModal.m
//  JYGetUserID_Facebook_Twitter
//
//  Created by Jeffery on 2014/8/20.
//  Copyright (c) 2014年 Jeffery. All rights reserved.
//

#import "JYTiwterUSERIDViewModal.h"

@interface JYTiwterUSERIDViewModal()

@end

@implementation JYTiwterUSERIDViewModal
-(RACCommand *)getUserIDCommand
{
    if (nil == _getUserIDCommand) {
        _getUserIDCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            
            return [self readFromSafari];
            
            //            [[self readFromAccountStore] filter:^BOOL(NSArray *accounts) {
            //
            //                if (<#condition#>) {
            //                    <#statements#>
            //                }
            //            }]
            
        }];
    }
    
    return _getUserIDCommand;
}

-(RACSignal *)readFromAccountStore
{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        // Retrieve the user information
        ACAccountStore *accountStore = [ACAccountStore new];
        // Request access to the user's Twitter accounts
        ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
        
        [accountStore requestAccessToAccountsWithType:accountType options:nil completion:^(BOOL granted, NSError *error){
            
            if (error) {
                [subscriber sendError:error];
            } else {
                
                // If the user allowed access (or previously allowed access), "granted" will be YES
                if (granted)
                {
                    // Fetch the accounts previously requested (remember, we're only requesting Twitter accounts)
                    NSArray *accounts = [accountStore accountsWithAccountType:accountType];
                    
                    if (accounts.count>0)
                    {
                        // It's important to note that a user may have more than one Twitter account
                        // It's up to you to create an interface that allows the user to choose which Twitter account he/she wants to use
                        // In this example, we'll just use the first one.
                        ACAccount *twitterAccount = [accounts objectAtIndex:0];
                        
                        NSLog(@"twitterAccount.username = %@",twitterAccount.username);
                        
                        NSLog(@"user_id = %@",[twitterAccount valueForKeyPath:@"properties.user_id"]);
                        //                NSLog(@"twitterAccount.identifier = %@",twitterAccount.);
                        // Create an agent object
                        //                TCAgent *agent = [TCAgent agentWithName:nil andMbox:nil];
                        //                TCAccount *account = [TCAccount accountWithID:twitterAccount.username forHomePage:@"http://twitter.com"];
                        
                        //                agent.account = account;
                        
                        // Do something with the agent object...
                        [subscriber sendNext:accounts];
                    } else {
                        [subscriber sendNext:nil];
                    }
                } else {
                    [subscriber sendNext:nil];
                }
            
                [subscriber sendCompleted];
            }
        }];
        
        return nil;
    }];
}

-(RACSignal *)readFromSafari
{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        [[TWitterSession twitterWithOAuth] postTokenRequest:^(NSURL *url, NSString *oauthToken) {
            
            NSLog(@"-- url: %@", url);
            NSLog(@"-- oauthToken: %@", oauthToken);
            
            [[UIApplication sharedApplication] openURL:url];
            
            [subscriber sendCompleted];
            
        }
                 authenticateInsteadOfAuthorize:NO
                                     forceLogin:@(YES)
                                     screenName:nil
                                  oauthCallback:@"myapp://twitter_access_tokens/"
                                     errorBlock:^(NSError *error) {
                                         
                                         NSLog(@"-- error: %@", error);
                                         [subscriber sendError:error];
        }];
        
        
        return nil;
    }];
}





@end
