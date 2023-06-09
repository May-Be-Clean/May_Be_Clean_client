String expToBadge(int exp) {
  if (exp < 8) {
    return "assets/icons/badge/level1.svg";
  }
  if (exp < 16) {
    return "assets/icons/badge/level2.svg";
  }
  if (exp < 24) {
    return "assets/icons/badge/level3.svg";
  }
  if (exp < 32) {
    return "assets/icons/badge/level4.svg";
  }
  return "assets/icons/badge/level5.svg";
}

String expToBadgeTitle(int exp) {
  if (exp < 8) {
    return "씨앗";
  }
  if (exp < 16) {
    return "새싹";
  }
  if (exp < 24) {
    return "숲";
  }
  if (exp < 32) {
    return "꽃";
  }
  return "열매";
}

String expNextTitle(int exp) {
  if (exp < 8) {
    return "새싹";
  }
  if (exp < 16) {
    return "숲";
  }
  if (exp < 24) {
    return "꽃";
  }
  if (exp < 32) {
    return "열매";
  }
  return "열매";
}

String expPrevious(int exp) {
  if (exp < 8) {
    return '0';
  }
  if (exp < 16) {
    return '8';
  }
  if (exp < 24) {
    return '16';
  }
  if (exp < 32) {
    return '24';
  }
  return '32';
}

String expNext(int exp) {
  if (exp < 8) {
    return '8';
  }
  if (exp < 16) {
    return '16';
  }
  if (exp < 24) {
    return '24';
  }
  if (exp < 32) {
    return '32';
  }
  return 'INF';
}

double expPercent(int exp) {
  if (exp < 8) {
    return exp / 8;
  }
  if (exp < 16) {
    return (exp - 8) / 8;
  }
  if (exp < 24) {
    return (exp - 16) / 8;
  }
  if (exp < 32) {
    return (exp - 24) / 8;
  }
  return 1;
}

String countToClover(int count) {
  if (count <= 0) {
    return "assets/icons/clover/clover_0.svg";
  }
  if (count == 1) {
    return "assets/icons/clover/clover_1.svg";
  }
  if (count == 2) {
    return "assets/icons/clover/clover_2.svg";
  }
  if (count == 3) {
    return "assets/icons/clover/clover_3.svg";
  }
  return "assets/icons/clover/clover_4.svg";
}
