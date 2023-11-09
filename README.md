# 쇼핑 앱

## 미리보기
![Simulator Screen Recording - iPhone 14 Pro - 2023-11-09 at 17 21 15](https://github.com/imashrimp/NaverShoppingProject/assets/114081840/2e93c70b-c7f1-4dd7-ac32-acc45c2bde9d)

## 목차

## 🛠️사용 기술 및 라이브러리
- UIKit / SnapKit / MVC
- Alamofire
- Realm
- Kingfisher

## 트러블 슈팅
### 1. html tag

네이버 쇼핑 API에서 얻은 상품 정보의 title 값에 포함된 HTML 태그를 

components(separatedBy:) 메서드를 활용하여 제거하고, 상품명을 셀에 표시함으로써 사용자에게 

더 깔끔하고 가독성 있는 정보를 제공

### 2. 페이지 네이션

네트워크 통신을 통해 가져온 아이템의 Count 계산을 통해 오프셋 기반 Pagination구현

### 3. 찜하기 동기화

네이버 쇼핑 OPEN API의 productId를 Realm DB의 PK로 활용한 동기화
