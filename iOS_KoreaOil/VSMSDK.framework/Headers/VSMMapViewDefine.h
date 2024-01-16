//
//  VSMMapViewDefine.h
//  TAModule
//
//  Created by 1001921 on 2015. 4. 5..
//
//

#import <UIKit/UIKit.h>

@class ObjectProperty;
@class VSMMapPoint;

/**
 * hit test 결과의 extra에서 pkey를 조회하기 위한 key.
 */
extern NSString* const OBJECT_EXTRA_PKEY;
/**
 * hit test 결과의 extra에서 stack이 속한 stack group들을 조회하기 위한 key.
 * 해당 stack이 여러 group에 속해 있을 경우 해당 값은 comma로 구분됨.
 */
extern NSString* const OBJECT_EXTRA_STACK_GROUPS;

/**
 * hit test 결과의 extra에서 stack code를 조회하기 위한 key.
 */
extern NSString* const OBJECT_EXTRA_STACK_CODE;

/**
 * cctv hit test 결과의 extra에서 도로명을 조회하기 위한 key.
 */
extern NSString* const OBJECT_EXTRA_CCTV_ROAD_NAME;

/**
 * cctv hit test 결과의 extra에서 방향정보를 조회하기 위한 key.
 */
extern NSString* const OBJECT_EXTRA_CCTV_DIRECTION;

/**
 * cctv hit test 결과의 extra에서 정보제공처를 조회하기 위한 key.
 */
extern NSString* const OBJECT_EXTRA_CCTV_OFFER;

/**
 * cctv hit test 결과의 extra에서 live URL 조회하기 위한 key.
 */
extern NSString* const OBJECT_EXTRA_CCTV_LIVE_URL;

/**
 * cctv hit test 결과의 extra에서 VOD URL을 조회하기 위한 key.
 */
extern NSString* const OBJECT_EXTRA_CCTV_VOD_URL;

/**
 * cctv hit test 결과의 extra에서 영상 생성 시각을 조회하기 위한 key.
 */
extern NSString* const OBJECT_EXTRA_CCTV_TIME;

/**
 *  팝업 마커내 히트된 정규화 위치 X좌표를 조회하기 위한 key.
 */
extern NSString* const OBJECT_EXTRA_HIT_POS_X;

/**
 * 팝업 마커내 히트된 정규화 위치 Y좌표를 조회하기 위한 key.
 */
extern NSString* const OBJECT_EXTRA_HIT_POS_Y;

/**
 * 테마 타입
 * 3 이상은 유저 정의입니다.
 */
typedef NS_ENUM(uint32_t, eObjectThemeType) {
    /** 일반
     */
    THEME_DAY = 1,
    /** 밤
     */
    THEME_NIGHT = 2,
    /** 유저 정의
     */
    THEME_USER_DEFINE = 3,
};

/**
 * 도로 등급을 나타내는 열거형 클래스.
 */
typedef NS_ENUM(NSUInteger, RoadCategoryLevel) {
    /**
     * 도로 등급 0
     */
    RoadCategory_L0 = 1 << 0 | 1 << 1,
    /**
     * 도로 등급 1
     */
    RoadCategory_L1 = 1 << 2 | 1 << 3 | 1 << 4 | 1 << 5 | 1 << 6,
    /**
     * 도로 등급 2
     */
    RoadCategory_L2 = 1 << 7 | 1 << 8 | 1 << 9 | 1 << 11 | 1 << 12,
    /**
     * 도로 등급 해안도로
     */
    RoadCategory_SeaRoute = 1 << 10
};

/**
 * 카메라 에니메이션 트리거 타입
 */
typedef NS_ENUM(NSInteger, CameraAnimationReason) {
    /** UserGesture
     */
    CameraAnimationByUserGesture,
    /** API
     */
    CameraAnimationByAPI,
    /** Internal
     */
    CameraAnimationByInternal
};

/**
 * 카메라 에니메이션 속성 Dirty Flag
 */
typedef NS_ENUM(NSInteger, CameraAnimationFlags) {
    /** 뷰 레벨 Dirty
     */
    CameraAnimation_Level         = 0x00000001,
    /** 지도 중앙 위치 Dirty
     */
    CameraAnimation_Position      = 0x00000002,
    /** 지도 각도 Dirty
     */
    CameraAnimation_Angle         = 0x00000004,
    /** 지도 버드뷰 각도 Dirty
     */
    CameraAnimation_3dAngle       = 0x00000008,
    /** 전부
     */
    CameraAnimation_All           = 0x0000ffff
};

/**
 * 건물 표출 타입
 */
typedef NS_ENUM(NSInteger, BuildingShowType) {
    /** 표출하지 않음.
     */
    BuildingShowType_NONE = 0,
    /** 2D
     */
    BuildingShowType_2D,
    /** 3D
     */
    BuildingShowType_3D,
    /** 2D/3D
     */
    BuildingShowType_2D3D,
};


