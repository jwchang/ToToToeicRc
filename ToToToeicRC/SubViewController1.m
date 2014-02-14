//
//  SubViewController1.m
//  ToToToeicRC
//
//  Created by Jaewoong chang on 14. 2. 13..
//  Copyright (c) 2014년 Jaewoong chang. All rights reserved.
//

#import "SubViewController1.h"
#import <sqlite3.h>
#import "TestSet.h"

@interface SubViewController1 ()

@end

@implementation SubViewController1 {
    NSMutableArray *data;
    sqlite3 *db;
    int cp;
    UILabel *lblno;
    UILabel *lblQuestion;
    UILabel *lblOption1;
    UILabel *lblOption2;
 
    UIImageView *imageView1;
    UIImageView *imageView2;
    UIImageView *imageView5;
    UIImageView *imageView6;
    NSString *userSelectedAnswer;
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) copyDatabase {
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [ documentPaths objectAtIndex:0];
    
    NSString *dbPath = [ documentPath  stringByAppendingPathComponent:@"toeicrc.sqlite"];
    NSFileManager *fm = [ NSFileManager defaultManager ];
    if ( NO == [fm fileExistsAtPath:dbPath] ) {
        NSLog(@"Not Exist");
        NSString *dbSourcePath = [[NSBundle mainBundle ] pathForResource:@"toeicrc" ofType:@"sqlite" ];
        NSError *error = nil;
        BOOL ret = [ fm  copyItemAtPath:dbSourcePath toPath:dbPath error:&error];
        NSAssert1(ret, @"Error on copy db file : %@", error);
    } else {
        NSLog(@"already exist %@", dbPath);
    }
    
}

- (void) openDatabase
{

    NSString *docPath = [ NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0 ];
    NSString *dbFilePath = [ docPath stringByAppendingPathComponent:@"toeicrc.sqlite" ];
    
    // db open
    int ret = sqlite3_open( [dbFilePath UTF8String ], &db  );
    NSAssert1(SQLITE_OK == ret, @"db error  %s", sqlite3_errmsg(db) );
    
}

- (void) selectData {
    // 쿼리 준비
    NSString *queryString = @"SELECT no, gubun, question, sub, subtype, option1, option2, option3, option4, mc, answer, comment  FROM toeicrc WHERE gubun = 'set1' ";
    sqlite3_stmt *stmt;
    int ret = sqlite3_prepare_v2(db, [queryString UTF8String ], -1, &stmt, NULL);
    
    NSAssert2(SQLITE_OK==ret, @"ERROR %d %s", ret, sqlite3_errmsg(db));
    
    // 모든 행의 정보를 읽어 온다
    while ( SQLITE_ROW == sqlite3_step(stmt)) {
        int no         = sqlite3_column_int(stmt, 0);
        char *gubun    = (char *)sqlite3_column_text(stmt, 1);
        char *question = (char *)sqlite3_column_text(stmt, 2);
        //char *sub      = (char *)sqlite3_column_text(stmt, 3);
        char *subtype  = (char *)sqlite3_column_text(stmt, 4);
        char *option1  = (char *)sqlite3_column_text(stmt, 5);
        char *option2  = (char *)sqlite3_column_text(stmt, 6);
        //char *option3  = (char *)sqlite3_column_text(stmt, 7);
        //char *option4  = (char *)sqlite3_column_text(stmt, 8);
        char *mc       = (char *)sqlite3_column_text(stmt, 9);
        char *answer   = (char *)sqlite3_column_text(stmt, 10);
        char *comment  = (char *)sqlite3_column_text(stmt, 11);
        
        // 객체 생성, 데이터 셋팅
        TestSet *one = [[ TestSet alloc ] init];
        one.no        = no;
        one.gubun     = [NSString stringWithCString:gubun encoding:NSUTF8StringEncoding  ];
        one.question = [NSString stringWithCString:question  encoding:NSUTF8StringEncoding  ];
        //one.sub      = [NSString stringWithCString:sub  encoding:NSUTF8StringEncoding  ];
        one.subtype   = [NSString stringWithCString:subtype  encoding:NSUTF8StringEncoding  ];
        one.option1   = [NSString stringWithCString:option1  encoding:NSUTF8StringEncoding  ];
        one.option2   = [NSString stringWithCString:option2  encoding:NSUTF8StringEncoding  ];
        //one.option3   = [NSString stringWithCString:option3  encoding:NSUTF8StringEncoding  ];
        //one.option4   = [NSString stringWithCString:option4  encoding:NSUTF8StringEncoding  ];
        one.mc       = [NSString stringWithCString:mc  encoding:NSUTF8StringEncoding  ];
        one.answer    = [NSString stringWithCString:answer  encoding:NSUTF8StringEncoding  ];
        one.comment   = [NSString stringWithCString:comment  encoding:NSUTF8StringEncoding  ];

        
        [data addObject:one];
    }
    sqlite3_finalize(stmt);
}

- (void) closeDatabase {
    sqlite3_close(db);
}

