//
//  VSMMapView.h
//  Tmap4
//
//  Created by flintlock on 2014. 10. 27..
//  Copyright (c) 2014년 M&Service. All rights reserved.
//


#import <UIKit/UIKit.h>
#include <AvailabilityMacros.h>

#import "VSMMapViewDefine.h"
#import "VSMMarkerBase.h"
#import "VSMMarkerManager.h"
#import "VSMTransformObject.h"
#import "VSMMapBounds.h"
#import "VSMCameraUpdate.h"
#import "VSMMapMatchingData.h"

@class VSMHandle;
@class VSMLocationManager;
@class VSMMapPoint;
@class MeterPoint;

/**프레임 렌더 시작 프로토콜
 */
@protocol OnWillRenderFrameDelegate <NSObject>
/**프레임 렌더 시작전 호출
 */
-(void)onWillRenderFrame;
@end

/** 지도 출력을 담당하는 클래스
 */
@interface VSMMapView : UIView <HitObjectNativeDelegate>

/** 화면 사이즈 변경 이벤트
 */
@property (atomic, weak) id<MapViewResizeDelegate> _Nullable MapViewResizeDelegate;

/** Touch 동작 이벤트
 */
@property (nonatomic, weak) id<MapTouchDelegate> mapTouchDelegate;

/** Map 관련 이벤트
 */
@property (nonatomic, weak) id<MapDataDelegate> mapDataDelegate;

/** POI Scale 변경 이벤트
*/
@property (nonatomic, weak) id<PoiScaleChangeDelegate> poiScaleChangeDelegate;

/** Map Title Angle
 */
@property (nonatomic, assign, readonly, getter=getTiltAngle) CGFloat tiltAngle;

/** Map Rotate Angle
 */
@property (nonatomic, assign, readonly, getter=getRotationAngle) CGFloat rotateAngle;

/** Map Move Mode
 *@see MapTrackMode
 */
@property (nonatomic, assign) MapTrackMode trackMode;

/** 터치 지원 여부 (default: YES)
 */
@property (nonatomic, assign) bool enableTouch;

/** POI 출력 여부 (default: YES)
 */
@property (nonatomic, assign) bool showPOI;

/** POI BoundingBox 출력 여부 (default: NO)
 */
@property (nonatomic, assign) bool showPOIBBox;

/** POI 충돌 Margin  (default:  0)
 */
@property (nonatomic, assign) float poiCollisionMargin;

/** 빌딩 출력 높이 (0.0 ~ 1.0)
 */
@property (nonatomic, assign) float buildingHeight;

/** Building Pattern 적용 여부 (default: NO)
 */
@property (nonatomic, assign) bool enableBuildingPattern;

/** 지하철 출력 여부 (default: YES)
 */
@property (nonatomic, assign) bool enableRenderSubwayLines;

/** 지하철/고속철도/경전철/일반철도/인천공항 노선 표출 출력 여부 (default: YES)
 */
@property (nonatomic, assign) bool enableRenderRailroads;

/** Building Filter 설정
 * @see VSMBuildingFilterMode
 */
@property (nonatomic, assign) VSMBuildingFilterMode buildingFilterMode;

/** Traffic Info 지도 에 출력
 */
@property (nonatomic, assign) bool showTrafficInfoOnMap;

/** CCTV 정보를 지도에 출력
 */
@property (nonatomic, assign) bool showCctv;

/** CCTV정보 사이즈 배율. (default: 1.0f)
 */
@property (nonatomic, assign) float cctvScale;

/** 유고/돌발 정보를 지도에 출력
 */
@property (nonatomic, assign) bool showAccidentInfo;

/** 유고/돌발 정보 사이즈 배율. (default: 1.0f)
 */
@property (nonatomic, assign) float accidentInfoScale;

/** 스크린 너비
 */
@property (nonatomic, assign, readonly) GLint currentWidth;

/** 스크린 높이
 */
@property (nonatomic, assign, readonly) GLint currentHeight;

/** Screen에서 Position icon 이 출력될 center 영역 (0, 0) ~ (1, 1)
 */
@property (nonatomic) CGPoint screenCenter;

/** 렌더링 주기 ms  (default: 30frame/1초)
 */
@property (nonatomic, assign) NSInteger renderTime;

@property (nonatomic, assign) NSInteger densityDpi DEPRECATED_MSG_ATTRIBUTE("use customDensityDpi instead.");

