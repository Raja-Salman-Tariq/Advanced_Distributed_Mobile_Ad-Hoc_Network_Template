import java.io.FileWriter;
import java.io.IOException;
import java.util.*;

import static java.lang.Thread.sleep;

public class Network {
    ArrayList<Integer> ringSizes;
    HashSet<Node> allUnique;
    int currSeqNo;
    int clock;
    int redPkts;  // redundant pkts
    String name;
    ArrayList<Node> participants;
    FileWriter myWriter;
    FileWriter pktWriter;
    Scanner inp;
    int rsp;        // ring search pkt count
    int totalPkts;
    int hopLife;

    public Network(String name) {
        currSeqNo=0;
        allUnique=new HashSet<>();
        rsp=0;
        hopLife=0;
        totalPkts=0;
        this.clock = 0;
        redPkts=0;
        this.name = name;
        this.participants = new ArrayList<>();
        ringSizes=new ArrayList<>();

        startNodes(false);
    }
    void networkSummary(){
        for (Node n:participants
        ) {
            System.out.print("Node "+idsToStr(n.id)+", [");
            for (Node n2:n.neighbors
            ) {
                System.out.print(idsToStr(n2.id)+",");
            }
            System.out.println("]");
        }
        System.out.println("|================================|");
        System.out.println("|Total Packets Generated:\t"+totalPkts+"\t|");
        System.out.println("|Total Redundant Packets:\t"+redPkts+"\t|");
        System.out.println("|Redundancy:\t\t\t"+(redPkts/totalPkts)*100+"%\t\t  |");
        System.out.println("|Convergence ticks/time:\t"+clock+"   |");
        System.out.println("|================================|");

        logToFile("|================================|", myWriter);
        logToFile("|Total Packets Generated:\t"+totalPkts+"\t|", myWriter);
        logToFile("|Total Redundant Packets:\t"+redPkts+"\t|", myWriter);
        logToFile("|Redundancy:\t\t\t"+(redPkts/totalPkts)*100+"%\t\t  |", myWriter);
        logToFile("|Convergence ticks/time:\t"+clock+"   |", myWriter);
        logToFile("|================================|", myWriter);

        System.out.println("\n\nRestart ? \t\t0.No\t\t1. Yes");

        if (inp.nextInt()==0) {
            System.out.println("Shutting down network...");
            return;
        }
        resetNetwork();
        startNodes(true);
    }
    void floodNode(){
//        System.out.println("FLOODING D NORM");
        System.out.println("Enter node to start flooding from.");
        String id=inp.next();
        int nid=strToNumID(id);
        Node n =findNodeWithID(nid);
        clock++;
        logToFile("Flooding started from node "+id, myWriter);
        currSeqNo=clock;
        n.events.add(new Event(clock, Event.CODE_FLOOD_NEW, "", "nw", false));
    }
    void floodNode(int nid){
//        System.out.println("FLOODING D ID");
        Node n =findNodeWithID(nid);
        if (n.hope_life>=participants.size()){
            logToFile("The hope life has grown equal to or greater than the number of participants in the network." +
                    "The node must not be present, terminating ring search.", myWriter);
            resetNetwork();
            return;
        }
        clock++;
        logToFile("\n\n\t\t< < =================== > >\nRestarting flooding with ring size "+(n.hope_life+2)+"\n\n", myWriter);
        currSeqNo=clock;
        n.events.add(new Event(clock, Event.CODE_FLOOD_NEW, "", "nw", false));
    }



//==============================================================
//<<-------------------   STRUCTURE FUNCS    ----------------->>
//--------------------------------------------------------------
    void choose_mode(){
        System.out.println("Select a mode to emulate:\n0. Naive Approach;\t\t1.Ring Search;\t\t2.OLSR/MPR");
        int mode=inp.nextInt();

        System.out.println("Select a topology to emulate:\n0. Show topologies.\t\t1.Topology # 1\t\t2.Topology # 2\t\t3.Topology # 3\t\t4.Topology # 4\t\t5.Random Topology.");
        int topology=0;

        topology=inp.nextInt();

        switch (topology){
            case(1):    topology1(mode); break;
            case(2):    topology2(mode); break;
            case(3):    topology3(mode); break;
            case(4):    topology4(mode); break;
            case(5):    randomTopology(mode); break;
        }

    }
    void startNodes(boolean rerun){
        if (rerun){
            System.out.println("Network has been restarted. Enter any number to proceed.");
            inp.next();
        }

        inp=new Scanner(System.in);


        try {
            this.myWriter = new FileWriter("nw.txt");
            pktWriter=new FileWriter("packets.txt");
        } catch (IOException e) {
            e.printStackTrace();
        }

        choose_mode();

        for (Node n:participants
        ) {
            n.start();
        }

        floodNode();
    }

