//
//  JYFBUSERIDViewModal.h
//  JYGetUserID_Facebook_Twitter
//
//  Created by Jeffery on 2014/8/20.
//  Copyright (c) 2014年 Jeffery. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JYFBUSERIDViewModal : NSObject
@property (nonatomic,strong)FBSession *session;
@property (nonatomic,assign)FBSessionState state;

@property (nonatomic,strong) RACCommand *fbBtnCmd;

-(void)FaceBookOpenActiveSessionWithCompletionHandler:(FBSessionStateHandler)handler;
@end
