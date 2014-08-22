JYGetUserID_Facebook_Twitter
============================

Get UserID from Facebook and Twitter, SSO


### Twitter:
1. Ref https://dev.twitter.com/docs/twitter-libraries
   The used Library is STTwitter (https://github.com/nst/STTwitter)

create Twitter application:
1. https://apps.twitter.com/
2. Callback URL needs fill URL, it can any thing. (https://github.com/nst/STTwitter/issues/93)

### Facebook
Implementing your custom login UI using API calls. 
- Prerequisites：
1. Your environment set up
2. A Facebook app properly configured and linked to your iOS app, with Single Sign On enabled
3. The Facebook SDK added to your project
4. Your Facebook app ID and display name added your app's .plist file ( you can follow our getting started guide. )
- sample code :  github.com/fbsamples/ios-howtos
- Get facebook user id  ( http://stackoverflow.com/a/22112540/3815784 )

```
    if (FBSession.activeSession.isOpen) {
    [[FBRequest requestForMe] startWithCompletionHandler:
     ^(FBRequestConnection *connection,
       NSDictionary<FBGraphUser> *user,
       NSError *error) {
         if (!error) {
             NSString *facebookId = user.id;
             NSLog(@"facebookId = %@",facebookId);
         }
     }];
    }
```