/** DPI. (default: CententScale * 160)
 */
@property (nonatomic, assign) NSInteger customDensityDpi;

/** 핸들
 */
@property (nonatomic, strong, readonly, nonnull) VSMHandle* vsmHandle;

@property (nonatomic, assign) CGFloat poiScale;

/** Poi 텍스트 크기 비율. (default: 1.25)
 */
@property (nonatomic, assign) CGFloat poiCaptionScale;

/** Poi 아이콘 크기 비율. (default: 1.25)
*/
@property (nonatomic, assign) CGFloat poiIconScale;

/** 터치 트랜스폼 오브젝트
 */
@property (nonatomic, strong) VSMTransformObject* transObject;


/** 도로 외곽선 출력 여부 (default: NO)
 */
@property (nonatomic, assign) bool showRoadOutline;

/** 도로명 POI 출력 여부 (default: NO)
 */
@property (nonatomic, assign) bool showRoadNamePoi;

/** 경로선 위 도로명 POI 출력 여부 (default: NO)
 */
@property (nonatomic, assign) bool showRoadNamePoiOnRoute;

/** [Internal use only] 도로네트워크 출력 여부 (default: NO)
 */
@property (nonatomic, assign) bool showRoadNetworkLine;

/**    사용자 차량의 유종 타입. (휘발유:0, 디젤:1, LPG:2, 전기차:3, 고급휘발유:4)
 */
@property (nonatomic, assign) NSInteger oilType;

/** 건물 출력 여부 (0: None, 1: 2D only, 2: 3D only, 3: 2D & 3D)
 * @see BuildingShowType
 */
@property (nonatomic, assign) BuildingShowType showBuildingType;

// app 에서 세팅하는 것으로 변경.
/** 정확한 scale값이 들어오면 YES를 리턴합니다.
 */
//@property (nonatomic, assign) BOOL preciseScaleFactor;

/** 표출 최소 뷰 레벨
 */
@property (nonatomic, readonly, getter=getMinZoomLevel) NSInteger minZoomLevel;

/** 표출 최대 뷰 레벨
 */
@property (nonatomic, readonly, getter=getMaxZoomLevel) NSInteger maxZoomLevel;

/** 지도 유효 사각영역 WGS84 좌표
 * @see VSMMapBounds
 */
@property (nonatomic, retain, nonnull) VSMMapBounds* mapValidArea;

/** 지도 유효 사각영역 가시 여부 (default: NO)
 */
@property (nonatomic, assign) bool showMapValidArea;

@property (nonatomic, assign) bool showVertex;

/**
 * Scroll Gesture 사용 여부 설정
 */
@property (nonatomic, assign) bool scrollGesturesEnabled;

/**
 * Rotate Gesture 사용 여부 설정
 */
@property (nonatomic, assign) bool rotateGesturesEnabled;

/**
 * Tilt Gesture 사용 여부 설정
 */
@property (nonatomic, assign) bool tiltGesturesEnabled;

/**
 * Scale Gesture 사용 여부 설정
 */
@property (nonatomic, assign) bool scaleGesturesEnabled;

/**
 * Quick Scale Gesture 사용 여부 설정
 */
@property (nonatomic, assign) bool quickScaleGesturesEnabled;


/** UIView 의 viewDidLoad 함수
 */
- (void) viewDidLoad;

/** UIView 의 viewWillAppear 함수
 */
- (void) viewWillAppear;

/** UIView 의 viewWillDisappear 함수
 */
- (void) viewWillDisappear;

/** 지도의 뷰 레벨을 지정합니다.
 @param level 지도 뷰 레벨  값.
 @param isSmooth 지도의 뷰 레벨 변경시 에니메이션 효과 여부
 */
- (void) setMapViewLevel:(NSInteger)level isSmooth:(BOOL)isSmooth;

/**    지도의 뷰 레벨을 한단계 지정합니다.
 
 @param type level 설정 Type. (MapViewLevelChangeType)
 */
- (void) startSmoothZoom:(MapViewLevelChangeType)type;

/** 지도에 설정된 뷰 레벨을 리턴합니다.
 @param mainLevel 얻고자 하는 메인 뷰 레벨
 @param subLevel 얻고자 하는 서브 뷰 레벨(0 ~ 999)
 */
- (void) getZoomLevel:(NSInteger*)mainLevel
             subLevel:(NSInteger*)subLevel;

