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
#define DropDown CGRectMake(self.frame.origin.x, self.frame.origin.y+self.frame.size.height+4, self.frame.size.width,((SuperView.bounds.size.height - (self.frame.origin.y + self.frame.size.height))-self.frame.size.height*(child?_ChildDataArray.count:_DataArray.count))<=0 ? (SuperView.bounds.size.height - (self.frame.origin.y + self.frame.size.height))-5 : self.frame.size.height*(child?_ChildDataArray.count:_DataArray.count))
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
    self.backgroundColor = [UIColor colorWithRed:0.98 green:0.98 blue:0.98 alpha:1.0];
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(0,0);
    self.layer.shadowOpacity = 0.3;
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
    [self.superview addSubview:self.dropdowntableview];
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
    }else{
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

    select = !select;
    if (select) {
        [self doDropDown];
    } else {
        [self doDropDownReduction];
    }
}
/**
 *  默认选中
 *
 *  @param row 选中行数
 */
-(void)selectRow:(NSInteger)row{
    _SelectRow = row;
    NSDictionary *dict = _DataArray[row];
    [self boolchild:dict[@"displayname"] type:2];
}

#pragma marker---- tableView dataSource----

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSInteger rowcount;
    
    if (child) {
        rowcount = _ChildDataArray.count;
    }else{
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
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.backgroundColor = _TextColor;

    //判断是否有子菜单
    if (child) {
        [self cellboolchild:_ChildDataArray[indexPath.row] cell:cell];

    }else{
        NSDictionary *dict = _DataArray[indexPath.row];
        [self cellboolchild:dict[@"displayname"] cell:cell];
    }
    return cell;
}

#pragma marker---- tableView delegate----

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //判断是否有子菜单
    if (child) {
        [self boolchild:_ChildDataArray[indexPath.row] type:0];
    }else{
        _SelectRow = indexPath.row;
        NSDictionary *dict = _DataArray[indexPath.row];
        [self boolchild:dict[@"displayname"] type:1];
    }
}

#pragma marker---- 懒加载控件 ----

-(UILabel *)mainTitleLabel{
    if (!_mainTitleLabel) {
        //主标题
        _mainTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(2, 0, self.frame.size.width*0.85-2, self.frame.size.height)];
        _mainTitleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:FontSize];
        _mainTitleLabel.textAlignment = NSTextAlignmentCenter;
        _mainTitleLabel.adjustsFontSizeToFitWidth = YES;
        _mainTitleLabel.textColor = _TextColor;
        if(SelectTitle&&![SelectTitle isEqualToString:EMPTY]){
            _mainTitleLabel.text = SelectTitle;
        }else{
            _mainTitleLabel.text = _DefaultTitle;
        }
        _mainTitleLabel.clipsToBounds = YES;
    }
    return _mainTitleLabel;
}
-(UIView *)arrowView{
    if (!_arrowView) {
        //三角形箭头
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(self.frame.size.width*0.85-2, 0, self.frame.size.width*0.15+2, self.frame.size.height)];
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
        _dropdowntableview.layer.cornerRadius = _CornerRadius;
        _dropdowntableview.backgroundColor = [UIColor whiteColor];
        _dropdowntableview.layer.shadowColor = [UIColor blackColor].CGColor;
        _dropdowntableview.layer.shadowOffset = CGSizeMake(0,0);
        _dropdowntableview.layer.shadowOpacity = 1.0;
        _dropdowntableview.separatorStyle = NO;
        _dropdowntableview.dataSource = self;
        _dropdowntableview.delegate = self;
        _dropdowntableview.hidden = YES;
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
    [path moveToPoint:CGPointMake(0, _arrowView.frame.size.height/2)];
    [path addLineToPoint:CGPointMake(_arrowView.frame.size.width/2, 0)];
    [path addLineToPoint:CGPointMake(_arrowView.frame.size.width, _arrowView.frame.size.height/2)];
    [path closePath];
    shapeLayer.path = path.CGPath;
    return shapeLayer;
}

#pragma marker---- 手势处理 ----
/**
 *  子控件超出父控件fram依旧响应点击事件
 */
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    
    CGPoint button =  [self convertPoint:point toView:_buttonview];
    CGPoint table =  [self convertPoint:point toView:_dropdowntableview];
    BOOL buttonbool = [_buttonview pointInside:button withEvent:event];
    BOOL tablebool = [_dropdowntableview pointInside:table withEvent:event];
    
    if (buttonbool){
        return _buttonview;
    }else if(tablebool){
        return _dropdowntableview;
    }else{
        UIView *hitView = [super hitTest:point withEvent:event];
        if (hitView == self){
            return nil;
        }else{
            return [super hitTest:point withEvent:event];
        }
    }
}
/**
 *  点击非本控件收起菜单
 */
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
    
    select = NO;
    [self doDropDownReduction];
    return YES;
}

#pragma marker---- 封装代码 ----
/**
 *  cell数据源是否存在子菜单判断
 */
-(void)cellboolchild:(id)title cell:(UITableViewCell*)cell{
    
    if ([title isKindOfClass:[NSString class]]) {
        cell.textLabel.text = title;
    }else if([title isKindOfClass:[NSMutableDictionary class]]||[title isKindOfClass:[NSDictionary class]]){
        cell.textLabel.text = [[title allKeys] firstObject];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    }
}
/**
 *  是否存在子菜单判断
 */
-(void)boolchild:(id)title type:(int)type{

    if ([title isKindOfClass:[NSString class]]) {//没有子菜单
        select = NO;
        if (type==2) {
            SelectTitle = title;
        }else{
            [self selectDropDown:title];
        }
    }else if([title isKindOfClass:[NSMutableDictionary class]]||[title isKindOfClass:[NSDictionary class]]){//有子菜单
        if (type==2) {
            SelectTitle = [[title allKeys] firstObject];
        }else{
            _ChildDataArray = [NSMutableArray arrayWithArray:[title valueForKey:[[title allKeys] firstObject]]];
            if (type==1)child = YES;
            [self doDropDown];
        }
    }
}
/**
 *  没有子菜单的情况封装
 */
-(void)selectDropDown:(NSString*)title{
    
    _mainTitleLabel.text = title;
    SelectTitle = _mainTitleLabel.text;
    [self doDropDownReduction];
    [self.delegate nowSelectRow:SelectTitle selectrow:_SelectRow];

}
/**
 *  下拉
 */
-(void)doDropDown{

    _dropdowntableview.hidden = NO;
    _mainTitleLabel.textColor = _SelectColor;
    
    NSIndexSet * sectionindexset=[[NSIndexSet alloc]initWithIndex:0];
    if (child) {
        [self.dropdowntableview reloadSections:sectionindexset withRowAnimation:UITableViewRowAnimationLeft];
    }else{
        [self.dropdowntableview reloadData];
    }
    
    _arrowView.transform = CGAffineTransformMakeRotation(M_PI);
    _dropdowntableview.frame = DropDown;
}
/**
 *  上拉还原
 */
-(void)doDropDownReduction{
    child = NO;
    _mainTitleLabel.textColor = _TextColor;
    _arrowView.transform = CGAffineTransformIdentity;
    _dropdowntableview.frame = DropDownReduction;

    if (_dropdowntableview.frame.size.height == self.frame.size.height) {
        _dropdowntableview.hidden = YES;
    }
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
