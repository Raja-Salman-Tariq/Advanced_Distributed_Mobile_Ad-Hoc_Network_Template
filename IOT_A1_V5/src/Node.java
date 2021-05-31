import java.io.FileWriter;
import java.io.IOException;
import java.util.*;
import java.util.concurrent.ArrayBlockingQueue;

import static java.lang.Math.abs;
import static java.lang.Math.log;

public class Node extends Thread{

    void establishMPRState(){
        for (Node n:neighbors
             ) {
            nw.requestNeighborInfo(id, n.id);
        }
//        ArrayList<Event> backup;
//        ArrayList<RingSearchPkt> pktBackup;
//        nw.logToFile("*******************"+sid+" establishing state...", nw.myWriter);
//        nw.logToFile("*******************"+sid+" establishing state...", myWriter);
        Event e=null;
        int count=neighbors.size();
        RingSearchPkt epkt=null;

        while (count>0){
            try {
                e=events.take();
            } catch (InterruptedException interruptedException) {
                interruptedException.printStackTrace();
            }
            if (e.code==Event.REQUEST_NEIGHBOR_INFO){
                count--;
//                nw.logToFile(sid+"\t\t++++++++++++++ new count: "+count, nw.myWriter);
//                nw.logToFile(sid+"\t\t++++++++++++++ new count: "+count, myWriter);
                try {
                    epkt=eventPkts.take();
                } catch (InterruptedException interruptedException) {
                    interruptedException.printStackTrace();
                }

                setTwoHopNeighbors(epkt);
            }
            else {
                events.add(e);
                if (e.packet) {
                    try {
                        eventPkts.add(eventPkts.take());
                    } catch (InterruptedException interruptedException) {
                        interruptedException.printStackTrace();
                    }
                }
            }
        }
        myUncoveredTwoHopNeighbors.addAll(twoHopNeighbors);
        setMPR();
//        nw.logToFile("xxxxxxxxxxxxxxxxxxxxx"+sid+" established state...", nw.myWriter);
//        nw.logToFile("xxxxxxxxxxxxxxxxxxxxx"+sid+" established state...", myWriter);
    }

    public void run(){

        if (mode==MPR){
            establishMPRState();
        }

        while(true) {
            Event e =sleep_wake_quit(); // will only pass if an event is present
            if (e==null) // of programme should quit, then return.
                return;

            switch (e.code) {
                case (Event.CODE_FLOOD_NEW):    // new packet created and flooded
                    flood_new();
                    break;
                case (Event.CODE_FLOODING):     // old packet flooding
                    naive_ring_olsr_selector();           // naive, ring search, and OLSR handled
                    break;
//                case (Event.REQUEST_NEIGHBOR_INFO):
//                    Node seeker=nw.findNodeWithID(nw.strToNumID(e.src));
//                    seeker.neighborListRcvr.add(neighbors);
//                    break;
                case (Event.TERMINATE):
                    //shutDownNode();
                    return;
                default:
                    continue;
            }
        }
    }

    void flood_new(){
        RingSearchPkt p;
        if (mode==RING_SEARCH) {
            System.out.println("Enter hope life for packet. Enter -1 to ignore hop life.");
            p = new RingSearchPkt(nw.getSeqNo(sid), this, 0, "", inp.nextInt());
        }
        else {
            p = new RingSearchPkt(nw.getSeqNo(sid), this, 0, "", -1);
//        packets.add(p);
        }
        p.dest=getFloodingDestination().id;

        nw.logToFile(sid+" Flooding new packet for "+nw.numToStrID(p.dest), myWriter);

        switch(mode) {
            case (MPR):
                MPR_flood(new RingSearchPkt(p, this, -1));
                break;
            case(REGULAR):
                flood(p);
                break;
            case(RING_SEARCH):
                ring_flood(p);
                break;
        }
    }

