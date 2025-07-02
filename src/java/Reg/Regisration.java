/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Reg;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import javax.jws.WebService;
import javax.jws.WebMethod;
import javax.jws.WebParam;

/**
 *
 * @author Lenovo
 */
@WebService(serviceName = "Regisration")
public class Regisration {

    /**
     * This is a sample web service operation
     */
   @WebMethod(operationName = "Login")
  public String Login(@WebParam(name = "user_name") String user_name, @WebParam(name = "password") String password) {
    try{
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con=DriverManager.getConnection("jdbc:mysql://localhost:3306/crimenew","root","Vishnu$20");
        Statement st=con.createStatement();
        ResultSet rs=st.executeQuery("Select * from user where username='"+user_name+"' and password='"+password+"' ");
        if(rs.next())
        {
                return "success";
        }
        else
        {
            return "server error";
        }
       }
        catch(Exception e){
        e.printStackTrace();
        }
        return "internal server error";
       
  }
  
   @WebMethod(operationName = "Register")
  public String Register(@WebParam(name = "user_name") String username, @WebParam(name = "password") String password, @WebParam(name = "email") String mail, @WebParam(name = "phone_number") String mobile) {
    try{     
    Class.forName("com.mysql.cj.jdbc.Driver");
    Connection con=DriverManager.getConnection("jdbc:mysql://localhost:3306/crimenew","root","Vishnu$20");
    PreparedStatement ps=con.prepareStatement("Insert into user(username,password,mail,mobile) Values(?,?,?,?)");
    ps.setString(1, username);
    ps.setString(2, password);
    ps.setString(3, mail);
    ps.setString(4, mobile);
    ps.executeUpdate();
        }catch(Exception e){
        e.printStackTrace();
        System.out.println("server busy");
        }
        
        
        
        return "success";
        
    } 
  
 @WebMethod(operationName = "getDeviceList3")
     public String getDeviceList3 (@WebParam(name = "area") String area,String method) {
   
     StringBuilder sb = new StringBuilder();
   try{
           Class.forName("com.mysql.cj.jdbc.Driver");
           Connection conn=DriverManager.getConnection("jdbc:mysql://localhost:3306/crimenew","root","Vishnu$20");
           Statement st=conn.createStatement();
           ResultSet rs=st.executeQuery("select * from crime ");       
           while(rs.next())
           {    
                String name=rs.getString("NAME");
                String place=rs.getString("PLACE");
                String dist=rs.getString("DIST");
                
                sb.append("NAME: ").append(name);
                sb.append("\n"); 
                sb.append("PLACE: ").append(place);
                sb.append("\n");
                sb.append("DISTRICT: ").append(dist);
                sb.append("@");
                
            }
     
               
    }
       catch(ClassNotFoundException | SQLException ex){
         //Logger.getLogger(Registration.class.getName()).log(Level.SEVERE,null,ex);
           System.out.println(ex);
         return "server temporarily not avilable";
       }
        System.out.println(sb.toString());
        return sb.toString();
        
     }

    /**
     *
     * @param username
     * @param landmark
     * @param complaint
     * @param phonenumber
     * @return
     */
    @WebMethod(operationName = "Report")
  public String Report(@WebParam(name = "name") String username, @WebParam(name = "landmark") String landmark, @WebParam(name = "complaint") String complaint, @WebParam(name = "phonenumber") String phonenumber) {
    try{     
    Class.forName("com.mysql.cj.jdbc.Driver");
    Connection con=DriverManager.getConnection("jdbc:mysql://localhost:3306/crimenew","root","Vishnu$20");
    PreparedStatement ps=con.prepareStatement("Insert into report(username,landmark,complaint,phonenumber) Values(?,?,?,?)");
    ps.setString(1, username);
    ps.setString(2, landmark);
    ps.setString(3, complaint);
    ps.setString(4, phonenumber);
    ps.executeUpdate();
        }
    catch(Exception e){
        System.out.println(e);
        e.printStackTrace();
        System.out.println("server busy");
        }
        
        
        
        return "success";
        
    } 
     

}

