//
//  ContactViewController.m
//  XmppDemo
//
//  Created by Jerry.Yao on 16/2/25.
//  Copyright © 2016年 Jerry.Yao. All rights reserved.
//

#import "ContactViewController.h"
#import "AddContactViewController.h"
#import "MJRefresh.h"
#import "IMMessagesViewController.h"
#import "ChatViewController.h"

@interface ContactViewController () <UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) NSArray *friends;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSFetchedResultsController *resultController;

@end

@implementation ContactViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UIBarButtonItem *addContactItem = [[UIBarButtonItem alloc] initWithTitle:@"添加" style:UIBarButtonItemStyleDone target:self action:@selector(addContactItemClick)];
    self.navigationItem.rightBarButtonItem = addContactItem;
    
    //[self loadFriends];
    [self loadFriendsWithResultController];
    [self.view addSubview:self.tableView];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
}

- (void)loadNewData
{
    [self.tableView reloadData];
    [NSThread sleepForTimeInterval:1];
    [self.tableView.mj_header endRefreshing];
}

// 添加好友
- (void)addContactItemClick
{
    AddContactViewController *addContact = [[AddContactViewController alloc] init];
    [self.navigationController pushViewController:addContact animated:YES];
}

- (void)loadFriendsWithResultController {
    // 1. 获取上下文对象
    NSManagedObjectContext *context = [XmppManager sharedManager].rosterStorage.mainThreadManagedObjectContext;
    
    // 2.FetchRequest (查表)
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"XMPPUserCoreDataStorageObject"];
    
    // 3. 设置过滤和排序
    NSString *myJid = [XmppManager sharedManager].myJid;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"streamBareJidStr = %@",myJid];
    request.predicate = predicate;
    
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"displayName" ascending:YES];
    request.sortDescriptors = @[sortDescriptor];
    
    // 4. 执行请求获取数据
    _resultController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
    _resultController.delegate = self;
    
    NSError *error = nil;
    [_resultController performFetch:&error];
    if (error) {
        LJLog(@"%@", error);
    }
    
}

- (void)loadFriends {
    // 1. 获取上下文对象
    NSManagedObjectContext *context = [XmppManager sharedManager].rosterStorage.mainThreadManagedObjectContext;
    
    // 2.FetchRequest (查表)
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"XMPPUserCoreDataStorageObject"];
    
    // 3. 设置过滤和排序
    NSString *myJid = [XmppManager sharedManager].myJid;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"streamBareJidStr = %@",myJid];
    request.predicate = predicate;
    
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"displayName" ascending:YES];
    request.sortDescriptors = @[sortDescriptor];
    
    // 4. 执行请求获取数据
    self.friends = [context executeFetchRequest:request error:nil];
     NSLog(@"Friends = %@", self.friends);
}

#pragma mark - NSFetchedResultsController获取结果代理方法(当好友数据发生改变会调用这个方法)
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    // 刷新列表
    [self.tableView reloadData];
}

#pragma mark - TableView数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    return self.friends.count;
    return _resultController.fetchedObjects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    
//    XMPPUserCoreDataStorageObject *object = self.friends[indexPath.row];
    XMPPUserCoreDataStorageObject *friend = _resultController.fetchedObjects[indexPath.row];
    // friend.sectionNum 0 在线 、 1 离开 、 2 离线
    // 判断好友状态
    switch ([friend.sectionNum intValue]) {
        case 0:
            cell.detailTextLabel.text = @"(在线)";
            break;
        case 1:
            cell.detailTextLabel.text = @"(离开)";
            break;
        case 2:
            cell.detailTextLabel.text = @"(离线)";
            break;
        default:
            break;
    }
    cell.textLabel.text = friend.jidStr;
    
    return cell;
}

#pragma mark - 进入聊天页面
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    XMPPUserCoreDataStorageObject *friend = _resultController.fetchedObjects[indexPath.row];
//    IMMessagesViewController *chat = [[IMMessagesViewController alloc] init];
    ChatViewController *chat = [[ChatViewController alloc] init];
    chat.friendJid = friend.jid;
    
    chat.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:chat animated:YES];
}

#pragma mark - 删除好友代理方法
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        XMPPUserCoreDataStorageObject *friend = _resultController.fetchedObjects[indexPath.row];
        [[XmppManager sharedManager].roster removeUser:friend.jid];
        LJLog(@"删除好友");
    }
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 50;
    }
    return _tableView;
}

- (void)dealloc
{
    _resultController.delegate = nil;
    _tableView.delegate = nil;
    _tableView.dataSource = nil;
}

@end
