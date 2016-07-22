//
//  ViewController.m
//  TableViewIndexDemo
//
//  Created by zhanggui on 16/7/19.
//  Copyright © 2016年 zhanggui. All rights reserved.
//

#import "ViewController.h"
#import "CityModel.h"
#import "ConcernCell.h"
#import "HotCell.h"
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *cityTableView;  //主表格

@property (nonatomic,strong)NSMutableArray *cityArray;  //城市数组

@property (nonatomic,strong)NSMutableDictionary *cityDict;  //城市字典，用于索引

@property (nonatomic,strong)NSMutableArray *saveToLocalArray;  //用于本地保存


@property (nonatomic,strong)NSMutableArray *hotCityArr;  //热门城市列表
@property (nonatomic,strong)NSMutableArray *concernCityArray;  //关注城市列表


@property (nonatomic,strong) ConcernCell *concernCell;

@property (nonatomic,strong)NSIndexPath *concernIndexPath;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateHeight) name:@"UpdateConcerCellHeight" object:nil];
    _cityDict = [[NSMutableDictionary alloc] initWithCapacity:26];
    _cityArray = [[NSMutableArray  alloc] initWithCapacity:526];
    self.cityTableView.tableFooterView = [UIView new];
    //加载本地数据，如果有本地数据就直接显示本地数据，如果没有则请求服务器
    [self p_loadLocalCityData];
    
    if ([_cityArray count]>0) {
        
        [self.cityTableView reloadData];
    }else {
         [self configDataFromRemote];
    }
   
}
- (IBAction)finishAction:(id)sender {
    NSLog(@"%lu",(unsigned long)[self.concernCityArray count]);
}
#pragma mark - update height
- (void)updateHeight {
    [self.cityTableView beginUpdates];
    [self.cityTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
    [self.cityTableView endUpdates];

}
#pragma mark - getRemoteData
- (void)configDataFromRemote {
    NSString *urlStr = [NSString stringWithFormat:@"http://apis.baidu.com/baidunuomi/openapi/cities"];
  
    NSURLSession *session = [NSURLSession sharedSession];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlStr]];
    [request setValue:@"2304cdaee07aa52690475edf3776cce6" forHTTPHeaderField:@"apikey"];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        [self p_configCityArrWithDic:dict];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self p_saveToLocal];
        });
        [self performSelectorOnMainThread:@selector(p_refreshTableView) withObject:nil waitUntilDone:YES];
    }];
    [task resume];
}
#pragma mark - private Method
- (void)p_loadLocalCityData {
    [_cityArray removeAllObjects];   //清空城市数组
    [self.saveToLocalArray removeAllObjects];
    NSString *plistName = @"CiytList.plist";
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filePath = [NSString stringWithFormat:@"%@/%@",docPath,plistName];
    
    //获取本地数据，放到数组里面
    NSMutableArray *arr = [NSMutableArray arrayWithContentsOfFile:filePath];
    
    [self p_initCityDicAndArr:arr];
}
//数据保存到本地
- (void)p_saveToLocal {
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:400];
    for (NSDictionary *dict in self.saveToLocalArray) {
        [array addObject:dict];
    }
    //保存到plist
    NSString *plistName = @"CiytList.plist";
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filePath = [NSString stringWithFormat:@"%@/%@",docPath,plistName];
   BOOL isWriteToFile =  [array writeToFile:filePath atomically:YES];
    if (isWriteToFile) {
        NSLog(@"写入成功");
    }else {
        NSLog(@"写入失败");
    }
}
//刷新table
- (void)p_refreshTableView {
    [self.cityTableView reloadData];
}
//把远程服务器读取数据配置到属性值中
- (void)p_configCityArrWithDic:(NSDictionary *)dic {
    NSArray *arr = dic[@"cities"];
    [self p_initCityDicAndArr:arr];   //配置检索数据
}
//配置_cityArray  && _cityDict
- (void)p_initCityDicAndArr:(NSArray *)arr {
    [self p_confiyHotCityData:arr];  //配置热门数据
    [self p_configConcernCityData:arr];   //配置关注城市
    self.saveToLocalArray = [NSMutableArray arrayWithArray:arr];
    for(NSDictionary *cityDic in arr) {
        CityModel *model = [[CityModel alloc] initWithDic:cityDic];
        [_cityArray addObject:model];
    }
    for(CityModel *model in _cityArray) {
        NSMutableArray *letterArr = _cityDict[model.firstSepllStr];
        if (letterArr==nil) {
            letterArr = [NSMutableArray new];
            [_cityDict setObject:letterArr forKey:model.firstSepllStr];
        }
        [letterArr addObject:model];
    }
    //

}
//配置关注城市
- (void)p_configConcernCityData:(NSArray *)arr {
    for (int i=0; i<0; i++) {
        CityModel *model = [[CityModel alloc] initWithDic:arr[i]];
        [self.concernCityArray addObject:model];
    }
}
//配置热门城市
- (void)p_confiyHotCityData:(NSArray *)arr {
    [self.hotCityArr removeAllObjects];
    for (int i=0; i<7; i++) {
        CityModel *model = [[CityModel alloc] initWithDic:arr[i]];
        [self.hotCityArr addObject:model];
    }
}
//得到检索关键字数组
- (NSArray *)p_getCityDictAllKeys {
    NSArray *keys = [_cityDict allKeys];
    return [keys sortedArrayUsingSelector:@selector(compare:)];
}
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40.0f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return [self p_getConcernCellHeight];
    }
    if (indexPath.section == 1) {
        return [self p_getHotCellHeight];
    }
    return 44;
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSArray *arr = [self p_getCityDictAllKeys];
    if (arr.count!=0) {
        NSLog(@"%lu",(unsigned long)arr.count);
    }
    return arr.count+2;  //2是关注城市和热门城市
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"关注城市";
    }
    if (section == 1) {
        return @"热门城市";
    }
    NSArray *arr = [self p_getCityDictAllKeys];
    return arr[section-2];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {  //关注城市
        return 1;
    }
    if (section == 1) {  //热门城市
        return 1;
    }
    NSArray *keys = [self p_getCityDictAllKeys];
    NSString *keyStr = keys[section-2];
    NSArray *arr = _cityDict[keyStr];
    return arr.count;
}
- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    NSMutableArray *arr = [[NSMutableArray alloc] initWithObjects:@"注",@"热", nil];
    [arr addObjectsFromArray:[self p_getCityDictAllKeys]];
    return arr;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
