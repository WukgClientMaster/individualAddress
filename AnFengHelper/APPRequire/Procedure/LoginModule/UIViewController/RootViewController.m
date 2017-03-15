//
//  RootViewController.m
//  AnFengHelper
//  Created by anfeng on 17/3/9.
//  Copyright © 2017年 AnFen. All rights reserved.
//

#import "RootViewController.h"
#import "APPDataBase.h"
#import "APPResultSet.h"
#import "APPDataBaseQueue.h"
#import "HTTPHelper.h"

NSString * loadDBPath();
NSString * loadDBPath()
{
    NSString * bundlepath = [[NSBundle mainBundle]pathForResource:@"AnFengSqlite" ofType:@"db"];
    NSString * documentpath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]stringByAppendingPathComponent:@"AnFengSqlite.db"];
    NSFileManager * fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath:documentpath]) {
        NSError * error;
        BOOL res = [fileManager copyItemAtPath:bundlepath toPath:documentpath error:&error];
        if (!res) {
            NSLog(@"数据库路径不存在.......");
        }else
        {
            return documentpath;
        }
    }
    else if ([fileManager fileExistsAtPath:documentpath])
    {
        return documentpath;
    }
    return @"";
}

void createTable(NSString*sql1,NSString * sql2);
void createTable(NSString*sql1,NSString * sql2)
{
    NSFileManager * fileManager= [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:loadDBPath()]) {
        APPDataBase * db = [APPDataBase databaseWithPath:loadDBPath()];
        if ([db open]) {
             NSString * sql = @"CREATE TABLE 'User' ('id' INTEGER PRIMARY KEY AUTOINCREMENT  NOT NULL , 'name' VARCHAR(30), 'password' VARCHAR(30))";
            BOOL res = [db executeUpdate:sql];
            if (!res) {
                __NSLog(@"error when creating db table");
            } else {
                __NSLog(@"succ to creating db table");
            }
        }
        else
        {
            __NSLog(@"error when open db");
        }
    }
}
void insertData(NSString*sql1,NSString * sql2);
void insertData(NSString*sql1,NSString * sql2)
{
    static int indx = 1;
    APPDataBase * db  = [APPDataBase databaseWithPath:loadDBPath()];
    if ([db open]) {
        NSString * sql  = @"insert into User (name, password) values(?, ?) ";;
        NSString * name = [NSString stringWithFormat:@"tangqiao%d",indx++];
        BOOL res = [db executeUpdate:sql,name,@"body"];
        if (!res) {
            __NSLog(@"error to inset data");
        }else
        {
            __NSLog(@"success to insrt data");
        }
    }
    else
    {
        __NSLog(@"error when open db");
    }
}
void queryData(NSString*sql1,NSString * sql2);
void queryData(NSString*sql1,NSString * sql2)
{
    APPDataBase * db = [APPDataBase databaseWithPath:loadDBPath()];
    if ([db open]) {
        NSString * sql = @"select * from User";
        APPResultSet *rs = [db executeQuery:sql];
        while ([rs next]) {
            int userID = [rs intForColumn:@"id"];
            NSString * name = [rs stringForColumn:@"name"];
            NSString * pass = [rs stringForColumn:@"password"];
            __NSLog(@"user id = %d,name = %@,pass = %@",userID,name,pass);
        }
        [db close];
    }
    else
    {
        __NSLog(@"error when open db");
    }
}

