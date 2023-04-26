import cc.arduino.*;
import processing.serial.*;

public class MicroInstructionWriter{
  
  Arduino arduino;
  
  public MicroInstructionWriter(Arduino arduino_obj){
    arduino = arduino_obj;
  }
  
  void write(String addr, String d1, String d2, String d3){
    println(addr);
    String splited_addr[] = addr.split("");
    for(int i=0; i<addr.length(); i++){
      if(splited_addr[i] == "X"){
        splited_addr[i] = "0";
        write(String.join("", splited_addr), d1, d2, d3);
        splited_addr[i] = "1";
        write(String.join("", splited_addr), d1, d2, d3);
      }
    }
  }
}
void write(String addr, String d1, String d2, String d3){
    println(addr);
    String splited_addr[] = addr.split("");
    for(int i=0; i<splited_addr.length; i++){
      if(splited_addr[i].equals("X")){
        splited_addr[i] = "0";
        write(String.join("", splited_addr), d1, d2, d3);
        splited_addr[i] = "1";
        write(String.join("", splited_addr), d1, d2, d3);
      }
    }
  }

MicroInstructionWriter mit;

String instructions[][] = {
{"000000XX", "00000000", "00000000", "00000000"},
};

void start(){
  //mit = new MicroInstructionWriter(new Arduino(this, Arduino.list()[0], 57600));
  write("0001XX01", "", "", "");
}
void draw(){

}
