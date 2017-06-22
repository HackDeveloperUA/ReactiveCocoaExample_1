//
//  ViewController.m
//  ReactiveExample_1
//
//  Created by Uber on 22/06/2017.
//  Copyright © 2017 Uber. All rights reserved.
//

#import "ViewController.h"

#import <ReactiveCocoa/ReactiveCocoa.h>



@interface ViewController ()

//UI
@property (weak, nonatomic) IBOutlet UIButton *changeNameButtton;
@property (weak, nonatomic) IBOutlet UIButton *changeAgeButton;
@property (weak, nonatomic) IBOutlet UIButton *changePasswordButton;
@property (weak, nonatomic) IBOutlet UIButton *changeSurenameButton;
@property (weak, nonatomic) IBOutlet UISwitch *switchIsConfirmation;
@property (weak, nonatomic) IBOutlet UIButton *task5Button;

// Data
@property (nonatomic, strong) NSString* username;
@property (nonatomic, strong) NSString* surename;
@property (nonatomic, strong) NSString* password;
@property (nonatomic, strong) NSString* passwordConfirmation;
@property (nonatomic, assign) NSInteger age;

@property (nonatomic, assign) BOOL createEnabled;

// Helpers Data
@property (nonatomic, strong) NSArray* names;
@property (nonatomic, strong) NSArray* passwords;
@property (nonatomic, strong) NSArray* surenames;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialSetupController];
    
    
    // Задание 1
    // RACObserve - создает сигнал и отправляет новое измененное значение в newName
    
    [RACObserve(self, username) subscribeNext:^(NSString *newName) {
        NSLog(@"currentName: %@",self.username);
        NSLog(@"newName: %@\n\n", newName);
    }];
    
    
    //  Задание 2
    //  В отличие от KVO, сигнал могут быть соединены и работать вместе.
    //  filter возвращает новый сигнал только если в его теле (в теле filter) возвращается YES;
    
    [[RACObserve(self, surename)
      filter:^(NSString *newSurname) {
          return [newSurname hasPrefix:@"v"];
      }]
     subscribeNext:^(NSString *newSurname) {
         NSLog(@"%@", newSurname);
     }];

    
    //  Задание 3
    //  Совмещение двух сигналов биндингов
    RAC(self, createEnabled) = [RACSignal combineLatest:@[ RACObserve(self, password),
                                                           RACObserve(self, passwordConfirmation)]
                                
                                                // Reduce всегда возвращает одно значение,в нашем случае BOOL
                                                // YES будет только в случае совпадения паролей
                                
                                                 reduce:^(NSString* password, NSString* passwordConfirmation){
                                                     NSLog(@"-- %d",[passwordConfirmation isEqualToString:password]);
                                                     return @([passwordConfirmation isEqualToString:password]);
                                                 }];
    
    // Задание 4
    // Биндинг на createEnabled, когда оно будет YES, включить switch
    
    [RACObserve(self, createEnabled) subscribeNext:^(NSNumber *newCreateEnable) {
        BOOL convertCreateEnable = [newCreateEnable boolValue];
        if (convertCreateEnable)
        [self.switchIsConfirmation setOn:convertCreateEnable];
    }];
    
    // Задание 5
    // Сигналы могут быть построены на любом потоке значений с течением времени,
    // а не только на KVO. Например, они также могут представлять нажатия кнопок:
    
    self.task5Button.rac_command = [[RACCommand alloc] initWithSignalBlock:^(id _) {
        NSLog(@"button was pressed!");
        return [RACSignal empty];
    }];
}


#pragma mark - Action

// Name
- (IBAction)changeUserNameAction:(UIButton *)sender
{
    self.username = self.names[ arc4random_uniform((uint32_t)_names.count-1) ];
}

// Password
- (IBAction)changePasswordAction:(UIButton *)sender
{
    self.password = self.passwords[ arc4random_uniform((uint32_t)_passwords.count-1) ];
}

// Age
- (IBAction)changeAgeAction:(UIButton *)sender
{
    self.age = arc4random_uniform(70);
}

// Surename
- (IBAction)changeSurename:(UIButton *)sender
{
    self.surename = self.surenames[ arc4random_uniform((uint32_t)_surenames.count-1) ];
}




#pragma mark - Settuping

-(void) initialSetupController {
    
    self.names = [NSArray arrayWithObjects:@"Andrew", @"Max", @"Alexsandr", @"Steve", nil];
    self.passwords = [NSArray arrayWithObjects:@"777MyPassword", @"vfhbyf",   @"marina", @"vpassword",
                                               @"yfnfif",   @"cjkysirj", @"123456", @"vnikita", nil];
     self.surenames = [NSArray arrayWithObjects:@"Skibinski", @"Lovenko", @"Jobs", @"Green", nil];
     self.passwordConfirmation = @"777MyPassword";
}


@end