/**    지도 뷰 레벨을 설정합니다.
 @param mainLevel 메인 뷰 레벨
 @param subLevel 서브 뷰 레벨 (0~999)
 @param animated 뷰 레벨 변경시, 에니메이션 효과 적용 여부
 */
- (void) setZoomLevel:(NSInteger)mainLevel
             subLevel:(NSInteger)subLevel
             animated:(BOOL)animated;

// [deprecated] Map center를 설정합니다.
// @param screenX 지도의 중심점이 될 월드 X 좌표.
// @param screenY 지도의 중심점이 될 월드 Y 좌표.
- (bool) setMapCenter:(int)screenX screenY:(int)screenY isAnim:(bool)isAnim;

/** screen좌표 상의 world 좌표를 화면 중심으로 이동시킵니다.
 @param screenX 지도의 중심점이될 월드 X 좌표.
 @param screenY 지도의 중심점이될 월드 Y 좌표.
 @param isAnim 지도 이동시 에니메이션 효과 여부
 */
- (BOOL) mapMoveToByScreen:(NSInteger)screenX
                   screenY:(NSInteger)screenY
                    isAnim:(BOOL)isAnim;

/** 지도의 중심점을 이동합니다.
 
 @param longitude Map의 중심점이될 경도 좌표.
 @param latitude Map의 중심점이될 위도 좌표.
 @param isAnim 이동시 에니메이션 효과 여부.
 
 @return boolean 지동 이동 지정 성공 여부.
 */
- (bool) setMapCenter:(double)longitude latitude:(double)latitude isAnim:(bool)isAnim;

/**
 * 지도중심의 wgs84 좌표를 얻습니다.
 * @return 지도중심의 wgs84 좌표
 * @see VSMMapPoint
 */
- (VSMMapPoint*) getMapCenter;


/** 지도의 중심점을 이동합니다.
 @param scale 현 상태에서 상대적 배율
 @param focus 포커싱될 screen좌표
 @param isAnim 이동시 Animation 효과 여부.
 @return boolean 지동 이동 지정 성공 여부.
 */
- (bool)setMapScale:(float)scale focus:(CGPoint)focus isAnim:(bool)isAnim;


/** 지도를 종합적으로 이동합니다.
 *  기본변형 center, zoom, angle, tilt), 기타기능(pivot, screenDelta), fitBounds, animation 설정
 *  @param updateData 이동 데이터
 *  @see VSMCameraUpdate
 */
- (void)moveCamera:(nullable VSMCameraUpdate*)updateData;


// WGS84 좌표를 Screen 좌표로 변환합니다. (Deprecated API)
// @param longitude longitude 좌표
// @param latitude latitude 좌표
// @param screenX screen X 좌표
// @param screenY screen Y 좌표
//
// @return boolean 변환 성공 여부.

- (bool) wgs84ToScreen:(double)longitude latitude:(double)latitude screenX:(int* _Nonnull)screenX screenY:(int* _Nonnull)screenY DEPRECATED_ATTRIBUTE;


/** WGS84 좌표를 Screen 좌표로 변환합니다.
 @param longitude 경도 좌표
 @param latitude 위도 좌표
 @param outPoint 위경도의 화면상 좌표(dp)
 @return boolean 변환 성공 여부.
 */
- (BOOL) wgs84ToScreen:(double)longitude
              latitude:(double)latitude
                 point:(CGPoint* _Nonnull)outPoint;


// Screen 좌표를 WGS84 좌표로 변환한다. (Deprecated API)
// @param screenX screen X 좌표
// @param screenY screen Y 좌표
// @param longitude longitude 좌표
// @param latitude latitude 좌표
// @return boolean 변환 성공 여부.
//
- (bool) screenToWgs84:(float)screenX screenY:(float)screenY longitude:(double* _Nonnull)longitude latitude:(double* _Nonnull)latitude DEPRECATED_ATTRIBUTE;


/** Screen 좌표를 WGS84 좌표로 변환합니다.
 @param point screen 좌표(dp)
 @param longitude 경도 좌표
 @param latitude 위도 좌표
 @return boolean 변환 성공 여부.
 */
- (BOOL) screenToWgs84:(CGPoint)point longitude:(double* _Nonnull)longitude latitude:(double* _Nonnull)latitude;

///Marker API 객체

/** Marker Manager 반환합니다.
 */
- (VSMMarkerManager* _Nonnull) getMarkerManager;

