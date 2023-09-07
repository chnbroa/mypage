package com.example.mypage.bbs;

import com.example.mypage.utility.DBClose;
import com.example.mypage.utility.DBOpen;

import com.example.mypage.notice.NoticeDTO;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

public class BbsDAO {

    public void upAnsnum(Map map) {
        Connection con = DBOpen.getConnection();
        PreparedStatement pstmt = null;
        StringBuffer sql = new StringBuffer();
        int grpno = (Integer) map.get("grpno");
        int ansnum = (Integer) map.get("ansnum");
        sql.append(" update bbs ");
        sql.append(" set ansnum = ansnum + 1 ");
        sql.append(" where grpno = ?  ");
        sql.append(" and ansnum > ?  ");

        try {
            pstmt = con.prepareStatement(sql.toString());
            pstmt.setInt(1, grpno);
            pstmt.setInt(2, ansnum);

            pstmt.executeUpdate();

        } catch (SQLException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        } finally {
            DBClose.close(pstmt,con);
        }

    }

    public boolean createReply(BbsDTO dto) {
        boolean flag = false;
        Connection con = DBOpen.getConnection();
        PreparedStatement pstmt = null;
        StringBuffer sql = new StringBuffer();
        sql.append(" INSERT INTO bbs(wname, title, ");
        sql.append(" content, passwd, wdate, grpno, indent, ansnum) ");
        sql.append(" VALUES(  ?, ?, ?, ?, sysdate(), ?, ?, ? ) ");

        try {
            pstmt = con.prepareStatement(sql.toString());
            pstmt.setString(1, dto.getWname());
            pstmt.setString(2, dto.getTitle());
            pstmt.setString(3, dto.getContent());
            pstmt.setString(4, dto.getPasswd());
            pstmt.setInt(5, dto.getGrpno());// ★부모의grpno
            pstmt.setInt(6, dto.getIndent() + 1);// ★부모의indent+1
            pstmt.setInt(7, dto.getAnsnum() + 1);// ★부모의ansnum+1

            int cnt = pstmt.executeUpdate();

            if (cnt > 0)
                flag = true;

        } catch (SQLException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        } finally {
            DBClose.close(pstmt,con);
        }

        return flag;
    }


    public BbsDTO readReply(int bbsno) {
        BbsDTO dto = null;
        Connection con = DBOpen.getConnection();
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        StringBuffer sql = new StringBuffer();
        sql.append(" select bbsno, grpno, indent, ansnum, title ");
        sql.append(" from bbs ");
        sql.append(" where bbsno = ? ");

        try {
            pstmt = con.prepareStatement(sql.toString());
            pstmt.setInt(1, bbsno);

            rs = pstmt.executeQuery();

            if(rs.next()) {
                dto = new BbsDTO();
                dto.setBbsno(rs.getInt("bbsno"));
                dto.setGrpno(rs.getInt("grpno"));
                dto.setIndent(rs.getInt("indent"));
                dto.setAnsnum(rs.getInt("ansnum"));
                dto.setTitle(rs.getString("title"));
            }

        } catch (SQLException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        } finally {
            DBClose.close(rs, pstmt, con);
        }

        return dto;
    }


