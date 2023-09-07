<%--
  Created by IntelliJ IDEA.
  User: chnbr
  Date: 2023-08-14
  Time: 오후 5:16
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/ssi/ssi_bbs.jsp"%>
<jsp:useBean id="dao" class="com.example.mypage.bbs.BbsDAO"/>
<%
    //검색부분
    String col = Utility.checkNull(request.getParameter("col"));
    String word = Utility.checkNull(request.getParameter("word"));
//    System.out.println(col+"|||"+word);

    if(col.equals("total")){
        word = "";
    }

    //페이지 관련
    int nowPage =1; //현재 보고있는 페이지
    if(request.getParameter("nowPage") != null)
        nowPage = Integer.parseInt(request.getParameter("nowPage"));

    int recordPerPage = 10;//한페이지당 보여줄 레코드갯수


    int sno = ((nowPage-1) * recordPerPage); //디비에서 가져올 시작 레코드 순번

    Map map= new HashMap();
    map.put("col", col);
    map.put("word", word);
    map.put("sno", sno);
    map.put("eno", recordPerPage);

    List<BbsDTO> list = dao.list(map);
    NoticeDTO noticeDTO = dao.list();
    int total = dao.total(col, word);


    String url = "list.jsp";

    String paging = Utility.paging(total, nowPage, recordPerPage, col, word, url);
%>

<html>
<head>
    <script>
        function read(bbsno){
            let url = "listForm.jsp";
            url +="?nowPage=<%=nowPage%>";
            url +="&col=<%=col%>";
            url +="&word=<%=word%>";
            url +="&bbsno="+bbsno;
            location.href=url;
        }

        function noticeread(bbsno){
            let url = "../notice/noticeForm.jsp";
            url +="?nowPage=<%=nowPage%>";
            url +="&col=<%=col%>";
            url +="&word=<%=word%>";
            url +="&bbsno="+bbsno;
            location.href=url;
        }


    </script>
</head>
<body>
<jsp:include page="/menu/top.jsp"/>

<div class="container mt-3">
    <div class="d-flex justify-content-between align-items-center">
        <div>
            <h2>게시판</h2>
        </div>
        <form action="list.jsp"  class="d-flex">
            <div class="row">
                <div class='col'>
                    <select class="form-select" name="col">
                        <option value="wname" <%if (col.equals("wname")) out.print("selected");%>>성명</option>
                        <option value="title" <%if (col.equals("title")) out.print("selected");%>>제목</option>
                        <option value="content"<%if (col.equals("content")) out.print("selected");%>>내용</option>
                        <option value="title_content" <%if (col.equals("title_content")) out.print("selected");%>>제목+내용</option>
                        <option value="total" <%if (col.equals("total")) out.print("selected");%>>전체출력</option>
                    </select>
                </div>
                <div class="col">
                    <input type="search" class="form-control" name="word" required="required" value="<%=word%>">  </input>

                </div>
                <div class='col'>
                    <button type="submit" class="btn btn-dark">검색</button>
                    <button type="button" class="btn btn-dark" data-bs-toggle="modal" data-bs-target="#myModal">등록</button>
                </div>
            </div>

        </form>
    </div>

    <div class="container mt-5 ">
        <!-- <h2>게시판</h2> -->

        <table class="table table-hover">
            <!--<table class="table table-striped table-hover">-->

            <thead>
            <tr>
                <th>번호</th>
                <th>제목</th>
                <th>작성자</th>
                <th>날짜</th>
                <th>조회수</th>
            </tr>
            </thead>

            <%--    여기에 최근 공지 사항 가져오기 !!!!!--%>

            <tbody class="table-active notice">
            <%
                if(noticeDTO == null){%>
            <tr> <td colspan="5"> 등록된 공지가 없습니다. </td></tr>
            <% }else {%>
            <tr>
                <td>공지!</td>
            <%--       공지사항 추가하기         --%>
                <td> <a  href="javascript:noticeread('<%=noticeDTO.getBbsno()%>')"> <%=noticeDTO.getTitle() %></a> </td>
                <td><%= noticeDTO.getWname() %></td>
                <td><%= noticeDTO.getWdate() %></td>
                <td><%= noticeDTO.getViewcnt() %></td>
            </tr>
            <% }%>
            </tbody>

            <tbody class="contents">
            <%
                if(list.size() == 0){%>
            <tr> <td colspan="5"> 등록된 글이 없습니다. </td></tr>
            <%
            }else {
                for(int i=0; i<list.size();i++){
                    BbsDTO dto = list.get(i);
            %>
            <tr>
                <td> <%=dto.getBbsno()%></td>
                <%--      <td><a href="javascript:read('<%=dto.getBbsno()%>')"> <%=dto.getTitle()%> </a></td>--%>
                <td>
                    <%
                        for(int r=0; r<dto.getIndent(); r++){
                            out.println("&nbsp;&nbsp;");
                        }
                        if(dto.getIndent()>0)
                            // out.print("[답변]");
                            out.print("<img src='../images/re.jpg' >");
                    %>

                    <a  href="javascript:read('<%=dto.getBbsno()%>')">
                        <%=dto.getTitle() %></a>
                    <%
                        if (Utility.compareDay(dto.getWdate().substring(0, 10))) {
                    %> <img src="../images/new.gif">
                    <% } %>

                </td>
                <td> <%=dto.getWname()%></td>
                <td> <%=dto.getWdate()%></td>
                <td> <%=dto.getViewcnt()%></td>
            </tr>
            <%
                    } //for_end

                } //if_end
            %>
            </tbody>
        </table>
        <%=paging%>
        <jsp:include page="/menu/bottom.jsp"/>
    </div>