/** User define의 callout popup 을 출력합니다.
 @param popupText 출력할 문구
 @param popupID ID
 @param longitude 경도
 @param latitude 위도
 */
- (void) showUserDefineCalloutPopup:(NSString*)popupText popupID:(int)popupID longitude:(double)longitude latitude:(double)latitude;

/** User define의 callout popup 을 제거합니다.
 @param isAnim Animation 적용 여부
 */
- (void) removeUserDefineCalloutPopups:(bool)isAnim;

// Hit test(deprecated API)
// @param screenPixelX Hit test X 픽셀좌표(pixel)
// @param screenPixelY Hit test Y 픽셀좌표(pixel)
// @param block Hit test 검출된 정보 전달 block
// @return hit 성공 여부
 
- (bool) hitTest:(float)screenPixelX y:(float)screenPixelY block:(HitTestCompleteBlock)block;

/** 히트테스트
 @param point 히트 테스트 스크린 좌표 좌표(dp)
 @param block 히트 테스트 검출된 정보 전달 블럭
 @return 히트 성공 여부
 */
- (bool) hitTest:(CGPoint)point block:(HitTestCompleteBlock)block;


/**
 * 화면 갱신 요청합니다.
 */
- (void) requestRender;


/**틸트 각도를 변경합니다.
 0도일 경우 2D뷰를 바라봅니다. 축적별로 각도 제한이 존재하며 제한 각도 이상의 값을 설정하지 못합니다.
 
 @param angle Tilt(끄덕각)각도 지정, 최대 값을 넘길 경우 최대 각도로 설정 됩니다.
 @param animation 애니메이션 사용 유무
 
 @return 뷰 핸들 객체가 유효하면 YES리턴.
 */
-(BOOL)setTiltAngle:(CGFloat)angle withAnimation:(BOOL)animation;

/** 회전 각도를 변경합니다.
 0도이면 정북 방향을 바라봅니다.
 @param angle 변경하려는 회전 각도
 @param animation 애니메이션 사용 유무
 */
-(BOOL)setRotationAngle:(CGFloat)angle
          withAnimation:(BOOL)animation;

/** 회전 각도 변경합니다.
0도이면 정북 방향을 바라봅니다.
@param angle 변경하려는 회전 각도  (0도 ~ 360도)
@param rotationMode 회전 방식 ( 0: 회전 없이 바로 각도 설정, 1: 자동, 2: 강제로 시계방향(clock-wise)회전, 3: 강제로 반시계방향 회전(counter-clock-wise)
*/
-(BOOL)setRotationAngle:(CGFloat)angle
       withRotationMode:(NSInteger)rotationMode;

/**
 * 주어진 화면 영역에 지도의 bound가 들어오도록 합니다.
 * 단, 지도에 tilt 및 rotation이 적용된 경우는 동작을 보장하지 않습니다.
 *
 * @param screenRect 화면 영역
 * @param northeast bound의 북동쪽 위치
 * @param southwest bound의 남서쪽 위치
 * @return 성공 여부
 * @see VSMMapPoint
 */
-(BOOL)drawMBRAll:(CGRect)screenRect
        northeast:(VSMMapPoint*)northeast
        southwest:(VSMMapPoint*)southwest;


#pragma mark - GPS Accuracy Drawing API
/** GPS 정확도 원 표출 여부 (default: NO)
 */
@property (nonatomic) BOOL showsGPSAccuracyCircle;

/**
 *  카메라 시점 오프셋 (0~1 사이값) 설정합니다.
 *  @param normalizedScreenPoint 정규화된 오프셋 값
 */
- (void) SetEyeOffset:(CGPoint) normalizedScreenPoint;

/**
 *  Flag에 해당하는 카메라 에니메이션 중단합니다.
 *  @param animationFlags 중단하고자 하는 속성 Flag
 */
- (void) stopCameraAnimation:(CameraAnimationFlags)animationFlags;

/**
 * Setting 프로퍼티값 Key/Value 추가합니다.
 * @param key key
 * @param value value
 */
- (void) setProperty:(NSString*)key
               value:(NSString*)value;

#pragma mark - Map Style

/**
 * 지도 스타일을 설정합니다.
 * @param styleName 스타일 이름
 */
- (void) setMapStyle:(NSString*) styleName;

/**
 * 도로 카테고리별 도로명 표출 여부를 설정합니다.
 * @param roadCategory 설정 타겟 카테고리 범위
 * @param show 도로명 표출 여부
 * @see RoadCategoryLevel
 */
