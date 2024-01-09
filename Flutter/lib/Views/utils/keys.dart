mixin keysforhistory {
  List<List<String>>? Hkeys(
    int m,
    int n,
  ) {
    List<List<String>>? twodkey = [];

    for (int j = 0; j < m; j++) {
      List<String>? onedkey = [];

      for (int i = 0; i < n; i++) {
        onedkey.add('HKEY_${j}_${i}_');
      }

      twodkey.add(onedkey);
    }

    return twodkey;
  }
}
