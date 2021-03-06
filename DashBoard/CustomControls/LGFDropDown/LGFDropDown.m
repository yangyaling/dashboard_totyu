//
//  LGFDropDown.m
//  下拉菜单
//
//  Created by totyu3 on 16/7/11.
//  Copyright © 2016年 totyu3. All rights reserved.
//
#define SuperView [UIApplication sharedApplication].windows.lastObject.rootViewController.view
#define EMPTY @""
//动态字体大小
#define FontSize (_mainTitleLabel.frame.size.height+_mainTitleLabel.frame.size.width)/10
//还原
#define DropDownReduction CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, 0)
//打开菜单
#define DropDown CGRectMake(self.frame.origin.x, self.frame.origin.y+self.frame.size.height+2, self.frame.size.width,((SuperView.bounds.size.height - (self.frame.origin.y + self.frame.size.height))-self.frame.size.height*(child?_ChildDataArray.count:_DataArray.count))<=0 ? (SuperView.bounds.size.height - (self.frame.origin.y + self.frame.size.height))-5 : self.frame.size.height*(child?_ChildDataArray.count:_DataArray.count))
//三角形view
#define ArrowViewRect CGRectMake(0, 0, view.frame.size.width>view.frame.size.height ? view.frame.size.height/2 : view.frame.size.width/2, view.frame.size.width>view.frame.size.height ? view.frame.size.height/2 : view.frame.size.width/2)

#import "LGFDropDown.h"

@interface LGFDropDown ()<UITableViewDelegate,UITableViewDataSource>
{
    BOOL select;
    BOOL child;//是否有子菜单
    //选中标题名字
    NSString *SelectTitle;
}
/**
 *  子菜单数组
 */
@property (nonatomic, strong) NSMutableArray          *ChildDataArray;

@property (nonatomic, strong) UIButton                *buttonview;

@property (nonatomic, copy) NSString                  *mainTitle;

@property (nonatomic, strong) UILabel                 *mainTitleLabel;

@property (nonatomic, weak) CAShapeLayer              *shapeLayer;

@property (nonatomic, strong) UIView                  *arrowView;

@property (nonatomic, strong) UITableView             *dropdowntableview;

@property (nonatomic, strong) UIButton *Cover;

@end

@implementation LGFDropDown
/**
 *  storyboard添加
 */
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}
/**
 *  代码添加
 */
-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit{
    
//    self.backgroundColor = [UIColor colorWithRed:0.98 green:0.98 blue:0.98 alpha:1.0];
//    self.layer.shadowColor = [UIColor blackColor].CGColor;
//    self.layer.shadowOffset = CGSizeMake(0,0);
//    self.layer.shadowOpacity = 0.3;
    [self defaultSet];
}
/**
 *  子控件适配自动布局
 */
-(void)layoutSubviews{
    [self viewConfig];
}
/**
 *  初始化子控件
 */
- (void)viewConfig
{
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self addSubview:self.mainTitleLabel];
    [self addSubview:self.buttonview];
    [self addSubview:self.arrowView];
}
/**
 *  默认初始化基本设置
 */
-(void)defaultSet{
    
    child = NO;
    SelectTitle = EMPTY;//默认选中为空
    _ArrowColor = [UIColor lightGrayColor];//箭头默认颜色
    _TextColor = [UIColor blackColor];//标题文字默认颜色
    _SelectColor = [UIColor lightGrayColor];//标题文字选中默认颜色
}
/**
 *  背景颜色
 */
-(void)setBackGroundColor:(UIColor *)BackGroundColor{
    
    _BackGroundColor = BackGroundColor;
    self.backgroundColor = _BackGroundColor;
}
/**
 *  标题圆角
 */
-(void)setCornerRadius:(CGFloat)CornerRadius{
    
    _CornerRadius = CornerRadius;
    self.layer.cornerRadius = _CornerRadius;
}
/**
 *  标题边框粗细
 */