/**
 * 지도 트랙 모드
 */
typedef NS_ENUM(NSInteger, MapTrackMode)
{
    /** 일반 지도 이동 모드
     */
    MapTrackModeNormal,
    /** 현위치가 지도 중심
     */
    MapTrackModeTrack,
    /** 현위치가 지도 중심 + 현위치 bearing이 지도 상단
     */
    MapTrackModeTrackAndHeadUp
};

/**
 * 지도 뷰 레벨 변경 타입
 */
typedef NS_ENUM(NSInteger, MapViewLevelChangeType) {
    /** 줌 아웃
     */
    MapViewLevelChangeTypeZoomOut = 1,
    /** 줌 인
     */
    MapViewLevelChangeTypeZoomIn,
    /** 줌 커스텀
     */
    MapViewLevelChangeTypeZoomCustom,
};

//typedef enum
//{
//    RouteTypeBasic = 0,
//    RouteTypePassed,
//    RouteTypeAlternative,
//}RouteType;

/**
 * 경로 정보 표출 여부 Flag
 */
typedef NS_OPTIONS(NSInteger, ShowRouteFlag) {
    /**
     * 유고정보 출력
     */
    ShowRouteFlagAccident          = 1<<0,
    /**
     * 경로선 출력
     */
    ShowRouteFlagRouteLine         = 1<<1,
    
    /**
     * 경로선 위 턴지짐에서 방향 출력
     */
    ShowRouteFlagTBT               = 1<<2,
    //ShowRouteFlagSDI               = 1<<3,
    
    /**
     * 경로의 출발지/목적지/경유지 깃발 출력
     */
    ShowRouteFlagFlag              = 1<<4,
    
    /**
     * 경로주변의 주유소/충전소 정보 출력
     */
    ShowRouteFlagOilInfo           = 1<<5,
    
    /**
     * 경로의 주요도로 출력
     */
    ShowRouteFlagMainRoadName      = 1<<6,
    
    /**
     * 출발지부터 목적지까지 방향선 출력
     */
    ShowRouteFlagDestline          = 1<<7
};

/**
 * 건물 필터 타입
 */
typedef NS_ENUM(NSInteger, VSMBuildingFilterMode) {
    /** No Filtering
     */
    BUILDING_FILTER_NONE = 0,
    
    /** 중,소형 건물 2D rendering
     */
    BUILDING_FILTER_L1,
    
    /** 건물 밀집도에 따라 중,소형 건물 2D rendering
     */
    BUILDING_FILTER_L2
};

/**
 * 히트 오브젝트 타입.
 * 히트 테스트시 히트된 오브젝트의 타입들을 나타냅니다.
 */
typedef NS_ENUM(NSInteger, HitObjectType) {
    /** None
     */
    HitObjectTypeNone                 = -1,
    /** POI
     */
    HitObjectTypePOI,
    /** Marker
     */
    HitObjectTypeMarker,
    /** Oil
     */
    HitObjectTypeOIL,
    /** Traffic
     */
    HitObjectTypeTraffic,
    /** CCTV
     */
    HitObjectTypeCctv,
    /** 전기차 충전소 POI
     */
    HitObjectTypeEVPOI,
    /** 대안 경로
     */
    HitObjectTypeAlternativeRoute,
    /** Flag
     */
    HitObjectTypeFlag,
    /** 경로선
     */
    HitObjectTypeRouteLine,
    /** 유저 정의
     */
    HitObjectTypeUserDefine           = 99,
};

/**
 * 히트테스트 완료 블럭
 * @param type 히트 오브젝트 타입
 * @param objectID 오브젝트 ID
 * @param point 오브젝트 위치 (WGS84)
 * @param property 오브젝트 프로퍼티
 * @param hitCallOut 콜아웃을 히트했는지 여부
 * @param showCallout 콜아웃 표출 여부
 */
typedef void (^HitTestCompleteBlock)(HitObjectType type,
                                     int objectID,
                                     VSMMapPoint* point,
                                     ObjectProperty* property,
                                     bool hitCallOut,
                                     bool *showCallout);

/**
 * 오브젝트 타입
 */
typedef NS_ENUM(NSInteger, VSMObjectType) {
    /** POI
     */
    ObjectPOI       = 0,
    /** Traffic
     */
    ObjectTraffic
};

/** Map View Touch deletage
 */
@protocol MapTouchDelegate <NSObject>

@optional
/** Map View Touch Began 이벤트
 * @param touches touches
 * @param event event
 */
- (void) mapViewTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;

/** Map View Touch Ended 이벤트
 * @param touches touches
 * @param event event
 */
- (void) mapViewTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;

/** Map View Touch Canceled 이벤트
 * @param touches touches
 * @param event event
 */
