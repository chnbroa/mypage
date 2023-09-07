<%--
  Created by IntelliJ IDEA.
  User: chnbr
  Date: 2023-08-28
  Time: 오후 4:32
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/ssi/ssi_poll.jsp"%>
<jsp:useBean id="service" class="com.example.mypage.poll.PollService" />
<%
  String[] itemnum = request.getParameterValues("itemnum");
  for(int i=0; i<itemnum.length ;i++)
    System.out.println(itemnum.length);
  boolean flag = service.updateCount(itemnum);
  String msg = "투표가 등록되지 않습니다.";
  if(flag)
    response.sendRedirect("./list.jsp");
//    msg = "투표가 정상적으로 등록되었습니다.";
%>
<script>
  alert("<%=msg%>");
  location.href = "poll.jsp#section2";
</script>