package com.example.mypage.poll;


import com.example.mypage.utility.DBClose;
import com.example.mypage.utility.DBOpen;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Map;
import java.util.Vector;


public class PollDAO {

    public boolean passCheck(Map map){
        boolean flag = false;
        Connection con = DBOpen.getConnection();
        PreparedStatement pstmt =null;
        ResultSet rs= null;
        int num = (Integer) map.get("num");
        String passwd = (String) map.get("passwd");

        StringBuffer sql = new StringBuffer();
        sql.append(" SELECT COUNT(num) as cnt  ");
        sql.append(" FROM poll  ");
        sql.append(" WHERE num=? AND passwd=? ");

        try {
            pstmt = con.prepareStatement(sql.toString());
            pstmt.setInt(1, num);
            pstmt.setString(2, passwd);

            rs = pstmt.executeQuery();
            rs.next();
            int cnt = rs.getInt("cnt");

            if (cnt > 0)
                flag = true; // 올바른 패스워드
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBClose.close(rs,pstmt,con);
        }
        return flag;
    }


    public boolean delete(int num) {
        boolean flag = false;
        Connection con = DBOpen.getConnection();
        PreparedStatement pstmt = null;
        StringBuffer sql = new StringBuffer();
        sql.append(" delete from poll ");
        sql.append(" where num = ? ");

        try {
            pstmt = con.prepareStatement(sql.toString());
            pstmt.setInt(1, num);

            int cnt = pstmt.executeUpdate();
            if (cnt > 0)
                flag = true;

        } catch (SQLException e) {
            e.printStackTrace();
        }finally {
            DBClose.close(pstmt,con);
        }
        return flag;
    }





    public PollDTO read(int num) {
        PollDTO dto = null;
        Connection con =DBOpen.getConnection();
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        StringBuffer sql = new StringBuffer();
        sql.append(" select * from poll where num = ? ");
        try {
            pstmt = con.prepareStatement(sql.toString());
            pstmt.setInt(1,num);
            rs=pstmt.executeQuery();
            if(rs.next()){
                dto = new PollDTO();
                dto.setQuestion(rs.getString("question"));
                dto.setType(rs.getInt("type"));
                dto.setActive(rs.getInt("active"));
                dto.setEdate(rs.getString("edate"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBClose.close(rs,pstmt, con);
        }
        return dto;
    }


    public boolean create(PollDTO dto)
    {
        boolean flag = false;
        Connection con = DBOpen.getConnection();
        PreparedStatement pstmt = null;

        StringBuffer sql = new StringBuffer();
        sql.append(" insert poll(question,sdate,edate,wdate,type, wname , passwd) ");
        sql.append(" values(?,?,?,now(),? ,? ,? ) ");
        try {
            pstmt = con.prepareStatement(sql.toString());
            pstmt.setString(1, dto.getQuestion());
            pstmt.setString(2, dto.getSdate());
            pstmt.setString(3, dto.getEdate());
            pstmt.setInt(4, dto.getType());
            pstmt.setString(5, dto.getWname());
            pstmt.setString(6, dto.getPasswd());


            int result = pstmt.executeUpdate();
            if(result > 0) flag = true;
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBClose.close(pstmt,con);
        }
        return flag;
    }

    public int getMaxNum(){
        int maxNum = 0;
        Connection con = DBOpen.getConnection();
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        StringBuffer sql = new StringBuffer();
        sql.append(" select max(num) from poll ");

        try {
            pstmt = con.prepareStatement(sql.toString());
            rs = pstmt.executeQuery();
            if (rs.next())
                maxNum = rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBClose.close(rs,pstmt,con);
        }


        return maxNum;
    }
    public int total(Map map){
        int total =0;
        Connection con = DBOpen.getConnection();
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        String col = (String)map.get("col");
        String word = (String)map.get("word");

        StringBuffer sql = new StringBuffer();
        sql.append(" select count(*) ");
        sql.append(" from poll ");
        if (word.trim().length() > 0)
            sql.append(" where " + col + " like concat('%',?,'%') ");

        try {
            pstmt= con.prepareStatement(sql.toString());
            if (word.trim().length() > 0)
                pstmt.setString(1, word);

            rs = pstmt.executeQuery();
            if (rs.next()) {
                total = rs.getInt(1);
            }

        }catch (SQLException e) {
            e.printStackTrace();
        }finally {
            DBClose.close(rs, pstmt, con);
        }

        return total;
    }

    public Vector<PollDTO> getList(Map map){
        Vector<PollDTO> list = new Vector<PollDTO>();
        Connection con = DBOpen.getConnection();
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        String col = (String)map.get("col");
        String word = (String)map.get("word");
        int sno = (int)map.get("sno");
        int eno = (int)map.get("eno");

        StringBuffer sql = new StringBuffer();
        sql.append(" select * from poll  ");
        if (word.trim().length() > 0) {
            sql.append(" where " + col + " like concat('%',?,'%') ");
        }
        sql.append(" order by num desc  ");
        sql.append(" limit ?, ?  ");
        int i = 1;

        try {
            pstmt = con.prepareStatement(sql.toString());
            if(word.trim().length() > 0)
                pstmt.setString(i++, word);

            pstmt.setInt(i++, sno);
            pstmt.setInt(i, eno);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                PollDTO dto = new PollDTO();
                dto.setNum(rs.getInt("num"));
                dto.setQuestion(rs.getString("question"));
                dto.setSdate(rs.getString("sdate"));
                dto.setEdate(rs.getString("edate"));
                dto.setWname(rs.getString("wname"));
                list.add(dto);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }finally {
            DBClose.close(rs,pstmt,con);
        }

        return list;

    }

}
