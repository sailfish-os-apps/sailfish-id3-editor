function open() {
    var db = LocalStorage.openDatabaseSync("ID3edit","1.0","Database", 1000000);
    return db;
}
