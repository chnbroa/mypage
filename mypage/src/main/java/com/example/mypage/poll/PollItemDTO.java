package com.example.mypage.poll;

import lombok.*;

@Setter
@Getter
@AllArgsConstructor
@NoArgsConstructor
@ToString
public class PollItemDTO {
    private int itemnum; // 아이템 번호
    private String item; // 아이템 내용
    private String[] items; //아이템들
    private int count; // 투표수
    private int num; // 설문 번호
}