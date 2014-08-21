//
//  TWitterSession.h
//  JYGetUserID_Facebook_Twitter
//
//  Created by Jeffery on 2014/8/21.
//  Copyright (c) 2014年 Jeffery. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TWitterSession : NSObject
+(TWitterSession *)sharedManager;
+(STTwitterAPI *)twitterWithOAuth;

@property(nonatomic,strong) NSString *oauthToken;
@property(nonatomic,strong) NSString *oauthTokenSecret;
@property(nonatomic,strong) NSString *userID;
@property(nonatomic,strong) NSString *screenName;

@end
