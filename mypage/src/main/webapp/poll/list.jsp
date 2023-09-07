<%--
  Created by IntelliJ IDEA.
  User: chnbr
  Date: 2023-08-14
  Time: 오후 5:16
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/ssi/ssi_poll.jsp"%>
<jsp:useBean id="service" class="com.example.mypage.poll.PollService" />
<%
    //검색관련------------------------
    String col = Utility.checkNull(request.getParameter("col"));
    String word = Utility.checkNull(request.getParameter("word"));

    if (col.equals("total")) {
        word = "";
    }

    //투표 관련

    int num =0;

    if(!(request.getParameter("num") == null || request.getParameter("num").equals(""))) {
        num = Integer.parseInt(request.getParameter("num"));
    }
    else {
        num = service.getMaxNum();
    }
    PollDTO numdto = service.read(num);
    Vector<PollItemDTO> vlist = service.itemList(num);

    int sum = service.sumCount(num);

    Vector<PollItemDTO> result = service.getView(num);
    String color[] = {"bg-success","bg-info","bg-warning","bg-danger","bg-dark","bg-secondary"};



//페이지관련-----------------------
    int nowPage = 1;//현재 보고있는 페이지
    if (request.getParameter("nowPage") != null) {
        nowPage = Integer.parseInt(request.getParameter("nowPage"));
    }
    int recordPerPage = 5;//한페이지당 보여줄 레코드갯수

    int sno = ((nowPage - 1) * recordPerPage); //디비에서 가져올 시작위치


    Map map = new HashMap();
    map.put("col", col);
    map.put("word", word);
    map.put("sno", sno);
    map.put("eno", recordPerPage);

//설문 목록
    Vector<PollDTO> list = service.getList(map);
    Iterator<PollDTO> iter = list.iterator();

    int total = service.total(col, word);

    String url = "poll.jsp";

    String paging = Utility.paging(total, nowPage, recordPerPage, col, word, url);
%>
<html>
<head>
    <title>설문 목록</title>
    <script>
        let i = 1;
        let num = 0;
        function addItem() {

            if (i > 9)
                return;
            i++;
            let sp = document.createElement('span')
            sp.className = "input-group-text";
            sp.innerText = i;
            let ele = document.createElement('input');
            ele.type = 'text';
            ele.className = "form-control";
            ele.name = "items";
            ele.id = `item${i}`;
            let items = document.getElementById('items-div');
            let dive = document.createElement('div');
            dive.className = "input-group";
            dive.appendChild(sp);
            dive.appendChild(ele);
            items.appendChild(dive);

        }

        function checknum(f) {
            let items = f.itemnum;
            let cnt = 0;
            for(let i=0;i<items.length;i++)
                if(items[i].checked)
                    cnt++;
            if(cnt ==0) {
                alert('항목을 체크해주세요');
                return false;
            }
        }

        function checkp(f) {
            if (f.question.value.length == 0) {
                alert('설문을 입력하세요');
                f.question.focus();
                return false;
            }
            if (f.sdate.value.length == 0) {
                alert('시작날짜를 선택하세요');
                f.sdate.focus();
                return false;
            }
            if (f.edate.value.length == 0) {
                alert('종료날짜를 선택하세요');
                f.edate.focus();
                return false;
            }

            if (document.querySelector('#item1').value.length == 0) {
                alert('첫번째 항목을 입력하세요');
                document.querySelector('#item1').focus();
                return false;
            }

            if (document.querySelector('#items-div').childElementCount < 1) {
                alert('항목을 1개이상 입력하세요');
                return false;
            }

        }

        function  section( n) {
                num = n;
                console.log(n);


                let url = 'list.jsp?num=' + num;
                console.log(url);

                location.href = url;

            }

        function delete_url(){
            let url  ="deleteForm.jsp";
            <%--url +="?nowPage=<%=nowPage%>";--%>
            <%--url +="&col=<%=col%>";--%>
            <%--url +="&word=<%=word%>";--%>
            url +="?num=<%=num%>";
            location.href=url;
        }
        window.addEventListener('DOMContentLoaded', function()
        {
            const urlParams = new URLSearchParams(window.location.search);
            if (urlParams.get("num") !== null) {
                var voteModal = new bootstrap.Modal(document.getElementById('voteModal'));
                voteModal.show();
            }
        });

    </script>