    void flood(Packet p){   // floods via naive approach
        nw.logToFile("Naive Flooding", nw.myWriter);
        nw.logToFile("Naive Flooding", myWriter);
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
            int htl=-1;
            RingSearchPkt newP=new RingSearchPkt(p, this, htl);
            nw.logToFile(sid+ " flooding pkt to "+n.sid, myWriter);
            Event e=new Event(nw.clock, Event.CODE_FLOODING, "", sid, true);
            n.events.add(e);
            n.eventPkts.add(newP);
        }
        nw.tick();
    }

    void ring_flood(RingSearchPkt p){
        nw.logToFile("Ring search Flooding", nw.myWriter);
        nw.logToFile("Ring search Flooding", myWriter);

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
        String myMPRIds=new String();

        int i=0;
        for (Node n:myMPR
             ) {
            myMPRIds+=(n.sid+", ");
        }

        if (!shouldFlood(p)){
            nw.redundantPkt(this);
            return;
        }

        nw.logToFile(sid+" MPR_Flooding to my MPRs: "+myMPRIds, myWriter);

        for (Node n:neighbors
        ) {
            if (n.id==p.src.id || p.interims.contains(n)) { // todo CAUTION ! ! ! : might go circular;
                nw.logToFile("Recursing", nw.myWriter);
                continue;
            }
            RingSearchPkt newP=new RingSearchPkt(p, this, -1);
            nw.logToFile(sid+ " < < < MPR > > > flooding pkt to "+n.sid+" "+newP.routeInfo(), myWriter);
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
    ArrayBlockingQueue<ArrayList<Node>> neighborListRcvr;
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
//            twoHopNeighbors = new HashSet<>();
//            myMPR=new HashSet<>();
//            myMPRSel=new HashSet<>();
            neighborListRcvr=new ArrayBlockingQueue<>(50);
            myUncoveredTwoHopNeighbors=new HashSet<>();
//            nw.logToFile("Abt to set 2 hop nbrs", nw.myWriter);
//            setTwoHopNeighbours();
//            nw.logToFile("Set 2 hop nbrs: "+twoHopNeighbors, nw.myWriter);
//            myUncoveredTwoHopNeighbors.addAll(twoHopNeighbors);
//            setMPR();

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
            if (p.seqNo == myP.seqNo) {
//                nw.logToFile("seq no if", myWriter);
                return false;
            }
        }


        if (p.dest==id) {
            nw.logDestFound(p);
//            nw.logToFile("dest if", myWriter);
            return false;
        }

        if (mode==MPR){ // TODO: this might cause unneccessary pkt drop, maybe re-look into this
            int last=p.interims.size()-1; // TODO: but also note, we won't flood to non MPR, so is ok.
            if (last>=0) {
                if (!myMPRSel.contains(p.interims.get(last))&&p.interims.size()>1) {
//                    nw.logToFile("Lastest if + "+p.interims.get(0).sid, myWriter);
                    return false;
                }
            }
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
//        System.out.println("<<<<<<<<<<< "+nw.findNodeWithID());
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
        events=new ArrayBlockingQueue<>(50);
        eventPkts=new ArrayBlockingQueue<>(50);
        try {
            myWriter=new FileWriter(nw.numToStrID(id)+".txt");
        } catch (IOException e) {
            e.printStackTrace();
        }

        twoHopNeighbors=null;
        myMPR=null;
        myMPRSel=null;
        myUncoveredTwoHopNeighbors=null;
        neighborListRcvr=null;
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
                ring_flood(myPkt);
            else if (mode==REGULAR)
                flood((Packet)myPkt);
            else if (mode==MPR)
                MPR_flood(myPkt);
        } catch (InterruptedException interruptedException) {
            interruptedException.printStackTrace();
        }
    }

    void setTwoHopNeighbors(RingSearchPkt epkt){
        if (twoHopNeighbors==null)
            twoHopNeighbors=new HashSet<>();
//        for (Node n:twoHopNeighbors
//        ) {
//            nw.logToFile("=====================Currently contains "+n.sid, myWriter);
//        }

        String mysitre="";
        for (Node no:neighbors
             ) {
            mysitre+=(no.sid+", ");
        }
//        nw.logToFile("Neighbors: "+mysitre, myWriter);

        for (Node n:epkt.interims
             ) {
//            nw.logToFile("Recvs 2 hop: "+n.sid, myWriter);
            if (neighbors.contains(n)) {
//                nw.logToFile("Discarding "+n.sid+" cuz contained", myWriter);
                continue;
            }
            if (sid==n.sid) {
//                nw.logToFile("Discarding "+n.sid+" same id", myWriter);
                continue;
            }
            twoHopNeighbors.add(n);
//            nw.logToFile("*********keeping "+n.sid+"", myWriter);
        }
    }

