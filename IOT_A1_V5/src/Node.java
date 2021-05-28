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

        for (Node n:myMPR
        ) {
            if (n.id==p.src.id) { // todo CAUTION ! ! ! : might go circular;
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
    Set<Node> myMPR;
    Set<Node> myMPRSel;
    Set<Node> myUncoveredTwoHopNeighbors;
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
            myMPR=new HashSet<>();
            myMPRSel=new HashSet<>();
            myUncoveredTwoHopNeighbors=new HashSet<>();

            setTwoHopNeighbours();
            myUncoveredTwoHopNeighbors.addAll(twoHopNeighbors);
            setMPR();

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
        if (mode==MPR){ // TODO: this might cause unneccessary pkt drop, maybe re-look into this
            int last=p.interims.size()-1; // TODO: but also note, we won't flood to non MPR, so is ok.
            if (!myMPRSel.contains(p.interims.get(last)))
                return false;
        }

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
        myMPR=null;
        myMPRSel=null;
        myUncoveredTwoHopNeighbors=null;
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
        System.out.println("\n\n=========================\n\n");
    }

    void setMPR(){

        // ------------- STEP # 2 FROM PDF
        for (Node n:twoHopNeighbors
             ) {
            if (n.neighbors.size()==1) { //if 2 hop node has only one node and that node...
                Node tmp=n.neighbors.get(0);
                if (hasNeighbourNode(tmp.id)) { /// ... is my neighbor, then add it
                    myMPR.add(tmp);
                    tmp.myMPRSel.add(this);
                    for (Node node:tmp.neighbors
                         ) {
                        if (myUncoveredTwoHopNeighbors.contains(node)) // mark relevant nodes as covered
                            myUncoveredTwoHopNeighbors.remove(node);
                    }
                }
            }
        }

        // ------------- STEP # 3 FROM PDF
        int idx=0;          // index to traverse neighbors
        Node MPR_cdd;       // mpr candidate
        int [] coverage = new int[neighbors.size()];
        for (int i = 0; i < coverage.length; i++) {
            coverage[i]=-1;
        }

        // find all neighbors' coverage
        while (idx<neighbors.size()){
            MPR_cdd=neighbors.get(idx);
            if (!myMPR.contains(MPR_cdd)){
                findCoverage(coverage, idx, MPR_cdd);
            }
            idx++;
        }

        // select best coverage and remove uncovered nodes from list, till all nodes are covered
        while (myUncoveredTwoHopNeighbors.size()>0){
            MPR_cdd=findHighestCoverageNode(coverage);
            for (Node n2: MPR_cdd.neighbors
                 ) {
                myUncoveredTwoHopNeighbors.remove(n2);
                System.out.println("Uncovered list size: "+myUncoveredTwoHopNeighbors.size());
            }
            myMPR.add(MPR_cdd);
            MPR_cdd.myMPRSel.add(this);
        }
    }

    Node findHighestCoverageNode(int [] coverage){
        int max=-1;
        int idx=-1;
        for (int i = 0; i < neighbors.size(); i++) {
            if (coverage[i]>max) {
                max = coverage[i];
                idx=i;
            }
        }
        coverage[idx]=-1;
        return neighbors.get(idx);
    }

    void findCoverage(int [] coverage, int idx, Node MPR_cdd){
        int cvrg=-1;
        for (Node n:myUncoveredTwoHopNeighbors
             ) {
            if (n.hasNeighbourNode(MPR_cdd.id))
                cvrg++;
        }
        coverage[idx]=cvrg;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        Node node = (Node) o;
        return id == node.id;
    }

    @Override
    public int hashCode() {
        return Objects.hash(id);
    }
}
