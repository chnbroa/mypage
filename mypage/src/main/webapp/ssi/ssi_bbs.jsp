<%--
  Created by IntelliJ IDEA.
  User: chnbr
  Date: 2023-08-24
  Time: 오후 4:31
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="com.example.mypage.utility.*" %>
<%@ page import="com.example.mypage.bbs.BbsDAO" %>
<%@ page import="com.example.mypage.bbs.BbsDTO" %>
<%@ page import="com.example.mypage.notice.NoticeDTO" %>
<%
    request.setCharacterEncoding("utf-8");
    String root = request.getContextPath();
%>