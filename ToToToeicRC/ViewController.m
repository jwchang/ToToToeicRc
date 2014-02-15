//
//  ViewController.m
//  ToToToeicRC
//
//  Created by Jaewoong chang on 14. 2. 13..
//  Copyright (c) 2014년 Jaewoong chang. All rights reserved.
//

#import "ViewController.h"
#import "SubViewController1.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}


- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // NSLog(@" prepareForSegue  ");
    
    if ( ![ @"TESTORHISTORY" isEqualToString:segue.identifier ]) {
    SubViewController1 *vc = ( SubViewController1 *) segue.destinationViewController;
    vc.selectedSet = segue.identifier;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
