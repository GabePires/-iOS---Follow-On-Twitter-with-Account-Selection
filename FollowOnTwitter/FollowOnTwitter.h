//
//  FollowOnTwitter.h
//  
//
//  Created by Pires on 5/20/15.
//  Copyright (c) 2015 perpetualApps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h> //need this.

@interface FollowOnTwitter : NSObject <UIActionSheetDelegate>

//the only function to be called.
//This class handles the rest given the properties.
-(void)followMe;

//the twitter account you want user to follow
@property (nonatomic) NSString *twitterHandle;

//the view in which you want display the uiactionsheet + anything else here.
@property (nonatomic) UIView *view;

@end
