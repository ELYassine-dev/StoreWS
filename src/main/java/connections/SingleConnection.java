package connections;

import java.sql.*;



import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class SingleConnection {
    private static final String URL = "jdbc:mysql://localhost:3306/store";
    private static final String USER = "root";
    private static final String PASSWORD = "";

    public static Connection getConnection() {
        try {
            return DriverManager.getConnection(URL, USER, PASSWORD);
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }
    }
}


















//package connections;
//
//import java.sql.*;
//
//import org.apache.tomcat.dbcp.dbcp2.SQLExceptionList;
//
//import java.DriverManager;
//
//
//
//public class SingleConnection {
//
//	private static final String url="jdbc:mysql://localhost:3303/Store";
//	private static final String user="root";
//	private static final String passe="";	
//
//public static Connection getConnection()throws SQLExceptionList {
//
//		return DriverManager.getConnection(url,user,passe);
//}
//
//
//}