-(void)setBorderColor:(UIColor *)BorderColor{
    
    _BorderColor = BorderColor;
    self.layer.borderColor = BorderColor.CGColor;
}
/**
 *  标题边框颜色
 */
-(void)setBorderWidth:(CGFloat)BorderWidth{
    
    _BorderWidth = BorderWidth;
    self.layer.borderWidth = _BorderWidth;
}
/**
 *  标题字体颜色
 */
-(void)setTextColor:(UIColor *)TextColor{
    
    _TextColor = TextColor;
    _mainTitleLabel.textColor = _TextColor;
}
/**
 *  点击选中标题字体改变颜色
 */
-(void)setSelectColor:(UIColor *)SelectColor{
    
    _SelectColor = SelectColor;
}
/**
 *  默认标题
 */
-(void)setDefaultTitle:(NSString *)DefaultTitle{
    
    _DefaultTitle = DefaultTitle;
    
    if(SelectTitle&&![SelectTitle isEqualToString:EMPTY]){
        _mainTitleLabel.text = SelectTitle;
    } else {
        _mainTitleLabel.text = _DefaultTitle;
    }
}
/**
 *  箭头颜色
 */
-(void)setArrowColor:(UIColor *)ArrowColor{
    
    _ArrowColor = ArrowColor;
    _shapeLayer.fillColor = _ArrowColor.CGColor;
}
/**
 *  下拉菜单点击状态
 */
-(void)selsctview{

    if (_DataArray.count > 0) {
        select = !select;
        if (select) {
            [self doDropDown];
        } else {
            [self doDropDownReduction];
        }
    }
}
/**
 *  默认选中
 *
 *  @param row 选中行数
 */
-(void)selectRow:(NSInteger)row childrow:(NSInteger)childrow{

    NSMutableDictionary *SystemUserDict = [NSMutableDictionary dictionaryWithContentsOfFile:SYSTEM_USER_DICT];
    NSDictionary *title = [NSDictionary dictionaryWithDictionary:_DataArray[row]];
    NSArray *floornoinfo = [NSArray arrayWithArray:title[@"floornoinfo"]];
    
    [SystemUserDict setValue:title[@"facilitycd"] forKey:@"mainvcfacilitycd"];
    if (floornoinfo.count > 0) {
        [SystemUserDict setValue:title[@"floornoinfo"][childrow][@"floorno"] forKey:@"mainvcfloorno"];
        if ([SystemUserDict writeToFile:SYSTEM_USER_DICT atomically:YES]) {
            [self selectDropDown:[NSString stringWithFormat:@"%@ %@",title[@"facilityname2"],title[@"floornoinfo"][childrow][@"floorno"]]];
        }
    } else {
        [SystemUserDict setValue:@"" forKey:@"mainvcfloorno"];
        if ([SystemUserDict writeToFile:SYSTEM_USER_DICT atomically:YES]) {
            [self selectDropDown:[NSString stringWithFormat:@"%@",title[@"facilityname2"]]];
        }
    }
    
    
}

#pragma marker---- tableView dataSource----

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSInteger rowcount;
    
    if (child) {
        rowcount = _ChildDataArray.count;
    } else {
        rowcount = _DataArray.count;
    }
    
    return rowcount;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return self.frame.size.height;
}
/**
 *  cell的显示
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DDIdentifier"];
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:FontSize];
    cell.textLabel.textColor = SystemColor(1.0);
//    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.backgroundColor = [UIColor whiteColor];

    //判断是否有子菜单
    if (child) {
        [self cellboolchild:_ChildDataArray[indexPath.row] cell:cell];
    } else {
        [self cellboolchild:_DataArray[indexPath.row] cell:cell];
    }
    return cell;
}
/**
 *  cell数据源是否存在子菜单判断
 */