</head>
<body>
<jsp:include page="/menu/top.jsp"/>

<div class="container mt-3">


    <div class="d-flex justify-content-between align-items-center">
        <div>
            <h2>투표</h2>
        </div>

        <form action="./list.jsp" class='pt-1'>
            <div class="row">
                <div class='col'>
                    <select class="form-select" name="col">
                        <option value="question"
                                <%if (col.equals("question"))out.print("selected");%>>설문</option>
                        <option value="sdate"
                                <%if (col.equals("sdate"))out.print("selected");%>>시작날짜</option>
                        <option value="edate"
                                <%if (col.equals("edate"))out.print("selected");%>>종료날짜</option>
                        <option value="total"
                                <%if (col.equals("total"))out.print("selected");%>>전체출력</option>
                    </select>
                </div>
                <div class="col">
                    <input type="text" class="form-control" placeholder="Enter 검색어"
                           name="word" value="<%=word%>">
                </div>
                <div class='col'>
                    <button type="submit" class="btn btn-dark">검색</button>
                    <button type="button" class="btn btn-dark" data-bs-toggle="modal"
                            data-bs-target="#myModal">
                        생성
                    </button>


                </div>
            </div>
        </form>

    </div>

    <div class="container mt-5 ">
        <!-- <h2>게시판</h2> -->
        <table class="table table-hover mt-2">
            <thead>
            <tr>
                <th>번호</th>
                <th>제목</th>
                <th>시작일 ~ 종료일</th>
                <th>작성자</th>
            </tr>
            </thead>
            <tbody>
            <%
                if (list.size() == 0) {
            %>

            <tr>
                <td colspan='4'>등록된 설문이 없습니다.</td>

            </tr>

            <%
            } else {
                while (iter.hasNext()) {
                    PollDTO dto = iter.next();
            %>
            <tr>
                <td><%=dto.getNum()%></td>
                <td><a class="nav-link"
                       href="javascript:section('<%=dto.getNum()%>')"
                       data-bs-target="#voteModal"
                ><%=dto.getQuestion()%></a></td>
                <td><%=dto.getSdate()%> ~ <%=dto.getEdate()%></td>
                <td><%=dto.getWname()%></td>
            </tr>
            <%
                    } //while end
                } //if end
            %>
            </tbody>
        </table>
        <%=paging%>
        <jsp:include page="/menu/bottom.jsp"/>
    </div>

</div>




<!-- 투표 생성 부분  -->
<div class="modal" id="myModal">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <!-- Modal Header -->
            <div class="modal-header">
                <h4 class="modal-title">투표 생성</h4>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>

            <!-- Modal body -->
            <div class="modal-body">
                <form action="./createProc.jsp" method="post"
                      onsubmit='return checkp(this)' id="creat_form" >
                    <div class="mt-3 ">
                        <label class="" for="question">작성자 :</label>
                        <input type="text" class="form-control" id="wname"
                               placeholder="홍길동" name="wname">
                    </div>
                    <div class="mt-3 ">
                        <label class="" for="question">설문 :</label>
                        <input type="text" class="form-control" id="question"
                               placeholder="설문 작성" name="question">
                    </div>

                    <div class="mt-3">
                        <span class="">항목들 :</span>
                        <div class="input-group" id='itemi'>
                            <span class="input-group-text">1</span>
                            <input type="text" class="form-control" name="items" id="item1">
                            <button type="button" class="btn btn-light" onclick="addItem()">add</button>
                        </div>
                        <div id="items-div"></div>

                    </div>

                    <div class="input-group mt-3">
                        <label class="input-group-text">시작일 :</label>
                        <input type="date" name="sdate" id="sdate" class="form-control">
                    </div>

                    <div class="input-group mt-3">
                        <label class="input-group-text">종료일 :</label>
                        <input type="date" name="edate" id="edate" class="form-control">
                    </div>

                    <div class="input-group mt-3">
                        <label class="input-group-text">복수 투표 :</label>
                        <div class="form-check">
                            <input type="radio" name="type" value="1"
                                   class="form-check-input m-2" id="yes" checked>
                            <label class="form-check-label" for="yes">yes</label>
                        </div>
                        <div class="form-check">
                            <input type="radio" name="type" value="0"
                                   class="form-check-input m-2" id="no">
                            <label class="form-check-label" for="no">no</label>
                        </div>
                    </div>


                </form>
            </div>
            <!-- Modal footer -->
            <div class="modal-footer">

                <div class="input-group mb-3 d-flex justify-content-between">
                    <div class="input-group w-25">
                        <span class="input-group-text w-50">비밀번호</span>
                        <input form="creat_form" type="password" class="form-control" id="passwd" placeholder="password" name="passwd">
                    </div>

                    <div>
                        <button type="submit" form="creat_form" class="btn text-primary"><svg xmlns="http://www.w3.org/2000/svg"
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




