class AKATEN {
  float ax;
  float ay;
  float avely;
  float avelx;
  float awi;
  float ahe;
  
  float defvelu = 2;
  float defveld = 5;
  float defvelu_n = -2;
  float defveld_n = -5;
  
  float modex = 0;
  float modey = 0;
  AKATEN(){
   modex = int(random(2));
   modey = int(random(2));
   
   if(modex == 0 && modey == 0){ // 左上
     ay = random(-100, height/2);
     if(ay < 0) ax = random(-100, width/2);
     else ax = 0;
   }else if(modex == 0 && modey == 1){ // 左下
     ay = random(height/2, height+100);
     if(ay > height) ax = random(-100, width/2);
     else ax = 0;
   }else if(modex == 1 && modey == 0){ // 右上
     ay = random(-100, height/2);
     if(ay < 0) ax = random(width/2, width+100);
     else ax = width;
   }else if(modex == 1 && modey == 1){ // 右下
     ay = random(height/2, height+100);
     ax = random(-1, -3);
     if(ay > height) ax = random(width/2, width+100);
     else ax = width;
   }
   
   if(modex == 0 && modey == 0){
     avely = random(defvelu, defveld);
     avelx = random(defvelu, defveld);
   }else if(modex == 0 && modey == 1){
     avely = random(defvelu_n, defveld_n);
     avelx = random(defvelu, defveld);
   }else if(modex == 1 && modey == 0){
     avely = random(defvelu, defveld);
     avelx = random(defvelu_n, defveld_n);
   }else if(modex == 1 && modey == 1){
     avely = random(defvelu_n, defveld_n);
     avelx = random(defvelu_n, defveld_n);
   }
   ahe = 50;
   awi = 100;
  }
  
  void move(){
    ay += avely;
    ax += avelx;
  }
  
  void display(){
    image(akaten, ax, ay, awi, ahe);
  }
  
  boolean isAlive() {
    if (ax+awi/2 < -400 || width+400 < ax-awi/2 || ay+ahe/2 < -200 || height+200 < ay-ahe/2) {
      return false;
    }
    return true;
  }
}
