<%--
  Created by IntelliJ IDEA.
  User: chnbr
  Date: 2023-08-28
  Time: 오후 3:47
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/ssi/ssi_notice.jsp"%>
<jsp:useBean id="dao" class="com.example.mypage.notice.NoticeDAO"/>
<jsp:useBean id="dto" class="com.example.mypage.notice.NoticeDTO"/>
<%-- 파라미터를 dto에 자동으로 넣어줌--%>
<jsp:setProperty name="dto" property="*" />
<%
    Map map = new HashMap();
    map.put("bbsno", dto.getBbsno());
    map.put("passwd", dto.getPasswd());
    boolean pflag= dao.passCheck(map);
    boolean flag= false;
    if(pflag)
        flag=dao.update(dto);

%>

<html>
<head>
    <title>공지사항 수정 </title>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
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
<div class="container">
    <div class="container p-5 my-5 border">
        <%
            if (!pflag)
                out.print("패스워드 오류 입니다.");
            else if(flag)
                out.print("글 수정 성공 입니다.");
            else out.print("글 수정 실패 입니다.");
        %>
    </div>
    <% if(!pflag) %> <button class="btn btn-light" onclick="history.back()">다시시도</button>
    <button class="btn btn-light" onclick="list()">목록</button>
</div>
</body>
</html>