<%--
  Created by IntelliJ IDEA.
  User: chnbr
  Date: 2023-08-28
  Time: 오후 2:36
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/ssi/ssi_bbs.jsp"%>
<jsp:useBean id="dao" class="com.example.mypage.bbs.BbsDAO" />
<jsp:useBean id="dto" class="com.example.mypage.bbs.BbsDTO" />
<jsp:setProperty name="dto" property="*" />
<%
    Map map = new HashMap();
    map.put("grpno", dto.getGrpno());
    map.put("ansnum", dto.getAnsnum());

    dao.upAnsnum(map);
    boolean flag = dao.createReply(dto);
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>게시판 답변처리</title>
    <meta charset="utf-8">
    <script>
        function list(){
            let url  ="list.jsp";
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
            if (flag) {
                out.print("글 답변 성공입니다.");
            } else {
                out.print("글 답변 실패입니다.");
            }
        %>
    </div>
    <button class="btn btn-light" onclick="location.href='createForm.jsp'">다시
        등록</button>

    <button class="btn btn-light" onclick="list()">목록</button>

</div>
</body>
</html>