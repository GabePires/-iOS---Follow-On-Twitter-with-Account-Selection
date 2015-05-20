# Follow On Twitter + Account Selection

Using the Social Framework and Accounts Framework, create a 'Follow me on Twitter' button in your iOS app.<br />
Problem: You want a user to be able to follow you on Twitter without ever leaving the app. You also<br />
want to control what happens if they choose to follow or not.<br />

This class displays use of: Social Framework, Accounts Frameworks, UIActionSheet, grand central dispatch.<br />

FollowOnTwitter let's your user follow you on Twitter without leaving the app, and handles multiple users via an ActionSheet.<br />

#Usage
1.Link Frameworks: Social, Accounts, and UIKit in Build Phases<br />
2.Drag and copy FollowOnTwitter folder into project<br />
3.Edit FollowOnTwitter.m functions to your liking: <br />
```objective-c
  -(void)twitterUnavailable{//handle unavailable twitter}
  -(void)successFollow{//handle data after success}
  -(void)thanksForFollowing{//handle UI after success}
```
4.Import the class to your Viewcontroller
```objective-c
  #import "FollowOnTwitter.h"
```
5.Implement FollowOnTwitter
```objective-c
    followOnTwitter = [[FollowOnTwitter alloc]init];
    followOnTwitter.twitterHandle = @"Gabe_A_Pires"; //the twitter user you want user to follow
    followOnTwitter.view = self.view; //the view you are using this in
    [followOnTwitter followMe];
```

# Miscellaneous
If your user has only one Twitter account, and you want them to circumvent the actionsheet replace this:<br />
```objective-c
  [self accountSelection];
```
with this:
```objective-c
  if([accountsArray count] > 1){
    //display actionsheet if more than one account on device
    [self accountSelection];
  }
  else{
  //skip actionsheet if only one account on device
    [self followOnTwitter:0];
  }
```
