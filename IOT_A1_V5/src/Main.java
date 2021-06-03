import java.util.Scanner;

public class Main {
    static Scanner inp;
    public static void main(String[] args) {
	// write your code here
        inp=new Scanner(System.in);
        Network nw=new Network("MANET");
//        nw.addNodes();//   1
//        nw.topology1();//   2
//        nw.topology1(Node.MPR);//  3
//        choose_mode(nw);
//        nw.startNodes(false);
//        nw.floodNode();
//        nw.networkSummary();
    }

    static void choose_mode(Network nw){
        System.out.println("Select a mode to emulate:\n0. Naive Approach\t\t1.Ring Search\t\t2.OLSR/MPR");
        int mode=inp.nextInt();

        System.out.println("Select a topology to emulate:\n0. Show topologies.\t\t1.Topology # 1\t\t2.Topology # 2\t\t3.Topology # 3\t\t4.Topology # 4\t\t5.Random Topology.");
        int topology=0;

        topology=inp.nextInt();

//        while (topology==0){
//            showTopologies();
//            topology=inp.nextInt();
//        }

        switch (topology){
            case(1):    nw.topology1(mode);
            case(2):    nw.topology2(mode);
            case(3):    nw.topology3(mode);
            case(4):    nw.topology4(mode);
            case(5):    nw.randomTopology(mode);
        }

    }

    static void showTopologies(){
//        try{
//            BufferedImage image = ImageIO.read(new File("pic.png"));
//
//            image.getGraphics().drawLine(1, 1, image.getWidth()-1, image.getHeight()-1);
//            image.getGraphics().drawLine(1, image.getHeight()-1, image.getWidth()-1, 1);
//
//            ImageIO.write(image, "png", new File("/tmp/output.png"));
//        }
//        catch (IOException e){
//            e.printStackTrace();
//        }
//        new ShowPNG("/pic2.png").setVisible(true);
    }
}

//@SuppressWarnings("serial")
//class ShowPNG extends JFrame {
//
//    public ShowPNG(String img) {
//        BufferedImage img2=new BufferedImage;
//        ImageIcon icon=new ImageIcon(img2);
//        JFrame frame=new JFrame();
//        frame.setLayout(new FlowLayout());
//        frame.setSize(img2.getWidth(null)+50, img2.getHeight(null)+50);
//        JLabel lbl=new JLabel();
//        lbl.setIcon(icon);
//        frame.add(lbl);
//        frame.setVisible(true);
//        frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
//    }
//}