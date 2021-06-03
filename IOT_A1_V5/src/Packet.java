import java.util.ArrayList;

public class Packet {

    static int ctr=0;

    Node src;
    ArrayList<Node> interims;
    int dest;
    int seqNo;
    String data;

    Packet(int _seqNo, Node _src, int _dst, String _data){
        ctr+=1;
        seqNo=_seqNo;
        src=_src;
        dest=_dst;
        data=_data;
        interims=new ArrayList<>();
    }


    Packet(Packet p, Node curr){
        ctr+=1;
        seqNo=p.seqNo;
        src=p.src;
        dest=p.dest;
        data=p.data;
        interims=new ArrayList<>();
        interims.addAll(p.interims);
//        interims.add(curr);
    }

    void addInterim(Node n){
        interims.add(n);//n.nw.logToFile("!!!!!!!!"+routeInfo(), n.nw.pktWriter);
    }
    String routeInfo(String curr_sid){
        String myLast;

        try{
            myLast=interims.get(interims.size()-1).sid;
        }catch (IndexOutOfBoundsException n){
            myLast=null;
        }

        String S1="\t\tSrc:"+src.sid+
                ", Last:"+myLast+
                ", Dst:"+Integer.toString(dest)+
                ", Curr:"+curr_sid+
                ", Seq # = "+seqNo+
                "\n\t\tRoute:";
        String S2="";

        for (Node n:interims
             ) {
            S2+="-->"+n.sid;
        }
        S2+="\n";
        return S1+S2;
    }

}