void multiThread(NSString*sql1,NSString * sql2);
void multiThread(NSString*sql1,NSString * sql2)
{
    APPDataBaseQueue * queue  = [APPDataBaseQueue databaseQueueWithPath:loadDBPath()];
    dispatch_queue_t dispatch_queue = dispatch_queue_create("queue.task.com", NULL);
    dispatch_async(dispatch_queue, ^{
        for (int i = 0; i < 10; i++) {
            [queue inDatabase:^(APPDataBase *db) {
               NSString * sql = @"insert into User (name, password) values(?, ?)";
               NSString * name = [NSString stringWithFormat:@"queue_clas_%d",i];
               NSString * pass = [NSString stringWithFormat:@"password_%d",i];
               BOOL res = [db executeUpdate:sql,name,pass];
                if (!res) {
                    __NSLog(@"error to add db data:%@",name);
                }else{
                    __NSLog(@"success to add db data:%@",name);
                }
           }];
        }
    });
}
void deleteData(NSString* sql1,NSString * sql2);
void deleteData(NSString* sql1,NSString * sql2)
{
    APPDataBase * db = [APPDataBase databaseWithPath:loadDBPath()];
    if ([db open]) {
        NSString * sql = @"delete from User";
        BOOL res = [db executeUpdate:sql];
        if (!res) {
            __NSLog(@"error to delete db data");
        }else
        {
            __NSLog(@"success to delete db data");
        }
        [db close];
    }
    else
    {
        __NSLog(@"error when open db");
    }
}
@interface RootViewController ()
@property(nonatomic,strong) UIButton * creattabItem;
@property(nonatomic,strong) UIButton * insertItem;
@property(nonatomic,strong) UIButton * queryItem;
@property(nonatomic,strong) UIButton * multiThreadItem;
@property(nonatomic,strong) NSMutableArray  * items;
@end

@implementation RootViewController
-(NSMutableArray *)items
{
    _items = ({
        if (!_items) {
             _items  = [NSMutableArray array];
        }
        _items;
    });
    return _items;
}
-(void)setObjectView
{
    self.view.backgroundColor  = AdapterColor(230, 230, 230);
    NSArray * items = @[@"createtab",@"insert",@"query",@"multiThread",@"delete"];
    for (int i = 0; i < items.count;i++) {
        UIButton * item = [UIButton buttonWithType:UIButtonTypeCustom];
        [item setTitle:items[i] forState:UIControlStateNormal];
        [item setTitleColor:[UIColor brownColor] forState:UIControlStateNormal];
        item.tag = 1000 + i;
        item.layer.masksToBounds = YES;
        item.layer.borderColor = [UIColor whiteColor].CGColor;
        item.layer.borderWidth = 1.0f;
        item.layer.cornerRadius= 5.0f;
        [item addTarget:self action:@selector(queryFromDB:) forControlEvents:UIControlEventTouchUpInside];
        [self.items addObject:item];
        [self.view addSubview:item];
    }
    __block  NSInteger padding = 50.0f;
    __block  UIButton * anchorItem;
    [self.items enumerateObjectsUsingBlock:^(UIButton * item, NSUInteger idx, BOOL * _Nonnull stop) { [item mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(kScreen_Width/3.0, 40.0));
            make.centerX.mas_equalTo(self.view.mas_centerX).with.offset(1.0f);
        if (anchorItem == nil) {
            make.top.mas_equalTo(self.view.mas_top).with.offset(padding);
        }
        else
        {
            make.top.mas_equalTo(anchorItem.mas_bottom).with.offset(padding);
        }
            anchorItem = item;
        }];
    }];
}
-(void)queryFromDB:(UIButton*)sender
{
    switch (sender.tag) {
        case 1000:
            createTable(@"", @"");
            break;
        case 1001:
            insertData(@"", @"");
            break;
        case 1002:
            queryData(@"", @"");
            break;
        case 1003:
            multiThread(@"", @"");
            break;
        case 1004:
            deleteData(@"", @"");
            break;
        default:
            break;
    }
}
- (void)viewDidLoad {
  [super viewDidLoad];
  [self  setObjectView];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSDictionary * params = @{@"username":@"15327102433",@"password":@"123456"};
    HTTPHelper *  helper = [HTTPHelper shareInstance];
    [helper postTaskWithPath:@"/api/account/login" params:params success:^(NSString *msg, id response) {
        
    } failure:^(NSError *error) {
        
    }];
}
@end
