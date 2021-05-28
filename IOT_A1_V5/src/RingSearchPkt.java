public class RingSearchPkt extends Packet{
    int htl; // hops to live

    public RingSearchPkt(int _seqNo, Node _src, int _dst, String _data, int htl) {
        super(_seqNo, _src, _dst, _data);
        this.htl = htl;
    }

    public RingSearchPkt(Packet p, Node curr, int htl) {
        super(p, curr);
        this.htl = htl;
    }

    void hop(){ if (htl>-1) htl--;}
    boolean isAlive(){return htl>0 || htl==-1;}
}
