<%--
  Created by IntelliJ IDEA.
  User: chnbr
  Date: 2023-08-28
  Time: 오후 3:21
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
  <title>게시판 삭제</title>
  <style>
    #red {
      color: red;
    }
  </style>
</head>
<body>
<jsp:include page="/menu/top.jsp" />
<div class="container mt-3">
  <h2>공지사항 삭제</h2>

  <p id='red'>삭제하면 복구할 수 없습니다</p>
  <form action="deleteProc.jsp" method="post">
    <input type="hidden" name="bbsno" value="<%=request.getParameter("bbsno")%>">
    <input type="hidden" name="nowPage" value="<%=request.getParameter("nowPage")%>">
    <input type="hidden" name="col" value="<%=request.getParameter("col")%>">
    <input type="hidden" name="word" value="<%=request.getParameter("word")%>">

    <div class="row">

      <div class="col">
        <input type="password" class="form-control"
               placeholder="Enter password" name="passwd">
      </div>

      <div class="col">
        <button class="btn btn-dark">삭제</button>
      </div>
    </div>
  </form>
</div>
</body>
</html>
