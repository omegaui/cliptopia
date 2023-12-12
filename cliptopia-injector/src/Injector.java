
import java.awt.Robot;
import static java.awt.event.KeyEvent.*;

class Injector {
    public static void main(String[] args) throws Exception {
        int key1 = VK_SHIFT;
        int key2 = VK_INSERT;
        if(args != null && args.length != 0 && args[0].equals("--standard")) {
          key1 = VK_CONTROL;
          key2 = VK_V;
        }
        Robot robot = new Robot();
        robot.keyPress(key1);
        robot.keyPress(key2);
        robot.keyRelease(key1);
        robot.keyRelease(key2);
    }
}