//    void setTwoHopNeighbours(){
//        twoHopNeighbors=new HashSet<>();
////        System.out.println("SETTING***************************req");
//        nw.logToFile(sid+" My Neighbors: "+neighbors, nw.myWriter);
//        int nodeid;
//        for (Node n:neighbors
//             ) {
////            nodeid=n.id;
////            nw.logToFile("Found iD ! :"+n.id, nw.myWriter);
////            nw.logToFile("FOUND NEIGHBORS: "+nw.findNodeWithID(n.id).neighbors, nw.myWriter);
////            ArrayList<Node> neighbors= null;
//////            System.out.println("***************************req");
////            System.out.println("<<<<<<<<<<<"+nw.findNodeWithID(n.id));
////            nw.logToFile("Going to sleep, waiting for neighbor info.", myWriter);
////            nw.logToFile("Node "+sid+" awaiting neighbor info", nw.myWriter);
//////            try {
//////                neighbors = neighborListRcvr.take();
//////            } catch (InterruptedException e) {
//////                e.printStackTrace();
//////            }
////////            System.out.println("***************************tek");
//////            nw.logToFile("Woken up with neighbor info", myWriter);
////            twoHopNeighbors.addAll(n.neighbors);
//            nw.requestNeighborInfo(id,n.id);
//            try {
//                nw.logToFile("RECEIVED DATA !"+neighborListRcvr.take(), nw.myWriter);
//            } catch (InterruptedException e) {
//                e.printStackTrace();
//            }
//
//        }
//
////        System.out.println("================== 2 hoppie neghghvz: "+twoHopNeighbors);
////        System.out.println("\n\n=========================\n\n");
//
//
//    }

    void setMPR(){

        String mystire;

        mystire="";
        for (Node n:twoHopNeighbors
        ) {
            mystire+=(n.sid+", ");
        }
//        nw.logToFile("2hoppers: " + mystire, myWriter);

        mystire="";
        for (Node n:myUncoveredTwoHopNeighbors
        ) {
            mystire+=(n.sid+", ");
        }
//        nw.logToFile("uncovered: " + mystire, myWriter);

        if (myMPR==null) {
            myMPR = new HashSet<>();
            myMPRSel = new HashSet<>();
        }
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
                        if (myUncoveredTwoHopNeighbors.contains(node)) {// mark relevant nodes as covered
//                            nw.logToFile("Removing node cuz only neighbor"+node.sid, myWriter);
                            myUncoveredTwoHopNeighbors.remove(node);
                        }
                    }
                }
            }
        }

        mystire="";
        for (Node n:myMPR
             ) {
            mystire+=n.sid;
        }
//        nw.logToFile("Step 2: " + mystire, nw.myWriter);

        // ------------- STEP # 3 FROM PDF
        int idx=0;          // index to traverse neighbors
        Node MPR_cdd;       // mpr candidate
        int [] coverage = new int[neighbors.size()];
        for (int i = 0; i < coverage.length; i++) {
            coverage[i]=-1;
        }

        mystire="";
        for (int i:coverage
             ) {
            mystire+=Integer.toString(i)+", ";
        }
//        nw.logToFile("Coverage1: "+mystire, myWriter);
        // find all neighbors' coverage
        while (idx<neighbors.size()){
            MPR_cdd=neighbors.get(idx);
            if (!myMPR.contains(MPR_cdd)){
                findCoverage(coverage, idx, MPR_cdd);
            }
            idx++;
        }

        mystire="";
        for (int i:coverage
        ) {
            mystire+=Integer.toString(i)+", ";
        }
//        nw.logToFile("Coverage2: "+mystire, myWriter);

        // select best coverage and remove uncovered nodes from list, till all nodes are covered
        while (myUncoveredTwoHopNeighbors.size()>0){
            MPR_cdd=findHighestCoverageNode(coverage);
            for (Node n2: MPR_cdd.neighbors
                 ) {
//                nw.logToFile("Removing node "+n2.sid+" cuz best coverage", myWriter);
                myUncoveredTwoHopNeighbors.remove(n2);
                System.out.println("Uncovered list size: "+myUncoveredTwoHopNeighbors.size());
            }
            myMPR.add(MPR_cdd);
            try {
                MPR_cdd.myMPRSel.add(this);
            } catch (NullPointerException npe){
                try {
                    sleep(5000);
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
                MPR_cdd.myMPRSel.add(this);
            }
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
