import processing.serial.*;
Serial myPort;

float[] CurrentPosition = new float[181];
float[][] MeanPosition = new float[3][181];
float M = 80;
color green = color(0, 153, 0);
color yellow = color(255, 255, 0);
color red = color(255, 0, 0);

void setup()
{
  printArray(Serial.list());
  myPort = new Serial(this, Serial.list()[0]);
  size(1280,720);
}

void draw()
{
  int R=width/2;  
  
  background(255);
  translate(width/2,height);  
  arc(0, 0, width, width, PI, 2*PI);
  arc(0, 0, 3*width/4, 3*width/4, PI, 2*PI);
  arc(0, 0, width/2, width/2, PI, 2*PI);
  arc(0, 0, width/4, width/4, PI, 2*PI);
  line(0,0, R*cos(30*2*PI/360), -R*sin(30*2*PI/360));
  line(0,0, R*cos(60*2*PI/360), -R*sin(60*2*PI/360));
  line(0,0, R*cos(90*2*PI/360), -R*sin(90*2*PI/360));
  line(0,0, R*cos(120*2*PI/360), -R*sin(120*2*PI/360));
  line(0,0, R*cos(150*2*PI/360), -R*sin(150*2*PI/360));
  line(0,0, R*cos(180*2*PI/360), -R*sin(180*2*PI/360));
  ellipse(0,0,10,10);
  
  while (myPort.available() > 0)
  {
    int lf=10; //Line Feed
    byte[] inBuffer = new byte [15];
    myPort.readBytesUntil(lf, inBuffer);
    if(inBuffer != null)
    {
      String Input = new String(inBuffer);
      if(Input.charAt(0)=='p')
      {
        String Position = new String();
        String Distance = new String();
        int i=1;
        while(Input.charAt(i)!='d')
        {
          Position+=Input.charAt(i);
          i=i+1;
        }
        Distance=Input.substring(i+1,Input.length());
        int Pos = int(Position);
        float Dis = float(Distance);
        CurrentPosition[Pos]=Dis;
        
        if(MeanPosition[0][Pos]==0)
        {
          MeanPosition[1][Pos]=CurrentPosition[Pos];
          MeanPosition[0][Pos]++;
          MeanPosition[2][Pos]=CurrentPosition[Pos]*CurrentPosition[Pos];
        }
        else
        {
         if(abs(MeanPosition[1][Pos]-CurrentPosition[Pos])<(M/10))
          {
            MeanPosition[0][Pos]++;
            MeanPosition[1][Pos]=(MeanPosition[1][Pos]*MeanPosition[0][Pos]+CurrentPosition[Pos])/(MeanPosition[0][Pos]+1);
            MeanPosition[2][Pos]=(MeanPosition[2][Pos]*MeanPosition[0][Pos]+CurrentPosition[Pos]*CurrentPosition[Pos])/(MeanPosition[0][Pos]+1);
          }
        }
        
        line(0,0, R*cos(Pos*2*PI/360), -R*sin(Pos*2*PI/360));
      }
    }
   }   
   
   for(int i=0; i<180; i++)
   {
     float rm = MeanPosition[1][i];
     float sigma = sqrt(MeanPosition[2][i]-MeanPosition[1][i]*MeanPosition[1][i]); // odchylenie standardowe
     /*
     float rmp = rm+sigma;
     float rmm = rm-sigma;
     line((rmm/M)*R*cos(i*2*PI/360), -(rmm/M)*R*sin(i*2*PI/360), (rmp/M)*R*cos(i*2*PI/360), -(rmp/M)*R*sin(i*2*PI/360)); // linia niepewności
     */
     if(2*sigma/M < 0.25)
       fill(green);
     if(2*sigma/M > 0.25 && 2*sigma/M < 0.5)
       fill(yellow);
     if(2*sigma/M > 0.5)
       fill(red);
     float xm = (rm/M)*R*cos(i*2*PI/360); 
     float ym = (rm/M)*R*sin(i*2*PI/360);
     ellipse(xm,-ym,10,10); // sredni pomiar

     fill(255);
    
     float r = CurrentPosition[i];
     if(abs(rm-r)/M < 0.25)
       fill(green);
     if( abs(rm-r)/M > 0.25 && abs(rm-r)/M  < 0.5)
       fill(yellow);
     if( abs(rm-r)/M  > 0.5)
       fill(red);
     float x = (r/M)*R*cos(i*2*PI/360);
     float y = (r/M)*R*sin(i*2*PI/360);
     ellipse(x,-y,5,5);    // ostatni pomiar   
     fill(255);
     
   }
   
}