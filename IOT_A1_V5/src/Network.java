import java.io.FileWriter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Scanner;

public class Network {
    int clock;
    int redPkts;  // redundant pkts
    String name;
    ArrayList<Node> participants;
    FileWriter myWriter;
    Scanner inp;

    public Network(String name) {
        this.clock = 0;
        redPkts=0;
        this.name = name;
        this.participants = new ArrayList<>();
        try {
            this.myWriter = new FileWriter("nw.txt");
        } catch (IOException e) {
            e.printStackTrace();
        }
        inp=new Scanner(System.in);
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

        System.out.println("Total Packets Generated: "+redPkts);
        System.out.println("Total Redundant Packets: "+Packet.ctr);
        System.out.println("Redundancy: "+(redPkts/Packet.ctr)*100+"%");
    }
    void floodNode(String id){
        int nid=strToNumID(id);
        Node n =findNodeWithID(nid);
        clock++;
        logToFile("Flooding started from node "+id, myWriter);
        n.events.add(new Event(clock, Event.CODE_FLOOD_NEW, "", "nw", false));
    }




//==============================================================
//<<-------------------   STRUCTURE FUNCS    ----------------->>
//--------------------------------------------------------------

    void startNodes(){
        for (Node n:participants
             ) {
            n.start();
        }
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
            addNode(true, mode);

        //Node n= participants[0]; // A

        Node n= participants.get(1); // B
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

//==============================================================
//<<------------------   LOG & MAINTENANCE   ----------------->>
//--------------------------------------------------------------

    void redundantPkt(Node src){
        redPkts++;
        logToFile("--- REDUNDANT PKT DROPPED BY "+src.sid, myWriter);
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
    }

    // OYEEE WE CAN FIND NETWORK WIDE PROLIFERATIONS; STORE ALL PACKETS IN A STATIC ARRAY WITHIN
    // PACKET CLASS. AS END OF NETWORK, JUST SEE HOW MANY PACKETS HAVING SAME ID AND COUNT>=NW SIZE
    // BUT CAREFUL, HOW TO CHECK AGAINST REDUNDANCY ? WAIT ! LOL REDUNDANT PKT ISNT BEINNG CREATED !
    // THIHS WILL WORK !!!

    void logPktDied(Packet p){
        try {
            myWriter.write(
                    "<--------------------------------------------->\n"+
                            clock+":\t===>> Packet died !\n"+
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
}
