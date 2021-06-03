public class Event {

    final static int CODE_FLOOD_NEW =1;
    final static int CODE_FLOODING=2;
    final static int TERMINATE=0;
    static final int RESTART=4;
    final static int REQUEST_NEIGHBOR_INFO=3;

    int time;
    int code;
    String eventDesc;
    String src;
//    Packet pkt;
    boolean packet;

    Event(int _time, int _code, String _eventDesc, String _src,  /*Packet p*/ boolean _packet){
        time=_time;
        code=_code;
        eventDesc=_eventDesc;
        src=_src;
//        Packet pkt= new Packet(p.seqNo, p.src, p.dest, p.data);
//        pkt.interims.addAll(p.interims);
        packet=_packet;
    }

}
