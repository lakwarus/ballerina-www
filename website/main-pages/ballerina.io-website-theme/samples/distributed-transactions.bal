transaction {
    int insertCount; string[] generatedID;
    var out = db1 -> updateWithGeneratedKeys("INSERT INTO
            CUSTOMER(NAME) VALUES ('Anne')", ());
    match out {
        (int, string[]) output =>
            (insertCount, generatedID) = output;
        error err => {
            throw err.cause but {() => err};
        }
    }
    var returnedKey = check <int>generatedID[0];
    sql:Parameter para1 = {sqlType:sql:TYPE_INTEGER, value:returnedKey};
    var ret = db2 -> update("INSERT INTO SALARY (ID, VALUE)
            VALUES (?, 2500)", para1);

    match ret {
        int retInt =>  {
            io:println("Inserted count to SALARY table:" + retInt);
        }
        error err => {
            retry;
        }
    }
    transactionSuccess = true;
} onretry {
    io:println("Transaction failed");
    transactionSuccess = false;
}