-(void)cellboolchild:(id)title cell:(UITableViewCell*)cell{
    NSArray *floornoinfo = [NSArray arrayWithArray:title[@"floornoinfo"]];
    if (floornoinfo.count > 0) {//有子菜单
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    }
    
    if (child) {
        cell.textLabel.text = title[@"floorno"];
    } else {
        cell.textLabel.text = title[@"facilityname2"];
    }
}

#pragma marker---- tableView delegate----

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //判断是否有子菜单
    if (child) {
        [self boolchild:indexPath.row type:0];
    } else {
        _SelectRow = indexPath.row;
        [self boolchild:indexPath.row type:1];
    }
}

#pragma marker---- 懒加载控件 ----

-(UIView *)Cover{
    if (!_Cover) {
        _Cover = [[UIButton alloc]initWithFrame:self.superview.bounds];
        [self.superview bringSubviewToFront:_Cover];
        _Cover.backgroundColor = [UIColor clearColor];
        [_Cover addTarget:self action:@selector(doDropDownReduction) forControlEvents:UIControlEventTouchDown];
    }
    return _Cover;
}

-(UILabel *)mainTitleLabel{
    if (!_mainTitleLabel) {
        //主标题
        _mainTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width*0.15, 0, self.frame.size.width*0.85, self.frame.size.height)];
        _mainTitleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:FontSize];
//        _mainTitleLabel.textAlignment = NSTextAlignmentCenter;
        _mainTitleLabel.adjustsFontSizeToFitWidth = YES;
        _mainTitleLabel.textColor = _TextColor;
        if(SelectTitle&&![SelectTitle isEqualToString:EMPTY]){
            _mainTitleLabel.text = SelectTitle;
        } else {
            _mainTitleLabel.text = _DefaultTitle;
        }
        _mainTitleLabel.clipsToBounds = YES;
    }
    return _mainTitleLabel;
}
-(UIView *)arrowView{
    if (!_arrowView) {
        //三角形箭头
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width * 0.15, self.frame.size.height)];
        _arrowView = [[UIView alloc]initWithFrame:ArrowViewRect];
        _shapeLayer = [self creatArrowShapeLayer];
        _shapeLayer.fillColor = _ArrowColor.CGColor;
        [_arrowView.layer addSublayer:_shapeLayer];
        _arrowView.userInteractionEnabled = NO;
        _arrowView.center = view.center;
    }
    return _arrowView;
}
-(UITableView *)dropdowntableview{
    if (!_dropdowntableview) {
        //下拉菜单
        _dropdowntableview = [[UITableView alloc]initWithFrame:DropDownReduction];
        [self.Cover bringSubviewToFront:_dropdowntableview];
        _dropdowntableview.layer.cornerRadius = _CornerRadius;
        _dropdowntableview.backgroundColor = [UIColor whiteColor];
        _dropdowntableview.layer.borderColor = SystemColor(1.0).CGColor;
        _dropdowntableview.layer.borderWidth = 1.0;
        _dropdowntableview.separatorStyle = NO;
        _dropdowntableview.dataSource = self;
        _dropdowntableview.delegate = self;
        _dropdowntableview.bounces = NO;
    }
    return _dropdowntableview;
}
-(UIButton *)buttonview{
    if (!_buttonview) {
        //按钮
        _buttonview = [[UIButton alloc]initWithFrame:self.bounds];
        [_buttonview addTarget:self action:@selector(selsctview) forControlEvents:UIControlEventTouchDown];
    }
    return _buttonview;
}
- (CAShapeLayer *)creatArrowShapeLayer{
    //画三角形
    CAShapeLayer *shapeLayer = [[CAShapeLayer alloc] init];
    UIBezierPath *path = [[UIBezierPath alloc] init];
    [path moveToPoint:CGPointMake(0, self.arrowView.frame.size.height/2)];
    [path addLineToPoint:CGPointMake(self.arrowView.frame.size.width/2, 0)];
    [path addLineToPoint:CGPointMake(self.arrowView.frame.size.width, self.arrowView.frame.size.height/2)];
    [path closePath];
    shapeLayer.path = path.CGPath;
    return shapeLayer;
}

