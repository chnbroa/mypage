package com.example.mypage.bbs;


import lombok.*;

@Setter
@Getter
@NoArgsConstructor
@AllArgsConstructor
@ToString
public class BbsDTO {
    /**
     * 번호
     */
    private int bbsno;
    /**
     * 글쓴이
     */
    private String wname;
    /**
     * 제목
     */
    private String title;
    /**
     * 내용
     */
    private String content;
    /**
     * 패스워드
     */
    private String passwd;
    /**
     * 조회수
     */
    private int viewcnt;
    /**
     * 등록일
     */
    private String wdate;
    /**
     * 그룹 번호
     */
    private int grpno;
    /**
     * 답변 차수
     */
    private int indent;
    /**
     * 답변 순서
     */
    private int ansnum;
}
