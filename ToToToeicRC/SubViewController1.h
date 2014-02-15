//
//  SubViewController1.h
//  ToToToeicRC
//
//  Created by Jaewoong chang on 14. 2. 13..
//  Copyright (c) 2014년 Jaewoong chang. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SubViewController1 : UIViewController

@property (strong, nonatomic)  NSString *selectedSet;

- (IBAction)btnOption1:(id)sender;
- (IBAction)btnOption2:(id)sender;
- (IBAction)btnOption3:(id)sender;
- (IBAction)btnOption4:(id)sender;

- (IBAction)btnHandler:(id)sender;

@end
