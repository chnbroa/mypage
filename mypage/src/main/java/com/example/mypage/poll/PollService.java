package com.example.mypage.poll;


import java.util.HashMap;
import java.util.Map;
import java.util.Vector;

public class PollService {
    private PollDAO dao;

    private  PollItemDAO idao;
    public PollService() {
        dao = new PollDAO();
        idao = new PollItemDAO();
    }



    public Vector<PollItemDTO> getView(int num) {

        if (num == 0)
            num = dao.getMaxNum();
        Vector<PollItemDTO> vlist = idao.getView(num);

        return vlist;
    }

    public int sumCount(int num) {
        if (num == 0)
            num = dao.getMaxNum();
        int count = idao.sumCount(num);
        return count;
    }


    public boolean updateCount(String[] itemnum) {

        boolean flag = false;

        flag = idao.updateCount(itemnum);

        return flag;

    }




    public int getMaxNum() {
        int num = dao.getMaxNum();
        return num;
    }

    public PollDTO read( int num){
        return dao.read(num);
    }
    public Vector<PollItemDTO> itemList(int num)
    {
        return idao.itemList(num);
    }

    public boolean create(PollDTO dto, PollItemDTO idto)
    {
        boolean flag = false;
        try{
            dao.create(dto);
            idto.setNum(dao.getMaxNum()); // 생성된 pk값 받아오기
            int size = idto.getItems().length;
            for (int i = 0; i < size; i++) {
                if (idto.getItems()[i].length() > 0) {
                    idto.setItem(idto.getItems()[i]);
                    idao.create(idto);
                }
            }
            flag = true;
        } catch (Exception e){
            e.printStackTrace();
        }

        return flag;
    }


    public Vector<PollDTO> getList(Map map) {

        Vector<PollDTO> list = dao.getList(map);

        return list;
    }

    public int total(String col, String word) {
        HashMap<String, String> map = new HashMap<String, String>();

        map.put("col", col);
        map.put("word",word);
        int total = dao.total(map);
        return total;
    }

}