#pragma marker---- 手势处理 ----


#pragma marker---- 封装代码 ----
/**
 *  是否存在子菜单判断
 */
-(void)boolchild:(NSInteger)row type:(int)type{
    
    NSMutableDictionary *SystemUserDict = [NSMutableDictionary dictionaryWithContentsOfFile:SYSTEM_USER_DICT];
    NSDictionary *title;
    if (child) {
        title = _ChildDataArray[row];
        [SystemUserDict setValue:[NSString stringWithFormat:@"%ld",(long)row] forKey:@"mainvcchildrow"];
        [SystemUserDict setValue:title[@"floorno"] forKey:@"mainvcfloorno"];
        if ([SystemUserDict writeToFile:SYSTEM_USER_DICT atomically:YES]) {
            [self selectDropDown:[NSString stringWithFormat:@"%@ %@",SelectTitle,title[@"floorno"]]];
        }
    } else {
        title = _DataArray[row];
        [SystemUserDict setValue:[NSString stringWithFormat:@"%ld",(long)row] forKey:@"mainvcrow"];
        NSArray *floornoinfo = [NSArray arrayWithArray:title[@"floornoinfo"]];
        if (floornoinfo.count > 0) {//有子菜单
            [SystemUserDict setValue:title[@"facilitycd"] forKey:@"mainvcfacilitycd"];
            if ([SystemUserDict writeToFile:SYSTEM_USER_DICT atomically:YES]) {
                SelectTitle = title[@"facilityname2"];
                _ChildDataArray = [NSMutableArray arrayWithArray:floornoinfo];
                if (type==1)child = YES;
                [self doDropDown];
            }
        }else{//没有子菜单
            
            select = NO;
            [SystemUserDict setValue:title[@"facilitycd"] forKey:@"mainvcfacilitycd"];
            [SystemUserDict setValue:@"" forKey:@"mainvcfloorno"];
            SelectTitle = title[@"facilityname2"];
            if ([SystemUserDict writeToFile:SYSTEM_USER_DICT atomically:YES]) {
                [self selectDropDown:[NSString stringWithFormat:@"%@",SelectTitle]];
            }
        }
    }

    
}
/**
 *  没有子菜单的情况封装
 */
-(void)selectDropDown:(NSString*)title{
    
    self.mainTitleLabel.text = title;
    [self doDropDownReduction];
    [self.delegate nowSelectRow:title selectrow:_SelectRow];
}
/**
 *  下拉
 */
-(void)doDropDown{
    
    [self.superview addSubview:self.Cover];
    [self.Cover addSubview:self.dropdowntableview];
    
    self.mainTitleLabel.textColor = _SelectColor;
    
    [self.dropdowntableview reloadData];
    
    self.arrowView.transform = CGAffineTransformMakeRotation(M_PI);
    self.dropdowntableview.frame = DropDown;
}
/**
 *  上拉还原
 */
-(void)doDropDownReduction{
    child = NO;
    
    select = NO;
    
    self.mainTitleLabel.textColor = _TextColor;
    self.arrowView.transform = CGAffineTransformIdentity;
    self.dropdowntableview.frame = DropDownReduction;

//    if (self.dropdowntableview.frame.size.height == self.frame.size.height) {
//        
//    }
    [self.dropdowntableview removeFromSuperview];
    [self.Cover removeFromSuperview];
}
/**
 *  table分割线顶格
 */
//-(void)setLastCellSeperatorToLeft:(UITableViewCell *)cell
//{
//    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
//        [cell setSeparatorInset:UIEdgeInsetsZero];
//    }
//    if ([cell respondsToSelector:@selector(setLayoutMargins:)]){
//        [cell setLayoutMargins:UIEdgeInsetsZero];
//    }
//    if([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]){
//        [cell setPreservesSuperviewLayoutMargins:NO];
//    }
//}
@end
