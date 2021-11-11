class STAR {
  float x = random(width);
  float y = random(-500,height+500);
  float z = random(0, 10);
  float size =  map(z, 0, 10, 1, 10);
  float yvel = map(z, 0, 10, 5, 20);
 
 void fall(){
   y = y + yvel;
   
   if(y > height){
     y = random(-500,-100);
   }
 }
 
 void display(){
   fill(255);
   noStroke();
   rect(x, y, size, size);
 }
}
