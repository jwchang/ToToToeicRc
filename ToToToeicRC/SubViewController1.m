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

    UIButton *btnOption1;
    UIButton *btnOption2;
    
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

- (void) createLabelObjects {

    lblno = [ [UILabel alloc] initWithFrame:CGRectMake(40, 50, 280, 80)];
    lblno.text = @"문제:";
    lblQuestion.numberOfLines = 1;
    [self.view addSubview:lblno];
    
    
    lblQuestion = [ [UILabel alloc] initWithFrame:CGRectMake(40, 80, 280, 160)];
    lblQuestion.text = @"";
    lblQuestion.numberOfLines = 4;
    [self.view addSubview:lblQuestion];
    
    btnOption1 =  [[ UIButton alloc ] initWithFrame:CGRectMake(40, 260, 280, 30) ];
    [self.view addSubview:btnOption1];
    [ btnOption1   addTarget:self  action:@selector(optionTouchHandler:) forControlEvents:UIControlEventTouchUpInside ];
    
    btnOption2 =  [[ UIButton alloc ] initWithFrame:CGRectMake(40, 290, 280, 30) ];
    [self.view addSubview:btnOption2];
    [ btnOption2   addTarget:self  action:@selector(optionTouchHandler:) forControlEvents:UIControlEventTouchUpInside ];
}

- (void) displayData:(int)idx {
    
    TestSet *aQuestion = [ data  objectAtIndex: idx];
    
    lblno.text = [NSString stringWithFormat:@"문제: %d", idx+1 ];
    lblQuestion.text = aQuestion.question;
    
    [ btnOption1 setTitle: [ NSString stringWithFormat:@"(1) %@", aQuestion.option1 ]  forState:UIControlStateNormal] ;
    [ btnOption2 setTitle: [ NSString stringWithFormat:@"(2) %@", aQuestion.option2 ]  forState:UIControlStateNormal] ;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    data = [NSMutableArray array];
    cp = 0;
    
    [ self copyDatabase ];
    [ self openDatabase ];
    [ self selectData];
    
    [ self createLabelObjects];
    [ self displayData:cp];
    
    [ self closeDatabase];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnHandler:(id)sender {
    
    cp = cp + 1;
    if ( cp <= 19 ) {
      [ self displayData:cp];
    }
    
}
@end