//        static NSString *concernCellIdentifier = @"concernCellIdentifier";
        _concernCell = [[ConcernCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        _concernCell.selectionStyle = UITableViewCellSelectionStyleNone;
        [_concernCell setShowContentWithCityArr:self.concernCityArray];
        NSLog(@"VIewControllers:%p",self.concernCityArray);
        _concernIndexPath = indexPath;
        return _concernCell;
    }
    if (indexPath.section == 1) {
       
        HotCell *hotCell = [[HotCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        hotCell.concernCityCellArray = self.concernCityArray;
        hotCell.selectionStyle = UITableViewCellSelectionStyleNone;
        [hotCell setShowContentWithCityArr:self.hotCityArr];
        return hotCell;

    }
    static NSString *CellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSArray *allCityLetterArr = [self p_getCityDictAllKeys];
    NSString *sectionCityLetter = allCityLetterArr[indexPath.section-2];
    NSArray *underLetterCityArr = _cityDict[sectionCityLetter];
    CityModel *model = underLetterCityArr[indexPath.row];
    cell.textLabel.text = model.cityName;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0 || indexPath.section==1) {
        return;
    }
}
#pragma mark - privateMehtod
- (CGFloat)p_getHotCellHeight {
    NSInteger isHaveAnotherLine = [self.hotCityArr count]%3==0? 0:1;
    CGFloat height = [self.hotCityArr count]/3*40+([self.hotCityArr count]/3-1)*5+isHaveAnotherLine*40+15;
    return height;
}
- (CGFloat)p_getConcernCellHeight {
    NSInteger isHaveAnotherLine = [self.concernCityArray count]%3==0? 0:1;
    CGFloat height = [self.concernCityArray count]/3*40+([self.concernCityArray count]/3-1)*5+isHaveAnotherLine*40+15+17+10;
    return height;
}
#pragma mark - setter
- (UITableView *)cityTableView {
    if (!_cityTableView) {
        _cityTableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
        _cityTableView.delegate = self;
        _cityTableView.dataSource = self;
        [self.view addSubview:_cityTableView];
    }
    return _cityTableView;
}
- (NSMutableArray *)saveToLocalArray {
    if (!_saveToLocalArray) {
        _saveToLocalArray = [[NSMutableArray alloc] init];
    }
    return _saveToLocalArray;
}
- (NSMutableArray *)concernCityArray {
    if (!_concernCityArray) {
        _concernCityArray = [[NSMutableArray alloc] init];
    }
    return _concernCityArray;
}
- (NSMutableArray *)hotCityArr {
    if (!_hotCityArr) {
        _hotCityArr = [[NSMutableArray alloc] init];
    }
    return _hotCityArr;
}
#pragma mark - dealloc
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
