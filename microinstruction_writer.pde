import cc.arduino.*;
import processing.serial.*;
import java.util.Arrays;

public class MicroInstructionWriter{
  
  Arduino arduino;
  int[] data_pins = {2, 3, 4, 5, 6, 7, 8 ,9};
  int addr_data = 10;
  int addr_clk = 11;
  int rom_we = 12;
  int rom_oe = 13;
  
  public MicroInstructionWriter(Arduino arduino_obj){
    arduino = arduino_obj;
    
    bus_output();
    
    arduino.pinMode(addr_data, Arduino.OUTPUT);
    arduino.pinMode(addr_clk, Arduino.OUTPUT);
    arduino.pinMode(rom_we, Arduino.OUTPUT);
    arduino.pinMode(rom_oe, Arduino.OUTPUT);
  }
  
  public void bus_input(){
    for(int i=0; i<8; i++){
      arduino.pinMode(data_pins[i], Arduino.INPUT);
    }
  }
  
  public void bus_output(){
    for(int i=0; i<8; i++){
      arduino.pinMode(data_pins[i], Arduino.OUTPUT);
    }
  }
  
  private void writeAddr(String[] addr){
    for(int i=0; i<addr.length; i++){
      int data = int(addr[i].equals("1"));
      arduino.digitalWrite(addr_data, data);
      delay(1);
      arduino.digitalWrite(addr_clk, 0);
      delay(1);
      arduino.digitalWrite(addr_clk, 1);
      delay(3);
      arduino.digitalWrite(addr_clk, 0);
      delay(1);
    }
  }
  
  public String read(String[] addr){
    bus_input();
    
    writeAddr(addr);
    arduino.digitalWrite(rom_we, 1);
    delay(3);
    arduino.digitalWrite(rom_oe, 0);
    delay(5);
    
    String result = "";
    for(int i=0; i<data_pins.length; i++){
      if(boolean(arduino.digitalRead(data_pins[i]))){
        result += "1";
      }else{
        result += "0";
      }
    }
    
    return result; 
  } 
  
  public void write(String[] addr, String[] d){
    bus_output();
    
    writeAddr(addr);
    arduino.digitalWrite(rom_oe, 1);
    delay(3);
    arduino.digitalWrite(rom_we, 1);
    delay(10);
    
    for(int i=0; i<d.length; i++){
      int data = int(d[i].equals("1"));
      arduino.digitalWrite(data_pins[i], data);
    }
    
    delay(10);
    
    arduino.digitalWrite(rom_we, 0);
    delay(10);
    arduino.digitalWrite(rom_we, 1);
    delay(50);
    println("Write: ", String.join("", d), " To ", String.join("", addr));
  }
  
  void test(){
    arduino.pinMode(13, Arduino.OUTPUT);
    arduino.digitalWrite(13, 1);
  }
}

MicroInstructionWriter mit;

void writeToROM(String[] addr, String[] d){
  mit.write(addr, d);
}

void readFromROM(String[] addr, String[] d){
  String result = mit.read(addr);
  boolean is_just_false = false;
  if(is_just_false){
    if(!String.join("", d).equals(result)) println("Read: ADDR: ", String.join("", addr), " : ", result, " : DATA: ", String.join("", d));
  }else{
    println("Read: ADDR: ", String.join("", addr), " : ", result, " : ", String.join("", d).equals(result));
  }
}

void read(String[][] instructions, int rom_index){
  for(int i=0; i<instructions.length; i++){
    decodeAddrHelper(
      instructions[i][0].split(""), 
      0, 
      instructions[i][1].split(""),
      instructions[i][2].split(""),
      instructions[i][3].split(""), false, rom_index
    );
  }
}

void write(String[][] instructions, int rom_index){
//String[] addr, int index, String d1, String d2, String d3) {
  for(int i=0; i<instructions.length; i++){
    decodeAddrHelper(
      instructions[i][0].split(""), 
      0, 
      instructions[i][1].split(""),
      instructions[i][2].split(""),
      instructions[i][3].split(""), true, rom_index
    );
  }
}

void decodeAddrHelper(String[] addr, int index, String[] d1, String[] d2, String[] d3, boolean is_write, int rom_index) {
  String[] d = {};
  if(rom_index == 1) d = d1;
  else if(rom_index == 2) d = d2;
  else if(rom_index == 3) d = d3;
  
  if (index == addr.length) {
    if(is_write){
      writeToROM(addr, d);
    }else{
      readFromROM(addr, d);
    }
    
    return;
  }
  
  if (addr[index].equals("X")) {
    addr[index] = "0";
    decodeAddrHelper(addr, index + 1, d1, d2, d3, is_write, rom_index);
    addr[index] = "1";
    decodeAddrHelper(addr, index + 1, d1, d2, d3, is_write, rom_index);
    addr[index] = "X";
  } else {
    decodeAddrHelper(addr, index + 1, d1, d2, d3, is_write, rom_index);
  }
}


String instructions[][] = {
  {"000000000000", "00000000", "00000000", "00000000"},
};

void start(){
  
  for(int i=0; i<8; i++){
    String[] s1 = instructions[i][0].split("");
    String[] s2 = instructions[i][3].split("");
    
    s1[i] = "1";
    s2[i] = "1";
    
    instructions[i][0] = String.join("", s1);
    instructions[i][3] = String.join("", s2);
  }
  for(int i=0; i<4; i++){
    String[] s1 = instructions[i+8][0].split("");
    String[] s2 = instructions[i+8][3].split("");
    
    s1[i+8] = "1";
    s2[i] = "1";
    
    instructions[i+8][0] = String.join("", s1);
    instructions[i+8][3] = String.join("", s2);
  }
  
  mit = new MicroInstructionWriter(new Arduino(this, Arduino.list()[0], 57600));
  println("Wait 3s");
  delay(1000);
  println("Wait 2s");
  delay(1000);
  println("Wait 1s");
  delay(1000);
  
  //read(instructions, 3);
  //write(instructions, 3);
  //mit.test();
}

void draw(){

}
