import cc.arduino.*;
import processing.serial.*;
import java.util.Arrays;

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
void write(String[] addr){
  println(String.join("", addr));
}

void decodeAddr(String[] addr, String d1, String d2, String d3) {
  decodeAddrHelper(addr, 0, d1, d2, d3);
}

void decodeAddrHelper(String[] addr, int index, String d1, String d2, String d3) {
  if (index == addr.length) {
    write(addr);
    return;
  }
  
  if (addr[index].equals("X")) {
    addr[index] = "0";
    decodeAddrHelper(addr, index + 1, d1, d2, d3);
    addr[index] = "1";
    decodeAddrHelper(addr, index + 1, d1, d2, d3);
    addr[index] = "X";
  } else {
    decodeAddrHelper(addr, index + 1, d1, d2, d3);
  }
}

MicroInstructionWriter mit;

String instructions[][] = {
{"000000XX", "00000000", "00000000", "00000000"},
};

void start(){
  //mit = new MicroInstructionWriter(new Arduino(this, Arduino.list()[0], 57600));
  decodeAddr("XX".split(""), "", "", "");
}
void draw(){

}