    void addNodes() {
        String usr_inp;
        do {
            System.out.println("Add node " +idsToStr(clock+1)+ "? \t1.Yes\t\t0.No");
            usr_inp = inp.next();
            if (usr_inp.equals("0"))
                continue;
            addNode();
        } while (!usr_inp.equals("0")); // add nodes
    }

    void addNode() {
        clock++;
        logToFile("Adding Node " + idsToStr(getSize()+1),myWriter);
        participants.add(new Node(getSize()+1, this));
    }

    void addNode(boolean terse, int mode) {
        clock++;
        if (!terse) {
            logToFile("Adding Node " + idsToStr(getSize() + 1), myWriter);
        }

        participants.add(new Node(getSize()+1,this, mode));
    }

    void topology1(int mode){
        for (int i=0; i< 9; i++)
            addNode(false, mode);

        //Node n= participants[0]; // A

        Node n= participants.get(1); // B
        n.addNeighbour("A", true);

        n= participants.get(2); // C
        n.addNeighbour("A", true);

        //Node n= participants[2]; // C

        n= participants.get(3); // D
        n.addNeighbour("B", true);
        n.addNeighbour("C", true);

        n= participants.get(4); // E
        n.addNeighbour("D", true);
        n.addNeighbour("C", true);

        n= participants.get(5); // F
        n.addNeighbour("E", true);

        n= participants.get(6); // G
        n.addNeighbour("F", true);
        n.addNeighbour("C", true);

        n= participants.get(7); // H
        n.addNeighbour("A", true);
        n.addNeighbour("C", true);
        n.addNeighbour("B", true);

        n= participants.get(8); // I
        n.addNeighbour("G", true);
        n.addNeighbour("H", true);
    }

    void topology2(int mode){
        for (int i=0; i< 9; i++)
            addNode(false, mode);

        //Node n= participants[0]; // A

        Node n= participants.get(1); // B
        n.addNeighbour("A", true);

        //Node n= participants[2]; // C

        n= participants.get(3); // D
        n.addNeighbour("B", true);
        n.addNeighbour("D", true);

        n= participants.get(4); // E
        n.addNeighbour("D", true);
        n.addNeighbour("B", true);

        n= participants.get(5); // F
        n.addNeighbour("E", true);

        n= participants.get(6); // G
        n.addNeighbour("D", true);
        n.addNeighbour("A", true);

        n= participants.get(7); // H
        n.addNeighbour("A", true);
        n.addNeighbour("E", true);
        n.addNeighbour("F", true);

        n= participants.get(8); // I
        n.addNeighbour("G", true);
        n.addNeighbour("H", true);
    }

