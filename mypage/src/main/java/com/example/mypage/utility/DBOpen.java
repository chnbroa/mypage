package com.example.mypage.utility;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBOpen{
    private static Connection con;

    public static Connection getConnection() {

        try {
            Class.forName(Constant.DRIVER);

            con = DriverManager.getConnection(Constant.URL, Constant.USER, Constant.PASSWORD);

        } catch (ClassNotFoundException | SQLException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }

        return con;
    }
}
