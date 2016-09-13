import saito.objloader.*;
import org.gamecontrolplus.gui.*;
import org.gamecontrolplus.*;
import net.java.games.input.*;
import processing.serial.*;

//SERIAL COMMS VARIABLES_______________________________________________________________________
//RECEIVE----------
final int BUFFER_LIMIT = 56;
int readPacketLoss = 0;
int sendPacketLoss = 0;
boolean readError = false;
boolean sendError = false;
byte[] data = new byte[BUFFER_LIMIT];

boolean connected = false;
int noRead = 0;

//SEND---------------
final char DC_WRITE = 'a';
final char SA_WRITE = 'b';
final char A_WRITE = 'c';


//GUI VARIABLES________________________________________________________________________________
ControlIO control;
ControlDevice gpad;

float rX, rY, lX, lY;
boolean s1, s2, b3, s4, s5;

int screenX, screenY;
PImage quad_bg, quad_border, quad_side, quad_top, g_off, g_on, y_off, y_on, r_off, r_on, connect_up, connect_down, start_up, start_down, RTH_on, RTH_off,
AL_on, AL_off, stop_on, stop_off, m1_bg, m2_bg, m3_bg, m1_tab_up, m1_tab_down, m2_tab_up, m2_tab_down, m3_tab_up, m3_tab_down, pr_vis_bg, pr_vis_bg_rot;
PFont text;
int stage = 1;
Serial port;

int modeTab = 1;

//----------------QUAD VARIABLES---------------------------------------
float pitch = 0;
float roll = 0;
float yaw = 0;

short pitch_lock = 0;
short roll_lock = 0;
short yaw_lock = 0;
short alt_lock = 0;
short motor_speed = 140;

float m1 = 0;
float m2 = 0;
float m3 = 0;
float m4 = 0;

int kill = 0;
boolean start = false;
int mode = 1;
//------------------------------------------------------------------------

void setup() {
  screenX = round(displayWidth * 1);
  screenY = round(displayHeight * 0.90);
  size(screenX, screenY, P3D);
  frame.setResizable(true);
  quad_bg = loadImage("Quad_gui.png");
  image(quad_bg, 0, 0, screenX, screenY);
  quad_border = loadImage("quad_borders.png");
  quad_side = loadImage("Quad_side.png");
  quad_top = loadImage("Quad_top.png");
  r_on = loadImage("quad_light_red_on.png");
  r_off = loadImage("quad_light_red_off.png");
  g_on = loadImage("quad_light_green_on.png");
  g_off = loadImage("quad_light_green_off.png");
  y_on = loadImage("quad_light_yellow_on.png");
  y_off = loadImage("quad_light_yellow_off.png");
  connect_up = loadImage("connect_btn_up.png");
  connect_down = loadImage("connect_btn_down.png");
  start_up = loadImage("start_btn_up.png");
  start_down = loadImage("start_btn_down.png");
  RTH_on = loadImage("RTH_btn_on.png");
  RTH_off = loadImage("RTH_btn_off.png");
  AL_on = loadImage("AL_btn_on.png");
  AL_off = loadImage("AL_btn_off.png");
  stop_on = loadImage("stop_btn_on.png");
  stop_off = loadImage("stop_btn_off.png");
  m1_bg = loadImage("mode_1_bg.png");
  m1_tab_up = loadImage("mode_1_tab_up.png");
  m1_tab_down = loadImage("mode_1_tab_down.png");
  m2_bg = loadImage("mode_2_bg.png");
  m2_tab_up = loadImage("mode_2_tab_up.png");
  m2_tab_down = loadImage("mode_2_tab_down.png");
  m3_tab_up = loadImage("mode_3_tab_up.png");
  m3_tab_down = loadImage("mode_3_tab_down.png");
  pr_vis_bg = loadImage("pr_vis_bg.png");
  pr_vis_bg_rot = loadImage("pr_vis_bg_rotated.png");
  text = createFont("font", 1000, true);
  port = new Serial(this, "COM5", 9600);
  port.bufferUntil('\n');
  control = ControlIO.getInstance(this);
  gpad = control.getMatchedDevice("fs_config");
}

void draw() {
  if (stage == 1) {
    tint(64, 64, 64, 127);
    fill(64, 64, 64, 127);
    drawGraphics();
    textWrite();
    tint(255, 255, 255, 255);
    textAlign(CENTER);
    fill(255, 255, 255, 255);
    textSize(26);
    text("GUI is loaded", screenX / 2, screenY / 2.5);
    text("Press <ENTER> to begin...", screenX / 2, (screenY / 2.5) + 60);
  }
  if (stage == 2) {
    if (mode == 1) {               //DIRECT CONTROL!
      getUserInput();
      gamePadCompute();
      drawGraphics();
      textWrite();
    }
    if (mode == 2) {                        //SEMI-AUTONOMOUS!
      getUserInput();
      gamePadCompute();
      drawGraphics();
      textWrite();
    }
    if (mode == 3) {                         //AUTONOMOUS MODE!
      drawGraphics();
      textWrite();
    }
  }
  
  connectionCheck();
}