    void topology3(int mode){
        for (int i=0; i< 9; i++)
            addNode(false, mode);

        //Node n= participants[0]; // A

        Node n= participants.get(1); // B
        n.addNeighbour("A", true);

        n= participants.get(2); // C
        n.addNeighbour("B", true);

        n= participants.get(3); // D
        n.addNeighbour("D", true);
        n.addNeighbour("B", true);

        n= participants.get(4); // E
        n.addNeighbour("E", true);
        n.addNeighbour("F", true);

        n= participants.get(5); // F
        n.addNeighbour("E", true);

        n= participants.get(6); // G
        n.addNeighbour("G", true);
        n.addNeighbour("H", true);

        n= participants.get(7); // H
        n.addNeighbour("A", true);
        n.addNeighbour("D", true);
        n.addNeighbour("B", true);

        n= participants.get(8); // I
        n.addNeighbour("C", true);
        n.addNeighbour("H", true);
    }

    void topology4(int mode){
        for (int i=0; i< 9; i++)
            addNode(false, mode);

        //Node n= participants[0]; // A

        Node n= participants.get(1); // B
        n.addNeighbour("A", true);

        n= participants.get(2); // C
        n.addNeighbour("C", true);


        n= participants.get(3); // D
        n.addNeighbour("B", true);
        n.addNeighbour("A", true);

        n= participants.get(4); // E
        n.addNeighbour("D", true);
        n.addNeighbour("E", true);

        n= participants.get(5); // F
        n.addNeighbour("E", true);

        n= participants.get(6); // G
        n.addNeighbour("F", true);
        n.addNeighbour("A", true);

        n= participants.get(7); // H
        n.addNeighbour("A", true);
        n.addNeighbour("H", true);
        n.addNeighbour("B", true);

        n= participants.get(8); // I
        n.addNeighbour("A", true);
        n.addNeighbour("B", true);
    }

    void randomTopology(int mode){
        for (int i=0; i< 9; i++)
            addNode(false, mode);

        //initialize n
        Node n = participants.get(1);

        //create list of nodes names
        List<String> nodes = new ArrayList<>();
        nodes.add("A");
        nodes.add("B");
        nodes.add("C");
        nodes.add("D");
        nodes.add("E");
        nodes.add("F");
        nodes.add("G");

        int countRandomNeighbors = 0;
        Random rand = new Random();

        for (int i = 1; i <= nodes.size(); i++) {
            n= participants.get(i);

            //generate random number of neighbours from 0-5
            countRandomNeighbors = rand.nextInt(5-1)+1;
            Collections.shuffle(nodes);
            for (int j = 0; j < countRandomNeighbors; j++) {
                n.addNeighbour(nodes.get(j), true);
            }
        }
    }

//==============================================================
//<<------------------   LOG & MAINTENANCE   ----------------->>
//--------------------------------------------------------------

