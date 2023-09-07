<%@ page import="com.example.mypage.bbs.BbsDAO" %><%--
  Created by IntelliJ IDEA.
  User: chnbr
  Date: 2023-08-28
  Time: 오후 3:47
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/ssi/ssi_notice.jsp" %>
<jsp:useBean id="dao" class="com.example.mypage.notice.NoticeDAO" />

<%
  int bbsno = Integer.parseInt(request.getParameter("bbsno"));
  NoticeDTO dto = dao.read(bbsno);

%>


<html>
<head>
  <title>공지사항 수정</title>
</head>
<body>
<jsp:include page="/menu/top.jsp" />


<div class="container mt-3">
  <h3>공지사항 수정</h3>
  <form action="updateProc.jsp" method="post">
    <input type="hidden" name="bbsno" value="<%=dto.getBbsno() %>">
    <input type="hidden" name="nowPage" value="<%=request.getParameter("nowPage")%>">
    <input type="hidden" name="col" value="<%=request.getParameter("col")%>">
    <input type="hidden" name="word" value="<%=request.getParameter("word")%>">
    <div class="mb-3 mt-3">
      <label for="wname">이름:</label> <input type="text"
                                            class="form-control" id="wname" value="<%=dto.getWname()%>"
                                            name="wname">
    </div>
    <div class="mb-3 mt-3">
      <label for="title">제목:</label> <input type="text"
                                            class="form-control" id="title" value="<%=dto.getTitle()%>"
                                            name="title">
    </div>
    <div class="mb-3 mt-3">
      <label for="content">내용:</label>
      <textarea class="form-control" rows="5" id="content" name="content"> <%=dto.getContent()%> </textarea>
    </div>
    <div class="mb-3 mt-3">
      <label for="passwd">비밀번호:</label> <input type="password"
                                               class="form-control" id="passwd" placeholder="Enter passwd"
                                               name="passwd">
    </div>

    <button type="submit" class="btn btn-outline-dark">수정</button>

  </form>
</div>
</html>
