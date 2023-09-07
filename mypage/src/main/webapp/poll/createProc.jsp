<%--
  Created by IntelliJ IDEA.
  User: chnbr
  Date: 2023-08-28
  Time: 오후 4:28
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/ssi/ssi_poll.jsp"%>
<jsp:useBean id="service" class="com.example.mypage.poll.PollService" />
<jsp:useBean id="dto" class="com.example.mypage.poll.PollDTO" />
<jsp:setProperty name="dto" property="*" />
<jsp:useBean id="idto" class="com.example.mypage.poll.PollItemDTO" />
<jsp:setProperty name="idto" property="*" />

<%
  System.out.println(idto.getItems().length);
  boolean flag = service.create(dto, idto);

  String msg = "설문 등록 실패";
  if (flag) {

    msg = "설문 등록 성공";
    response.sendRedirect("./list.jsp");
  }
%>
<script>
  <%--alert('<%=msg%>');--%>

</script>