-(void) setShowRoadCategory:(RoadCategoryLevel)roadCategory
                       show:(BOOL)show;

/**
 * 도로 카테고리별 도로명 표출 여부 반환합니다.
 * @param roadCategory 질의할 roadCategory 설정 카테고리 범위
 * @return 도로명 표출 여부
 * @see RoadCategoryLevel
 */
-(BOOL) showRoadCategory:(RoadCategoryLevel)roadCategory;

/**
 * 링크 카테고리별 표출 여부 설정합니다.
 * @param category 설정할 카테고리 범위
 * @param show 링크 표출 여부
 */
-(void) setShowLinkCategory:(NSInteger)category
                       show:(BOOL)show;

/**
 * 링크 카테고리별 표출 여부 설정합니다.
 * @param category 질의할 카테고리 범위
 * @return링크 표출 여부
 */
-(BOOL) showLinkCategory:(NSInteger)category;

-(void) setShowLinkFacility:(NSInteger)category
                       show:(BOOL)show;

-(BOOL) showLinkFacility:(NSInteger)category;

/** 지도 스크린샷 이미지합니다.
 */
@property (nonatomic, strong) UIImage* capturedImage;

/** 지도 스크린샷 허용 여부합니다.
 */
@property (nonatomic, assign) BOOL screenCaptureMode;

/** 지도 스크린샷 찍습니다.
 @param size 스크린 사이즈
 @return 캡처 이미지
 */
- (nullable UIImage*) captureScreen:(CGSize)size;

#pragma mark - Location

/**
 * 위치 정보 매니저
 * @see VSMLocationManager
 */
@property (nonatomic, strong, readonly, nonnull) VSMLocationManager* locationManager;

#pragma mark - OnWillRenderFrameDelegate

/**
 * OnWillRenderFrameDelegate 추가
 * @see OnWillRenderFrameDelegate
 */
-(void) addOnWillRenderFrameDelegate:(nonnull id<OnWillRenderFrameDelegate>)delegate;

/**
 * OnWillRenderFrameDelegate 삭제
 * @see OnWillRenderFrameDelegate
 */
-(void) removeOnWillRenderFrameDelegate:(nonnull id<OnWillRenderFrameDelegate>)delegate;

#pragma mark - Effective Region

/**
 * 지정 화면을 설정합니다.
 * @param screenRect 지정 화면
 */
-(void) setMapEffectiveRegion:(CGRect)screenRect;

/**
 * 마커를 지정된 화면 영역 안으로 이동시킵니다.
 * @param marker 마커
 * @param animation 효과 여부
 * @see VSMMarkerBase
 */
-(void) moveIntoEffectiveRegion:(nonnull VSMMarkerBase*)marker withAnimation:(BOOL)animation;

/**
 * 특정 오브젝트를 지정된 화면 영역 안으로 이동시킵니다.
 * @param objectId  오브젝트 아이디
 * @param objectType 오브젝트 타입 OBJECT_POI, OBJECT_TRAFFIC
 * @param animation 애니메이션 효과 여부
 */
-(void) moveIntoEffectiveRegion:(int)objectId objectType:(VSMObjectType)objectType withAnimation:(BOOL)animation;

#pragma mark - Traffic

/**
 * 주변교통정보 중 표시하지 않을 링크 목록을 설정합니다.
 * @param linkIds 링크ID array pointer
 * @param linkCount 링크 수
 */
-(void) setTrafficInfoFilterOut:(const uint32_t* _Nullable)linkIds linkCount:(uint32_t)linkCount;

#pragma mark - MapEngine으로부터 수신한 HitTest 결과 처리 (Don't override)

/**
 * MapEngine으로부터 수신한 HitTest 결과를 처리합니다.
 * @param type 히트된 오프젝트 타입
 * @param objectID 오브젝트ID
 * @param meterPoint 지점(EPSG3857)
 * @param hitCallout 콜아웃을 히트했는지 여부
 * @param showCallout 콜아웃을 띄울 것인지 여부
 * @see HitObjectType
 * @see MeterPoint
 * @see ObjectProperty
 *
 */
- (void)dispatchHitTestResult:(HitObjectType)type
                     objectID:(int)objectID
                   meterPoint:(MeterPoint* _Nonnull)meterPoint
                     property:(ObjectProperty* _Nonnull)property
                   hitCallout:(bool)hitCallout
                  showCallout:(bool* _Nullable)showCallout;
