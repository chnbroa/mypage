<%--
  Created by IntelliJ IDEA.
  User: chnbr
  Date: 2023-08-14
  Time: 오후 5:18
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@include file="/ssi/ssi_bbs.jsp"%>
<jsp:useBean id="dao" class="com.example.mypage.bbs.BbsDAO"/>
<%

    int bbsno = Integer.parseInt(request.getParameter("bbsno"));


    String nowPage =request.getParameter("nowPage");
    String col = request.getParameter("col");
    String word = request.getParameter("word");

    dao.upViewcnt(bbsno);
    BbsDTO dto = dao.read(bbsno);

    String content = dto.getContent().replaceAll("\r\n", "<br>");
%>

<html>
<head>
    <title>Insert title gere</title>
    <script>
        function list(){
            let url  ="list.jsp";
            url +="?nowPage=<%=nowPage%>";
            url +="&col=<%=col%>";
            url +="&word=<%=word%>";

            location.href=url;
        }

        function  update(){
            let url  ="updateForm.jsp";
            url +="?nowPage=<%=nowPage%>";
            url +="&col=<%=col%>";
            url +="&word=<%=word%>";
            url +="&bbsno=<%=bbsno%>";
            location.href=url;
        }

        function delete_url(){
            let url  ="deleteForm.jsp";
            url +="?nowPage=<%=nowPage%>";
            url +="&col=<%=col%>";
            url +="&word=<%=word%>";
            url +="&bbsno=<%=bbsno%>";
            location.href=url;
        }

        function reply(){
            let url  ="replyForm.jsp";
            url +="?nowPage=<%=nowPage%>";
            url +="&col=<%=col%>";
            url +="&word=<%=word%>";
            url +="&bbsno=<%=bbsno%>";
            location.href=url;
        }


    </script>
</head>
<body>
<jsp:include page="/menu/top.jsp"/>
<div class="container mt-3">

  <div class="card" style="width: 100%">
    <div class="card-header">
        <%=dto.getTitle()%>
    </div>
    <pre style="height: 500px; overflow-y: scroll"><%=content%></pre>

    <div class="card-footer d-flex justify-content-between">
      <div>
        성 명 : <%=dto.getWname()%> | 등록일 : <%=dto.getWdate()%>  | 조회수 : <%=dto.getViewcnt()%>
      </div>

      <div>
<%--        <a href= "<%=root%>/bbs/noticeList.jsp" class="btn btn-outline-primary  btn-sm " type="submit">목록</a>--%>
      </div>
    </div>
    <div class="card-footer">
<%--        <button class="btn btn-outline-dark" onclick ="location='createForm.jsp'">등록</button>--%>
        <button class="btn btn-outline-dark" onclick="delete_url()">삭제</button>
        <button class="btn btn-outline-dark" onclick="update()">수정</button>
        <button class="btn btn-outline-dark" onclick="reply()">답글</button>
        <button class="btn btn-outline-dark" onclick="list()">목록</button>
    </div>
  </div>
    <jsp:include page="/menu/bottom.jsp"/>
</div>

</body>
</html>