<%
    if (numdto != null) {
%>
<!-- 투표 부분  -->
<div class="modal" id="voteModal">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <!-- Modal Header -->
            <div class="modal-header">
                <h4 class="modal-title">투표</h4>

                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>

            <!-- Modal body -->
            <div class="modal-body">
                <label class="m-10">설문 내용 : <%=numdto.getQuestion()%></label>
                <form action="pollProc.jsp" class="p-3" id="vote_form"
                      onsubmit='return checknum(this)' >
                    <%
                        for (int i = 0; i < vlist.size(); i++) {
                            PollItemDTO idto = vlist.get(i);

                            if (numdto.getType() == 1) { //복수선택 확인
                    %>
                    <div class="form-check">
                        <input type="checkbox" class="form-check-input" id='check<%=i%>'
                               name='itemnum' value='<%=idto.getItemnum()%>'>
                        <label class="form-check-label" for='check<%=i%>'><%=idto.getItem()%></label>
                    </div>
                    <%
                    } else {
                    %>
                    <div class="form-check">
                        <input type="radio" class="form-check-input" id='radio<%=i%>'
                               name="itemnum" value="<%=idto.getItemnum()%>">
                        <label class="form-check-label" for='radio<%=i%>'><%=idto.getItem()%></label>
                    </div>

                    <%
                            } //if end
                        } //for end
                    %>
                </form>
                </div>
                <!-- Modal footer -->
                <div class="modal-footer">

                    <div class="input-group mb-3 d-flex justify-content-between">

                        <div>
                            <%
                                LocalDate now = LocalDate.now(); //현재 날짜
                                LocalDate edate_ = LocalDate.parse(numdto.getEdate()); //설문 종료날짜

                                if (numdto.getActive() == 0 || now.isAfter(edate_)) { //종료페이지 지난날짜인 경우
                            %>

                            <button type="submit" form="" class="btn  btn-light" data-bs-toggle="tooltip" title="투표기간 종료!" >
                                <svg xmlns="http://www.w3.org/2000/svg" width="35" height="35" fill="currentColor" class="bi bi-x-circle" viewBox="0 0 16 16">
                                    <path d="M8 15A7 7 0 1 1 8 1a7 7 0 0 1 0 14zm0 1A8 8 0 1 0 8 0a8 8 0 0 0 0 16z"/>
                                    <path d="M4.646 4.646a.5.5 0 0 1 .708 0L8 7.293l2.646-2.647a.5.5 0 0 1 .708.708L8.707 8l2.647 2.646a.5.5 0 0 1-.708.708L8 8.707l-2.646 2.647a.5.5 0 0 1-.708-.708L7.293 8 4.646 5.354a.5.5 0 0 1 0-.708z"/>
                                </svg>
                            </button>
                            <%
                            } else {
                            %>

                            <button type="submit" form="vote_form" class="btn  btn-light"  ><svg xmlns="http://www.w3.org/2000/svg"
                                                                                                                                          width="35" height="35" fill="currentColor" class="bi bi-check-circle" viewBox="0 0 16 16">
                                <path d="M8 15A7 7 0 1 1 8 1a7 7 0 0 1 0 14zm0 1A8 8 0 1 0 8 0a8 8 0 0 0 0 16z" />
                                <path
                                        d="M10.97 4.97a.235.235 0 0 0-.02.022L7.477 9.417 5.384 7.323a.75.75 0 0 0-1.06 1.06L6.97 11.03a.75.75 0 0 0 1.079-.02l3.992-4.99a.75.75 0 0 0-1.071-1.05z" />
                            </svg>
                            </button>
                            <%
                                }
                            %>



                            <button type="button" class="btn btn-light "  data-bs-toggle="modal"  data-bs-target="#resultModal" >
                                <svg xmlns="http://www.w3.org/2000/svg" width="35" height="35" fill="currentColor" class="bi bi-file-bar-graph" viewBox="0 0 16 16">
                                    <path d="M4.5 12a.5.5 0 0 1-.5-.5v-2a.5.5 0 0 1 .5-.5h1a.5.5 0 0 1 .5.5v2a.5.5 0 0 1-.5.5h-1zm3 0a.5.5 0 0 1-.5-.5v-4a.5.5 0 0 1 .5-.5h1a.5.5 0 0 1 .5.5v4a.5.5 0 0 1-.5.5h-1zm3 0a.5.5 0 0 1-.5-.5v-6a.5.5 0 0 1 .5-.5h1a.5.5 0 0 1 .5.5v6a.5.5 0 0 1-.5.5h-1z"/>
                                    <path d="M4 0a2 2 0 0 0-2 2v12a2 2 0 0 0 2 2h8a2 2 0 0 0 2-2V2a2 2 0 0 0-2-2H4zm0 1h8a1 1 0 0 1 1 1v12a1 1 0 0 1-1 1H4a1 1 0 0 1-1-1V2a1 1 0 0 1 1-1z"/>
                                </svg>
                            </button>

                            <button class="btn btn-light" onclick="delete_url()">
                                <svg xmlns="http://www.w3.org/2000/svg" width="35" height="35" fill="currentColor" class="bi bi-trash" viewBox="0 0 16 16">
                                    <path d="M5.5 5.5A.5.5 0 0 1 6 6v6a.5.5 0 0 1-1 0V6a.5.5 0 0 1 .5-.5Zm2.5 0a.5.5 0 0 1 .5.5v6a.5.5 0 0 1-1 0V6a.5.5 0 0 1 .5-.5Zm3 .5a.5.5 0 0 0-1 0v6a.5.5 0 0 0 1 0V6Z"/>
                                    <path d="M14.5 3a1 1 0 0 1-1 1H13v9a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V4h-.5a1 1 0 0 1-1-1V2a1 1 0 0 1 1-1H6a1 1 0 0 1 1-1h2a1 1 0 0 1 1 1h3.5a1 1 0 0 1 1 1v1ZM4.118 4 4 4.059V13a1 1 0 0 0 1 1h6a1 1 0 0 0 1-1V4.059L11.882 4H4.118ZM2.5 3h11V2h-11v1Z"/>
                                </svg>
                            </button>


                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<%
}
%>




