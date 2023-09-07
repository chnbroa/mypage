<%--
  Created by IntelliJ IDEA.
  User: chnbr
  Date: 2023-08-28
  Time: 오후 3:30
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/ssi/ssi_notice.jsp"%>
<jsp:useBean id="dao" class="com.example.mypage.notice.NoticeDAO"/>
<jsp:useBean id="dto" class="com.example.mypage.notice.NoticeDTO"/>
<%-- 파라미터를 dto에 자동으로 넣어줌--%>
<jsp:setProperty name="dto" property="*" />

<%
  boolean flag = dao.create(dto);
  if(flag)
  {
    response.sendRedirect("./noticeList.jsp");
  }

%>
