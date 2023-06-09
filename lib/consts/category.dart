/// 카테고리 매핑이고, 리스트의 첫번째는 한글 이름, 두번째는 기본 svg, 세번째는 선택된 svg(흰색)
Map<String, List<String>> storeCategories = {
  'refill': [
    '리필스테이션',
    'assets/icons/category/refill.svg',
    'assets/icons/category/refill.svg',
  ],
  'upcycle': [
    '업사이클',
    'assets/icons/category/upcycle.svg',
    'assets/icons/category/upcycle.svg',
  ],
  'nodisposable': [
    '노일회용품',
    'assets/icons/category/nodisposable.svg',
    'assets/icons/category/nodisposable.svg',
  ],
  'vegan': [
    '비건',
    'assets/icons/category/vegan.svg',
    'assets/icons/category/vegan.svg',
  ],
  'restaurant': [
    '식당',
    'assets/icons/category/restaurant.svg',
    'assets/icons/category/restaurant_selected.svg'
  ],
  'cafe': [
    '카페',
    'assets/icons/category/cafe.svg',
    'assets/icons/category/cafe_selected.svg',
  ],
  'accessory': [
    '소품샵',
    'assets/icons/category/accessory.svg',
    'assets/icons/category/accessory_selected.svg',
  ],
};

/// 가게후기 매핑이고, 리스트의 첫번째는 한글 이름, 두번째는 이미지 uri
Map<String, List<String>> reviewCategories = {
  'clean': ['청결한 매장', 'assets/icons/review/clean.png'],
  'large': ['넓은 매장', 'assets/icons/review/large.png'],
  'parking': ['주차 공간', 'assets/icons/review/parking.png'],
  'mood': ['분위기 좋은', 'assets/icons/review/mood.png'],
  'variant': ['다양한 제품', 'assets/icons/review/variant.png'],
  'valuable': ['가치있는', 'assets/icons/review/valuable.png'],
  'quality': ['품질이 좋은', 'assets/icons/review/quality.png'],
  'effective': ['가성비 좋은', 'assets/icons/review/effective.png'],
  'kind': ['친절한', 'assets/icons/review/kind.png'],
};