- (void) mapViewTouchesCancled:(NSSet *)touches withEvent:(UIEvent *)event;

/** Map View Long Press 이벤트
 * @param location 지점 screen 좌표
 */
- (void) mapViewLongPressed:(CGPoint)location;

/**
 * Single Tab event
 * @param mapView 터치한 Map View
 * @param screenPoint 지점 screen 좌표
 */
- (void) mapViewDidSingleTap:(UIView *)mapView screenPoint:(CGPoint)screenPoint;

/**
 * Double Tab event
 * @param mapView 터치한 Map View
 * @param screenPoint 지점 screen 좌표
 */
- (void) mapViewDidDoubleTap:(UIView *)mapView screenPoint:(CGPoint)screenPoint;

/**
 * Pinch In event
 * @param mapView Pinch In Map View
 */
- (void) mapViewWillPinchIn:(UIView *)mapView;

/**
 * Pinch Out event
 * @param mapView Pinch Out Map View
 */
- (void) mapViewWillPinchOut:(UIView *)mapView;

/**
 * Panning event
 * @param mapView Panning Map View
 */
- (void) mapViewWillStartPan:(UIView *)mapView;


/**
 * Two Finger Single Tab event
 * @param mapView 터치한 Map View
 * @param screenPoint1 지점 screen 좌표1
 * @param screenPoint2 지점 screen 좌표2
 */
- (void) mapViewDidTwoFingerSingleTap:(UIView *)mapView screenPoint1:(CGPoint)screenPoint1 screenPoint2:(CGPoint)screenPoint2;


@end

/** 지도 뷰  변형 데이터 관련 위임 프로토콜
 */
@protocol MapDataDelegate <NSObject>

@optional
/** Map View Level 변경 이벤트
	@param value 변경된 level
 */
- (void) viewLevelChanged:(NSInteger)value;

/** 현위치 변경 이벤트
	@param point 변경된 위경도 좌표
 *  @see VSMMapPoint
 */
- (void) positionChanged:(VSMMapPoint*)point;

/**
 * 정북 기준 Angle 변경 이벤트
 *
 * @param angle 변경된 Angle
 */
- (void) viewAngleChanged:(float)angle;

/**
 * Tilt 변경 이벤트
 *
 * @param tiltAngle 변경된 Tilt
 */
- (void) viewTiltChanged:(float)tiltAngle;


/** Address 변경 이벤트
 @param text 변경된 주소
 */
- (void) addressTextChanged:(NSString*)text;

/** Screen Center 변경 이벤트
 @param worldX 변경된 월드 좌표
 @param worldY 변경된 월드 좌표
 */
- (void) screenCenterChanged:(double)worldX worldY:(double)worldY;

/** Api에 의한 카메라 이동 시작 이벤트
 */
- (void) cameraAnimationBegan;

/** Api에 의한 카메라 이동 종료 이벤트
 */
- (void) cameraAnimationEnded;

/** 사용자 터치 시작 이벤트
 */
- (void) userGestureBegan;

/** 사용자 터치 조작 종료 이벤트(추후 deaccelation이 발생할 수 있음)
 @param cameraAnimationEnabled 사용자 입력 이후 카메라 애니메이션이 작동여부
 */
- (void) userGestureEnded:(BOOL)cameraAnimationEnabled;

@end

/**
 * 히트테스트 완료 위임 프로토콜
 */
@protocol HitObjectNativeDelegate <NSObject>

/** Hit Test 결과 이벤트
 * @param objectID 오브젝트ID
 * @param point 오브젝트 위치 (WGS84)
 * @param property 오브젝트 프로퍼티
 * @param hitCallout 콜아웃을 히트했는지 여부
 * @param showCallout 콜아웃 표출 여부
 * @see HitObjectType
 * @see VSMMapPoint
 * @see ObjectProperty
 */
-(void)onHitObject:(HitObjectType)type
          objectID:(int)objectID
             point:(VSMMapPoint*)point
          property:(ObjectProperty*)property
        hitCallout:(bool)hitCallout
       showCallout:(bool*)showCallout;
@end

/**
 * 지도 사이즈 변경 위임 프로토콜
 */
@protocol MapViewResizeDelegate <NSObject>

@optional

/** Map view screen resize 변경 이벤트
 @param x 리사이즈 x
 @param y 리사이즈  y
 @param width  리사이즈 width
 @param height  리사이즈 height
*/
-(void)mapViewResized:(int)x
                    y:(int)y
                width:(int)width
               height:(int)height;

@end

/**
 * POI 스케일 위임 프로토콜
 */
@protocol PoiScaleChangeDelegate <NSObject>

/**
 * POI 스케일 변경
 * @param poiScale POI 스케일
 */
-(void) poiScaleChanged:(float)poiScale;

@end
