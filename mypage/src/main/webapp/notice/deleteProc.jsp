<%--
  Created by IntelliJ IDEA.
  User: chnbr
  Date: 2023-08-28
  Time: 오후 3:21
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/ssi/ssi_notice.jsp"%>
<jsp:useBean id="dao" class="com.example.mypage.notice.NoticeDAO" />


<%
  int bbsno = Integer.parseInt(request.getParameter("bbsno"));
  String passwd = request.getParameter("passwd");
  Map map = new HashMap();
  map.put("bbsno", bbsno);
  map.put("passwd", passwd);

  boolean flag = false;
  boolean pflag = dao.passCheck(map);
  if(pflag){
    flag = dao.delete(bbsno);
  }
%>

<html>
<head>
  <title>게시판 삭제</title>
  <meta charset="utf-8">
  <script>
    function list(){
      let url  ="noticeList.jsp";
      url +="?nowPage=<%=request.getParameter("nowPage")%>";
      url +="&col=<%=request.getParameter("col")%>";
      url +="&word=<%=request.getParameter("word")%>";
      location.href=url;
    }
  </script>

</head>
<body>
<jsp:include page="/menu/top.jsp" />
<div class="container mt-3">
  <div class="container p-5 my-5 border">
    <%
      if(!pflag){
        out.print("잘못된 비밀번호 입니다.");
      }else if(flag){
        out.print("글 삭제를 성공했습니다.");
      }else{
        out.print("글 삭제를 실패했습니다.");
      }

    %>
  </div>
  <%if (!pflag) {%><button class="btn btn-dark" onclick="history.back()">다시시도</button>
  <%
    }
  %>
  <button type="button" class="btn btn-light" onclick="list()">목록</button>
</div>

</body>
</html>
