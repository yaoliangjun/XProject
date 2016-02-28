//
//  ChatViewController.m
//  XProject
//
//  Created by Jerry.Yao on 16/2/27.
//  Copyright © 2016年 Jerry.Yao. All rights reserved.
//

#import "ChatViewController.h"
#import "MJRefresh.h"

@interface ChatViewController () <UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate, UITextViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSFetchedResultsController *resultController;
@property (nonatomic, strong) PlaceHolderTextView *inputView;

@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    // 查询聊天记录
    [self loadChatMessage];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    
    self.tableView.mj_header = header;
    // 隐藏时间
    header.lastUpdatedTimeLabel.hidden = YES;
    
    // 隐藏状态
    header.stateLabel.hidden = YES;
}

- (void)loadNewData
{
    [NSThread sleepForTimeInterval:1];
    [self.tableView.mj_header endRefreshing];
}

- (void)loadChatMessage
{
    // 1. 获取上下文对象
    NSManagedObjectContext *context = [XmppManager sharedManager].msgStorage.mainThreadManagedObjectContext;
    
    // 2. 创建请求对象 查询聊天记录表
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"XMPPMessageArchiving_Message_CoreDataObject"];
    
    // 3. 过滤条件和排序设置, 查询当前登录用户的当前选中聊天用户的记录
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"streamBareJidStr = %@ AND bareJidStr = %@", [XmppManager sharedManager].myJid, self.friendJid.bare];
    request.predicate = predicate;
    // 时间正序
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"timestamp" ascending:YES];
    request.sortDescriptors = @[sortDescriptor];
    
    // 4. 执行请求查询数据库
    NSError *error = nil;
    _resultController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
    _resultController.delegate = self;
    
    [_resultController performFetch:&error];
    if (error) {
        NSLog(@"execute chat message error : %@", error);
    }
    
    // 刷新列表
    [self.tableView reloadData];
    [self scrollToBottom];
    
}

#pragma mark - NSFetchedResultsController获取结果代理方法(当好友数据发生改变会调用这个方法)
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    NSLog(@"数据发生了改变，刷新一下吧");
    // 刷新列表
    [self.tableView reloadData];
    [self scrollToBottom];
}

#pragma mark - Tableview滚动到底部
- (void)scrollToBottom
{
    NSInteger friendsCount = _resultController.fetchedObjects.count;
    if (friendsCount > 0) {
        NSInteger lastRow = friendsCount - 1;
        NSIndexPath *lastIndexPath = [NSIndexPath indexPathForRow:lastRow inSection:0];
        [self.tableView scrollToRowAtIndexPath:lastIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }

}

- (void)setupView {
    self.title = @"Chat";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    
    [self.view addSubview:self.inputToolbar];
}

#pragma mark - 输入聊天信息工具条
- (UIView *)inputToolbar
{
    UIView *toolBar = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight - 40 - 64, kScreenWidth, 40)];
    toolBar.backgroundColor = kLightGrayColor;
    
    UIButton *sendBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth - 60, 0, 60, 40)];
    [sendBtn setTitle:@"Send" forState:UIControlStateNormal];
    [sendBtn setTitleColor:kGrayColor forState:UIControlStateNormal];
    sendBtn.titleLabel.font = kHelveticaBoldFont(16);
    [sendBtn addTarget:self action:@selector(sendBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [toolBar addSubview:sendBtn];
    
    PlaceHolderTextView *inputView = [[PlaceHolderTextView alloc] initWithFrame:CGRectMake(60, 1, kScreenWidth - 60 * 2, 38)];
    _inputView = inputView;
    inputView.placeholderColor = kGrayColor;
    inputView.placeholderText = @"New Message";
    inputView.layer.borderColor = kLightGrayColor.CGColor;
    inputView.layer.borderWidth = 0.5;
    inputView.layer.cornerRadius = 4;
    inputView.delegate =self;
    [toolBar addSubview:inputView];
    
    UIButton *clipBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 40)];
    [clipBtn setImage:[UIImage imageNamed:@"clip"] forState:UIControlStateNormal];
    [clipBtn addTarget:self action:@selector(clipBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [toolBar addSubview:clipBtn];
    
    return toolBar;
}

#pragma mark - 点击附件按钮
- (void)clipBtnClick
{
    NSLog(@"点击附件按钮");
}

#pragma mark - 发送信息按钮
- (void)sendBtnClick
{
    NSString *message = _inputView.text;
    if (!message.length) {
        NSLog(@"请输入信息再发送");
        return;
    }
    
    [self sendMessage:message];
}

- (void)sendMessage:(NSString *)message
{
    // 发送聊天信息
    XMPPMessage *chatMsg = [XMPPMessage messageWithType:@"chat" to:self.friendJid];
    [chatMsg addBody:_inputView.text];
    [[XmppManager sharedManager].xmppStream sendElement:chatMsg];
    
    _inputView.text = nil;
    [_inputView resignFirstResponder];
}

- (void)textViewDidChange:(UITextView *)textView
{
    NSString *message = textView.text;
    if ([message rangeOfString:@"\n"].length != 0) {
        // 去除换行字符
        message = [message stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        [self sendMessage:message];
    }
}

#pragma mark - TableView数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _resultController.fetchedObjects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    
    XMPPMessageArchiving_Message_CoreDataObject *msg = _resultController.fetchedObjects[indexPath.item];
    
    if ([msg.outgoing boolValue]) {
        // 自己发出去的信息
        cell.textLabel.text = nil;
        cell.detailTextLabel.text = msg.body;
        
    } else {
        cell.textLabel.text = msg.body;
        cell.detailTextLabel.text = nil;
    }
    cell.detailTextLabel.numberOfLines = 0;
    cell.textLabel.numberOfLines = 0;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
    
//    if ([_inputView isFirstResponder]) {
//        [_inputView resignFirstResponder];
//    }
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64 - 40) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 50;
//        _tableView.allowsSelection = NO;
    }
    return _tableView;
}

- (void)dealloc
{
    _tableView.delegate = nil;
    _tableView.dataSource = nil;
}

@end