/**
 * MapDataDelegate에 뷰 레벨 변경 고지합니다.
 * @param level 메인 뷰 레벨
 * @param subLevel 서브 뷰 레빌
 */
- (void)dispatchViewLevelChanged:(int32_t)level subLevel:(int32_t)subLevel;

/**
 * MapDataDelegate에 현 위치 변경 고지합니다.
 * @param meterPoint 지점(EPSG3857)
 * @see MeterPoint
 */
- (void)dispatchPositionChanged:(MeterPoint* _Nonnull)meterPoint;

/**
 * MapDataDelegate에  Z회전 고지합니다.
 * @param angle 회전각 (Degree)
 */
- (void)dispatchViewAngleChanged:(float)angle;

/**
 * MapDataDelegate에  X회전 고지합니다.
 * @param tiltAngle 회전각 (Degree)
 */
- (void)dispatchViewTiltChanged:(float)tiltAngle;

#pragma mark - Dirty Rendering

/** 다음 frame이 그려지도록 요청한다.
 */
- (void)triggerRepaint;

/**
 * 스택 그룹명칭으로 특정 스택 표출 여부를 설정. App config에 종속된 settings file을 통해 정의된 name을 사용합니다.
 * @param stackGroupName 스택 그룹명
 * @param visibility 표출 여부
 */
- (void)setStackGroupVisibility:(NSString*)stackGroupName visibility:(BOOL)visibility;

/**
 * POI 카테고리 명칭으로 POI 표출 여부를 설정. App config에 종속된 settings file을 통해 정의된 name을 사용합니다.
 * @param categoryGroupName 카테고리 그룹명
 * @param visibility 표출 여부
 */
- (void)setPOICategoryGroupVisibility:(NSString*)categoryGroupName visibility:(BOOL)visibility;


#pragma mark - Screen Area Boundary
/**
 * 지도 유효 영역 가시여부 설정합니다.
 * @param showScreenBounds 지도 유효 영역 가시여부
 */
- (void)setShowMapValidArea:(BOOL)showScreenBounds;

/**
 * 지도 유효 영역 설정합니다.
 * @param screenBounds 지도 유효 영역 (WGS84)
 * @see VSMMapBounds
 */
- (void)setMapValidArea:(nonnull VSMMapBounds*)screenBounds;


#pragma mark - MM Renderer
/**
 * 맵매칭 데이터 표출 여부 설정합니다.
 * @param show 맵매칭 데이터 표출 여부
 */
- (BOOL)setMapMatchingDrawStatus:(BOOL)show;

/**
 * 맵매칭 포인트 쌍을 추가하여 렌더링합니다.
 * @param gps GPS 포인트 (WGS84)
 * @param match 매칭 포인트 (WGS84)
 * @see VSMMapMatchingPoint
 */
- (BOOL)addMapMatchingPos:(VSMMapMatchingPoint*)gps match:(VSMMapMatchingPoint*)match;

/**
 * 맵매칭 포인트 쌍을 모두 제거합니다.
 */
- (BOOL)clearMapMatchingPos;

/**
 * 맵매칭 네트워크 정보를 추가하여 렌더링합니다.
 * @param network 맵매칭 네트워크
 * @see VSMMapMatchingNetwork
 */
- (BOOL)addMapMatchingNetwork:(VSMMapMatchingNetwork*)network;

/**
 * ID에 해당하는 맵매칭 네트워크 1개를 삭제합니다.
 * @param identifier 네트워크 ID
 */
- (BOOL)removeMapMatchingNetwork:(int)identifier;

/**
 * 맵매칭 네트워크내 링크 색상을 변경합니다.
 * @param networkIdentifier 네트워크 ID
 * @param linkIdentifier 링크 ID
 * @param colorType 변경할 색 타입
 */
- (BOOL)updateMapMatchingLinkColor:(int)networkIdentifier linkIdentifier:(int)linkIdentifier colorType:(int)colorType;

/**
 * 맵매칭 사각영역을 추가하여 렌더링합니다.
 * @param rect 사각 영역  (WGS84)
 * @see VSMMapMatchingRect
 */
- (BOOL)addMapMatchingRect:(VSMMapMatchingRect*)rect;

/**
 * 맵매칭 사각영역을 삭제합니다.
 */
- (BOOL)clearMapMatchingRect;
@end