    public boolean delete(int bbsno) {
        boolean flag = false;
        Connection con = DBOpen.getConnection();
        PreparedStatement pstmt = null;
        StringBuffer sql = new StringBuffer();
        sql.append(" delete from bbs ");
        sql.append(" where bbsno = ? ");

        try {
            pstmt = con.prepareStatement(sql.toString());
            pstmt.setInt(1, bbsno);

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


    public boolean passCheck(Map map){
        boolean flag = false;
        Connection con = DBOpen.getConnection();
        PreparedStatement pstmt =null;
        ResultSet rs= null;
        int bbsno = (Integer) map.get("bbsno");
        String passwd = (String) map.get("passwd");

        StringBuffer sql = new StringBuffer();
        sql.append(" SELECT COUNT(bbsno) as cnt  ");
        sql.append(" FROM bbs  ");
        sql.append(" WHERE bbsno=? AND passwd=? ");

        try {
            pstmt = con.prepareStatement(sql.toString());
            pstmt.setInt(1, bbsno);
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
    public boolean update(BbsDTO dto){
        boolean flag = false;
        Connection con = DBOpen.getConnection();
        PreparedStatement pstmt = null;
        StringBuffer sql = new StringBuffer();
        sql.append(" UPDATE bbs  ");
        sql.append(" SET ");
        sql.append("    wname   = ?,  ");
        sql.append("    title   = ?,  ");
        sql.append("    content = ?  ");
        sql.append(" WHERE bbsno  = ?  ");

        try {
            pstmt = con.prepareStatement(sql.toString());
            pstmt.setString(1, dto.getWname());
            pstmt.setString(2, dto.getTitle());
            pstmt.setString(3, dto.getContent());
            pstmt.setInt(4, dto.getBbsno());

            int cnt = pstmt.executeUpdate();
            if (cnt > 0)
                flag = true;
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBClose.close(pstmt,con);
        }

        return flag;
    }
    public BbsDTO read(int bbsno){
        BbsDTO dto  =null;
        Connection con = DBOpen.getConnection();
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        StringBuffer sql = new StringBuffer();
        sql.append(" SELECT bbsno, wname, title, content,  viewcnt, wdate ");
        sql.append(" FROM bbs   ");
        sql.append(" WHERE bbsno = ?  ");

        try {
            pstmt = con.prepareStatement(sql.toString());
            pstmt.setInt(1, bbsno);

            rs = pstmt.executeQuery();

            if (rs.next()) {
                dto = new BbsDTO();
                dto.setBbsno(rs.getInt("bbsno"));
                dto.setWname(rs.getString("wname"));
                dto.setTitle(rs.getString("title"));
                dto.setContent(rs.getString("content"));
                dto.setViewcnt(rs.getInt("viewcnt"));
                dto.setWdate(rs.getString("wdate"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        finally {
            DBClose.close(rs,pstmt,con);
        }
        return dto;
    }
    public void upViewcnt(int bbsno) {
        Connection con = DBOpen.getConnection();
        PreparedStatement pstmt = null;
        StringBuffer sql = new StringBuffer();
        sql.append(" update bbs ");
        sql.append(" set viewcnt = viewcnt + 1 ");
        sql.append(" where bbsno = ? ");
        try {
            pstmt = con.prepareStatement(sql.toString());
            pstmt.setInt(1,bbsno);
            pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }finally {
            DBClose.close(pstmt, con);
        }

    }
    public int total(String col, String word){
        int total =0;
        Connection con = DBOpen.getConnection();
        PreparedStatement pstmt =null;
        ResultSet rs= null;
        StringBuffer sql = new StringBuffer();
        sql.append(" select count(*) as cnt from bbs ");
        if (word.trim().length() > 0 && col.equals("title_content")) {
            sql.append(" where title concat('%',?,'%') ");
            sql.append(" or content like concat('%',?,'%') ");
        } else if (word.trim().length() > 0) {
            sql.append(" where " + col + " like concat('%',?,'%') ");
        }

        try {
            pstmt = con.prepareStatement(sql.toString());
            if (word.trim().length() > 0 && col.equals("title_content")) {
                pstmt.setString(1, word);
                pstmt.setString(2, word);
            } else if (word.trim().length() > 0) {
                pstmt.setString(1, word);
            }

            rs= pstmt.executeQuery();

            //이게 뭐누?
            rs.next();
            total = rs.getInt("cnt");

        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBClose.close(rs,pstmt,con);
        }

        return total;
    }

    public List<BbsDTO> list(Map map) {
        List<BbsDTO> list = new ArrayList<BbsDTO>();
        Connection con = DBOpen.getConnection();
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        String col = (String) map.get("col");
        String word = (String) map.get("word");
        int sno = (Integer) map.get("sno");
        int eno = (Integer) map.get("eno");
        StringBuffer sql = new StringBuffer();
        sql.append(" SELECT bbsno, wname, title, viewcnt, wdate ");
        sql.append(" ,grpno,indent,ansnum ");
        sql.append("  FROM bbs   ");
        if (word.trim().length() > 0 && col.equals("title_content")) {
            sql.append(" where title like concat('%',?,'%') ");
            sql.append(" or content like concat('%',?,'%')");
        } else if (word.trim().length() > 0) {
            sql.append(" where " + col + " like concat('%',?,'%') ");
        }
        sql.append(" order by grpno desc, ansnum ");
        sql.append(" limit ?, ?  ");

        try {
            pstmt = con.prepareStatement(sql.toString());
            int i = 0;
            if (word.trim().length() > 0 && col.equals("title_content")) {
                pstmt.setString(++i, word);
                pstmt.setString(++i, word);
            } else if (word.trim().length() > 0) {
                pstmt.setString(++i, word);
            }
            pstmt.setInt(++i, sno);
            pstmt.setInt(++i, eno);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                BbsDTO dto = new BbsDTO();
                dto.setBbsno(rs.getInt("bbsno"));
                dto.setWname(rs.getString("wname"));
                dto.setTitle(rs.getString("title"));
                dto.setViewcnt(rs.getInt("viewcnt"));
                dto.setWdate(rs.getString("wdate"));
                dto.setGrpno(rs.getInt("grpno"));
                dto.setIndent(rs.getInt("indent"));
                dto.setAnsnum(rs.getInt("ansnum"));


                list.add(dto);
            }

        } catch (SQLException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        } finally {
            DBClose.close(rs, pstmt, con);
        }

        return list;
    }


//    상단 공지사항을 불러내기 위해 추가

    public NoticeDTO list() {
        NoticeDTO dto = null;
        Connection con = DBOpen.getConnection();
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        StringBuffer sql = new StringBuffer();
        sql.append(" SELECT bbsno, wname, title, viewcnt, wdate ");
        sql.append(" , grpno, indent, ansnum ");
        sql.append("  FROM notice   ");
        sql.append(" order by bbsno desc ");
        sql.append(" limit 1  ");

        try {
            pstmt = con.prepareStatement(sql.toString());
            rs = pstmt.executeQuery();

            if (rs.next()) {
                dto = new NoticeDTO();
                dto.setBbsno(rs.getInt("bbsno"));
                dto.setWname(rs.getString("wname"));
                dto.setTitle(rs.getString("title"));
                dto.setViewcnt(rs.getInt("viewcnt"));
                dto.setWdate(rs.getString("wdate"));
                dto.setGrpno(rs.getInt("grpno"));
                dto.setIndent(rs.getInt("indent"));
                dto.setAnsnum(rs.getInt("ansnum"));

            }

        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBClose.close(rs, pstmt, con);
        }

        return dto;
    }
    public boolean create(BbsDTO dto){
        boolean flag = false;
        Connection con = DBOpen.getConnection();
        PreparedStatement pstmt = null;
        StringBuffer sql = new StringBuffer();
        sql.append(" insert into bbs(wname, title, content, passwd, wdate, grpno) ");
        sql.append(" values(?,?,?,?,sysdate(), ");
        sql.append(" (SELECT ifnull(MAX(grpno),0) + 1 FROM bbs b)) ");

        try {
            pstmt = con.prepareStatement(sql.toString());
            pstmt.setString(1, dto.getWname());
            pstmt.setString(2, dto.getTitle());
            pstmt.setString(3, dto.getContent());
            pstmt.setString(4, dto.getPasswd());

            int cnt = pstmt.executeUpdate();

            if (cnt > 0)
                flag = true;

        } catch (SQLException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        } finally {
            DBClose.close(pstmt,con);
        }

        return flag;
    }
}
