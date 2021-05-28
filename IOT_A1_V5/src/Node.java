import java.io.FileWriter;
import java.io.IOException;
import java.util.*;
import java.util.concurrent.ArrayBlockingQueue;

import static java.lang.Math.abs;
import static java.lang.Math.log;

public class Node extends Thread{

    public void run(){

        while(true) {
            Event e =sleep_wake_quit();
            if (e==null) // of programme should quit, then return.
                return;

            switch (e.code) {
                case (Event.CODE_FLOOD_NEW):    // new packet created and flooded
                    flood_new();
                    break;
                case (Event.CODE_FLOODING):     // old packet flooding
                    naive_ring_olsr_selector();           // naive, ring search, and OLSR handled
                    break;
                case (Event.TERMINATE):
                    //shutDownNode();
                    return;
                default:
                    continue;
            }
        }
    }


    void flood_new(){
        Packet p;
        if (mode==RING_SEARCH) {
            System.out.println("Enter hope life for packet. Enter -1 to ignore hop life.");
            p = new RingSearchPkt(nw.getSeqNo(sid), this, 0, "", inp.nextInt());
        }
        else {
            p = new Packet(nw.getSeqNo(sid), this, 0, "");
//        packets.add(p);
        }
        p.dest=getFloodingDestination().id;

        nw.logToFile(sid+" Flooding new packet.", myWriter);

        flood(p);
    }

    void flood(Packet p){   // floods via naive approach

        if (!shouldFlood(p)){
            nw.redundantPkt(this);
            return;
        }

        for (Node n:neighbors
        ) {
            if (n.id==p.src.id) {
//                nw.logToFile("Contition met "+n.id+" & src: "+p.src.id, myWriter);
                continue;
            }
//            nw.logToFile(sid+" about to read recvd pkt", myWriter);
            int htl;
            if (mode==REGULAR)
                htl=-1;
            else
                htl=((RingSearchPkt)p).htl-1;
            RingSearchPkt newP=new RingSearchPkt(p, this, htl);
            nw.logToFile(sid+ " flooding pkt to "+n.sid, myWriter);
            Event e=new Event(nw.clock, Event.CODE_FLOODING, "", sid, true);
            n.events.add(e);
            n.eventPkts.add(newP);
        }
        nw.tick();
    }


    void flood(RingSearchPkt p){

        if (!shouldFlood(p)){
            nw.redundantPkt(this);
            return;
        }

        if (mode==RING_SEARCH){
            if (!p.isAlive()){
                nw.logPktDied(p);
                return;
            }
        }

        for (Node n:neighbors
        ) {
            if (n.id==p.src.id) {
//                nw.logToFile("Contition met "+n.id+" & src: "+p.src.id, myWriter);
                continue;
            }
//            nw.logToFile(sid+" about to read recvd pkt", myWriter);
            RingSearchPkt newP=new RingSearchPkt(p, this, p.htl-1);
            nw.logToFile(sid+ " flooding pkt to "+n.sid, myWriter);
            Event e=new Event(nw.clock, Event.CODE_FLOODING, "", sid, true);
            n.events.add(e);
            n.eventPkts.add(newP);
        }
        nw.tick();
    } // floods via ring search

    void MPR_flood(RingSearchPkt p){
        if (!shouldFlood(p)){
            nw.redundantPkt(this);
            return;
        }

        for (Node n:neighbors
        ) {
            if (n.id==p.src.id) {
                continue;
            }
            int htl;
            if (mode==REGULAR)
                htl=-1;
            else
                htl=((RingSearchPkt)p).htl-1;
            RingSearchPkt newP=new RingSearchPkt(p, this, htl);
            nw.logToFile(sid+ " flooding pkt to "+n.sid, myWriter);
            Event e=new Event(nw.clock, Event.CODE_FLOODING, "", sid, true);
            n.events.add(e);
            n.eventPkts.add(newP);
        }
        nw.tick();
    }
//==============================================================
//<<-------------------   STRUCTURE FUNCS    ----------------->>
//--------------------------------------------------------------
    int id;
    int ctr;
    int mode;
    String sid;
    ArrayList<Node> neighbors;
    Set<Node> twoHopNeighbors;
    ArrayList<Packet> packets;
    ArrayBlockingQueue<Event> events;
    ArrayBlockingQueue<RingSearchPkt> eventPkts;
    Network nw;
    FileWriter myWriter;
    Scanner inp;

    static final int RING_SEARCH=1;
    static final int REGULAR=0;
    static final int MPR=2;


    public Node(int id, Network nw) {
        constructing(id, nw);
        setNeighbours(inp);
    }

