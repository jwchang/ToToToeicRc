//
//  TestSet.h
//  ToToToeicRC
//
//  Created by Jaewoong chang on 14. 2. 13..
//  Copyright (c) 2014년 Jaewoong chang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TestSet : NSObject

@property                       int no;
@property (copy, nonatomic) NSString *gubun;
@property (copy, nonatomic) NSString *question;
@property (copy, nonatomic) NSString *sub;
@property (copy, nonatomic) NSString *subtype;
@property (copy, nonatomic) NSString *option1;
@property (copy, nonatomic) NSString *option2;
@property (copy, nonatomic) NSString *option3;
@property (copy, nonatomic) NSString *option4;
@property (copy, nonatomic) NSString *mc;
@property (copy, nonatomic) NSString *answer;
@property (copy, nonatomic) NSString *comment;

@end
