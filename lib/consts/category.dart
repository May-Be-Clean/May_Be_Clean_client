/// 카테고리 매핑이고, 리스트의 첫번째는 한글 이름, 두번째는 기본 svg, 세번째는 선택된 svg(흰색)
Map<String, List<String>> storeCategoryMapping = {
  'REFILL': [
    '리필스테이션',
    'assets/icons/category/refill.svg',
    'assets/icons/category/refill.svg',
  ],
  'UPCYCLE': [
    '업사이클링',
    'assets/icons/category/upcycle.svg',
    'assets/icons/category/upcycle.svg',
  ],
  'ECO': [
    '노일회용품',
    'assets/icons/category/nodisposable.svg',
    'assets/icons/category/nodisposable.svg',
  ],
  'RESTAURANT': [
    '식당',
    'assets/icons/category/restaurant.svg',
    'assets/icons/category/restaurant_selected.svg'
  ],
  'CAFE': [
    '카페',
    'assets/icons/category/cafe.svg',
    'assets/icons/category/cafe_selected.svg',
  ],
  'ACCESSORY': [
    '소품샵',
    'assets/icons/category/accessory.svg',
    'assets/icons/category/accessory_selected.svg',
  ],
};

/// 가게후기 매핑이고, 리스트의 첫번째는 한글 이름, 두번째는 이미지 uri
Map<String, List<String>> reviewCategoryMapping = {
  'CLEAN': ['청결한 매장', 'assets/icons/review/clean.png'],
  'LARGE': ['넓은 매장', 'assets/icons/review/large.png'],
  'PARKING': ['주차 공간', 'assets/icons/review/parking.png'],
  'MOOD': ['분위기 좋은', 'assets/icons/review/mood.png'],
  'VARIANT': ['다양한 제품', 'assets/icons/review/variant.png'],
  'VALUABLE': ['가치있는', 'assets/icons/review/valuable.png'],
  'QUALITY': ['품질이 좋은', 'assets/icons/review/quality.png'],
  'EFFECTIVE': ['가성비 좋은', 'assets/icons/review/effective.png'],
  'KIND': ['친절한', 'assets/icons/review/kind.png'],
};
