#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>

@implementation ViewController
static AVCaptureSession * captureSession;
static AVCaptureDevice * captureDevice;
static AVAudioPlayer * tapaudio, * moveaudio;
static UIAcceleration * accele;
static BOOL shaking;
const float power = 2.0;

- (void)setupSession {
    captureSession = [[AVCaptureSession alloc] init];
    captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    AVCaptureDeviceInput * videoInput = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:nil];
    AVCaptureMovieFileOutput * movieFileOutput = [[AVCaptureMovieFileOutput alloc] init];
    
    [captureSession beginConfiguration];
    if ([captureSession canAddInput:videoInput])  [captureSession addInput:videoInput];
    if ([captureSession canAddOutput:movieFileOutput])         [captureSession addOutput:movieFileOutput];
    captureSession.sessionPreset = AVCaptureSessionPresetLow;
    [captureSession commitConfiguration];
}

- (void)tapplay:(NSString *)sound {
    NSString *path = [[NSBundle mainBundle] pathForResource:sound ofType:@"mp3"]; 
    NSURL *url = [NSURL fileURLWithPath:path]; 
    tapaudio = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil]; 
    [tapaudio play];
}

#pragma mark - View lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSession];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hundleTap)];
    [self.view addGestureRecognizer:tap];
    
    [[UIAccelerometer sharedAccelerometer] setUpdateInterval:0.1];
    [[UIAccelerometer sharedAccelerometer] setDelegate:self];
    shaking = NO;
}

- (void)flash:(BOOL)on {
    [captureDevice lockForConfiguration:nil];
    captureDevice.torchMode = (on) ? AVCaptureFlashModeOn : AVCaptureFlashModeOff;
    [captureDevice unlockForConfiguration];
}

- (void)hundleTap {   
    self.view.backgroundColor = [UIColor greenColor];
    [self flash:NO];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    NSString * file;
    if (accele.x > 0.5) file = @"b_003";
    if (accele.x < -0.5) file = @"b_090";
    if (accele.y > 0.5) file = @"b_036";
    if (accele.y < -0.5) file = @"b_053";
    if (accele.z > 0.5) file = @"b_039";
    if (accele.z < -0.5) file = @"b_040";
    [self tapplay:file];
    [self flash:YES];
    self.view.backgroundColor = [UIColor colorWithRed:0 green:184 blue:172 alpha:1];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    self.view.backgroundColor = [UIColor redColor];
    [self tapplay:@"b_095"];
    [self flash:NO];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [self tapplay:@"b_008"];
    self.view.backgroundColor = [UIColor yellowColor];
}

- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration {
    accele = acceleration;
    if (shaking) return;
    shaking = YES;
    
    if (acceleration.x > 2 || acceleration.y > 2 || acceleration.z > 2) {
        NSString * mfile;
        if (acceleration.x > 2) mfile = @"ji_001";
        if (acceleration.y > 2) mfile = @"ji_002";
        if (acceleration.z > 2) mfile = @"ji_008";
        NSString *path = [[NSBundle mainBundle] pathForResource:mfile ofType:@"mp3"]; 
        NSURL *url = [NSURL fileURLWithPath:path]; 
        moveaudio = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil]; 
        [moveaudio play];
    }
    shaking = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