<%
    if (numdto != null) { // 등록된 설문이 있는 경우
%>

<!-- 투표 결과 Modal -->
<div class="modal" id="resultModal">
    <div class="modal-dialog">
        <div class="modal-content">

            <!-- Modal Header -->
            <div class="modal-header">
                <h4 class="modal-title">투표 결과</h4>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>

            <!-- Modal body -->
            <div class="modal-body">

                <ul class="list-group">
                    <li class="list-group-item">Q : <%=numdto.getQuestion()%></li>
                    <li class="list-group-item">총 투표자 : <%=sum%>명
                    </li>
                </ul>

                <ol class="list-group list-group-numbered">
                        <%
                    if (sum > 0) {
                        for (int i = 0; i < result.size(); i++) {
                            PollItemDTO idtor = result.get(i);
                            String item = idtor.getItem();//아이템



                            int j = (int) (Math.random() * (color.length - 1) + 0);
                            String hRGB = color[j];
                            double count = idtor.getCount();//투표수
                            int ratio = (int) (Math.ceil(count / sum * 100));

                            //System.out.println("radio:" + ratio);
                    %>

                    <li class="list-group-item"><%=item%>
                        <div class="progress">
                            <div class="progress-bar <%=hRGB%>" style="width:<%=ratio%>%"></div>
                        </div> (<%=(int) count%>)
                    </li>
                        <%
                        } //for
                        out.println("</ol>");
                    } else {
                        out.println("<ul class='list-group'><li class='list-group-item'>투표를 먼저 해주세요</li></ul>");
                    }
                    %>
            </div>

            <!-- Modal footer -->
            <div class="modal-footer">
                <button type="button" class="btn btn-danger" data-bs-dismiss="modal">Close</button>
            </div>

        </div>
    </div>
</div>
<!-- Modal end -->

<%
    }
%>
</body>
</html>