</div>



<!-- 개시판 생성 부분  -->
<div class="modal" id="myModal">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <!-- Modal Header -->
            <div class="modal-header">
                <h4 class="modal-title">게시판 생성</h4>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>

            <!-- Modal body -->
            <div class="modal-body">
                <form action="createProc.jsp" method="post" id="create">
                    <div class="modal-body-fir mb-3 d-flex justify-content-between">
                        <div class="input-group me-5">
                            <span class="input-group-text">제목</span>
                            <input type="text" class="form-control " placeholder="title" name="title">
                        </div>
                        <div class="input-group">
                            <span class="input-group-text">이름</span>
                            <input type="text" class="form-control" placeholder="name" name="wname">
                        </div>
                    </div>

                    <div class="mb-3 mt-3 ">
                        <label for="content">내용</label>
                        <div class="" style="height: 650px">
                            <textarea class="form-control h-100" rows="15" id="content" name="content"></textarea>
                        </div>
                    </div>
                </form>
            </div>
            <!-- Modal footer -->
            <div class="modal-footer">

                <div class="input-group mb-3 d-flex justify-content-between">
                    <div class="input-group w-25">
                        <span class="input-group-text w-50">비밀번호</span>
                        <input form="create" type="password" class="form-control" id="passwd" placeholder="passwd" name="passwd">
                    </div>

                    <div>
                        <button type="submit" form="create" class="btn text-primary"><svg xmlns="http://www.w3.org/2000/svg"
                                                                                          width="35" height="35" fill="currentColor" class="bi bi-plus-circle" viewBox="0 0 16 16">
                            <path d="M8 15A7 7 0 1 1 8 1a7 7 0 0 1 0 14zm0 1A8 8 0 1 0 8 0a8 8 0 0 0 0 16z" />
                            <path
                                    d="M8 4a.5.5 0 0 1 .5.5v3h3a.5.5 0 0 1 0 1h-3v3a.5.5 0 0 1-1 0v-3h-3a.5.5 0 0 1 0-1h3v-3A.5.5 0 0 1 8 4z" />
                        </svg>
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

</body>
</html>
