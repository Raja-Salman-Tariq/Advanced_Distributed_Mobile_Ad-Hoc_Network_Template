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
        interims.add(curr);
    }

    void addInterim(Node n){
        interims.add(n);
    }
    String routeInfo(){
        String S1="Src:"+src.sid+
                ", Last:"+interims.get(interims.size()-1).sid+
                ", Dst:"+Integer.toString(dest)+", Seq # = "+seqNo+
                "\n\t\tRoute:";
        String S2="";

        for (Node n:interims
             ) {
            S2+="-->"+n.sid;
        }
        return S1+S2;
    }
}
