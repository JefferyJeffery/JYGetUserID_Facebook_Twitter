//
//  TWitterSession.m
//  JYGetUserID_Facebook_Twitter
//
//  Created by Jeffery on 2014/8/21.
//  Copyright (c) 2014年 Jeffery. All rights reserved.
//

#import "TWitterSession.h"

@implementation TWitterSession
{
    STTwitterAPI *twitterWithOAuth;
}

#pragma mark Singleton Methods

+ (TWitterSession *)sharedManager {
    static id sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (id)init {
    if (self = [super init]) {

    }
    return self;
}

- (void)dealloc {
    // Should never be called, but just here for clarity really.
}

+(STTwitterAPI *)twitterWithOAuth
{
    TWitterSession *session = [TWitterSession sharedManager];
    
    if (nil == session->twitterWithOAuth) {
        session->twitterWithOAuth = [STTwitterAPI twitterAPIWithOAuthConsumerKey:@"qyGUerIzpXCcSgWpaUP9meJix"
                                                                  consumerSecret:@"cltu4fqXrS6sKdqbTLBGFpC5LHb5F90ClaV2LJL1JEHtIdfIgx"];
    }
    
    return session->twitterWithOAuth;
}

@end