- (void) optionTouchHandler:(id) sender {
    NSLog(@"button clicked");
}

- (void) hideImages {
   
    UIImage *imgCheck1 = [ UIImage imageNamed:@"OK.png"];  //38x40
    imageView1 = [ [UIImageView alloc]  initWithImage:imgCheck1  ];
    imageView1.frame = CGRectMake( 85, 500, imgCheck1.size.width, imgCheck1.size.height );
    imageView1.hidden = YES;
    [self.view addSubview:imageView1];
    
    
    UIImage *imgCheck2 = [ UIImage imageNamed:@"OK.png"];  //38x40
    imageView2 = [ [UIImageView alloc]  initWithImage:imgCheck2  ];
    imageView2.frame = CGRectMake( 130, 500, imgCheck2.size.width, imgCheck2.size.height );
    imageView2.hidden = YES;
    [self.view addSubview:imageView2];
    
    UIImage *imgCheck5 = [ UIImage imageNamed:@"Obtn.png"];  // 정답시 표시할 이미지
    imageView5 = [ [UIImageView alloc]  initWithImage:imgCheck5  ];
    imageView5.frame = CGRectMake( 80, 280, imgCheck5.size.width, imgCheck5.size.height );
    imageView5.hidden = YES;
    [self.view addSubview:imageView5];
    

    UIImage *imgCheck6 = [ UIImage imageNamed:@"Xbtn.png"];  // 정답시 표시할 이미지
    imageView6 = [ [UIImageView alloc]  initWithImage:imgCheck6  ];
    imageView6.frame = CGRectMake( 80, 280, imgCheck6.size.width, imgCheck6.size.height );
    imageView6.hidden = YES;
    [self.view addSubview:imageView5];
    
}

- (void) createLabelObjects {

    lblno = [ [UILabel alloc] initWithFrame:CGRectMake(40, 50, 280, 80)];
    lblno.text = @"문제:";
    lblQuestion.numberOfLines = 1;
    [self.view addSubview:lblno];
    
    lblQuestion = [ [UILabel alloc] initWithFrame:CGRectMake(40, 80, 280, 160)];
    lblQuestion.text = @"";
    lblQuestion.numberOfLines = 4;
    [self.view addSubview:lblQuestion];
    
    lblOption1 = [ [UILabel alloc] initWithFrame:CGRectMake(40, 280, 280, 30)];
    lblOption1.text = @"";
    lblOption1.numberOfLines = 1;
    [self.view addSubview:lblOption1];

    lblOption2 = [ [UILabel alloc] initWithFrame:CGRectMake(40, 310, 280, 30)];
    lblOption2.text = @"";
    lblOption2.numberOfLines = 1;
    [self.view addSubview:lblOption2];
    
}

- (void) displayData:(int)idx {
    
    TestSet *aQuestion = [ data  objectAtIndex: idx];
    
    lblno.text = [NSString stringWithFormat:@"문제: %d", idx+1 ];
    lblQuestion.text = aQuestion.question;
    
    lblOption1.text = [ NSString    stringWithFormat:@"(1) %@", aQuestion.option1];
    lblOption2.text = [ NSString    stringWithFormat:@"(2) %@", aQuestion.option2];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    data = [NSMutableArray array];
    cp = 0;
    userSelectedAnswer = @"0";
    
    [ self copyDatabase ];
    [ self openDatabase ];
    [ self selectData];
    
    [ self createLabelObjects];
    [ self hideImages ];
    [ self displayData:cp];
    
    [ self closeDatabase];

}



- (IBAction)btnOption1:(id)sender {

    userSelectedAnswer = @"a";
    
    imageView1.hidden = NO;
    imageView2.hidden = YES;
}

- (IBAction)btnOption2:(id)sender {

    userSelectedAnswer = @"b";
    
    imageView1.hidden = YES;
    imageView2.hidden = NO;
}

- (IBAction)btnOption3:(id)sender {
     NSLog(@"option3 touched");
}

- (IBAction)btnOption4:(id)sender {
     NSLog(@"option4 touched");
}

- (void) clearScreen {
    imageView1.hidden = YES;
    imageView2.hidden = YES;
    imageView5.hidden = YES;
    imageView6.hidden = YES;
}

- (void) checkUptheAnswer:(int) idx {
 
    // 정답 비교
    TestSet *aQuestion = [ data  objectAtIndex: idx];
    
    // NSLog(@" aquestion.answer = %@", aQuestion.answer );
    if ( [ userSelectedAnswer   isEqual:aQuestion.answer ] ) {
        NSLog(@"정답");
        imageView5.hidden = NO;
    } else {
        NSLog(@"오답");
        imageView6.hidden = NO;
    }
    
}

- (IBAction)btnHandler:(id)sender {
    
    [ self checkUptheAnswer:cp ];
    cp = cp + 1;
    if ( cp <= 19 ) {
      [ self clearScreen   ];
      [ self displayData:cp];
    }
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