    public Node(int id, Network nw, boolean override) {
        constructing(id, nw);
    }

    public Node(int id, Network nw, int _mode){
        constructing(id, nw);
        mode=_mode;
        if (mode==MPR) {
            twoHopNeighbors = new HashSet<>();
            setTwoHopNeighbours();
        }
    }

    void setNeighbours(Scanner inp){
        String usr_inp;
        int linking;

        do {
            System.out.println("Add link/neighbour ? No (enter 0)\t\tYes (enter neighbour node ID, (eg 1)");
                usr_inp = inp.next();
                linking=nw.strToNumID(usr_inp);
            if (linking == 0) {
                return;
            }
            Node tmp = nw.findNodeWithID(linking);
            if (tmp == null) {
                System.out.println("ERROR: ID/Node " + linking + " not found/present yet.");
                continue;
            }
            addNeighbour(tmp);
            tmp.addNeighbour(this);
        } while (linking != 0);
    }

    void addNeighbour(Node neighbour){
        if (!hasNeighbourNode(neighbour.id))
            neighbors.add(neighbour);
    }

    void addNeighbour(String nsid){
        Node neighbour= nw.findNodeWithID(nw.strToNumID(nsid));
        if (!hasNeighbourNode(neighbour.id))
            neighbors.add(neighbour);
    }

    void addNeighbour(String nsid, boolean bidi){
        Node neighbour= nw.findNodeWithID(nw.strToNumID(nsid));
        if (!hasNeighbourNode(neighbour.id))
            neighbors.add(neighbour);

        if (bidi){
            neighbour.addNeighbour(this);
        }
    }


//===========================================================
//<<-------------------   HELPER FUNCS    ----------------->>
//-----------------------------------------------------------

    boolean hasNeighbourNode(int nodeID){
        for (Node neighbour:neighbors
        ) {
            if (neighbour.id==nodeID)
                return true;
        }
        return false;
    }

    boolean quit(){
        if (ctr%10==0){
            System.out.println("Quit? y/n");
            String uinp=inp.next();
            if (uinp.equals("y")){
                try {
                    myWriter.close();
                } catch (IOException ioException) {
                    ioException.printStackTrace();
                }
                return true;
            }
            return false;
        }
        return false;
    }

    boolean shouldFlood(Packet p) {
        for (Packet myP : packets
        ) {
            if (p.seqNo == myP.seqNo)
                return false;
        }

        packets.add(p);

        if (p.dest==id) {
            nw.logDestFound(p);
            return false;
        }

        return true;
    }

    Node getFloodingDestination(){
//        return null;
        System.out.println("Enter destination node, or enter 0 for random selection");
        String uinp= inp.next();

        if (!uinp.equals("0")){
            return nw.findNodeWithID(nw.strToNumID(uinp));
        }

        Random rand=new Random();
        int rval=(rand.nextInt(nw.participants.size()));
        return neighbors.get(rand.nextInt(neighbors.size())-1);
    }

    void constructing(int id, Network nw){
        mode=0;
        ctr=1;
        this.id = id;
        sid= nw.numToStrID(id);
        this.neighbors = new ArrayList<>();
        this.packets = new ArrayList<>();
        this.nw = nw;
        inp=new Scanner(System.in);
        int cap=nw.getSize();
        int cap2=nw.getSize();
        events=new ArrayBlockingQueue<>(10);
        eventPkts=new ArrayBlockingQueue<>(10);
        try {
            myWriter=new FileWriter(nw.numToStrID(id)+".txt");
        } catch (IOException e) {
            e.printStackTrace();
        }

        twoHopNeighbors=null;
    }

    Event sleep_wake_quit(){
        Event e=null;
        nw.logToFile(sid + " going to sleep.", myWriter);
        try {
            e = events.take();
        } catch (InterruptedException interruptedException) {
            interruptedException.printStackTrace();
        }
        nw.logToFile(sid + " waking up.", myWriter);

        if (quit()){
            return null;
        }
        return e;
    }

    void naive_ring_olsr_selector(){
        try {
            RingSearchPkt myPkt=eventPkts.take();
            if (mode==RING_SEARCH)
                flood(myPkt);
            else if (mode==REGULAR)
                flood((Packet)myPkt);
            else if (mode==MPR)
                MPR_flood(myPkt);
        } catch (InterruptedException interruptedException) {
            interruptedException.printStackTrace();
        }
    }

    void setTwoHopNeighbours(){
        for (Node n:neighbors
             ) {
            twoHopNeighbors.addAll(n.neighbors);
        }

        System.out.println("================== 2 hoppie neghghvz: "+twoHopNeighbors);
    }
}
