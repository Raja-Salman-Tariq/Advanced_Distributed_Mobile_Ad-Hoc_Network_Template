import java.util.Scanner;

public class Main {
    static Scanner inp;
    public static void main(String[] args) {
	// write your code here
        inp=new Scanner(System.in);
        Network nw=new Network("MANET");
//        nw.addNodes();//   1
//        nw.topology1();//   2
        nw.topology1(Node.MPR);//  3
//        choose_mode(nw);
        nw.startNodes();
        nw.floodNode("A");
        nw.networkSummary();
    }

    static void choose_mode(Network nw){
        System.out.println("Select a mode to emulate:\n0. Naive Approach;\t\t1.Ring Search;\t\t2.OLSR/MPR");
        int option=inp.nextInt();
        nw.topology1(option);
    }
}