    void resetNetwork(){
        boolean states=true;
        int i=0;

        while(participants.size()>0) {
            if (participants.get(i).state == true) {
                try {
                    sleep(1000);
                } catch (InterruptedException e) {
                   e.printStackTrace();
                }
            }
            else participants.remove(i);
            i=(i+1)%participants.size();
        }

        // code from constr
        rsp=0;
        totalPkts=0;
        this.clock = 0;
        redPkts=0;
        this.name = name;
        this.participants = new ArrayList<>();

        try {
            myWriter.close();
            pktWriter.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    void redundantPkt(Node src, Packet p){
        redPkts++;
        logToFile("--- REDUNDANT PKT DROPPED BY "+src.sid, myWriter);
        String alreadyHas="\t\t";

        alreadyHas+=hasPktHow(src, p.seqNo);

        logToFile("---\t\tTotal Pkts: "+totalPkts+",\t\tRed Pkts: "+redPkts+"\t\tRSP Pkts: "+rsp+" ---\n\t\t\t"+p.routeInfo(src.sid)+"\n"+alreadyHas, pktWriter);
    }

    void logDestFound(Packet p){
        try {
            myWriter.write(
                    "<--------------------------------------------->\n"+
                    clock+":\t===>> Destination Found !\n"+
                            "Source: \t"+p.src.sid+"\nDest: "+numToStrID(p.dest)+
                            "\nPath: \t\t["
            );

            for (Node n:p.interims
                 ) {
                myWriter.write(n.sid+", ");
            }
            myWriter.write("]\n<--------------------------------------------->\n");

        } catch (IOException ioException) {
            ioException.printStackTrace();
        }

        try {
            myWriter.flush();
        } catch (IOException ioException) {
            ioException.printStackTrace();
        }

        try {
            sleep(5000);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        for (Node n:participants
             ) {
            n.events.add(new Event(clock, Event.TERMINATE, "", "nw", false));
        }
        networkSummary();
    }

    // OYEEE WE CAN FIND NETWORK WIDE PROLIFERATIONS; STORE ALL PACKETS IN A STATIC ARRAY WITHIN
    // PACKET CLASS. AS END OF NETWORK, JUST SEE HOW MANY PACKETS HAVING SAME ID AND COUNT>=NW SIZE
    // BUT CAREFUL, HOW TO CHECK AGAINST REDUNDANCY ? WAIT ! LOL REDUNDANT PKT ISNT BEINNG CREATED !
    // THIHS WILL WORK !!!

    void logPktDied(Packet p, boolean dropped, Node src){
        rsp--;
        String reason="";
        if (dropped)
            reason = " beacause it was dropped ";
        logToFile("###\t\tTotal Pkts: "+totalPkts+",\t\tRed Pkts: "+redPkts+"\t\tRSP Pkts: "+(rsp)+" ###\n\t\t\t"+p.routeInfo(src.sid)+"\n", pktWriter);
        try {
            myWriter.write(
                    "<--------------------------------------------->\n"+
                            clock+":\t===>> Packet died"+reason+" !"+
                            "\tSource: "+p.src.sid+"\tDest: "+numToStrID(p.dest)+
                            "\tPath: \t\t["
            );

            for (Node n:p.interims
            ) {
                myWriter.write(n.sid+", ");
            }
            myWriter.write("]\n");//<--------------------------------------------->\n");

        } catch (IOException ioException) {
            ioException.printStackTrace();
        }

        try {
            myWriter.flush();
        } catch (IOException ioException) {
            ioException.printStackTrace();
        }

        HashSet<Node> tmp=new HashSet<>();
        getPermissibleRspCount((p.src.hope_life)-2, tmp,p.src);


        for (Node n:tmp
             ) {
            System.out.println(n.sid+", ");
        }
        System.out.println(p.src.hope_life);
        System.out.println("=================");

        if (rsp==tmp.size()) {
            logToFile("***********   HURRAAAAAHHH   **************", myWriter);
            expandRing(p);
        }
        else
            notifyUnique(p);
    }
    void notifyUnique(Packet p){
        if (currSeqNo==p.seqNo) {
            allUnique.add(p.src);
            allUnique.addAll(p.interims);
        }
        if (allUnique.size()==participants.size()) {
            allUnique.clear();
            try {
                sleep(5000);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
            logToFile("***********   hayayayayayay   **************", myWriter);
            expandRing(p);
        }
    }
    HashSet<Node> getPermissibleRspCount(int r, HashSet<Node> countedNodes, Node n){
        if (r<=0)
            return null;

        for (Node no:n.neighbors
             ) {
            try {
                countedNodes.addAll(getPermissibleRspCount(r - 1, countedNodes, no));
            }catch (NullPointerException npe){

            }
        }

        countedNodes.addAll(n.neighbors);
        return countedNodes;
    }

    int countNodes(Node src){
        int cnt=0;
        for (Node n: src.neighbors)
            cnt++;
        return cnt;
    }

    void expandRing(Packet p){
//        if (ringSizes.contains(p.src.hope_life+2))
//                return;
        // restart all nodes
//        for (Node n:participants
//             ) {
//            n.events.add(new Event(clock, Event.RESTART, "", "nw", false));
//        }

        // wait on all nodes
//        int i=0;
//        ArrayList<Node> waitingFor=new ArrayList<>();
//        waitingFor.addAll(participants);
//
//        int iter=0;
//        while(waitingFor.size()>0 && iter++<5) {
//            Node n=waitingFor.get(i);
//            if (n.packets.size() >0) {
//                logToFile("Restarting flooding. Waiting for "+waitingFor.size()+" more...", myWriter);
//                try {
//                    n.events.add(new Event(clock, Event.RESTART, "", "nw", false));
//                    sleep(500);
//                } catch (InterruptedException e) {
//                    e.printStackTrace();
//                }
//            }
//            else waitingFor.remove(i);
//            i=(i+1)%waitingFor.size();
//        }

        // begin re flooding
            int sz=p.src.neighbors.size();
            rsp=0;
            totalPkts=0;
            redPkts=0;
            logToFile("<---------------------"+rsp+" < "+sz+"-------------------->", pktWriter);
            ringSizes.add(p.src.hope_life+2);
            floodNode(p.src.id);

    }
//===========================================================
//<<-------------------   HELPER FUNCS    ----------------->>
//-----------------------------------------------------------
    public String numToStrID(int node_id){ //REF: https://coderwall.com/p/8iu4jw/integer-to-letter-mapping
        char [] charray=(Integer.toString(node_id-1, 26)).toCharArray();
//        System.out.println("charray: "+charray);
        String result="";
        for (char c:charray
        ) {
            // convert the base 26 character back to a base 10 integer
            int x = Integer.parseInt(Character.valueOf(c).toString(), 26);
            // append the ASCII value to the result
            result += String.valueOf((char)(x + 'A'));
        }
        return result;
    }

    int strToNumID(String node_id){
        if (node_id.equals("0"))return 0;

        return node_id.toCharArray()[0]-'A'+1;
    }

    String idsToStr(int id){
        return id+"/"+numToStrID(id);
    }

    void logToFile(String str, FileWriter myWriter){
        try {
            myWriter.write(clock+":\t\t"+str+"\n");
        } catch (IOException ioException) {
            ioException.printStackTrace();
        }

        try {
            myWriter.flush();
        } catch (IOException ioException) {
            ioException.printStackTrace();
        }

    }

    int getSize(){
        return participants.size();
    }

    Node findNodeWithID(int ID){
        for (Node p:participants
        ) {
            if (p.id==ID)
                return p;
        }
        return null;
    }

    public int getSeqNo(String sid) {
        clock++;
        logToFile(sid+" creating pkt with seqNum "+clock,myWriter);
        return clock;
    }

    void tick(){
        clock++;
    }

    public void requestNeighborInfo(int id, int id1) {
        Node n=findNodeWithID(id1);
        Node dst=findNodeWithID(id);

        RingSearchPkt p=new RingSearchPkt(-1, null, id, "",-1);

        for (Node neighb:n.neighbors
             ) {
            p.addInterim(neighb);
        }

        dst.eventPkts.add(p);
        dst.events.add(new Event(clock,Event.REQUEST_NEIGHBOR_INFO, "", numToStrID(id),true));
//        logToFile("Sharing data: "+n.neighbors, myWriter);
//        dst.neighborListRcvr.add(new ArrayList<Node>(n.neighbors));
    }

    public int requestNeighborCnt(int id) {
        Node src=findNodeWithID(id);
        int nct=0;

        for (Node n:src.neighbors) {
            for (Node neighb : n.neighbors
            ) {
                nct++;
            }
        }
        return nct;
    }
    public int requestSecondNeighborCnt(int id) {
        Node src=findNodeWithID(id);
        int nct=0;

        for (Node n:src.neighbors) {
            for (Node neighb : n.neighbors
            ) {
                nct++;
            }
        }
        return nct;
    }

    public String hasPktHow(Node node, int seqNu){
        String toRet="Via: ";
        for (Packet p:node.packets){
            if (p.seqNo==seqNu){
                for (Node n:p.interims
                ) {
                    toRet+="-->"+n.sid;
                }
                toRet+="\n";
            }
        }
        return toRet;
    }
}
